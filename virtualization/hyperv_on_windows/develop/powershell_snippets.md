ms.ContentId: 8DE9250B-556B-47BC-AD9A-8992B3D3D0F9
title: PowerShell Snippets

# PowerShell Snippets

PowerShell is an awesome scripting, automation, and management tool for Hyper-V.  Here is a toolbox for exploring some of the cool things it can do!

All Hyper-V management requires running as administrator so assume all scripts and snippets must be run as administrator from a Hyper-V Administrator account.

If you aren't sure if you have the right permissions, type `Get-VM` and if it runs with no errors, you're ready to go.


## PowerShell Direct tools
All of the scripts and snippets in this section will rely on the following basics.

**Requirements** :  
*  PowerShell Direct.  Windows 10 guest and host OS.

**Common Variables** :  
`$VMName` -- this is a string with the VMName.  See a list of available VMs with `Get-VM`  
`$cred` -- Credential for the guest OS.  Can be populated using `$cred = Get-Credential`  

### Check if the guest has booted

Hyper-V Manager doesn't give you visibility into the guest operating system which often makes it difficult to know whether the guest OS has booted.

Use this command to check whether the guest has booted.

``` PowerShell
if((Invoke-Command -VMName $VMName -Credential $cred {"Test"}) -ne "Test"){Write-Host "Not Booted"} else {Write-Host "Booted"}
```  

**Outcome**  
Prints a friendly message declaring the state of the guest OS.


### Script locking until the guest has booted

The following function waits uses the same principle to wait until PowerShell is available in the guest (meaning the OS has booted and most services are running) then returns.

``` PowerShell
function waitForPSDirect([string]$VMName, $cred){
   Write-Output "[$($VMName)]:: Waiting for PowerShell Direct (using $($cred.username))"
   while ((Invoke-Command -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}
```

**Outcome**  
Prints a friendly message and locks until the connection to the VM succeeds.  
Succeeds silently.

### Script locking until the guest has a network
With PowerShell Direct it is possible to get connected to a PowerShell session inside a virtual machine before the virtual machine has received an IP address.

``` PowerShell
# Wait for DHCP
while ((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Dhcp") {sleep -Milliseconds 10}
```

** Outcome **
Locks until a DHCP lease is recieved.  Since this script is not looking for a specific subnet or IP address, it works no matter what network configuration you're using.  
Succeeds silently.