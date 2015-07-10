ms.ContentId: C481ACA0-C4AD-4AC1-B1B5-97AA635D0809
title: Step 10: Experiment with Windows PowerShell

# Step 9: Experiment with Windows PowerShell

Now that you have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how you can automate many of these activities with PowerShell.

### Return a list of Hyper-V commands

1.	Click on the Windows start button, type **PowerShell**.
2.	Run the following command to display a searchable list of PowerShell commands available with the Hyper-V PowerShell Module.

 ```powershell
get-command –module hyper-v | out-gridview
```
  You get something like this: <!--I'd crop this screenshot to make it shorter and get rid of the whitespace on the left. You only need enough to get the point across. They don't need to see everything..-->

  ![](media\command_grid.png)

3. To learn how to use a PowerShell cmdlet like **get-vm**, run the following command:

  ```powershell
get-help get-vm
```
 This shows you how to structure the command, what the required and optional parameters are, and the aliases that you can use.

 ![](media\get_help.png)


### Return a list of virtual machines

<!--As this is a walkthrough, the exercises should line up with they've already done. We've only had them create one VM titled Windows Walkthrough VM. -->

Use the **get-vm** command to return a list of virtual machines.
1. In PowerShell, run the following command:
 
 ```powershell
get-vm
```
 This displays something like this:

 ![](media\get_vm.png)

2. To return a list of only powered on virtual machines, add a where clause to filter the list like this: <!--I'd suggest adding more detail here like "...where $_.State is x and -eq is y. That way people can understand and extrapolate the command for other uses. -->
  ``` 
get-vm | where {$_.State –eq ‘Running’}
```
3.  To list all virtual machines in a powered off state, run this command:
  ``` 
get-vm | where {$_.State –eq ‘Off’}
```

### Power on or off virtual machines
<!--I think these should all be turn on/turn off. Power on/off sounds weird to me. Or is it Start/shut down or Start/Stop vm? Should match terms we use in UI. Also this doesn't line up with previous walkthrough topic - we've only had them create one VM.-->

1. To power on a particular virtual machine, run the following command with name of the virtual machine:
 ```powershell
Start-vm –Name <virtual machine name>
```
2. To power on all currently powered off virtual machines, get a list of those machines and pipe the list to the 'start-vm' command:
  ```powershell
get-vm | where {$_.State –eq ‘Off’} | start-vm
```
3. To power off all running virtual machines, run this:
  ```powershell
get-vm | where {$_.State –eq ‘Running’} | stop-vm
```

### Create a VM checkpoint

Load an instance of a virtual machine into the PowerShell session and then pipe this to the **checkpoint-vm** command, similar to this:
<!--What do you mean by load an instance? Try to simplify this sentence. "Get the vm attributes and pipe this into ..." Also if this is for a beginner I'm not sure that pipe is going to make sense. I know that's what it's called but we should say what it does the first time you mention it.  -->
```powershell
get-vm -Name <VM Name> | checkpoint-vm -snapshotname <name for snapshot>
```
For example, here is a checkpoint with the name DEMOCP:
 
 ![](media\POSH_CP2.png) <!--This needs a box around the checkpoint. Took me too long to figure out what I was supposed to see.-->

### Delete a Virtual Machine 

To delete a virtual machine, use the **remove-vm** command. 
```powershell
remove-vm -Name <virtual machine name>
```
A virtual machine must be powered off before it can be deleted. <!--stopped or turned off?-->

### Create a new virtual machine

The following example shows how to create a new virtual machine in the PowerShell Integrated Scripting Environment (ISE).

1. To open the PowerShell ISE click on start, type **PowerShell ISE**.
2. Run the following code to create a virtual machine where:

  - Lines 1 – 9: Defines the VM parameters storing each in a PowerShell variable.
  - Line 11: Creates the new VM using all defined parameters.
  - Line 12: Adds a virtual CD Rom drive to the VM and mounts installation media in this drive.

  ```powershell
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
3. Use the splatting to create a virtual machine. Splatting groups parameters and passes these to a command as a single unit. Splatting makes scripts more readable, easier to change and re-use.

The same script used in step 2 is re-written using the splatting method and looks like:   

```powershell
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

This document has shown some simple steps to explorer the Hyper-V PowerShell module as well as some sample scenarios. For more information on the Hyper-V PowerShell module, see the Reference Guide found here <!—Insert Reference Guide --> .  
  
## Next step: ##
[Step 10: Backup your virtual machines](step10.md)


