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

    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns -Recurse > $LogsPath"\HNSRegistry.txt"
    Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp -Recurse > $LogsPath"\vmsmpRegistry.txt"
}

# Need to refactor ConfirmDelete* and possibly Get Friendly name
#function ConfirmDelete
#{
#}

function ConfirmDeleteSwitch
{
    Param(
        [string] $switch
    )

    $switchfriendlyname = (Get-ItemProperty $switch).Friendlyname 
    if ($switchfriendlyname -eq "DockerNAT")
    {
        # Don't delete the Docker NAT switch - used by Docker for Windows (Docker CE) Moby LinuxVM 
        continue 
    }
    else
    {
        $response = Read-Host -Prompt "Are you sure you want to delete switch: $($switchfriendlyname)[Y] or [N]"
        if ($response -eq "Y" -or $response -eq "y")
        {
            Write-Host "Deleting switch: $($switchfriendlyname)"
            Remove-Item -Path $switch -Recurse -Force
        }
    }       
}

function ConfirmDeleteNic
{
    Param(
        [string] $nic
    )

    $nicfriendlyname = (Get-ItemProperty $nic).Friendlyname 
    if ( ($nicfriendlyname -eq "HNS Internal NIC") -or ($nicfriendlyname -eq "HNS Transparent NIC") )
    {
        $response = Read-Host -Prompt "Are you sure you want to delete: $($nicfriendlyname)? [Y] or [N]"
        if ($response -eq "Y" -or $response -eq "y")
        {
            Write-Host "Deletingh: $($nicfriendlyname)"
            Remove-Item -Path $nic -Recurse -Force
        }
    }    
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
        # NOTE: This will not delete the default "NAT" network 
        # NOTE: This will remve networks for any vSwitches created OOB (e.g. through New-VMSwitch) but it will not remove the vSwitch itself 
        docker network rm $network
    }

    $cmdlet = @()
    $cmdlet = (Get-Command *ContainerNetwork*)

    if ($cmdlet.Count -ne 0)
    {
        # These cmdlets are only valid in RS1 (Windows Server 2016 and Windows 10 Anniversary Edition - 1607) 
        Get-ContainerNetwork | Remove-ContainerNetwork -Force -ErrorAction SilentlyContinue
    }
    else
    {
        # Delete vm switches
        # TODO - Make sure all vm switches associated with Docker have been removed        

        # Delete NAT (if exists)
        # TODO - Make sure all NetNats associated with Docker 'nat' networks have been removed
    }

    if ($ForceDeleteAllSwitches.IsPresent)
    {  
        # Only delete "nat" internal switch or HNS-created nat switch   
        if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList")
        {
            $switchList = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList\ | %{$_.PSPath }
            foreach ($switch in $switchList)
            {
                ConfirmDeleteSwitch($switch)                                                  
                
                #TODO - Only do this if we actually have deleted at least one switch
                $rebootRequired = $true
            }
        }

        if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList")
        {
            $nicList = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList\ | %{$_.PSPath }

            foreach ($nic in $niclist)
            {
                ConfirmDeleteNic($nic)

                # TODO - Only require reboot if we actually have deleted at least one NIC
                $rebootRequired = $true
            }                                                        
        }

        $adapters = Get-NetAdapter 

        foreach ($adapter in $adapters)
        {
            if ($adapters.HardwareInterface -eq $true)
            {
                # TODO - We only want to do this on HNS-created switches which we've deleted 
                #Disable-NetAdapterBinding -Name $adapters.Name -ComponentID vms_pp
            }
        }

        # Only remove NATs created by HNS on request from Docker 
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
        #Restart-Service docker -ErrorAction SilentlyContinue

        $hns = Get-Service hns

        # TODO - Need to refactor this section since we're checking for different Docker engines in multiple locations
        $docker = Get-Service com.docker.service -ErrorAction SilentlyContinue
        if ($docker -eq $null)
        {
            $docker = Get-Service docker 
        }        

        if ($hns.Status -ne "Running" -or $docker.Status -ne "Running")
        {
            $rebootRequired = $true
        }
    }

    return $rebootRequired
}

try
{
    # Currently, this script is not compatible with overlay networking. 
    # To avoid system configuration issues, all overlay networks should be removed before this script is run.

    # Check if we're running Docker for Windows (Windows 10)
    $docker = Get-Service com.docker.service -ErrorAction SilentlyContinue
    if ($docker -eq $null)
    {
        $docker = Get-Service docker 
    }

    if ($docker -eq $null)
    {
        Write-Host "ERROR: docker service not found on host"
        return
    }

    #Restart-Service $docker -ErrorAction SilentlyContinue
    #while ($docker.Status -not -eq "Running")
    #{
    #    sleep(2)
    #}    

    if ($docker.Status -eq "Running")
    {
        $dockerNetworks = Invoke-Expression -Command "docker network ls -f driver=overlay -q" -ErrorAction SilentlyContinue
        if (@($dockerNetworks).Length -gt 0)
        {        
            Write-Host "WARNING: This script is not compatible with overlay networking." -ForegroundColor Yellow
            foreach ($network in $dockerNetworks)
            {
                Write-Host "Overlay network detected. Id:" $network
            }

            # TODO - Add prompt...
            Write-Host "Would you like to remove these networks?"                        
        }
    }
    
    
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

        $rebootRequired = $false 

        Write-Host "WARNING: This will delete all Docker networks on the host"
        $value = Read-Host -Prompt "Do you want to continue? [Y]es or [N]o"
        if ($value.tolower() -eq 'y' -or $value.tolower() -eq 'yes')
        {
            $rebootRequired = ForceCleanupSystem -ForceDeleteAllSwitches:$($ForceDeleteAllSwitches.IsPresent)
        }

        if ($tracingEnabled)
        {
            StopTracing | Out-Null
        }
    
        # Collect logs before force cleanup
        CopyAllLogs -LogsPath "$LogPath\PostCleanupState" | Out-Null
      
        if ($rebootRequired)
        {
            Write-Host "Script complete! Reboot required. Restart now? Enter (Y)es or (N)o ..." -ForegroundColor Green 
            Write-Host "*Warning: Do not run any Docker commands before rebooting your machine!*" -ForegroundColor Yellow
            $rebootNow = Read-Host
            if ($rebootNow.toLower() -eq "y" -or $rebootNow.toLower() -eq "yes")
            {
                Restart-Computer -Force
            }
            else { return }
        }

    }

    Write-Host "Complete!!!" -ForegroundColor Green 
    
}
catch
{
    Write-Host "Script Failed:$_" -ForegroundColor Red 
}
