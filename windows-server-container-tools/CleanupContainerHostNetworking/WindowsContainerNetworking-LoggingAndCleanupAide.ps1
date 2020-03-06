# Windows Container Networking -- Host Network Service (HNS) Logging and Cleanup Script
#   -  The purpose of this script is to aid network troubleshooting on Window container hosts
#   -  This script was developed and is maintained by the Windows Core Networking team at Microsoft
#   -  Detailed directions for running this script can be found in the accompanying README document
#   -  Submit comments/requests on this script to GitHub, or by emailing us directly
#           - Windows container GitHub repository: https://github.com/Microsoft/Virtualization-Documentation/issues
#           - Core Networking team email alias: sdn_feedback@microsoft.com

param
(
    [switch] $Cleanup,
    [switch] $CaptureTraces,
    [switch] $ForceDeleteAllSwitches,
    [string] $LogPath = "."
)

# -----------------------------------------------------------------------
# This function force removes all container networks on the system.
# -----------------------------------------------------------------------
function RemoveAllNetworks
{
    $ErrorActionPreference = "silentlycontinue"
    $dockerNetworks = Invoke-Expression -Command "docker network ls -q"

    foreach ($network in $dockerNetworks)
    {
        $net = docker network inspect $network --format '{{json .}}' | ConvertFrom-Json
        if ($net.Name -ne 'nat'-And $net.Name -ne 'none')
        {
            docker network rm $network
        }
    }
    $ErrorActionPreference = "continue"
}

# -----------------------------------------------------------------------
# This function force removes all containers on the system.
# -----------------------------------------------------------------------
function RemoveAllContainers
{
    $ErrorActionPreference = "silentlycontinue"
    $dockerContainers = Invoke-Expression -Command "docker ps -aq"

    foreach ($container in $dockerContainers)
    {
        docker rm -f $container
    }
    $ErrorActionPreference = "continue"
}

# -----------------------------------------------------------------------
# This function cleans up networking components on the container host.
#   - Removes/deletes all containers on the host
#   - Removes/deletes all container networks on the host
#   - If ForceDeleteAllSwitches argument is true:
#           - Switch/NIC registry keys are removed
#                   HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList
#                   HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList
#           - All physical network adapters (`Get-NetAdapter`) are unbound from any Hyper-V Virtual Switch components (`Disable-NetAdapterBinding -Name <ADAPTER NAME> -ComponentID vms_pp`)
#           - NAT network is removed:
#                   `Get-NetNatStaticMapping | Remove-NetNatStaticMapping`
#                   `Get-NetNat | Remove-NetNat`
#           - If changes made require reboot, HNS service is stopped and HNS.data file is removed
#
# Parameters: $ForceDeleteAllSwitches
# Returns: $rebootRequired
# -----------------------------------------------------------------------
function ForceCleanupSystem
{
    Param(
        [switch] $ForceDeleteAllSwitches
    )

    $rebootRequired =$false

    RemoveAllContainers
    RemoveAllNetworks

    if ($ForceDeleteAllSwitches.IsPresent)
    {
        if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList")
        {
            $switchList = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList\ | %{$_.PSPath }

            if ($switchList.count -ne 0)
            {
                Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList -Recurse -Force
                $rebootRequired = $true
            }
        }

        if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList")
        {
            $nicList = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList\ | %{$_.PSPath }

            if ($nicList.count -ne 0)
            {
                Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList -Recurse -Force
                $rebootRequired = $true
            }
        }

        $adapters = Get-NetAdapter

        foreach ($adapter in $adapters)
        {
            if ($adapter.HardwareInterface -eq $true)
            {
                if ($adapter.Name) {
                    Disable-NetAdapterBinding -Name $adapter.Name -ComponentID vms_pp
                } elseif ($adapter.InterfaceDescription) {
                    Disable-NetAdapterBinding -InterfaceDescription $adapter.InterfaceDescription -ComponentID vms_pp
                }
            }
        }

        Get-NetNatStaticMapping | Remove-NetNatStaticMapping -Confirm:$false
        Get-NetNat | Remove-NetNat -Confirm:$false

        if ($rebootRequired)
        {
            Stop-Service hns -Force

            if (Test-Path "C:\ProgramData\Microsoft\Windows\HNS\HNS.data")
            {
                del C:\ProgramData\Microsoft\Windows\HNS\HNS.data
            }
        }

    }

    if(!$rebootRequired)
    {
        Restart-Service hns -ErrorAction SilentlyContinue
        $hns = Get-Service hns

        if ($hns.Status -ne "Running")
        {
            $rebootRequired = $true
        }
    }

    return $rebootRequired
}

