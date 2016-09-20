Param(
    [string]$Cleanup,
    [int]$StartFromStage = 0,
    [int]$StopBeforeStage = 255,
    [int]$MemoryScaleFactor = 1
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

$Script:EnvironmentVMs = @()

$Script:stagenames = (
    "Stage 0 Create VMs", 
    "Stage 1 Roles, Computernames, Static IPs",
    "Stage 2 Prepare HGS, configure DHCP, create fabric domain",
    "Stage 3 Configure HGS, join compute nodes to domain"
    )

$Script:stage = $StartFromStage
$Script:MemoryScaleFactor = $MemoryScaleFactor

# (Get-WmiObject -q "SELECT * FROM Msvm_ComputerSystem WHERE ElementName = 'ImportantVM'" -n root\virtualization\v2).ProcessID

#######################################################################################
# Helper Functions
#######################################################################################

function Log-Message
{
    Param(
        [int]
        $Level = 0,

        [Parameter(Mandatory=$True)]
        [string] 
        $Message,

        [ValidateSet("Informational","Warning","Error")]
        $MessageType = "Informational"
    )
    Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -ForegroundColor Cyan -NoNewline
    Write-Host " $("`t"*$Level)" -ForegroundColor White -NoNewline
    
    switch ($MessageType) {
        "Informational" { Write-Host $Message }
        "Warning" { Write-Host $Message -ForegroundColor Yellow }
        "Error" { Write-Host $Message -ForegroundColor Red }
    }
}

function Reboot-VM {
    Param(
        [Microsoft.HyperV.PowerShell.VirtualMachine]$VM
    )
    If ($VM.State -eq "Running")
    {
        Stop-VM -VM $VM -ErrorAction SilentlyContinue | Out-Null
    }
    Start-VM -VM $VM
}

function Prepare-VM 
{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$VMname,
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
    $VMPath = $VHDXPath = Join-Path $FabricPath -ChildPath "$VMname"
    $VHDXPath = Join-Path $VMPath -ChildPath "Virtual Hard Disks\OSDisk.vhdx"

    $VM = Get-VM -VMName $VMname -ErrorAction SilentlyContinue
    If ($VM)
    {
        Log-Message -Level 1 -Message "[$VMname] Removing existing Virtual Machine"
        Stop-VM -VM $VM -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
        Get-VMSnapshot -VM $VM | Remove-VMSnapshot -Confirm:$false | Out-Null
        Remove-VM -VM $VM -Force -WarningAction SilentlyContinue | Out-Null
        If (Test-Path $VHDXPath)
        {
            Remove-Item -Path $VHDXPath -Force -ErrorAction Stop | Out-Null
        }
    }

    If (Test-Path $VHDXPath)
    {
        Log-Message -Level 1 -Message "[$VMname] Removing existing VHDX"
        Remove-Item -Path $VHDXPath -Force -ErrorAction Stop | Out-Null
    }

    Log-Message -Level 1 -Message "[$VMname] Creating new differencing disk" 
    New-VHD -Differencing -Path $VHDXPath -ParentPath $basediskpath -ErrorAction Stop | Out-Null
    
    If ($Script:MemoryScaleFactor -ne 1) 
    {
        Log-Message -Level 1 -Message "Multiplying memory assignment with factor $Script:MemoryScaleFactor"
        $startupmemory = $startupmemory * $Script:MemoryScaleFactor
    }

    Log-Message -Level 1 -Message "[$VMname] Creating Virtual Machine"
    $VM = New-VM -Name $VMname -MemoryStartupBytes $startupmemory -Path $FabricPath -VHDPath $VHDXPath -Generation 2 -SwitchName $switchname -ErrorAction Stop

    If ($processorcount -gt 1)
    {
        Log-Message -Level 1 -Message "[$VMname] Setting processor count to $processorcount"
        Set-VMProcessor -VM $VM -Count $processorcount  | Out-Null
    }
    If (-not $dynamicmemory)
    {
        Log-Message -Level 1 -Message "[$VMname] Disabling Dynamic Memory"
        Set-VMMemory -VM $VM -DynamicMemoryEnabled $false | Out-Null
    }
    If ($enablevirtualizationextensions)
    {
        Log-Message -Level 1 -Message "[$VMname] Enabling Virtualization Extensions"
        Set-VMProcessor -VM $VM -ExposeVirtualizationExtensions $true | Out-Null
        Log-Message -Level 1 -Message "[$VMname] Enabling Virtualization Extensions"
        Get-VMNetworkAdapter -VM $VM | Set-VMNetworkAdapter -MacAddressSpoofing on
    }
    If ($enablevtpm)
    {
        Log-Message -Level 1 -Message "[$VMname] Enabling vTPM"
        $keyprotector = New-HgsKeyProtector -Owner $Script:HgsGuardian -AllowUntrustedRoot
        Set-VMKeyProtector -VM $VM -KeyProtector $keyprotector.RawData -ErrorAction Stop | Out-Null
        Enable-VMTPM -VM $VM -ErrorAction Stop | Out-Null
    }

    if ($startvm)
    {
        Log-Message -Level 1 -Message "[$VMname] Starting VM"
        Start-VM $VM -ErrorAction Stop | Out-Null
    }

    # return vm
    $VM
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
        Log-Message -Message "Shutting down VMs for environment checkpoint for $($Script:stagenames[$Stage])"
        Stop-VM -VM $VirtualMachines -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    Log-Message -Message "Creating environment checkpoint for $($Script:stagenames[$Stage])"
    Checkpoint-VM -SnapshotName $Script:stagenames[$Stage] -VM $VirtualMachines | Out-Null
}

function Reset-EnvironmentToStageCheckpoint
{
    Param(
        [int]$Stage,
        [Microsoft.HyperV.PowerShell.VirtualMachine[]]$VirtualMachines = $Script:EnvironmentVMs
    )
    Log-Message -Message "Resetting environment to latest available stage checkpoint"
    $success = $false
    Do  
    {
        Log-Message -Level 1 -Message "Searching checkpoints for $($Script:stagenames[$Stage])"
        $Snapshots = Get-VMSnapshot -VM $VirtualMachines -Name $Script:stagenames[$Stage] -ErrorAction SilentlyContinue
        If ($Snapshots)
        {
            Stop-VM -VM $VirtualMachines -TurnOff -Force -WarningAction SilentlyContinue
            # todo: check if count is right
            Log-Message -Level 1 -Message "Checkpoints found. Restoring."
            $Snapshots | Restore-VMSnapshot -Confirm:$false
            # todo: delete later checkpoints
            $success = $True
            $Script:stage = $Stage + 1
        }
        If ($Stage -gt 0 -and -not $success)
        {
            Log-Message -Level 1 -Message "Checkpoints not found."
            $Stage--
        }
    } While (-not $success -and $Stage -ge -1)
    If (-not $success)
    {
        Log-Message -Level 1 -Message "Locating checkpoints not successful. Resetting current stage to 0"
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
        Log-Message -Level 1 -Message "Starting VM $($VirtualMachine.VMName)"
        Start-VM $VirtualMachine -ErrorAction Stop | Out-Null
    }
    
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            Log-Message -Level 1 -Message "Integration components did not come up after 10 minutes" -MessageType Error
            throw
        } 
        Start-Sleep -sec 1
    } 
    until ((Get-VMIntegrationService -VM $VirtualMachine |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47").PrimaryStatusDescription -eq "OK")
    Log-Message -Level 1 -Message "Heartbeat IC connected."

    Log-Message -Level 1 -Message "Waiting for PSDirect connection to $($VirtualMachine.VMName) to be available"
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            Log-Message -Level 1 -Message "Could not connect to PS Direct after 10 minutes" -MessageType Error
            throw
        } 
        Start-Sleep -sec 1
        $psReady = Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
    } 
    until ($psReady)
    
    Log-Message -Level 1 -Message "Executing Script Block"
    If ($ArgumentList)
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList -ErrorAction SilentlyContinue    
    }
    else 
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ErrorAction SilentlyContinue    
    }
    
}

Function Begin-Stage {
    Log-Message -Message "Begin $($Script:stagenames[$Script:stage])"
    $Script:StageStartTime = Get-Date
}

Function End-Stage {
    Log-Message -Message "End of $($Script:stagenames[$Script:stage]) - Duration: $(((Get-Date) - $Script:StageStartTime))"
    Create-EnvironmentStageCheckpoint
    $Script:stage++
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

#######################################################################################
# Initialization of additional variables
#######################################################################################

$Script:HgsGuardian = Get-HgsGuardian UntrustedGuardian -ErrorAction SilentlyContinue
if (!$Script:HgsGuardian) {
    Log-Message -Message "Local Guardian not found - creating UntrustedGuardian"
    $Script:HgsGuardian = New-HgsGuardian -Name UntrustedGuardian –GenerateCertificates -ErrorAction Stop
}

if (-not (Get-VMSwitch -Name $Script:fabricSwitch -ErrorAction SilentlyContinue)) {
    Log-Message -Message "Fabric Switch not found - creating internal switch"
    New-VMSwitch -Name $Script:fabricSwitch -SwitchType Internal -ErrorAction Stop #| Out-Null
}

$hgs01 = Get-VM -VMName $Script:VmNameHgs #-ErrorAction SilentlyContinue
$dc01 = Get-VM -VMName $Script:VmNameDc #-ErrorAction SilentlyContinue
$VMm01 = Get-VM -VMName $Script:VmNameVmm #-ErrorAction SilentlyContinue
$compute01 = Get-VM -VMName "$Script:VmNameCompute 01" #-ErrorAction SilentlyContinue
$compute02 = Get-VM -VMName "$Script:VmNameCompute 02" #-ErrorAction SilentlyContinue

if ($hgs01 -and $dc01 -and $VMm01 -and $compute01 -and $compute02)
{
    Log-Message -Message "Initializing variable storing environment VMs"
    $Script:EnvironmentVMs = $hgs01, $dc01, $VMm01, $compute01, $compute02    
}
else 
{
    Log-Message -Message "Starting from Stage 0 since not all VMs could be found"
    $StartFromStage = 0
    $Script:stage = 0
}

#######################################################################################
# Beginning of Environment Build
#######################################################################################

If ($StartFromStage -gt 1)
{
    Reset-EnvironmentToStageCheckpoint -Stage ($StartFromStage-1)
}

#######################################################################################
# Beginning of Stage 0: Create VMs
#######################################################################################
If ($Script:stage -eq 0 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage
    $hgs01 = Prepare-VM -vmname $Script:VmNameHgs -basediskpath $Script:baseServerCorePath -dynamicmemory $true
    $dc01 = Prepare-VM -vmname $Script:VmNameDc -basediskpath $Script:baseServerCorePath -dynamicmemory $true
    $VMm01 = Prepare-VM -vmname $Script:VmNameVmm -basediskpath $Script:baseServerStandardPath
    $compute01 = Prepare-VM -vmname "$Script:VmNameCompute 01" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    $compute02 = Prepare-VM -vmname "$Script:VmNameCompute 02" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    
    $Script:EnvironmentVMs = ($hgs01, $dc01, $VMm01, $compute01, $compute02)
    End-Stage
} 

#######################################################################################
# End of Stage 0: Create VMs
#######################################################################################

#######################################################################################
# Beginning of Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################
If ($Script:stage -eq 1 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    Log-Message -Level 1 -Message "Starting all VMs to parallelize specialization"
    Start-VM -VM $Script:EnvironmentVMs -ErrorAction Stop | Out-Null

    $scriptBlock = {
            Param(
                [hashtable]$param
            )
            If ($param["features"])
            {
                Write-Host "Calling Install-WindowsFeature $($param["features"])"
                Install-WindowsFeature $param["features"] -IncludeManagementTools #-ErrorAction Stop #| Out-Null
            }
            If ($param["ipaddress"])
            {
                Write-Host "Setting Network configuration: IP $($param["ipaddress"])"
                Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $param["ipaddress"] -PrefixLength 24 | Out-Null
            }
            Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses 192.168.42.1}
            If ($param["computername"])
            {
                Write-Host "Renaming computer to $($param["computername"])"
                Rename-Computer $param["computername"] -WarningAction SilentlyContinue | Out-Null
            }
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            features="HostGuardianServiceRole";
            ipaddress="192.168.42.99";
            computername="HGS01"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            features=("AD-Domain-Services","DHCP");
            ipaddress="192.168.42.1";
            computername="DC01"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $VMm01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            features=("NET-Framework-Features", "NET-Framework-Core", "Web-Server", "ManagementOData", "Web-Dyn-Compression", "Web-Basic-Auth", "Web-Windows-Auth", "Web-Scripting-Tools", "WAS", "WAS-Process-Model", "WAS-NET-Environment", "WAS-Config-APIs");
            computername="VMM01"
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            computername="Compute01"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdministratorCredential -ScriptBlock $scriptBlock -ArgumentList @{
            computername="Compute02"
        }

    End-Stage
} 
# Defining all VMs that are part of the environment
#######################################################################################
# End of  Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################

#######################################################################################
# Beginning of Stage 2 Prepare HGS, configure DHCP, create fabric domain
#######################################################################################
If ($Script:stage -eq 2 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Preparing Host Guardian Service"
            Install-HgsServer -HgsDomainName $param["hgsdomainname"] -SafeModeAdministratorPassword $param["adminpassword"] -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            hgsdomainname=$hgsDomainName;
            adminpassword=$localAdministratorPassword
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "`tSetting PowerShell as default shell"
            Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "PowerShell.exe" | Out-Null

            Write-Host "Configuring DHCP Server"
            Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
            Add-DhcpServerv4Scope -Name default -StartRange 192.168.42.100 -EndRange 192.168.42.200 -SubnetMask 255.255.255.0 #| Out-Null
            Set-DhcpServerv4OptionValue -DnsDomain $param["domainname"] -DnsServer 192.168.42.1 #| Out-Null
            Set-DhcpServerv4OptionValue -OptionId 6 -value "192.168.42.1"

            Write-Host "Creating fabric domain $($param["domainName"])"
            Install-ADDSForest -DomainName $param["domainName"] -SafeModeAdministratorPassword $param["adminpassword"] -Force -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            domainname=$domainName;
            adminpassword=$localAdministratorPassword
        }

    Reboot-VM -vm $dc01

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            #Add-DhcpServerInDC -DnsName "dc01.$($param["domainname"])"
            #Restart-Service DHCPServer -WarningAction SilentlyContinue | Out-Null

            Write-Host "Creating AD Users and Groups"
            Write-Host "Creating User Lars" -NoNewline
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline
                New-ADUser -Name "Lars" -SAMAccountName "lars" -GivenName "Lars" -DisplayName "Lars" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host ""

            Write-Host "Creating VMM service account user" -NoNewline
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline
                New-ADUser -Name "vmmserviceaccount" -SAMAccountName "vmmserviceaccount" -GivenName "VMM" -DisplayName "vmmserviceaccount" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host ""

            Write-Host "Creating ComputeHosts group" -NoNewline
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline
                New-ADGroup -Name "ComputeHosts" -DisplayName "Hyper-V Compute Hosts" -GroupCategory Security -GroupScope Universal  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host ""

            Write-Host "Registering DHCP server with DC" -NoNewline
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline
                Add-DhcpServerInDC -ErrorAction Continue
            } until ($?) 
            Write-Host ""
            
            Write-Host "Creating offline domain join blobs for compute hosts in domain $($param["domainname"])"
            mkdir C:\djoin
            djoin /Provision /Domain $($param["domainname"]) /Machine Compute01 /SaveFile C:\djoin\Compute01.djoin
            djoin /Provision /Domain $($param["domainname"]) /Machine Compute02 /SaveFile C:\djoin\Compute02.djoin
            New-SmbShare -Path C:\djoin -Name djoin -ContinuouslyAvailable $true -ReadAccess Everyone
            #djoin /Provision /Domain $($param["domainname"]) /Machine VMM01 /SaveFile C:\djoin\VMM.djoin        
        } -ArgumentList @{
            domainname=$domainName;
            adminpassword=$localAdministratorPassword
        }
    End-Stage
} 
#######################################################################################
# End of Stage 2 Prepare HGS, configure DHCP, create fabric domain
#######################################################################################

