---
title: Working with Hyper-V and Windows PowerShell
description: Working with Hyper-V and Windows PowerShell
keywords: windows 10, hyper-v
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 6d1ae036-0841-4ba5-b7e0-733aad31e9a7
---

# Working with Hyper-V and Windows PowerShell

Now that you have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how you can automate many of these activities with PowerShell.

### Return a list of Hyper-V commands

1.	Click on the Windows start button, type **PowerShell**.
2.	Run the following command to display a searchable list of PowerShell commands available with the Hyper-V PowerShell Module.

 ```powershell
get-command -module hyper-v | out-gridview
```
  You get something like this:

  ![](media\command_grid.png)

3. To learn more about a particular PowerShell command use `get-help`. For instance running the following command returns information about the `get-vm` Hyper-V command.

  ```powershell
get-help get-vm
```
 The output shows you how to structure the command, what the required and optional parameters are, and the aliases that you can use.

 ![](media\get_help.png)


### Return a list of virtual machines

Use the `get-vm` command to return a list of virtual machines.

1. In PowerShell, run the following command:
 
 ```powershell
get-vm
```
 This displays something like this:

 ![](media\get_vm.png)

2. To return a list of only powered on virtual machines add a filter to the `get-vm` command. A filter can be added by using the where-object command. For more information on filtering see the [Using the Where-Object](https://technet.microsoft.com/en-us/library/ee177028.aspx) documentation.   

 ```powershell
 get-vm | where {$_.State -eq ‘Running’}
 ```
3.  To list all virtual machines in a powered off state, run the following command. This command is a copy of the command from step 2 with the filter changed from ‘Running’ to ‘Off’.

 ```powershell
 get-vm | where {$_.State -eq ‘Off’}
 ```

### Start and shut down virtual machines

1. To start a particular virtual machine, run the following command with name of the virtual machine:

 ```powershell
 Start-vm -Name <virtual machine name>
 ```

2. To start all currently powered off virtual machines, get a list of those machines and pipe the list to the 'start-vm' command:

  ```powershell
 get-vm | where {$_.State -eq ‘Off’} | start-vm
 ```
3. To shut down all running virtual machines, run this:
 
  ```powershell
 get-vm | where {$_.State -eq ‘Running’} | stop-vm
 ```

### Create a VM checkpoint

To create a checkpoint using PowerShell, select the virtual machine using the `get-vm` command and pipe this to the `checkpoint-vm` command. Finally give the checkpoint a name using `-snapshotname`. The complete command looks like the following:

 ```powershell
 get-vm -Name <VM Name> | checkpoint-vm -snapshotname <name for snapshot>
 ```
### Create a new virtual machine

The following example shows how to create a new virtual machine in the PowerShell Integrated Scripting Environment (ISE). This is a simple example and could be expanded on to include additional PowerShell features and more advanced VM deployments.

1. To open the PowerShell ISE click on start, type **PowerShell ISE**.
2. Run the following code to create a virtual machine. See the [New-VM](https://technet.microsoft.com/en-us/library/hh848537.aspx) documentation for detailed information on the New-VM command.

  ```powershell
 $VMName = "VMNAME"

 $VM = @{
     Name = $VMName 
     MemoryStartupBytes = 2147483648
     Generation = 2
     NewVHDPath = "C:\Virtual Machines\$VMName\$VMName.vhdx"
     NewVHDSizeBytes = 53687091200
     BootDevice = "VHD"
     Path = "C:\Virtual Machines\$VMName "
     SwitchName = (get-vmswitch).Name[0]
 }

 New-VM @VM
  ```

## Wrap up and References

This document has shown some simple steps to explorer the Hyper-V PowerShell module as well as some sample scenarios. For more information on the Hyper-V PowerShell module, see the [Hyper-V Cmdlets in Windows PowerShell reference](https://technet.microsoft.com/%5Clibrary/Hh848559.aspx).  
 