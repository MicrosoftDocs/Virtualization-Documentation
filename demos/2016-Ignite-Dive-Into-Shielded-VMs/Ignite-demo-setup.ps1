Param(
    [string]$Cleanup,
    [int]$StartFromStage = 0,
    [int]$StopBeforeStage = 255
)

#######################################################################################
# Initialization of variables
#######################################################################################

$Script:basePath = "C:\Ignite"
$Script:sourcePath = "C:\IgniteSource"

$Script:baseMediaPath = Join-Path $Script:sourcePath -ChildPath "\WindowsServer2016\server_en-us_vl\" -Resolve

$domainName = "relecloud.com"
$hgsDomainName = "hgs.$domainName"
$localAdministratorPassword = ConvertTo-SecureString -AsPlainText "P@ssw0rd." -Force

$Script:internalSwitchName = "FabricInternal"
$Script:externalSwitchName = "FabricExternal"
$Script:fabricSwitch = $Script:externalSwitchName

$Script:localAdministratorCredential = New-Object System.Management.Automation.PSCredential (“administrator”, $localAdministratorPassword)
$Script:relecloudAdministratorCredential = New-Object System.Management.Automation.PSCredential (“relecloud\administrator”, $localAdministratorPassword)
$Script:hgsAdministratorCredential = New-Object System.Management.Automation.PSCredential (“hgs\administrator”, $localAdministratorPassword)

$Script:baseServerCorePath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerDataCenterCore.vhdx"
$Script:baseServerStandardPath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerStandard.vhdx"
$Script:baseNanoServerPath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerDataCenterNano.vhdx"
$Script:ImageConverterPath = Join-Path -Path $Script:baseMediaPath -ChildPath "NanoServer\NanoServerImageGenerator\Convert-WindowsImage.ps1"

$Script:UnattendPath = Join-Path $Script:sourcePath -ChildPath "IgniteUnattend.xml"

$Script:VmNameDc = "Fabric - Domain Controller"
$Script:VmNameVmm = "Fabric - Virtual Machine Manager"
$Script:VmNameCompute = "Fabric - Guarded Host"
$Script:VmNameHgs = "HGS - Host Guardian Service"

$Script:HgsGuardian = Get-HgsGuardian UntrustedGuardian -ErrorAction SilentlyContinue
if (!$Script:HgsGuardian) {
    $Script:HgsGuardian = New-HgsGuardian -Name UntrustedGuardian –GenerateCertificates -ErrorAction Stop
}

$Script:stagenames = (
    "Stage 0: Create VMs", 
    "Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs",
    "Stage 2: Prepare HGS and create fabric domain",
    "Stage 3: Configure HGS, configure DHCP, join compute nodes to domain"
    )

$Script:stage = $StartFromStage

if (-not (Get-VMSwitch -Name $Script:fabricSwitch -ErrorAction SilentlyContinue)) {
    Write-Host "Fabric Switch not found - creating internal switch"
    New-VMSwitch -Name $Script:fabricSwitch -SwitchType Internal -ErrorAction Stop | Out-Null
}

#######################################################################################
# Explicit cleanup
#######################################################################################

If (($Cleanup -eq "VM") -or ($Cleanup -eq "Everything"))
{
    Write-Host "[Cleanup] Removing existing VMs"
    Get-VM | Stop-VM -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
    Get-VM | Remove-VM -Force -WarningAction SilentlyContinue | Out-Null
    Get-ChildItem -Path (Join-Path $Script:basePath -ChildPath fabric) -Recurse | Remove-Item -Force -Recurse -WarningAction SilentlyContinue | Out-Null
}
If (($Cleanup -eq "Baseimages") -or ($Cleanup -eq "Everything"))
{
    Write-Host "[Cleanup] Removing existing base VHDXs"
    if (Test-Path $Script:baseServerCorePath)
    {
        Remove-Item -Path $Script:baseServerCorePath -Force | Out-Null
    }
    if (Test-Path $Script:baseServerStandardPath)
    {
        Remove-Item -Path $Script:baseServerStandardPath -Force | Out-Null
    }
    if (Test-Path $Script:baseNanoServerPath)
    {
        Remove-Item -Path $Script:baseNanoServerPath -Force | Out-Null
    }
}

#######################################################################################
# Preparation of base VHDXs
#######################################################################################

if (Test-Path $Script:ImageConverterPath)
{
    # Running Image converter script to get Convert-WindowsImage function
    . $Script:ImageConverterPath
}

