ms.ContentId: C481ACA0-C4AD-4AC1-B1B5-97AA635D0809
title: Step 10: Experiment with Windows PowerShell

# Step 10: Experiment with Windows PowerShell

Now that we have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how we can automate many of these activities with PowerShell.

##Return a list of Hyper-V commands:
Before working with Hyper-V virtual machines let’s explore the Hyper-V module
1.	Click on the start button and type PowerShell and click enter. This will open up the PowerShell scripting environment.
2.	Type the following command. This will produce a searchable list of PowerShell commands available with the Hyper-V PowerShell Module.

```
get-command –module hyper-v | out-gridview
```
![](media\command_grid.png)

PowerShell includes a get-help system that allows us to quickly discover how to use PowerShell commands. For instance to see more information on how to use the get-vm command, enter the following:

```
get-help get-vm
```
Which will produce:

![](media\get_help.png)

## Return a list of virtual machines

Now that we have examined the commands available for Hyper-V, let’s use one to return a list of virtual machines deployed to the Hyper-V host. Simply entering the get-vm command will return a list of all virtual machines running on the host.

```
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

## Power on or off virtual machines

Let's now perform some actions against virtual machines. To power on a particular virtual machine we can run the following specifying the name of the virtual machine:

```powershell
Start-vm –Name <virtual machine name>
```

Or to power on all currently powered off virtual machines, we can gather a list of thoes machines and pipe this to the start-vm command:

```powershell
get-vm | where {$_.State –eq ‘Off’} | start-vm
```

Similarly, to power off all running virtual machines the command would be similar to this:

```powershell
get-vm | where {$_.State –eq ‘Running’} | stop-vm
```
##Create a VM checkpoint 

One option for creating a checkpoint is to load an instance of a virtual machine into the PowerShell session and then pipe this to the checkpoint-vm command similar to this:

```
get-vm -Name <VM Name> | checkpoint-vm -snapshotname <name for snapshot>
```
Which will result in a checkpoint with the name specified in the command:

![](media\POSH_CP2.png)

##Delete a Virtual Machine

To delete a virtual machine we use the remove-vm command. A virtual machine must be powered off before it can be deleted.

```
remove-vm -Name <virtual machien name>
```

##Create a new virtual machine

## Next step: ##
[Step 10: Backup your virtual machines](step10.md)


