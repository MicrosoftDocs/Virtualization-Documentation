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

$Script:domainName = "relecloud.com"
$Script:hgsDomainName = "hgs.$($Script:domainName)"
$Script:clearTextPassword = "P@ssw0rd."
$Script:passwordSecureString = ConvertTo-SecureString -AsPlainText $Script:clearTextPassword -Force

$Script:internalSwitchName = "FabricInternal"
$Script:internalSubnet = "10.10.42."
$Script:externalSwitchName = "FabricExternal"
$Script:fabricSwitch = $Script:internalSwitchName


$Script:localAdminCred = New-Object System.Management.Automation.PSCredential ("administrator", $Script:passwordSecureString)
$Script:relecloudAdminCred = New-Object System.Management.Automation.PSCredential ("relecloud\administrator", $Script:passwordSecureString)
$Script:hgsAdminCred = New-Object System.Management.Automation.PSCredential ("hgs\administrator", $Script:passwordSecureString)

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
    "Stage 3 Configure HGS in AD mode, join compute nodes to domain"
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
        Log-Message -Level 1 -Message "Shutting down $($VM.VMName)"
        Stop-VM -VM $VM -ErrorAction SilentlyContinue | Out-Null
    }
    Log-Message -Level 1 -Message "Starting $($VM.VMName)"
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
        Log-Message -Level 1 -Message "[$VMname] Multiplying memory assignment with factor $Script:MemoryScaleFactor"
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
    
    For ($i=$Stage+1; $i -lt ($Script:stagenames).Count; $i++)
    {
        $Snapshots = Get-VMSnapshot -VM $VirtualMachines -Name $Script:stagenames[$i] -ErrorAction SilentlyContinue 
        If ($Snapshots)
        {
            Log-Message -Level 1 -Message "Removing checkpoints for stage $($Script:stagenames[$i])"
            $Snapshots | Remove-VMSnapshot -Confirm:$false 
        }
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

    Log-Message -Level 1 -Message "Waiting for PSDirect connection to $($VirtualMachine.VMName) for $($Credential.UserName)"
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

function Copy-ItemToVm
{
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential,
        
        [Parameter(Mandatory=$true)]
        [String]
        $SourcePath,

        [Parameter(Mandatory=$true)]
        [String]
        $DestinationPath
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

    Log-Message -Level 1 -Message "Opening PowerShell session to VM $($VirtualMachine.Name)"
    $s = New-PSSession -VMId $VirtualMachine.VMId -Credential $Credential
    Invoke-Command -Session $s -ScriptBlock {
        $path = Split-Path -Path $using:DestinationPath -Parent
        If (-not (Test-Path $path))
        {
            New-Item -ItemType Directory -Path $path | Out-Null
        } 
    }
    Log-Message -Level 1 -Message "Copying file to VM $($VirtualMachine.Name)"
    Copy-Item -ToSession $s -Path $SourcePath -Destination $DestinationPath  | Out-Null
    Log-Message -Level 1 -Message "Closing PowerShell session"
    Remove-PSSession $s | Out-Null

    #Copy-VMFile -VM $VirtualMachine -SourcePath $SourcePath -DestinationPath $DestinationPath -FileSource Host -CreateFullPath
}

Function WaitFor-ActiveDirectory {
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Log-Message -Level 1 -Message "Waiting for AD to be available"
    Invoke-CommandWithPSDirect -VirtualMachine $VirtualMachine -Credential $Credential -ScriptBlock {
        do {
            Write-Host "." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 2
            Get-ADComputer $env:COMPUTERNAME 
        } until ($?)
    }
    Log-Message -Level 1 -Message "succeeded."
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
# Start of script 
#######################################################################################
$Script:ScriptStartTime = Get-Date
Log-Message -Message "Starting script"

#######################################################################################
# Explicit cleanup
#######################################################################################

If (($Cleanup -eq "VM") -or ($Cleanup -eq "Everything"))
{
    Log-Message -Message "[Cleanup] Removing existing VMs"
    Get-VM | Stop-VM -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
    Get-VM | Remove-VM -Force -WarningAction SilentlyContinue | Out-Null
    Get-ChildItem -Path (Join-Path $Script:basePath -ChildPath fabric) -Recurse | Remove-Item -Force -Recurse -WarningAction SilentlyContinue | Out-Null
}
If (($Cleanup -eq "Baseimages") -or ($Cleanup -eq "Everything"))
{
    Log-Message -Message "[Cleanup] Removing existing base VHDXs"
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
    Log-Message -Message "[Prepare] Running Image converter script to get Convert-WindowsImage function"
    . $Script:ImageConverterPath
}

if (-Not (Test-Path $Script:baseServerCorePath))
{
    Log-Message -Message "[Prepare] Creating Server Datacenter Core base VHDX"
    Convert-WindowsImage -SourcePath (Join-Path $Script:baseMediaPath -ChildPath "sources\Install.wim") -VHDPath $Script:baseServerCorePath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
}

if (-Not (Test-Path $Script:baseServerStandardPath))
{
    Log-Message -Message "[Prepare] Creating Server Standard Full UI base VHDX"
    Convert-WindowsImage -SourcePath (Join-Path $Script:baseMediaPath -ChildPath "sources\Install.wim") -VHDPath $Script:baseServerStandardPath -DiskLayout UEFI -Edition SERVERSTANDARD -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
}

if (-Not (Test-Path $Script:baseNanoServerPath))
{
    Log-Message -Message "[Prepare] Creating Nano Server Datacenter base VHDX"
    # Importing Nano Server Image Generator PowerShell Module
    Import-Module (Join-Path $Script:baseMediaPath -ChildPath "\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1") | Out-Null

    New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:baseMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-SCVMM-Package,Microsoft-NanoServer-SCVMM-Compute-Package  -TargetPath $Script:baseNanoServerPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString | Out-Null
}

#######################################################################################
# Initialization of additional variables
#######################################################################################

$Script:HgsGuardian = Get-HgsGuardian UntrustedGuardian -ErrorAction SilentlyContinue
if (!$Script:HgsGuardian) {
    Log-Message -Message "[Prepare] Local Guardian not found - creating UntrustedGuardian"
    $Script:HgsGuardian = New-HgsGuardian -Name UntrustedGuardian –GenerateCertificates -ErrorAction Stop
}

if (-not (Get-VMSwitch -Name $Script:fabricSwitch -ErrorAction SilentlyContinue)) {
    Log-Message -Message "[Prepare] Fabric Switch not found - creating internal switch"
    New-VMSwitch -Name $Script:fabricSwitch -SwitchType Internal -ErrorAction Stop | Out-Null
}

$hgs01 = Get-VM -VMName $Script:VmNameHgs -ErrorAction SilentlyContinue
$dc01 = Get-VM -VMName $Script:VmNameDc -ErrorAction SilentlyContinue
$vmm01 = Get-VM -VMName $Script:VmNameVmm -ErrorAction SilentlyContinue
$compute01 = Get-VM -VMName "$Script:VmNameCompute 01" -ErrorAction SilentlyContinue
$compute02 = Get-VM -VMName "$Script:VmNameCompute 02" -ErrorAction SilentlyContinue

if ($hgs01 -and $dc01 -and $vmm01 -and $compute01 -and $compute02)
{
    Log-Message -Message "[Prepare] Initializing variable storing environment VMs"
    $Script:EnvironmentVMs = $hgs01, $dc01, $vmm01, $compute01, $compute02    
}
else 
{
    Log-Message -Message "[Prepare] Starting from Stage 0 since not all VMs could be found"
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
    $vmm01 = Prepare-VM -vmname $Script:VmNameVmm -basediskpath $Script:baseServerStandardPath
    $compute01 = Prepare-VM -vmname "$Script:VmNameCompute 01" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    $compute02 = Prepare-VM -vmname "$Script:VmNameCompute 02" -processorcount 4 -startupmemory 2GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:baseNanoServerPath
    
    $Script:EnvironmentVMs = ($hgs01, $dc01, $vmm01, $compute01, $compute02)
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

    $ScriptBlock_FeaturesComputerName = {
            Param(
                [hashtable]$param
            )
            If ($param["features"])
            {
                If ($param["featuresource"])
                {
                    Write-Host "Calling Install-WindowsFeature $($param["features"]) using source path $($param["featuresource"])" -ForegroundColor Gray
                    Install-WindowsFeature $param["features"] -IncludeManagementTools -Source $param["featuresource"] -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null
                } else {
                    Write-Host "Calling Install-WindowsFeature $($param["features"])" -ForegroundColor Gray
                    Install-WindowsFeature $param["features"] -IncludeManagementTools -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null                    
                }
            }
            If ($param["ipaddress"])
            {
                Write-Host "Setting Network configuration: IP $($param["ipaddress"])" -ForegroundColor Gray
                Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $param["ipaddress"] -PrefixLength 24 | Out-Null
            }
            Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "$($param["subnet"])1"}
            If ($param["computername"])
            {
                Write-Host "Renaming computer to $($param["computername"])" -ForegroundColor Gray
                Rename-Computer $param["computername"] -WarningAction SilentlyContinue | Out-Null
            }
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("AD-Domain-Services","DHCP");
            ipaddress="$($Script:internalSubnet)1";
            computername="DC01";
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features="HostGuardianServiceRole";
            ipaddress="$($Script:internalSubnet)99";
            computername="HGS01";
            subnet=$Script:internalSubnet
        }

    Copy-ItemToVm -VirtualMachine $vmm01 -SourcePath (Join-Path $Script:baseMediaPath -ChildPath "sources\sxs\microsoft-windows-netfx3-ondemand-package.cab") -DestinationPath C:\sxs\microsoft-windows-netfx3-ondemand-package.cab -Credential $Script:localAdminCred

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("NET-Framework-Features", "NET-Framework-Core", "Web-Server", "ManagementOData", "Web-Dyn-Compression", "Web-Basic-Auth", "Web-Windows-Auth", "Web-Scripting-Tools", "WAS", "WAS-Process-Model", "WAS-NET-Environment", "WAS-Config-APIs");
            featuresource="C:\sxs";
            computername="VMM01";
            subnet=$Script:internalSubnet
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            computername="Compute01";
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            computername="Compute02";
            subnet=$Script:internalSubnet
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

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Setting PowerShell as default shell" -ForegroundColor Gray
            Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "PowerShell.exe" | Out-Null

            Write-Host "Configuring DHCP Server" -ForegroundColor Gray
            Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
            Add-DhcpServerv4Scope -Name "IPv4 network" -StartRange "$($param["subnet"])100" -EndRange "$($param["subnet"])200" -SubnetMask 255.255.255.0 | Out-Null
            Write-Host "Creating fabric domain $($param["domainName"])" -ForegroundColor Gray
            Install-ADDSForest -DomainName $param["domainName"] -SafeModeAdministratorPassword $param["adminpassword"] `
                               -InstallDNS -NoDNSonNetwork -NoRebootOnCompletion -Force -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            domainname=$Script:domainName;
            adminpassword=$Script:passwordSecureString;
            subnet=$Script:internalSubnet
        }

    Reboot-VM -vm $dc01 | Out-Null
    WaitFor-ActiveDirectory -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Creating AD Users and Groups" -ForegroundColor Gray
            Write-Host "Creating User Lars" -NoNewline -ForegroundColor Gray
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADUser -Name "Lars" -SAMAccountName "lars" -GivenName "Lars" -DisplayName "Lars" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." -ForegroundColor Gray
            Add-ADGroupMember "Domain Admins" "Lars"

            Write-Host "Creating VMM service account user" -NoNewline -ForegroundColor Gray
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADUser -Name "vmmserviceaccount" -SAMAccountName "vmmserviceaccount" -GivenName "VMM" -DisplayName "vmmserviceaccount" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." -ForegroundColor Gray

            Write-Host "Creating ComputeHosts group" -NoNewline -ForegroundColor Gray
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADGroup -Name "ComputeHosts" -DisplayName "Hyper-V Compute Hosts" -GroupCategory Security -GroupScope Universal  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." -ForegroundColor Gray

            Set-DhcpServerv4OptionValue -DnsDomain $param["domainname"] -DnsServer "$($param["subnet"]).1" | Out-Null
            Set-DhcpServerv4OptionValue -OptionId 6 -value "$($param["subnet"]).1"

            Write-Host "Registering DHCP server with DC" -NoNewline -ForegroundColor Gray
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                Add-DhcpServerInDC -ErrorAction Continue
            } until ($?) 
            Write-Host "done." -ForegroundColor Gray
            
            Write-Host "Creating offline domain join blobs for compute hosts in domain $($param["domainname"])" -ForegroundColor Gray
            New-Item -Path 'C:\djoin' -ItemType Directory | Out-Null
            Start-Process "djoin.exe" -Verb RunAs -ArgumentList "/Provision", "/Domain $($param["domainname"])", "/Machine Compute01", "/SaveFile C:\djoin\Compute01.djoin"
            Start-Process "djoin.exe" -Verb RunAs -ArgumentList "/Provision", "/Domain $($param["domainname"])", "/Machine Compute02", "/SaveFile C:\djoin\Compute02.djoin"

            Write-Host "Adding offline provisioned systems to ComputeHosts group" -ForegroundColor Gray
            Add-ADGroupMember "ComputeHosts" -Members "Compute01$"
            Add-ADGroupMember "ComputeHosts" -Members "Compute02$"

        } -ArgumentList @{
            domainname=$Script:domainName;
            adminpassword=$Script:passwordSecureString;
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Preparing Host Guardian Service" -ForegroundColor Gray
            Install-HgsServer -HgsDomainName $param["hgsdomainname"] -SafeModeAdministratorPassword $param["adminpassword"] -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            hgsdomainname=$Script:hgsDomainName;
            adminpassword=$Script:passwordSecureString
        }

    Reboot-VM $hgs01 | Out-Null
    WaitFor-ActiveDirectory -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred | Out-Null

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred -ScriptBlock {
        Param(
            [hashtable]$param
        )

        New-Item -Path 'C:\HgsCertificates' -ItemType Directory | Out-Null

        Write-Host "Creating self-signed certificates for HGS configuration" -ForegroundColor Gray
        $signingCert = New-SelfSignedCertificate -DnsName "signing.$($param["hgsdomainname"])"
        Export-PfxCertificate -Cert $signingCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\signing.pfx | Out-Null
        $encryptionCert = New-SelfSignedCertificate -DnsName "encryption.$($param["hgsdomainname"])"
        Export-PfxCertificate -Cert $encryptionCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\encryption.pfx | Out-Null

        Write-Host "Removing certificates from local store after exporting" -ForegroundColor Gray 
        Remove-Item $EncryptionCert.PSPath, $SigningCert.PSPath -DeleteKey -ErrorAction Continue | Out-Null

        Write-Host "Configuring Host Guardian Service - AD-based trust" -ForegroundColor Gray
        Initialize-HgsServer -HgsServiceName service -SigningCertificatePath C:\HgsCertificates\signing.pfx `
            -SigningCertificatePassword $param["adminpassword"] -EncryptionCertificatePath C:\HgsCertificates\encryption.pfx `
            -EncryptionCertificatePassword $certificatePassword -TrustActiveDirectory -WarningAction SilentlyContinue | Out-Null

        Write-Host "Fixing up the cluster network" -ForegroundColor Gray
        (Get-ClusterNetwork).Role = 3

        Write-Host "Speeding up DNS registration of cluster network name" -ForegroundColor Gray
        Get-ClusterResource -Name HgsClusterResource | Update-ClusterNetworkNameResource | Out-Null

    } -ArgumentList @{
        hgsdomainname=$Script:hgsDomainName
        adminpassword=$Script:passwordSecureString
    }


    End-Stage
} 
#######################################################################################
# End of Stage 2 Prepare HGS, configure DHCP, create fabric domain
#######################################################################################

#######################################################################################
# Beginning of Stage 3 Configure HGS in AD mode, join compute nodes to domain
#######################################################################################
If ($Script:stage -eq 3 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    $ComputeHostsSID = Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
        Write-Host "Retrieving SID for group ComputeHosts" -NoNewline -ForegroundColor Gray
        do {
            Write-Host "." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 2
            $sid = Get-ADGroup ComputeHosts -ErrorAction SilentlyContinue | select -ExpandProperty SID | select -ExpandProperty Value
        } until ($?)
        Write-Host " SID: $sid" -ForegroundColor Gray
        $sid
    } # This also ensures that AD functionality is up and running before continuing.

    Start-VM $hgs01 | Out-Null

    $ScriptBlock_DomainJoin = {
            Param(
                [hashtable]$param
            )
            $dcip = $(($using:EnvironmentVMs | ?{$_.VMName -contains "Domain Controller"}).IPAddress)
            Write-Host "Waiting for domain controller $($param["domainname"]) at $dcip" -ForegroundColor Gray
            while (!(Test-Connection -Computername "$dcip" -BufferSize 16 -Count 1 )) #-Quiet -ea SilentlyContinue 
            {
                Start-Sleep -Seconds 2
            }
            $edition = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion')| Select -expandproperty EditionID
            Write-Host "Joining system $($env:COMPUTERNAME) ($($edition)) to domain $($param["domainname"])." -NoNewline -ForegroundColor Gray
            switch ($edition)
            {
                "ServerDataCenterNano" {
                    $djoinpath = "\\$(($using:EnvironmentVMs | ?{$_.VMName -contains "Domain Controller"}).IPAddress)\c$\djoin\$($env:COMPUTERNAME).djoin"
                    Write-Host " Using $djoinpath" -ForegroundColor Gray
                    Start-Process "djoin.exe" -Verb RunAs -ArgumentList "/requestodj", '/loadfile $djoinpath', "/windowspath c:\windows", "/localos"
                }
                default {
                    $cred = New-Object System.Management.Automation.PSCredential ($param["domainuser"], $param["domainpwd"])
                    do {
                        Write-Host "." -NoNewline -ForegroundColor Gray
                        Start-Sleep -Seconds 2
                        Add-Computer -DomainName $param["domainname"] -Credential $cred -ErrorAction SilentlyContinue -WarningAction SilentlyContinue| Out-Null    
                    } until ($?)
                    Write-Host "done." -ForegroundColor Gray
                }
            }
        }
    
    $Arg_DomainJoin = @{
            domainname=$Script:domainName;
            domainuser="relecloud\administrator";
            domainpwd=$Script:passwordSecureString
        }

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin 
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin
    
    Reboot-VM $compute01
    Reboot-VM $compute02

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Creating a DNS forwarder to the fabric AD $($param["domainname"])" -ForegroundColor Gray
            Add-DnsServerConditionalForwarderZone -Name $($param["domainname"]) -MasterServers "$($param["subnet"])1"

            Write-Host "Adding a one-way trust to the fabric AD $($param["domainname"])" -ForegroundColor Gray
            Start-Process "netdom.exe" -Verb RunAs -ArgumentList "trust", "$($param["hgsdomainname"])", "/domain:$($param["domainname"])", "/userD:$($param["domainuser"])", "/passwordD:$($param["domainpwd"])" /add

            Write-Host "Adding SID $($param["computehostssid"]) to HGS attestation" -ForegroundColor Gray
            Add-HgsAttestationHostGroup -Name "ComputeHosts" -Identifier $param["computehostssid"]
        } -ArgumentList @{
            domainname=$Script:domainName;
            domainuser="relecloud\administrator";
            domainpwd=$Script:clearTextPassword;
            hgsdomainname=$Script:hgsDomainName;
            computehostssid = $ComputeHostsSID;
            subnet=$Script:internalSubnet
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            Write-Host "Creating DNS Zone delegation to HGS for $($param["domainname"])" -ForegroundColor Gray
            Add-DnsServerZoneDelegation -Name $($param["domainname"]) -ChildZone "hgs" -NameServer "hgs01.$($param["domainname"])" -IPAddress "$($param["subnet"])99"
            #Add-DnsServerConditionalForwarderZone -Name "hgs.relecloud.com" -MasterServers "$($param["subnet"])99"
        } -ArgumentList @{
            domainname=$Script:domainName;
            hgsdomainname=$Script:hgsDomainName
            subnet=$Script:internalSubnet
        }

    $ScriptBlock_HgsClientConfiguration = {
        Param(
                [hashtable]$param
        )
        Write-Host "Configuring HGS Client" -ForegroundColor Gray
        Set-HgsClientConfiguration -KeyProtectionServerUrl $param["keyprotectionserverurl"] -AttestationServerUrl $param["attestationserverurl"]
    }

    $Arg_HgsClientConfiguration = @{
            keyprotectionserverurl="http://service.$($Script:hgsDomainName)/KeyProtection";
            attestationserverurl="http://service.$($Script:hgsDomainName)/Attestation"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_HgsClientConfiguration -ArgumentList $Arg_HgsClientConfiguration 
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_HgsClientConfiguration -ArgumentList $Arg_HgsClientConfiguration

    End-Stage
} 
#######################################################################################
# End of Stage 3 Configure HGS in AD mode, join compute nodes to domain
#######################################################################################

#New-NanoServerImage -ComputerName "NanoVM" -Compute -DeploymentType Guest -Edition Datacenter -MediaPath $Script:baseMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-ShieldedVM-Package -TargetPath $compute2VHDXPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString -InterfaceNameOrIndex Ethernet -Ipv4Address 192.168.42.202 -Ipv4SubnetMask 255.255.255.0 -Ipv4Dns 192.168.42.1 -Ipv4Gateway 192.168.42.1 | Out-Null
if ($Script:stage -eq 99)
    {
    #######################################################################################
    # Customizing VMs
    #######################################################################################

    # Add VMM additional disk
    $VMMDataVHDXPath = Join-Path $Script:basePath -ChildPath "\fabric\VMM01Data.vhdx"
    New-VHD -Dynamic -SizeBytes 30GB -Path $VMMDataVHDXPath #| Out-Null
    Add-VMHardDiskDrive -VM $vmm01 -Path $VMMDataVHDXPath #| Out-Null

    #Steps to run inside of the DC: 

    # Wait for restart!!

    #create share \\dc01\VMs

    # Create Group for compute nodes
    # Add compute1, compute2 to compute nodes
    # Grant Permissions to Share for Compute nodes

    #Copying offline domain join blobs to host

    # Customizing VMM
    Copy-VMFile -VM $vmm01 -SourcePath (Join-Path $Script:basePath -ChildPath "fabric\VMM.djoin") -DestinationPath C:\VMM.djoin -Credential $Script:localAdminCred

    Invoke-Command -VMId $vmm01.VMId -Credential $Script:localAdminCred -ScriptBlock {
            djoin /requestodj /loadfile C:\vmm.djoin /LOCALOS /WINDOWSPATH C:\Windows
        }

    Invoke-Command -VMId $vmm01.VMId -Credential $Script:localAdminCred -ScriptBlock {
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

    Invoke-Command -VMId $dc01.VMId -Credential $Script:relecloudAdminCred -ArgumentList ($Script:domainName, $Script:relecloudAdminCred) -ScriptBlock {
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

    Invoke-Command -VMId $dc01.VMId -Credential $Script:relecloudAdminCred -ArgumentList ($Script:DomainName, $Script:passwordSecureString) -ScriptBlock {
            Param($domainName, $passwordSecureString)
            # Add Compute Hosts to group
            Add-ADGroupMember "ComputeHosts" -Members "Compute01$"
            Add-ADGroupMember "ComputeHosts" -Members "Compute02$"
        }

    Invoke-Command -VMId $compute2.VMId -Credential $Script:relecloudAdminCred -ScriptBlock {
            (Get-PlatformIdentifier –Name 'Compute02').InnerXml | Out-file C:\Compute02.xml
            New-CIPolicy –Level FilePublisher –Fallback Hash –FilePath 'C:\HW1CodeIntegrity.xml'
            ConvertFrom-CIPolicy –XmlFilePath 'C:\HW1CodeIntegrity.xml' –BinaryFilePath 'C:\HW1CodeIntegrity.p7b'
            Get-HgsAttestationBaselinePolicy -Path 'C:\HWConfig1.tcglog'
        }
}
Log-Message -Message "Script finished - Total Duration: $(((Get-Date) - $Script:ScriptStartTime))"