if (-Not (Test-Path $Script:baseServerCorePath))
{
    Write-Host "[Prepare] Creating Server Datacenter Core base VHDX"
    # Creating Server Datacenter Core vhdx based on media
    Convert-WindowsImage -SourcePath (Join-Path $Script:baseMediaPath -ChildPath "sources\Install.wim") -VHDPath $Script:baseServerCorePath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
}

if (-Not (Test-Path $Script:baseServerStandardPath))
{
    Write-Host "[Prepare] Creating Server Standard Full UI base VHDX"
    # Creating Server Standard vhdx based on media
    Convert-WindowsImage -SourcePath (Join-Path $Script:baseMediaPath -ChildPath "sources\Install.wim") -VHDPath $Script:baseServerStandardPath -DiskLayout UEFI -Edition SERVERSTANDARD -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
}

if (-Not (Test-Path $Script:baseNanoServerPath))
{
    Write-Host "[Prepare] Creating Nano Server Datacenter base VHDX"
    # Importing Nano Server Image Generator PowerShell Module
    Import-Module (Join-Path $Script:baseMediaPath -ChildPath "\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1") | Out-Null

    New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:baseMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-SCVMM-Package,Microsoft-NanoServer-SCVMM-Compute-Package  -TargetPath $Script:baseNanoServerPath -EnableRemoteManagementPort -AdministratorPassword $localAdministratorPassword | Out-Null
}

# Checkpoint-VM [-VM] <VirtualMachine[]> [[-SnapshotName] <String> ] [-AsJob] [-Passthru] [-Confirm] [-WhatIf] [ <CommonParameters>]
# Set-VM -Name <vmname> -CheckpointType Standard

# (Get-WmiObject -q "SELECT * FROM Msvm_ComputerSystem WHERE ElementName = 'ImportantVM'" -n root\virtualization\v2).ProcessID

#######################################################################################
# Helper Functions
#######################################################################################

function Prepare-VM 
{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$vmname,
        [Parameter(Mandatory=$True)]
        [string]$basediskpath,

        [int]$processorcount = 2,
        $startupmemory = 1GB,
        [bool]$dynamicmemory = $false,
        [string]$switchname = $Script:fabricSwitch,
        [bool]$startvm = $false,
        [bool]$enablevirtualizationextensions = $false,
        [bool]$enablevtpm = $false
    )

    $FabricPath = Join-Path $Script:basePath -ChildPath "\fabric\"
    $VmPath = $VHDXPath = Join-Path $FabricPath -ChildPath "$vmname"
    $VHDXPath = Join-Path $VmPath -ChildPath "Virtual Hard Disks\OSDisk.vhdx"

    $vm = Get-VM -VMName $vmname -ErrorAction SilentlyContinue
    If ($vm)
    {
        Write-Host "`t[$vmname] Removing existing Virtual Machine"
        Stop-VM -VM $vm -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
        Get-VMSnapshot -VM $vm | Remove-VMSnapshot -Confirm:$false | Out-Null
        Remove-VM -VM $vm -Force -WarningAction SilentlyContinue | Out-Null
        If (Test-Path $VHDXPath)
        {
            Remove-Item -Path $VHDXPath -Force -ErrorAction Stop | Out-Null
        }
    }

    Write-Host "`t[$vmname] Creating Virtual Machine"

    If (Test-Path $VHDXPath)
    {
        Write-Host "`t[$vmname] Removing existing VHDX"
        Remove-Item -Path $VHDXPath -Force -ErrorAction Stop | Out-Null
    }

    Write-Host "`t[$vmname] Creating new differencing disk" 
    New-VHD -Differencing -Path $VHDXPath -ParentPath $basediskpath -ErrorAction Stop | Out-Null
    $vm = New-VM -Name $vmname -MemoryStartupBytes $startupmemory -Path $FabricPath -VHDPath $VHDXPath -Generation 2 -SwitchName $switchname -ErrorAction Stop

    If ($processorcount -gt 1)
    {
        Write-Host "`t[$vmname] Setting processor count to $processorcount"
        Set-VMProcessor -VM $vm -Count $processorcount  | Out-Null
    }
    If (-not $dynamicmemory)
    {
        Write-Host "`t[$vmname] Disabling Dynamic Memory"
        Set-VMMemory -VM $vm -DynamicMemoryEnabled $false | Out-Null
    }
    If ($enablevirtualizationextensions)
    {
        Write-Host "`t[$vmname] Enabling Virtualization Extensions"
        Set-VMProcessor -VM $vm -ExposeVirtualizationExtensions $true | Out-Null
    }
    If ($enablevtpm)
    {
        Write-Host "`t[$vmname] Enabling vTPM"
        $keyprotector = New-HgsKeyProtector -Owner $Script:HgsGuardian -AllowUntrustedRoot
        Set-VMKeyProtector -VM $vm -KeyProtector $keyprotector.RawData -ErrorAction Stop | Out-Null
        Enable-VMTPM -VM $vm -ErrorAction Stop | Out-Null
    }

    if ($startvm)
    {
        Write-Host "`t[$vmname] Starting VM"
        Start-VM $vm -ErrorAction Stop | Out-Null
    }

    # return vm
    $vm
}

