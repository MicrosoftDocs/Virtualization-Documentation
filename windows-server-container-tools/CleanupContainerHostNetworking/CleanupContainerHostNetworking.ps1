param
(
    [parameter(Mandatory=$false)] [switch] $ForceCleanup,
    [parameter(Mandatory=$false)] [string] $LogPath = "."
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

    cmd /c "netsh trace start globallevel=6 provider={0c885e0d-6eb6-476c-a048-2457eed3a5c1} provider={80CE50DE-D264-4581-950D-ABADEEE0D340} provider={D0E4BC17-34C7-43fc-9A72-D89A59D6979A} provider={93f693dc-9163-4dee-af64-d855218af242} provider={564368D6-577B-4af5-AD84-1C54464848E6} scenario=Virtualization provider=Microsoft-Windows-Hyper-V-VfpExt capture=no report=disabled traceFile=$logFile" 

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

    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns -Recurse > $LogsPath"\HNSRegistry.txt"
    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp -Recurse > $LogsPath"\vmsmpRegistry.txt"
}

function ForceCleanupSystem
{
    $rebootRequired =$false
    
    $dockerConatiners = Invoke-Expression -Command "docker ps -aq" -ErrorAction SilentlyContinue

    foreach ($container in $dockerConatiners)
    {
        docker rm -f $container
    }

    Get-ContainerNetwork | Remove-ContainerNetwork -Force -ErrorAction SilentlyContinue
    
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

    Get-NetNatStaticMapping | Remove-NetNatStaticMapping -Confirm:$false
    Get-NetNat | Remove-NetNat -Confirm:$false

    Stop-Service hns -Force

    if (Test-Path "C:\ProgramData\Microsoft\Windows\HNS\HNS.data")
    {
        del C:\ProgramData\Microsoft\Windows\HNS\HNS.data
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

    if ($ForceCleanup.IsPresent)
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

        $rebootRequired = ForceCleanupSystem

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
