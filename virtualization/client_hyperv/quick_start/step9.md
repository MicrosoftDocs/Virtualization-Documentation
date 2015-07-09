ms.ContentId: C481ACA0-C4AD-4AC1-B1B5-97AA635D0809
title: Step 10: Experiment with Windows PowerShell

# Step 9: Experiment with Windows PowerShell

Now that we have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how we can automate many of these activities with PowerShell.

### Return a list of Hyper-V commands
Before we work with Hyper-V virtual machines, let’s explore the Hyper-V module:
1.	Click on the Windows start button, type **PowerShell** and click **enter** to open the PowerShell scripting environment.
2.	Type the following command to display a searchable list of PowerShell commands available with the Hyper-V PowerShell Module.

 ```powershell
get-command –module hyper-v | out-gridview
```
  Grid view of available Hyper-V commands: <!--I'd crop this screenshot to make it shorter and get rid of the whitespace on the left. You only need enough to get the point across. They don't need to see everything..-->

  ![](media\command_grid.png)

3. PowerShell includes a `get-help` system that allows us to quickly discover how to use PowerShell commands. For instance to see more information on how to use the `get-vm` command, enter the following:

  ```powershell
get-help get-vm
```
Which will produce information about how to structure the command, required and optional parameters and aliases:

![](media\get_help.png)


### Return a list of virtual machines

Now that we have examined the commands available for Hyper-V, let’s use the 'get-vm' command to return a list of virtual machines:

```powershell
get-vm
```
Which will produce output similar to this:

![](media\get_vm.png)


To return a list of only powered on virtual machines we can place a filter on the command like this:
``` 
get-vm | where {$_.State –eq ‘Running’}
```

Or to list all virtual machines in a powered off state:
``` 
get-vm | where {$_.State –eq ‘Off’}
```

### Power on or off virtual machines

Let's now perform an action against a virtual machine. To power on a particular virtual machine we can run the following, specifying the name of the virtual machine:
```powershell
Start-vm –Name <virtual machine name>
```

Or to power on all currently powered off virtual machines, we can gather a list of thoes machines and pipe this to the 'start-vm' command:
```powershell
get-vm | where {$_.State –eq ‘Off’} | start-vm
```

Similarly, to power off all running virtual machines the command would be:
```powershell
get-vm | where {$_.State –eq ‘Running’} | stop-vm
```

### Create a VM checkpoint

One option for creating a checkpoint is to load an instance of a virtual machine into the PowerShell session and then pipe this to the `checkpoint-vm` command, similar to this:
```powershell
get-vm -Name <VM Name> | checkpoint-vm -snapshotname <name for snapshot>
```
Which will result in a checkpoint with the name specified in the command:
 
 ![](media\POSH_CP2.png) 

### Delete a Virtual Machine 

To delete a virtual machine we use the `remove-vm` command. A virtual machine must be powered off before it can be deleted.
```powershell
remove-vm -Name <virtual machien name>
```

### Create a new virtual machine

Finally we will take a look at VM creation with PowerShell. This example will contain more than one line of code and may be more manageable if working from the PowerShell Integrated Scripting Environment (ISE).

To open the PowerShell ISE click on start, type `PowerShell ISE` and then press the `enter` key.

The following code consists of:

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
A more simple way to write this script would be to use a concept referred to as splatting. Splatting groups parameters and passes these to a command as a single unit. Splatting makes our scripts more readable, easier to modify and re-use.

The same script re-written using the splatting method would look like this:   

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

This document has shown some simple steps for exploring the Hyper-V PowerShell module as well as some sample use cases. For more information on the Hyper-V PowerShell module see the Reference Guide found here <!—Insert Reference Guide --> .  
  
## Next step: ##
[Step 10: Backup your virtual machines](step10.md)