function Create-EnvironmentStageCheckpoint
{
    Param(
        [int]$Stage = $Script:stage,
        [Microsoft.HyperV.PowerShell.VirtualMachine[]]$VirtualMachines = $Script:EnvironmentVMs,
        [bool]$shutdown = $True
    )
    If ($shutdown)
    {
        Write-Host "Shutting down VMs for environment checkpoint for $($Script:stagenames[$Stage])"
        Stop-VM -VM $VirtualMachines -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    Write-Host "Creating environment checkpoint for $($Script:stagenames[$Stage])"
    Checkpoint-VM -SnapshotName $Script:stagenames[$Stage] -VM $VirtualMachines | Out-Null
}

function Reset-EnvironmentToStageCheckpoint
{
    Param(
        [int]$Stage,
        [Microsoft.HyperV.PowerShell.VirtualMachine[]]$VirtualMachines = $Script:EnvironmentVMs
    )
    Write-Host "Resetting environment to latest available stage checkpoint"
    $success = $false
    Do  
    {
        Write-Host "`tChecking if checkpoints for $($Script:stagenames[$Stage]) exist"
        $Snapshots = Get-VMSnapshot -VM $VirtualMachines -Name $Script:stagenames[$Stage] -ErrorAction SilentlyContinue
        If ($Snapshots)
        {
            # todo: check if count is right
            Write-Host "`tRestoring Checkpoints"
            $Snapshots | Restore-VMSnapshot -Confirm:$false
            # todo: delete later checkpoints
            $success = $True
            $Script:stage = $Stage + 1
        }
        If ($Stage -gt 0 -and -not $success)
        {
            Write-Host "`tCheckpoints not found"
            $Stage--
        }
    } While (-not $success -and $Stage -ge -1)
    If (-not $success)
    {
        Write-Host "`tLocating checkpoints not successful - Resetting current stage to 0"
        $Script:stage = 0
    }
}

function Invoke-CommandWithPSDirect
{
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential,
        
        [Parameter(Mandatory=$true)]
        [ScriptBlock]
        $ScriptBlock,

        [Object[]]
        $ArgumentList
    )
    If ($VirtualMachine.State -eq "Off")
    {
        Write-Host "`tStarting VM $($VirtualMachine.VMName)"
        Start-VM $VirtualMachine -ErrorAction Stop | Out-Null
    }
    
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            throw "Integration components did not come up after 10 minutes"
        } 
        Start-Sleep -sec 1
    } 
    until ((Get-VMIntegrationService -VM $VirtualMachine |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47").PrimaryStatusDescription -eq "OK")
    Write-Output "`tHeartbeat IC connected."

    Write-Host "`tWaiting for PSDirect connection to $($VirtualMachine.VMName) to be available"
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            throw "Could not connect to PS Direct after 10 minutes"
        } 
        Start-Sleep -sec 1
        $psReady = Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
    } 
    until ($psReady)
    
    Write-Host "`tExecuting Script Block"
    If ($ArgumentList)
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList -ErrorAction SilentlyContinue    
    }
    else 
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ErrorAction SilentlyContinue    
    }
    
}

#######################################################################################
# Beginning of Environment Build
#######################################################################################

$hgs01 = Get-VM -VMName $Script:VmNameHgs -ErrorAction SilentlyContinue
$dc01 = Get-VM -VMName $Script:VmNameDc -ErrorAction SilentlyContinue
$vmm01 = Get-VM -VMName $Script:VmNameVmm -ErrorAction SilentlyContinue
$compute01 = Get-VM -VMName "$Script:VmNameCompute 01" -ErrorAction SilentlyContinue
$compute02 = Get-VM -VMName "$Script:VmNameCompute 02" -ErrorAction SilentlyContinue

$Script:EnvironmentVMs = $hgs01, $dc01, $vmm01, $compute01, $compute02

