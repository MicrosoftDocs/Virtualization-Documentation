

# Get the ID and security principal of the current user account
 $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
 $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
 # Get the security principal for the Administrator role
 $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
 # Check to see if we are currently running "as Administrator"
 if ($myWindowsPrincipal.IsInRole($adminRole))
 {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    #$Host.UI.RawUI.BackgroundColor = "DarkGreen"
    clear-host
 } else {
    # We are not running "as Administrator" - so relaunch as administrator
    
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    
    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
    
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);
    
    # Exit from the current, unelevated, process
    exit
}

$rootReserveKey = "MemoryReserve"
$rootReserveKeyPath = "HKLM:Software\Microsoft\Windows NT\CurrentVersion\Virtualization"

Write-Host "Checking for $rootReserveKey reg key"

if ($s = Get-ItemProperty $rootReserveKeyPath | Select-Object -ExpandProperty $rootReserveKey)
{
   Write-Host "$rootReserveKey reg key set.  Value: $s MB"
   Remove-ItemProperty -Path $rootReserveKeyPath -Name $rootReserveKey
}

Write-Host "Press any key to exit"
Read-Host