#######################################################################################
# Beginning of Stage 3 Configure HGS, join compute nodes to domain
#######################################################################################
If ($Script:stage -eq 3 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdministratorCredential -ScriptBlock {
            Param(
                [hashtable]$param
            )
            New-Item -Path 'C:\HgsCertificates' -ItemType Directory | Out-Null

            Write-Host "Creating self-signed certificates for HGS configuration"
            $signingCert = New-SelfSignedCertificate -DnsName "signing.$($param["hgsdomainname"])"
            Export-PfxCertificate -Cert $signingCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\signing.pfx | Out-Null
            $encryptionCert = New-SelfSignedCertificate -DnsName "encryption.$($param["hgsdomainname"])"
            Export-PfxCertificate -Cert $encryptionCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\encryption.pfx | Out-Null

            Write-Host "Removing certificates from local store after exporting"
            Remove-Item $EncryptionCert.PSPath, $SigningCert.PSPath -DeleteKey -ErrorAction Continue | Out-Null

            Write-Host "Configuring Host Guardian Service - AD-based trust"
            Initialize-HgsServer -HgsServiceName service -SigningCertificatePath C:\HgsCertificates\signing.pfx -SigningCertificatePassword $param["adminpassword"] -EncryptionCertificatePath C:\HgsCertificates\encryption.pfx -EncryptionCertificatePassword $certificatePassword -TrustActiveDirectory -WarningAction SilentlyContinue | Out-Null

            Write-Host "Fixing up the cluster network"
            (Get-ClusterNetwork).Role = 3

        } -ArgumentList @{
            hgsdomainname=$hgsDomainName
            adminpassword=$localAdministratorPassword
        }

    Start-VM $dc01

    $ScriptBlock_DomainJoin = {
            Param(
                [hashtable]$param
            )
            Write-Host "Waiting for domain controller $($param["domainname"])"
            while (!(Test-Connection -Computername "$(($using:EnvironmentVMs | ?{$_.VMName -contains "Domain Controller"}).IPAddress)" -BufferSize 16 -Count 1 )) #-Quiet -ea SilentlyContinue 
            {
                Start-Sleep -Seconds 2
            }
            Write-Host "Joining system to domain $($param["domainname"])" -NoNewline
            $cred = New-Object System.Management.Automation.PSCredential ($param["domainuser"], $param["domainpwd"])
            do {
                Write-Host "." -NoNewline
                Start-Sleep -Seconds 1
                Add-Computer -DomainName $param["domainname"] -Credential $cred -ErrorAction SilentlyContinue | Out-Null    
            } until ($?)
            Write-Host ""
        }

    Invoke-CommandWithPSDirect -VirtualMachine $VMm01 -Credential $Script:localAdministratorCredential -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList @{
            domainname=$domainName;
            domainuser="relecloud\administrator";
            domainpwd=$localAdministratorPassword
        }

#    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdministratorCredential -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList @{
#            domainname=$domainName;
#            domainuser="relecloud\administrator";
#            domainpwd=$localAdministratorPassword
#        }
#    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdministratorCredential -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList @{
#            domainname=$domainName;
#            domainuser="relecloud\administrator";
#            domainpwd=$localAdministratorPassword
#        }
    #Write-Host "`tCopying offline domain-join blobs to host"
    #$s = New-PSSession -VMId $dc01.VMId -Credential $Script:relecloudAdministratorCredential
    #Copy-Item -FromSession $s -Path C:\djoin\Compute01.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    #Copy-Item -FromSession $s -Path C:\djoin\Compute02.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    #Copy-Item -FromSession $s -Path C:\djoin\VMM.djoin -Destination (Join-Path $Script:basePath -ChildPath fabric) | Out-Null
    #Remove-PSSession $s | Out-Null

    End-Stage
} 
#######################################################################################
# End of Stage 3 Configure HGS, join compute nodes to domain
#######################################################################################

