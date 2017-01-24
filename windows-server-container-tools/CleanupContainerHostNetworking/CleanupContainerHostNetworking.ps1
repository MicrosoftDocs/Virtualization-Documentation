param
(
    [switch] $Cleanup,
    [switch] $ForceDeleteAllSwitches,
    [string] $LogPath = ".",
    [switch] $CaptureTraces
) 

function StartTracing
{
    Param(
      [string] $LogsPath
    )

    $LogsPath += "_$($script:namingPrefix)"

    if (!(Test-Path $LogsPath))
    {
        mkdir $LogsPath
    }

    $logFile = "$LogsPath\HNSTrace.etl"

    cmd /c "netsh trace start globallevel=6 provider={0c885e0d-6eb6-476c-a048-2457eed3a5c1} provider={80CE50DE-D264-4581-950D-ABADEEE0D340} provider={D0E4BC17-34C7-43fc-9A72-D89A59D6979A} provider={93f693dc-9163-4dee-af64-d855218af242} scenario=Virtualization provider=Microsoft-Windows-Hyper-V-VfpExt capture=no report=disabled traceFile=$logFile" 

 }

function StopTracing
{

    netsh trace stop

}

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

function CopyAllLogs
{
    Param(
      [string] $LogsPath 
    )

    $LogsPath += "_$($script:namingPrefix)"
    
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

function ForceCleanupSystem
{
    Param(
      [switch] $ForceDeleteAllSwitches 
    )

    $rebootRequired =$false
    
    $dockerContainers = Invoke-Expression -Command "docker ps -aq" -ErrorAction SilentlyContinue

    foreach ($container in $dockerContainers)
    {
        docker rm -f $container
    }

    $dockerNetworks = Invoke-Expression -Command "docker network ls -q" -ErrorAction SilentlyContinue

    foreach ($network in $dockerNetworks)
    {
        docker network rm $network
    }

    $cmdlet = @()
    $cmdlet = (Get-Command *ContainerNetworking*)

    if ($cmdlet.Count -ne 0)
    {
        Get-ContainerNetwork | Remove-ContainerNetwork -Force -ErrorAction SilentlyContinue
    }

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
        Restart-Service docker -ErrorAction SilentlyContinue

        $hns = Get-Service hns
        $docker = Get-Service docker


        if ($hns.Status -ne "Running" -or $docker.Status -ne "Running")
        {
            $rebootRequired = $true
        }
    }

    return $rebootRequired
}

try
{
    # Generate Random names for prefix
    $rand = New-Object System.Random
    $prefixLen = 8
    [string]$namingPrefix = ''
    for($i = 0; $i -lt $prefixLen; $i++)
    {
        $namingPrefix += [char]$rand.Next(65,90)
    }

    # Collect logs before force cleanup
    CopyAllLogs -LogsPath "$LogPath\PreCleanupState" | Out-Null

    if ($CaptureTraces.IsPresent)
    {
        try{

            StartTracing -LogsPath "$LogPath\PreCleanupState" | Out-Null
            Write-Host "Please Repro the issue and post repro, press any key to continue ..."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            StopTracing | Out-Null
        }
        catch
        {
            Write-Host "Failed to collect tracing $_" -ForegroundColor Red 
            $tracingEnabled = $false
        }
    }
    
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
    
        # Collect logs before force cleanup
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