If ($Script:EnvironmentVMs.Count -lt 5) 
{
    Write-Host "Starting from Stage 0 since not all VMs could be found"
    $StartFromStage = 0
}

If ($StartFromStage -gt 1)
{
    Reset-EnvironmentToStageCheckpoint -Stage ($StartFromStage-1)
}

#######################################################################################
# Beginning of Stage 0: Create VMs
#######################################################################################
If ($Script:stage -eq 0 -and $Script:stage -lt $StopBeforeStage)
{
    Write-Host "Begin $($Script:stagenames[$Script:stage])"
    $hgs01 = Prepare-VM -vmname $Script:VmNameHgs -basediskpath $Script:baseServerCorePath -dynamicmemory $true
    $dc01 = Prepare-VM -vmname $Script:VmNameDc -basediskpath $Script:baseServerCorePath -dynamicmemory $true
    $vmm01 = Prepare-VM -vmname $Script:VmNameVmm -basediskpath $Script:baseServerStandardPath
    $compute01 = Prepare-VM -vmname "$Script:VmNameCompute 01" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    $compute02 = Prepare-VM -vmname "$Script:VmNameCompute 02" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    Write-Host "End of $($Script:stagenames[$Script:stage])"

    $Script:EnvironmentVMs = $hgs01, $dc01, $vmm01, $compute01, $compute02
    Create-EnvironmentStageCheckpoint
    $Script:stage++
} 

#######################################################################################
# End of Stage 0: Create VMs
#######################################################################################

#######################################################################################
# Beginning of Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################
If ($Script:stage -eq 1 -and $Script:stage -lt $StopBeforeStage)
{
    Write-Host "Begin $($Script:stagenames[$Script:stage])"

    Write-Host "`tStarting all VMs to parallelize specialization"
    Start-VM -VM $Script:EnvironmentVMs -ErrorAction Stop | Out-Null

    $scriptBlock = {
            Param(
                [hashtable]$param
            )
            If ($param["features"])
            {
                Write-Host "`t`tCalling Install-WindowsFeature $($param["features"])"
                Install-WindowsFeature $param["features"] -IncludeManagementTools -WarningAction SilentlyContinue | Out-Null
            }
            If ($param["ipaddress"])
            {
                Write-Host "`t`tSetting Network configuration: IP $($param["ipaddress"])"
                Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $param["ipaddress"] -PrefixLength 24 | Out-Null
            }
            If ($param["computername"])
            {
                Write-Host "`t`tRenaming computer to $($param["computername"])"
                Rename-Computer $param["computername"] -WarningAction SilentlyContinue | Out-Null
            }
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            features="HostGuardianServiceRole";
            ipaddress="192.168.42.99";
            computername="HGS01"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            features="AD-Domain-Services,DHCP";
            ipaddress="192.168.42.1";
            computername="DC01"
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            computername="Compute01"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            computername="Compute02"
        }

    Write-Host "End of $($Script:stagenames[$Script:stage])"

    Create-EnvironmentStageCheckpoint
    $Script:stage++
} 
# Defining all VMs that are part of the environment
#######################################################################################
# End of  Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################

#######################################################################################
# Beginning of Stage 2: Prepare HGS and create fabric domain
#######################################################################################
If ($Script:stage -eq 2 -and $Script:stage -lt $StopBeforeStage)
{
    Write-Host "Begin $($Script:stagenames[$Script:stage])"

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "`t`tPreparing Host Guardian Service"
            Install-HgsServer -HgsDomainName $param["hgsdomainname"] -SafeModeAdministratorPassword $param["adminpassword"]
        } -ArgumentList @{
            hgsdomainname=$hgsDomainName;
            adminpassword=$localAdministratorPassword
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "`t`tCreating fabric domain"
            Install-ADDSForest -DomainName  $param["domainName"] -SafeModeAdministratorPassword $param["adminpassword"] -Force
        } -ArgumentList @{
            hgsdomainname=$domainName;
            adminpassword=$localAdministratorPassword
        }

    Write-Host "End of $($Script:stagenames[$Script:stage])"

    Create-EnvironmentStageCheckpoint
    $Script:stage++
} 
#######################################################################################
# End of Stage 2: Prepare HGS and create fabric domain
#######################################################################################