#New-NanoServerImage -ComputerName "NanoVM" -Compute -DeploymentType Guest -Edition Datacenter -MediaPath $Script:baseMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-ShieldedVM-Package -TargetPath $compute2VHDXPath -EnableRemoteManagementPort -AdministratorPassword $localAdministratorPassword -InterfaceNameOrIndex Ethernet -Ipv4Address 192.168.42.202 -Ipv4SubnetMask 255.255.255.0 -Ipv4Dns 192.168.42.1 -Ipv4Gateway 192.168.42.1 | Out-Null
if ($Script:stage -eq 99)
    {
    #######################################################################################
    # Customizing VMs
    #######################################################################################

    # Add VMM additional disk
    $VMMDataVHDXPath = Join-Path $Script:basePath -ChildPath "\fabric\VMM01Data.vhdx"
    New-VHD -Dynamic -SizeBytes 30GB -Path $VMMDataVHDXPath #| Out-Null
    Add-VMHardDiskDrive -VM $VMm01 -Path $VMMDataVHDXPath #| Out-Null

    #Steps to run inside of the DC: 

    # Wait for restart!!

    #create share \\dc01\VMs

    # Create Group for compute nodes
    # Add compute1, compute2 to compute nodes
    # Grant Permissions to Share for Compute nodes

    #Copying offline domain join blobs to host

    # Customizing VMM
    Copy-VMFile -VM $VMm01 -SourcePath (Join-Path $Script:basePath -ChildPath "fabric\VMM.djoin") -DestinationPath C:\VMM.djoin -Credential $Script:localAdministratorCredential

    Invoke-Command -VMId $VMm01.VMId -Credential $Script:localAdministratorCredential -ScriptBlock {
            djoin /requestodj /loadfile C:\vmm.djoin /LOCALOS /WINDOWSPATH C:\Windows
        }

    Invoke-Command -VMId $VMm01.VMId -Credential $Script:localAdministratorCredential -ScriptBlock {
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