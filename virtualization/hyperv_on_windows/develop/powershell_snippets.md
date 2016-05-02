---
title: PowerShell Snippets
description: PowerShell Snippets
keywords: windows 10, hyper-v
author: scooley
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: dc33c703-c5bc-434e-893b-0c0976b7cb88
---

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

Here are two views of the same functionality, first as a code snippet then as a PowerShell function.

Snippet:  
``` PowerShell
if((Invoke-Command -VMName $VMName -Credential $cred {"Test"}) -ne "Test"){Write-Host "Not Booted"} else {Write-Host "Booted"}
```  

Function:  
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

## Managing credentials with PowerShell
Hyper-V scripts frequently require handling credentials for one or more virtual machines, Hyper-V host, or both.

There are multiple ways you can achieve this when working with PowerShell Direct or standard PowerShell remoting:

1. The first (and simplest) way is to have the same user credentials be valid in the host and the guest or local and remote host.  
  This is quite easy if you are logging in with your Microsoft account - or if you are in a domain environment.  
  In this scenario you can just run `Invoke-Command -VMName "test" {get-process}`.

2. Let PowerShell prompt you for credentials  
  If your credentials do not match you will automatically get a credential prompt allowing you to provide the appropriate credentials for the virtual machine.

3. Store credentials in a variable for reuse.
  Running a simple command like this:  
  ``` PowerShell
  $localCred = Get-Credential
   ```
  And then running something like this:
  ``` PowerShell
  Invoke-Command -VMName "test" -Credential $localCred  {get-process} 
  ```
  Will mean that you only get prompted once per script/PowerShell session for your credentials.

4. Code your credentials into your scripts.  **Don't do this for any real workload or system**
 > Warning:  _Do not do this in a production system.  Do not do this with real passwords._
  
  You can hand craft a PSCredential object with some code like this:  
  ``` PowerShell
  $localCred = New-Object -typename System.Management.Automation.PSCredential -argumentlist "Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) 
  ```
  Grossly insecure - but useful for testing.  Now you get no prompts at all in this session. 

