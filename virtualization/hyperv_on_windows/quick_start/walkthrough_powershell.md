ms.ContentId: B9414110-BEFD-423F-9AD8-AFD5EE612CDA
title: Step 8: Experiment with Windows PowerShell

# Step 8: Experiment with Windows PowerShell

Now that you have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how you can automate many of these activities with PowerShell.

### Return a list of Hyper-V commands

1.	Click on the Windows start button, type **PowerShell**.
2.	Run the following command to display a searchable list of PowerShell commands available with the Hyper-V PowerShell Module.

 ```
get-command –module hyper-v | out-gridview
```
  You get something like this:

  ![](media\command_grid.png)

3. To learn more about a particular PowerShell command use `get-help`. For instance running the following command will return information about the `get-vm` Hyper-V command.

  ```
get-help get-vm
```
 The output shows you how to structure the command, what the required and optional parameters are, and the aliases that you can use.

 ![](media\get_help.png)


### Return a list of virtual machines

Use the `get-vm` command to return a list of virtual machines.

1. In PowerShell, run the following command:
 
 ```
get-vm
```
 This displays something like this:

 ![](media\get_vm.png)

2. To return a list of only powered on virtual machines add a filter to the command. A filter can be added by passing the output of `get-vm` using pipe caracter `|` to the `where-object` command or `where` for short. Finally inside of curly braces `{}` declare that the state should be equal to ‘Running’ as seen below.      

 ``` 
 get-vm | where {$_.State –eq ‘Running’}
 ```
3.  To list all virtual machines in a powered off state, run the following command. This command is a copy of the command from step 2 with the filter changed from ‘Running’ to ‘Off’.

 ``` 
 get-vm | where {$_.State –eq ‘Off’}
 ```

### Start and shut down virtual machines

1. To start a particular virtual machine, run the following command with name of the virtual machine:

 ```
 Start-vm –Name <virtual machine name>
 ```

2. To start all currently powered off virtual machines, get a list of those machines and pipe the list to the 'start-vm' command:
  ```
 get-vm | where {$_.State –eq ‘Off’} | start-vm
 ```
3. To shut down all running virtual machines, run this:
 
  ```
 get-vm | where {$_.State –eq ‘Running’} | stop-vm
 ```

### Create a VM checkpoint

To create a checkpoint using PowerShell, select the virtual machine using the `get-vm` command and pass this to the `checkpoint-vm` command using the pipe character `|`,. Finally give the checkpoint a name using `-snapshotname`. The complete command will look like the following:

 ```
 get-vm -Name <VM Name> | checkpoint-vm -snapshotname <name for snapshot>
 ```
For example, here is a checkpoint with the name DEMOCP:
 
 ![](media\POSH_CP2.png)

### Create a new virtual machine

The following example shows how to create a new virtual machine in the PowerShell Integrated Scripting Environment (ISE).

1. To open the PowerShell ISE click on start, type **PowerShell ISE**.
2. Run the following code to create a virtual machine where:

  - Lines 1 – 9: Defines the VM parameters storing each in a PowerShell variable.
  - Line 11: Creates the new VM using all defined parameters.
  - Line 12: Adds a virtual CD Rom drive to the VM and mounts installation media in this drive.

 ```
 $Name = "POSHVM"
 $MemoryStartupBytes = 2147483648
 $Generation = 2
 $NewVHDPath = "D:\Windows 10 VM\POSHVM\$Name.vhdx"
 $NewVHDSizeBytes = 53687091200
 $BootDevice = "VHD"
 $Path = "D:\Windows 10 VM\POSHVM"
 $SwitchName = (get-vmswitch).Name
 $DVDPath = "C:\Media\media.iso"

 New-VM -Name $Name -MemoryStartupBytes $MemoryStartupBytes -Generation $Generation -NewVHDPath $NewVHDPath -NewVHDSizeBytes $NewVHDSizeBytes -BootDevice $BootDevice -SwitchName $SwitchName -Path $Path 
 Add-VMDvdDrive -VMName $Name -Path $DVDPath
 ```
3. This script could be re-written like this to increase readability and reusability. 

 ```
 $VM = @{
     Name = "POSHVM"
     MemoryStartupBytes = 2147483648
     Generation = 2
     NewVHDPath = "D:\Windows 10 VM\POSHVM\$Name.vhdx"
     NewVHDSizeBytes = 53687091200
     BootDevice = "CD"
     Path = "D:\Windows 10 VM\POSHVM"
     SwitchName = (get-vmswitch).Name
 }

 $DVD = @{
     Path = "C:\media\media_disk.iso"
 }

 New-VM @VM
 Add-VMDvdDrive @DVD
 ```

### Wrap up and References

This document has shown some simple steps to explorer the Hyper-V PowerShell module as well as some sample scenarios. For more information on the Hyper-V PowerShell module, see the [Hyper-V Cmdlets in Windows PowerShell reference](https://technet.microsoft.com/%5Clibrary/Hh848559.aspx).  
  



