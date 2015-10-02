ms.ContentId: FBBAADE6-F1A1-4B5C-8FD2-BDCA3FCF81CA
title: Step 5 - Experiment with Checkpoints

# Experiment with Checkpoints 

One of the great benefits to virtualization is the ability to easily save the state of a virtual machine. In Hyper-V this is done through the use of virtual machine checkpoints. You may want to checkpoint a VM before making software configuration changes, applying a software update, or installing new software. If any of these were to cause an issue, the virtual machine can be reverted to the state at which it was when then checkpoint was taken.

Windows 10 Hyper-V includes two types of checkpoints:

- **Standard Checkpoints** – takes a snapshot of the VM and VM memory state at the time the checkpoint is initiated. This can be problematic for some workload such as when the VM is hosting a database or other sever / client workload.
- **Production Checkpoints** – uses Volume Shadow Copy Service or File System Freeze on a Linux VM to create an application consistent storage snapshot.

Production checkpoints are selected by default however this can be changed using either Hyper-V manager or PowerShell.

## Changing the checkpoint type using Hyper-V Manager

1. Open up Hyper-V Manager.

2. Right click on a virtual machine and select **settings**.

3. Under Management select **Checkpoints**.

4. Select the desired checkpoint type.

![](media/checkpoint_upd.png)

## Change the checkpoint type using PowerShell

The following commands can be run to change the checkpoint with PowerShell. 

```powershell
# Set to Standard Checkpoint.
Set-VM -Name <vmname> -CheckpointType Standard

# Set to Production Checkpoint.
Set-VM -Name <vmname> -CheckpointType Production

# Set to Production Checkpoint with no failback to Standard. 
Set-VM -Name <vmname> -CheckpointType ProductionOnly
```

## Working with Standard Checkpoints in Hyper-V Manager 

This exercise will walk through creating and applying a standard checkpoint. For this example, a simple change will be made to the virtual machine. The concept of checkpoints would also apply to more significant changes such as changing a software configuration. Before starting this exercise make sure that you have a virtual machine to work with and have changed the checkpoint type to Standard Checkpoints. 

**Modify the VM and Create a Standard Checkpoint**

1. Log into your virtual machine and create a text file on the desktop.

2. In the text file enter the text ‘This is a Standard Checkpoint.’, save the file, but **do not close Notepad**.

3. In Hyper-V Manager either right click on the virtual machine and select **Checkpoint**, or highlight the virtual machine and select the **Checkpoint** button from the actions menu.

When the checkpoint has been created it will be listed under the Checkpoints tree view of Hyper-V Manager. The checkpoint is given an auto generated name with a timestamp indicating the time at which the checkpoint was created.

![](media/std_checkpoint_upd.png) 

**Apply the Standard Checkpoint with Hyper-V Manager**

Now that a checkpoint exists make a modification to the system and then apply the checkpoint to revert the virtual machine back to the saved state. 

1. Delete the text file from the virtual machines desktop.

2. Open up Hyper-V Manager, right click on the standard checkpoint, and select Apply.

3. Select Apply on the Apply Checkpoint notification window.

![](media/apply_standard_upd.png) 

Once the checkpoint has been applied notice, that not only is the text file present, but the system is in the exact state that it was when the checkpoint was created. In this case Notepad is open and the text file loaded.

## Working with Production Checkpoints in Hyper-V Manager

Let’s now examine production checkpoints. This process is almost identical to working with standard checkpoint however will have slightly different results. Before beginning make sure you have a virtual machine and that you have changes the checkpoint type to Production checkpoints.

**Modify the VM and Create a Production Checkpoint**

1. Log into the VM and create a new text file. If you have been following along in this exercises you can use the existing text file.

2. Enter ‘This is a Production Checkpoint.’ into the text file, save the file but **do not close Notepad**.

3. Open up Hyper-V Manager > right click on the virtual machine > select **Checkpoint**.

4. Click **OK** on the Production Checkpoint Created Window.

![](media/production_Checkpoin_upd.png) 
	
**Apply the Production Checkpoint with Hyper-V Manager**

Now that a checkpoint exists make a modification to the system and then apply the checkpoint to revert the virtual machine back to the saved state. 

1. Delete the text file from the virtual machines desktop.

2. Open up Hyper-V Manager, right click on the production checkpoint, and select **Apply**.

3. Select **Apply** on the Apply Checkpoint notification window.

Once the production checkpoint has been applied, noticed that the virtual machine is in an off state.

1. Start and log into the virtual machine.

2. Take note that the text file has been restored, however unlike the standard checkpoint the notepad process has not been restored.   

## Managing Checkpoints with Hyper-V Manager

In addition to applying a checkpoint using Hyper-V manager several other actions can be completed.

- **Rename the checkpoint** – useful for including details about the system state when the checkpoint was created.

- **Delete the checkpoint** – when a checkpoint is no longer needed, deleting it will free up storage space on the Hyper-V host.

- **Export a checkpoint** – this action will create an export of the virtual machine in the state at which it was when the checkpoint was created. The result of exporting a checkpoint is a single virtual machine backup. When this backup is imported back into Hyper-V it will include no checkpoint data.

Each of these actions can be accessed through the right click contextual menu or the actions pane in Hyper-V Manager.

## Working with Checkpoint in PowerShell

To set the stage for working with checkpoints and PowerShell do the following:

1. Create a text file and enter the text ‘PowerShell checkpoint demonstration’. If you have been following along in this exercises you can use the existing text file.

2. On the Hyper-V Host open up a PowerShell session by clicking on **start** > type **powershell** > push **enter**.

3. Create a checkpoint using the **CheckPoint-VM** command. This command will create a checkpoint of the type configured for the VM. See the Configuring Checkpoint Type section earlier in this document for instructions on how to change this type.

	```powershell
	CheckPoint-VM –Name <VMName>
	```
4. When the checkpoint process has completed, delete the file from the virtual machine.

5. To see a list of checkpoints for a virtual machine use the **Get-VMSnapshot** command.

	```powershell
	Get-VMSnapshot -VMName <VMName>
	```
6. To apply the checkpoint use the **Restore-VMSnapshot** command.

	```powershell
	Restore-VMCheckpoint -Name <checkpoint name> -VMName <VMName> -Confirm:$false
	```

## Next Step
[Export and Import Virtual Machines](walkthrough_export_import.md)