# -----------------------------------------------------------------------
# This function ends log tracing
# Parameters: _
# Returns: _
# -----------------------------------------------------------------------
function StopTracing
{
    netsh trace stop
}

# -----------------------------------------------------------------------
# This function initializes log tracing
# Parameters: -LogsPath <Path where logs should be saved>
# Returns: _
# -----------------------------------------------------------------------
function StartTracing
{
    Param(
        [string] $LogsPath
    )

    $LogsPath += "_$($script:namingSuffix)"

    if (!(Test-Path $LogsPath))
    {
        mkdir $LogsPath
    }

    $logFile = "$LogsPath\HNSTrace.etl"

    cmd /c "netsh trace start globallevel=6 provider={0c885e0d-6eb6-476c-a048-2457eed3a5c1} provider={80CE50DE-D264-4581-950D-ABADEEE0D340} provider={D0E4BC17-34C7-43fc-9A72-D89A59D6979A} provider={93f693dc-9163-4dee-af64-d855218af242} provider={564368D6-577B-4af5-AD84-1C54464848E6} scenario=Virtualization provider=Microsoft-Windows-Hyper-V-VfpExt capture=no report=disabled traceFile=$logFile"
}

# -----------------------------------------------------------------------
# Gets VFP policies for a given switch
# Parameter: SwitchName
# Returns: _
# -----------------------------------------------------------------------
function GetAllPolicies
{
    param(
        [string]$switchName = $(throw "please specify a switch name")
    )

    $switches = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualEthernetSwitch
    foreach ($switch in $switches)
    {
        if ( $switch.ElementName -eq $switchName)
        {
            $ExternalSwitch = $switch
            break
        }
    }

    if (Test-Path "C:\Windows\System32\vfpctrl.exe")
    {
        $vfpCtrlExe = "vfpctrl.exe"
        $ports = $ExternalSwitch.GetRelated("Msvm_EthernetSwitchPort", "Msvm_SystemDevice", $null, $null, $null, $null, $false, $null)
        foreach ($port in $ports)
        {
            $portGuid = $port.Name
            echo "Policy for port : " $portGuid
            & $vfpCtrlExe /list-space  /port $portGuid
            & $vfpCtrlExe /list-mapping  /port $portGuid
            & $vfpCtrlExe /list-rule  /port $portGuid
            & $vfpCtrlExe /port $portGuid /get-port-state
        }
    }
}

