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
    $dockerNetworks = Invoke-Expression -Command "docker network ls -q" -ErrorAction SilentlyContinue

    foreach ($network in $dockerNetworks)
    {
        docker network rm $network
    }
    $ErrorActionPreference = "continue"
}

# -----------------------------------------------------------------------
# This function force removes all containers on the system.
# -----------------------------------------------------------------------
function RemoveAllContainers
{
    $ErrorActionPreference = "silentlycontinue"
    $dockerContainers = Invoke-Expression -Command "docker ps -aq" -ErrorAction SilentlyContinue

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
#           - Network adapters (`Get-NetAdapter`) are unbound (`Disable-NetAdapterBinding`)
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
            if ($adapters.HardwareInterface -eq $true)
            {
                Disable-NetAdapterBinding -Name $adapters.Name -ComponentID vms_pp
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
     foreach ($switch in $switches) {
         if ( $switch.ElementName -eq $switchName) {
             $ExternalSwitch = $switch
             break
         }
     }

     if (Test-Path "C:\Windows\System32\vfpctrl.exe")
     {
         $vfpCtrlExe = "vfpctrl.exe"
         $ports = $ExternalSwitch.GetRelated("Msvm_EthernetSwitchPort", "Msvm_SystemDevice", $null, $null, $null, $null, $false, $null)
         foreach ($port in $ports) {
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

    if (Test-Path "C:\Windows\System32\vfpctrl.exe")
    {
        $allSwitches = Get-VMSwitch
        foreach ($switch in $allSwitches)
        {
            GetAllPolicies -switchName $switch.Name > $LogsPath"\SwitchPolicies_$($switch.Name).txt"
        }

        Get-Service vfpext | FL * > $LogsPath"\vfpext.txt"
    }

    # Check if Docker (any version) is running...
    $ErrorActionPreference = "silentlycontinue"
    if ((Get-Process docker*).Length -gt 0)
    {
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
    }
    $ErrorActionPreference = "continue"

    Get-VMSwitch | FL * > $LogsPath"\GetVMSwitch.txt"
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
    # Currently, this script is not compatible with overlay networking.
    # To avoid system configuration issues, all overlay networks should be removed before this script is run.

    # Check if Docker (any version) is running...
    $dockerIsRunning = ((Get-Process docker*).Length -gt 0)
    if ($dockerIsRunning)
    {
        $dockerNetworks = Invoke-Expression -Command "docker network ls -f driver=overlay -q" -ErrorAction SilentlyContinue
        foreach ($network in $dockerNetworks)
        {
            Write-Host "Overlay network detected. Id:" $network
        }
    }

    Write-Host "WARNING: This script is not compatible with overlay networking. Before continuing, ensure all overlay networks are removed from your system." -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to continue (or Ctrl+C to stop script) ..."

    # Generate naming suffix for logs that will be generated
    $namingSuffix = GenerateRandomSuffix

    # Collect info on the machine state
    CopyAllLogs -LogsPath "$LogPath\PreCleanupState" | Out-Null

    # Capture Traces...
    if ($CaptureTraces.IsPresent)
    {
        try{

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

    # Cleanup host...
    if ($Cleanup.IsPresent)
    {
        $tracingEnabled = $true
        try{

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
