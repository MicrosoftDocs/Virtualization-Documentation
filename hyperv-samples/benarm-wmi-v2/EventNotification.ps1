# WMI Query that specifies what events we will watch for
$Query = "Select * from __InstanceModificationEvent within 3 where TargetInstance ISA 'MSVM_ComputerSystem' `
          and TargetInstance.EnabledState <> PreviousInstance.EnabledState"

# Script block that will run whenever the event fires
[ScriptBlock]$Action = {
   $VMName = $Event.SourceEventArgs.NewEvent.TargetInstance.ElementName

   switch ($Event.SourceEventArgs.NewEvent.TargetInstance.EnabledState)
   {
        2 {$vmState = "running"}
        3 {$vmState = "turned off"}
        9 {$vmState = "paused"}
        6 {$vmState = "in a saved state"}
        10 {$vmState = "starting"}
        4 {$vmState = "stopping"}
        default {$vmState = "in an unknown state..."}
    }

    if ($Event.SourceEventArgs.NewEvent.TargetInstance.EnabledState -eq 1)
    {
        $vmState = $Event.SourceEventArgs.NewEvent.TargetInstance.OtherEnabledState
    }

    Write-Host "The virtual machine '$($vmName)' is now $($vmState)."
}

# Register for the events
Register-WMIEvent -Query $Query -Action $Action -Namespace root\virtualization\v2

# To clean up - run "Get-EventSubscriber | Unregister-Event"
