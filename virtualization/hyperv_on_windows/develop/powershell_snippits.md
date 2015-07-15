ms.ContentId: 52f74e95-ce0b-4112-846a-cbeb552c2ac5
title: Useful PowerShell Snippits

# Useful PowerShell Snippits

PowerShell is an awesome scripting, automation, and management tool for Hyper-V.  As such, here is a toolbox for some of the cool things it can do!

## PowerShell Direct to check if OS has loaded in the VM

Hyper-V doesn't give you any visibility into the guest operating system.

``` PowerShell
function waitForPSDirect([string]$VMName, $cred){
   Write-Output "[$($VMName)]:: Waiting for PowerShell Direct (using $($cred.username))"
   while ((icm -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}
```