# -----------------------------------------------------------------------
# This function collects logs to capture machine state
# Parameters: -LogsPath <Path where logs should be saved>
# Returns: _
#
# Information/logs collected by this function:
#   - HNS Event log: c:\Windows\System32\winevt\Logs\Microsoft-Windows-Host-Network-Service-Admin.evtx
#   - System event log: c:\Windows\System32\winevt\Logs\System.evtx
#   - HNS.data file: c:\ProgramData\Microsoft\Windows\HNS\HNS.data
#   - `ipconfig /allcompartments /all`
#   - Info for each switch: `GetAllPolicies -switchName $switch.Name`
#   - VFP info: Get-Service vfpext
#   - Docker version: `docker -v`
#   - Docker info: `docker info`
#   - `Get-VMSwitch`
#   - `Get-NetNat`
#   - `Get-NetNatStaticMapping`
#   - `Get-Service winnat`
#   - `Get-Service mpssvc`
#   - `Get-NetAdapter -IncludeHidden`
#   - `Get-NetAdapterBinding -IncludeHidden`
#   - `Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns`
#   - `Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp`
# -----------------------------------------------------------------------
function CopyAllLogs
{
    Param(
        [string] $LogsPath
    )

    $LogsPath += "_$($script:namingSuffix)"

    if (!(Test-Path $LogsPath))
    {
        mkdir $LogsPath
    }

    Copy-Item c:\Windows\System32\winevt\Logs\Microsoft-Windows-Host-Network-Service-Admin.evtx $LogsPath
    Copy-Item c:\Windows\System32\winevt\Logs\System.evtx $LogsPath

    $hns = Get-Service hns

    try
    {
        if ($hns.Status -eq "Running")
        {
            net stop hns
        }
        if (Test-Path "C:\ProgramData\Microsoft\Windows\HNS\HNS.data")
        {
            Copy-Item c:\ProgramData\Microsoft\Windows\HNS\HNS.data $LogsPath
        }
    }
    finally
    {
        if ($hns.Status -eq "Running")
        {
            net start hns
        }
    }

    ipconfig /allcompartments /all > $LogsPath"\ipconfig.txt"



    Try

    {

        Resolve-Path "C:\Windows\System32\vfpctrl.exe" -ErrorAction Stop | Out-Null

        ($allSwitches = Get-VMSwitch) | FL * > $LogsPath"\GetVMSwitch.txt"
        foreach ($switch in $allSwitches)
        {
            GetAllPolicies -switchName $switch.Name > $LogsPath"\SwitchPolicies_$($switch.Name).txt"
        }

        Get-Service vfpext | FL * > $LogsPath"\vfpext.txt"

    }
    Catch [System.Management.Automation.ItemNotFoundException], [System.Management.Automation.CommandNotFoundException]
    {
        Write-Host "WARNING: Microsoft Hyper-V role is not installed or misconfigured" -ForegroundColor Yellow
    }

    # Get docker version
    docker -v > $LogsPath"\docker_v.txt"

    # Get docker info
    docker info > $LogsPath"\docker_info.txt"

    # Get list containing IDs of current container networks on host
    $networks=docker network ls -q

    # Initialize file for recording network info
    "Number of container networks currently on this host: "+$networks.Length+"`\n" > $LogsPath"\docker_network_inspect.txt"

    # Inspect each network
    foreach($network in $networks)
    {
        $addMe = docker network inspect $network
        Add-Content $LogsPath"\docker_network_inspect.txt" $addMe
    }

    
    if ((Get-WindowsFeature -Name Hyper-V).Installed -and (Get-Command Get-VMSwitch -ErrorAction SilentlyContinue)){
        Get-VMSwitch | FL * > $LogsPath"\GetVMSwitch.txt"
    }

    Get-NetNat | FL * > $LogsPath"\GetNetNat.txt"
    Get-NetNatStaticMapping | FL *> $LogsPath"\GetNetNatStaticMapping.txt"
    Get-Service winnat | FL * > $LogsPath"\WinNat.txt"
    Get-Service mpssvc | FL * > $LogsPath"\mpssvc.txt"
    Get-NetAdapter -IncludeHidden | FL * > $LogsPath"\GetNetAdapters.txt"
    Get-NetAdapterBinding -IncludeHidden | FL * > $LogsPath"\GetNetAdapterBinding.txt"

    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns -Recurse > $LogsPath"\HNSRegistry.txt"
    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp -Recurse > $LogsPath"\vmsmpRegistry.txt"
}

