param([string]$vmName)
#
# Enable-NestedVm.ps1
#
# Checks VM for nesting comatability and configures if not properly setup.
#
# Author: Drew Cross

if([string]::IsNullOrEmpty($vmName)) {
    Write-Host "No VM name passed"
    Exit;
}

#
# Need to run elevated.  Do that here.
#

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running as an administrator
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running as an administrator, so change the title and background colour to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)";
    #$Host.UI.RawUI.BackgroundColor = "DarkBlue";
    Clear-Host;
    } else {
    # We are not running as an administrator, so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter with added scope and support for scripts with spaces in it's path
    $newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null;

    # Exit from the current, unelevated, process
    Exit;
    }

#
# Get Vm Information
#

$vm = Get-VM -Name $vmName

$vmInfo = New-Object PSObject
    
# VM info
Add-Member -InputObject $vmInfo NoteProperty -Name "ExposeVirtualizationExtensions" -Value $false
Add-Member -InputObject $vmInfo NoteProperty -Name "DynamicMemoryEnabled" -Value $vm.DynamicMemoryEnabled
Add-Member -InputObject $vmInfo NoteProperty -Name "SnapshotEnabled" -Value $false
Add-Member -InputObject $vmInfo NoteProperty -Name "State" -Value $vm.State


# is nested enabled on this VM?
$vmInfo.ExposeVirtualizationExtensions = (Get-VMProcessor -VM $vm).ExposeVirtualizationExtensions

Write-Host "This script will set the following for $vmName in order to enable nesting:"

# Output text for proposed actions
if ($vmInfo.State -eq 'Saved') {
    Write-Host "\tSaveed state will be removed"
}
if ($vmInfo.State -ne 'Off' -or $vmInfo.State -eq 'Saved') {
    Write-Host "Vm State:" $vmInfo.State
    Write-Host "    $vmName will be turned off"
}
if ($vmInfo.ExposeVirtualizationExtensions -eq $false) {
    Write-Host "    Virtualization extensions will be enabled"
}
if ($vmInfo.DynamicMemoryEnabled -eq $true) {
    Write-Host "    Dynamic memory will be disabled"
}

Write-Host "Input Y to accept or N to cancel:" -NoNewline

$char = Read-Host

while(-not ($char.StartsWith('Y') -or $char.StartsWith('N'))) {
    Write-Host "Invalid Input, Y or N" 
    $char = Read-Host
}


if($char.StartsWith('Y')) {
   if ($vmInfo.State -eq 'Saved') {
        Remove-VMSavedState -VMName $vmName
    }
    if ($vmInfo.State -ne 'Off' -or $vmInfo.State -eq 'Saved') {
        Stop-VM -VMName $vmName
    }
    if ($vmInfo.ExposeVirtualizationExtensions -eq $false) {
        Set-VMProcessor -VMName $vmName -ExposeVirtualizationExtensions $true
    }
    if ($vmInfo.DynamicMemoryEnabled -eq $true) {
        Set-VMMemory -VMName $vmName -DynamicMemoryEnabled $false
    }
    Exit;
}

if($char.StartsWith('N')) {
    Write-Host "Exiting..."
    Exit;
}

Write-Host 'Invalid input'
