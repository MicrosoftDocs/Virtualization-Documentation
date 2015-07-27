ms.ContentId: 8DE9250B-556B-47BC-AD9A-8992B3D3D0F9
title: PowerShell Snippets

# PowerShell Snippets

PowerShell is an awesome scripting, automation, and management tool for Hyper-V.  Here is a toolbox for exploring some of the cool things it can do!

All Hyper-V management requires running as administrator so assume all scripts and snippets must be run as administrator from a Hyper-V Administrator account.

If you aren't sure if you have the right permissions, type `Get-VM` and if it runs with no errors, you're ready to go.


## Use PowerShell Direct to see if the guest OS booted


Hyper-V Manager doesn't give you visibility into the guest operating system which often makes it difficult to know whether the guest OS has booted once the VM is running.

The following function waits until PowerShell is available in the guest OS (meaning the OS has booted and most services are running) then returns.

``` PowerShell
function waitForPSDirect([string]$VMName, $cred){
   Write-Output "[$($VMName)]:: Waiting for PowerShell Direct (using $($cred.username))"
   while ((icm -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}
```

**Requirements** :  
*  PowerShell Direct.  Windows10+ guest and host OS.

**Parameters** :  
`$VMName` -- this is a string with the VMName.  See a list of available VMs with `Get-VM`  
`$cred` -- Credential for the guest OS.  Can be populated using `$cred = Get-Credential`  

**Outcome**  
Prints a friendly message and locks in the while loop until the connection to the VM succeeds.  
Succeeds silently.  