# -----------------------------------------------------------------------
# This function generates a string of 8 random characters
# Parameters: _
# Returns: 8 character string
# -----------------------------------------------------------------------
function GenerateRandomSuffix
{
    $rand = New-Object System.Random
    $len = 8
    [string]$namingSuffix = ''
    for($i = 0; $i -lt $len; $i++)
    {
        $namingSuffix += [char]$rand.Next(65,90)
    }
    return $namingSuffix
}

# -----------------------------------------------------------------------
# SCRIPT STARTS HERE
# -----------------------------------------------------------------------
try
{
    # FIRST, WHICH VERSION OF THE DOCKER SERVICE IS RUNNING ON THIS HOST?
    # *******************************************************************
    Try
    {
        # Simple "Docker" service is installed
        Get-Service docker -ErrorAction silentlycontinue
    }
    Catch [Microsoft.PowerShell.Commands.ServiceCommandException]
    {
        # "Docker for Windows" is installed
        Get-Service com.docker.service -ErrorAction stop
    }
    Catch
    {
        write-host "ERROR: Docker is not running on this host. Please start Docker and try again." -ForegroundColor Red
        exit
    }

    # MAKE SURE HOST IS NOT IN SWARM MODE
    # ***********************************
    # This script requires that the docker engine on the host not be running in swarm mode. Making sure this host is not in swarm mode...
    $dockerInfo = docker info --format '{{json .}}' | ConvertFrom-Json
    While ($dockerInfo.Swarm.LocalNodeState -eq 'active')
    {
        Write-Host "WARNING: This script cannot be used on hosts that are running in swarm mode, and this machine is currently in an active swarm state." -ForegroundColor Yellow
        Write-Host "Would you like to exit swarm mode now to continue running this script?"
        $Readhost = Read-Host " ( y / n ) "
        Switch ($ReadHost)
        {
            Y {Write-host "Exiting swarm mode now..."; docker swarm leave --force; sleep 10;}
            N {Write-Host "Cannot run script when host is in active swarm state. Exiting."; exit;}
            Default {Write-Host "Cannot run script when host is in active swarm state. Exiting."; exit;}
        }
        $dockerInfo = docker info --format '{{json .}}' | ConvertFrom-Json
    }

    # CAPTURE HOST STATE
    # ******************
    # Generate naming suffix for logs that will be generated
    $namingSuffix = GenerateRandomSuffix

    # Collect info on the machine state
    CopyAllLogs -LogsPath "$LogPath\PreCleanupState" | Out-Null

    # IF -CAPTURETRACES OPTION IS PRESENT...
    # **************************************

    if ($CaptureTraces.IsPresent)
    {
        try
        {
            StartTracing -LogsPath "$LogPath\PreCleanupState" | Out-Null
            Write-Host "Please reproduce issues for troubleshooting now. After completing repro steps, press any key to continue..."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            StopTracing | Out-Null
        }
        catch
        {
            Write-Host "Failed to collect tracing $_" -ForegroundColor Red
            $tracingEnabled = $false
        }
    }

    # IF -CLEANUP OPTION IS PRESENT...
    # ********************************

    if ($Cleanup.IsPresent)
    {
        $tracingEnabled = $true
        try
        {
            StartTracing -LogsPath "$LogPath\PostCleanupState" | Out-Null
        }
        catch
        {
            Write-Host "Failed to collect tracing $_" -ForegroundColor Red
            $tracingEnabled = $false
        }

        $rebootRequired = ForceCleanupSystem -ForceDeleteAllSwitches:$($ForceDeleteAllSwitches.IsPresent)

        if ($tracingEnabled)
        {
            StopTracing | Out-Null
        }

        # Collect logs after force cleanup
        CopyAllLogs -LogsPath "$LogPath\PostCleanupState" | Out-Null

        if ($rebootRequired)
        {
            Write-Host "PLEASE RESTART THE SYSTEM TO COMPLETE CLEANUP" -ForegroundColor Green
        }
    }

    Write-Host "Complete!!!" -ForegroundColor Green
}
catch
{
    Write-Host "Script Failed:$_" -ForegroundColor Red
}
