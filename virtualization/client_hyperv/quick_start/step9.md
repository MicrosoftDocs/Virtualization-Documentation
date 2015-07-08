ms.ContentId: C481ACA0-C4AD-4AC1-B1B5-97AA635D0809
title: Step 10: Experiment with Windows PowerShell

# Step 10: Experiment with Windows PowerShell

Now that we have walked through the basics of deploying Hyper-V, creating virtual machines and managing these virtual machines, let’s explore how we can automate many of these activities with PowerShell.

##Return a list of Hyper-V commands:
Before working with Hyper-V virtual machines let’s explore the Hyper-V module
1.	Click on the start button and type PowerShell ISE and click enter. This will open up the PowerShell scripting environment.
2.	Type the following command. This will produce a searchable list of the PowerShell commands available with the Hyper-V PowerShell Module.

```
get-command –module hyper-v | out-gridview
```

![](media\command_grid.png)

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

To power on a particular virtual machine we can run the following:

```powershell
Start-vm –Name <virtual machine name>
```

Or to power on all currently powered off virtual machines we can gather a list  of only thoes machines and pipe this to the start-vm command like this:

```powershell
get-vm | where {$_.State –eq ‘Off’} | start-vm
```

##Create a new virtual machine
##Create a VM checkpoint 
##Remove a Virtual Machine

## Next step: ##
[Step 10: Backup your virtual machines](step10.md)