#######################################################################################
# Beginning of Stage 3: Configure HGS, configure DHCP, join compute nodes to domain
#######################################################################################
If ($Script:stage -eq 3 -and $Script:stage -lt $StopBeforeStage)
{
    Write-Host "Begin $($Script:stagenames[$Script:stage])"

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "`t`tCreating self-signed certificates for HGS configuration"
            $signingCert = New-SelfSignedCertificate -DnsName "signing.$($param["hgsdomainname"])"
            Export-PfxCertificate -Cert $signingCert -Password $param["adminpassword"] -FilePath C:\signing.pfx
            $encryptionCert = New-SelfSignedCertificate -DnsName "encryption.$($param["hgsdomainname"])"
            Export-PfxCertificate -Cert $encryptionCert -Password $param["adminpassword"] -FilePath C:\encryption.pfx

            Write-Host "`t`tConfiguring Host Guardian Service"
            Initialize-HgsServer -HgsServiceName service -SigningCertificatePath C:\signing.pfx -SigningCertificatePassword $param["adminpassword"] -EncryptionCertificatePath C:\encryption.pfx -EncryptionCertificatePassword $certificatePassword -TrustActiveDirectory

        } -ArgumentList @{
            hgsdomainname=$hgsDomainName
            adminpassword=$localAdministratorPassword
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "`t`tCreating DHCP security groups"
            netsh dhcp add securitygroups
            Restart-Service DHCPServer

            Write-Host "`t`tCreating DHCP scope"
            
            Add-DhcpServerv4Scope -Name default -StartRange 192.168.42.1 -EndRange 192.168.42.200 -SubnetMask 255.255.255.0 -State Active
            Add-DhcpServerv4ExclusionRange -Name default -StartRange 192.168.42.1 -EndRange 192.168.42.99
            Set-DhcpServerv4OptionValue -DnsDomain $param["domainname"] -DnsServer 192.168.42.1
            Add-DhcpServerInDC -DnsName "dc01.$($param["domainname"])"
            Restart-Service DHCPServer

            Write-Host "`t`tSuppressing Server Manager configuration warning for DHCP configuration"
            Set-ItemProperty –Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

            Write-Host "`t`tCreating AD Users and Groups"
            New-ADUser -Name "Lars" -SAMAccountName "lars" -GivenName "Lars" -DisplayName "Lars" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true
            New-ADUser -Name "vmmserviceaccount" -SAMAccountName "vmmserviceaccount" -GivenName "VMM" -DisplayName "vmmserviceaccount" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true
            New-ADGroup -Name "ComputeHosts" -DisplayName "Hyper-V Compute Hosts" -GroupCategory Security -GroupScope Universal

            Write-Host "`t`tCreating offline domain join blobs in domain $($param["domainname"])"
            mkdir C:\djoin
            djoin /Provision /Domain $($param["domainname"]) /Machine Compute01 /SaveFile C:\djoin\Compute01.djoin
            djoin /Provision /Domain $($param["domainname"]) /Machine Compute02 /SaveFile C:\djoin\Compute02.djoin
            djoin /Provision /Domain $($param["domainname"]) /Machine VMM01 /SaveFile C:\djoin\VMM.djoin        
        } -ArgumentList @{
            domainname=$domainName;
            adminpassword=$localAdministratorPassword
        }

    Write-Host "`tCopying offline domain-join blobs to host"
    $s = New-PSSession -VMId $dc01.VMId -Credential $Script:relecloudAdministratorCredential
    Copy-Item -FromSession $s -Path C:\djoin\Compute01.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    Copy-Item -FromSession $s -Path C:\djoin\Compute02.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    Copy-Item -FromSession $s -Path C:\djoin\VMM.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    Remove-PSSession $s | Out-Null

    Write-Host "End of $($Script:stagenames[$Script:stage])"

    Create-EnvironmentStageCheckpoint
    $Script:stage++
} 
#######################################################################################
# End of Stage 3: Configure HGS, configure DHCP, join compute nodes to domain
#######################################################################################

