ms.ContentId: 52f74e95-ce0b-4112-846a-cbeb552c2ac5
title: Useful PowerShell Snippits

# Useful PowerShell Snippits

PowerShell is an awesome scripting, automation, and management tool for Hyper-V.  As such, here is a toolbox for some of the cool things it can do!

All Hyper-V management requires running as Administrator so assume all scripts and snippits must be run as administrator from a Hyper-V Administrator account.

Sanity Check: If `Get-VM` runs with no errors, you're all set :)

If you need a script to auto-elevate and your user account is an Administrator account, see this handy snippit.

Here is the [Hyper-V PowerShell Reference](https://technet.microsoft.com/%5Clibrary/Hh848559.aspx).
<!-- let's add this external link to the TOC under develop? -->

## PowerShell Direct to check if the guest OS booted

Hyper-V doesn't give you any visibility into the guest operating system which often makes it difficult to know whether the guest OS has booted once the VM is running.

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