#New-NanoServerImage -ComputerName "NanoVM" -Compute -DeploymentType Guest -Edition Datacenter -MediaPath $Script:baseMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-ShieldedVM-Package -TargetPath $compute2VHDXPath -EnableRemoteManagementPort -AdministratorPassword $localAdministratorPassword -InterfaceNameOrIndex Ethernet -Ipv4Address 192.168.42.202 -Ipv4SubnetMask 255.255.255.0 -Ipv4Dns 192.168.42.1 -Ipv4Gateway 192.168.42.1 | Out-Null
if ($Script:stage -eq 99)
    {
    #######################################################################################
    # Customizing VMs
    #######################################################################################

    # Add VMM additional disk
    $VMMDataVHDXPath = Join-Path $Script:basePath -ChildPath "\fabric\VMM01Data.vhdx"
    New-VHD -Dynamic -SizeBytes 30GB -Path $VMMDataVHDXPath | Out-Null
    Add-VMHardDiskDrive -VM $vmm01 -Path $VMMDataVHDXPath | Out-Null

    #Steps to run inside of the DC: 

    # Wait for restart!!

    #create share \\dc01\VMs

    # Create Group for compute nodes
    # Add compute1, compute2 to compute nodes
    # Grant Permissions to Share for Compute nodes

    #Copying offline domain join blobs to host

    # Customizing VMM
    Copy-VMFile -VM $vmm01 -SourcePath (Join-Path $Script:basePath -ChildPath "fabric\VMM.djoin") -DestinationPath C:\VMM.djoin -Credential $Script:localAdministratorCredential

    Invoke-Command -VMId $vmm01.VMId -Credential $Script:localAdministratorCredential -ScriptBlock {
            djoin /requestodj /loadfile C:\vmm.djoin /LOCALOS /WINDOWSPATH C:\Windows
        }

    Invoke-Command -VMId $vmm01.VMId -Credential $Script:localAdministratorCredential -ScriptBlock {
            ([ADSI]"WinNT://vmm01/Administrators,group").psbase.Invoke("Add",([ADSI]"WinNT://Relecloud/vmmserviceaccount").path)
        }
        
    # Steps torun inside of VM
    #
    # ADK Setup
    #
    # SQL Setup:
    # setup.exe /CONFIGURATIONFILE=D:\SQLConfigurationFile.ini /IAcceptSQLServerLicenseTerms
    #
    # Install-WindowsFeature Hyper-V-Tools,Hyper-V-PowerShell
    #
    # VMM Setup

    Invoke-Command -VMId $dc01.VMId -Credential $Script:relecloudAdministratorCredential -ArgumentList ($domainName, $Script:relecloudAdministratorCredential) -ScriptBlock {
            Param($domainName, $credential)

            ipmo 'C:\Program Files\Microsoft System Center 2016\Virtual Machine Manager\bin\psModules\virtualmachinemanager\virtualmachinemanager.psd1'
            
            #New-SCRunAsAccount -Credential $credential -Name "DomainAdministrator" -Description "" -JobGroup "dd4fa4fa-a60f-40c3-a00e-0f23f13efd59"

            Set-SCCloudCapacity -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -UseCustomQuotaCountMaximum $true -UseMemoryMBMaximum $true -UseCPUCountMaximum $true -UseStorageGBMaximum $true -UseVMCountMaximum $true

            $addCapabilityProfiles = @()
            $addCapabilityProfiles += Get-SCCapabilityProfile -Name "Hyper-V"

            Set-SCCloud -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -RunAsynchronously -ReadWriteLibraryPath "\\VMM01.relecloud.com\MSSCVMMLibrary\VHDs" -AddCapabilityProfile $addCapabilityProfiles

            $hostGroups = @()
            $hostGroups += Get-SCVMHostGroup -ID "0e3ba228-a059-46be-aa41-2f5cf0f4b96e"
            New-SCCloud -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -VMHostGroup $hostGroups -Name "Guarded Fabric" -Description "" -RunAsynchronously -ShieldedVMSupportPolicy "ShieldedVMSupported"

    }

    # Customization based on compute nodes

    Invoke-Command -VMId $dc01.VMId -Credential $Script:relecloudAdministratorCredential -ArgumentList ($domainName, $localAdministratorPassword) -ScriptBlock {
            Param($domainName, $localAdministratorPassword)
            # Add Compute Hosts to group
            Add-ADGroupMember "ComputeHosts" -Members "Compute01$"
            Add-ADGroupMember "ComputeHosts" -Members "Compute02$"
        }

    Invoke-Command -VMId $compute2.VMId -Credential $Script:relecloudAdministratorCredential -ScriptBlock {
            (Get-PlatformIdentifier –Name 'Compute02').InnerXml | Out-file C:\Compute02.xml
            New-CIPolicy –Level FilePublisher –Fallback Hash –FilePath 'C:\HW1CodeIntegrity.xml'
            ConvertFrom-CIPolicy –XmlFilePath 'C:\HW1CodeIntegrity.xml' –BinaryFilePath 'C:\HW1CodeIntegrity.p7b'
            Get-HgsAttestationBaselinePolicy -Path 'C:\HWConfig1.tcglog'
        }
}