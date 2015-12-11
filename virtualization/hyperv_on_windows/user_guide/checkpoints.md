# Using checkpoints to revert virtual machines to a previous state

One of the great benefits to virtualization is the ability to easily save the state of a virtual machine. In Hyper-V this is done through the use of virtual machine checkpoints. You may want to create a virtual machine checkpoint before making software configuration changes, applying a software update, or installing new software. If a system change were to cause an issue, the virtual machine can be reverted to the state at which it was when then checkpoint was taken.

Windows 10 Hyper-V includes two types of checkpoints:

* **Standard Checkpoints** -- takes a snapshot of the virtual machine and virtual machine memory state at the time the checkpoint is initiated. A snapshot is not a full backup and can cause data consistancy issues with systems that replicate data between different nodes such as Active Directory.  Hyper-V only offered standard checkpoints (formerly called snapshots) prior to Windows 10.

* **Production Checkpoints** –- uses Volume Shadow Copy Service or File System Freeze on a Linux virtual machine to create a data conistenant back of the virtual machine.

Production checkpoints are selected by default however this can be changed using either Hyper-V manager or PowerShell.

## Changing the Checkpoint Type for a VM

### Using Hyper-V Manager

1. Open Hyper-V Manager.

2. Right click on a virtual machine and select **settings**.

3. Under Management select **Checkpoints**.

4. Select the desired checkpoint type.

![](media/checkpoint_upd.png)

### Using PowerShell

The following commands can be run to change the checkpoint with PowerShell. 

```powershell
# Set to Standard Checkpoint.
Set-VM -Name <vmname> -CheckpointType Standard
```

```powershell
# Set to Production Checkpoint, if the production checkpoint fails a standard checkpoint is be created.
Set-VM -Name <vmname> -CheckpointType Production
```

```powershell
# Set to Production Checkpoint, if the production checkpoint fails a standard checkpoint is not be created. 
Set-VM -Name <vmname> -CheckpointType ProductionOnly
```

## Creating and applying checkpoints

### Using Hyper-V Manager
To create a checkpoint
1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	Right-click the name of the virtual machine, and then click **Checkpoint**.
3.	When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 

If you want to revert your virtual machine to a previous point-in-time, you can apply an existing checkpoint.

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the checkpoint that you want to use and click **Apply**.
3.	A dialog box appears with the following options: 

```	
**Create Checkpoint and Apply**: Creates a new checkpoint of the virtual machine before it applies the earlier checkpoint. 

**Apply**: Applies only the checkpoint that you have chosen. You cannot undo this action.

**Cancel**: Closes the dialog box without doing anything.
```

### Using PowerShell

3. Create a checkpoint using the **CheckPoint-VM** command. This command creates a checkpoint of the type configured for the virtual machine. See the Configuring Checkpoint Type section earlier in this document for instructions on how to change this type.

	```powershell
	Checkpoint-VM –Name <VMName>
	```
4. When the checkpoint process has completed, delete the file from the virtual machine.

5. To see a list of checkpoints for a virtual machine use the **Get-VMCheckpoint** command.

	```powershell
	Get-VMCheckpoint -VMName <VMName>
	```
6. To apply the checkpoint use the **Restore-VMCheckpoint** command.

	```powershell
	Restore-VMCheckpoint -Name <checkpoint name> -VMName <VMName> -Confirm:$false
	```

## Manage Checkpoints with PowerShell

Just as checkpoints can be created, applied, and managed manually with the Hyper-V Manager, these actions can also be automated using PowerShell. Note that when managing checkpoints with PowerShell the commands are run from the Hyper-V host and not from within the virtual machine itself.

> Several aliases have been created in the Hyper-V PowerShell module so that checkpoint and snapshot can be used interchangeably. This document uses checkpoint, however be aware that you may see similar command using the term snapshot.


## Export, Rename, Delete Checkpoints with PowerShell 

To export a virtual machine checkpoint, use the following command.

```powershell
Export-VMCheckpoint –VMName <virtual machine name>  –Name <checkpoint name> -Path <path for export>
```


To rename a virtual machine checkpoint, use the following command.

```powershell
Rename-VMCheckpoint –VMName <virtual machine name> –Name <checkpoint name> --NewName <new checkpoint name>
```
To delete a virtual machine checkpoint, use the following command.

```powershell
Remove-VMCheckpoint –VMName <virtual machine name> –Name <checkpoint name>
```

## Enable or disable checkpoints

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	To allow checkpoints to be taken off this virtual machine, make sure Enable Checkpoints is selected -- this is the default behavior.  
To disable checkpoints, deselect the **Enable Checkpoints** check box.
4.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Choose standard or production checkpoints

Standard checkpoints (formerly known as snapshots) capture the exact memory state of your virtual machine.  That means the virtual machine will restore with **exactly** the same state in which the checkpoint was taken down to the exact application state.  
Standard checkpoints may contain information about client connections, transactions, and the external network state. This information may not be valid when the checkpoint is applied.  Additionally, if a checkpoint is taken during an application crash, restoring that checkpoint will be in the middle of that crash.

The presence of a standard checkpoint for a virtual machine may impact the disk performance of the virtual machine.  We do not recommend using standard checkpoints on virtual machines when performance or the availability of storage space is critical.


Applying a production checkpoint involves booting the guest operating system from an offline state. This means that no application state or security information is captured as part of the checkpoint process. 

The following table shows when to use production checkpoints or standard checkpoints, depending on the state of the virtual machine.

|   **Virtual Machine State** | **Production Checkpoint** |  **Standard Checkpoint** |
|:-----|:-----|:-----|
|**Running with Integration Services**| Yes | Yes |
|**Running without Integration Services** | No | Yes | 
|**Offline - no saved state**| Yes | Yes |
|**Offline - with saved state**| No | Yes |
|**Paused** | No| Yes |




##Delete a checkpoint

To cleanly delete a checkpoint: 

1.	In **Hyper-V Manager**, select the virtual machine.
2.	In the **Checkpoints** section, right-click the checkpoint that you want to delete, and click Delete. You can also delete a checkpoint and all subsequent checkpoints. To do so, right-click the earliest checkpoint that you want to delete, and then click ****Delete Checkpoint** Subtree**.
3.	You might be asked to verify that you want to delete the checkpoint. Confirm that it is the correct checkpoint, and then click **Delete**. 
4.	The .avhdx and .vhdx files will merge, and when complete, the .avhdx file will be deleted from the file system. 

> **Tip:** You can use Windows Powershell to delete a checkpoint by using the **Remove-VMSnapshot** cmdlet. 
 
 Checkpoints are stored as .avhdx files in the same location as the .vhdx files for the virtual machine. You should not delete the .avhdx files directly.





## Export, Rename, Delete Checkpoints Using Hyper-V Manager 

In addition to applying a checkpoint, using Hyper-V manager several other actions can be completed.

- **Export** – Allows you to export the checkpoint to another location. The export is a virtual machine backup that can be used to import the virtual machine into different location or different Hyper-V host.

- **Rename** – useful for including details about the system state when the checkpoint was created.

- **Delete Checkpoint** – when a checkpoint is no longer needed, deleting it frees up storage space on the Hyper-V host.

Each of these actions can be accessed through the right click contextual menu of the virtual machine or the actions pane in Hyper-V Manager.

## Change where checkpoint settings and save state files are stored
If the virtual machine has no checkpoints, you can change where the checkpoint configuration and saved state files are stored.

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
	
2.	In the **Management** section, select **Checkpoints** or **Checkpoint File Location**.
	
4.	In **Checkpoint File Location**, enter the path to the folder where you would like to store the files.
	
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.

The default location for storing checkpoint configuration files is: %systemroot%\ProgramData\Microsoft\Windows\Hyper-V\Snapshots.


<!-- This belongs in dev docs

This folder will contain the .VMRS file with the runtime and saved state data and a .VMCX configuration file, which uses the checkpoint GUID as the file name.
-->

## Rename a checkpoint

1.	In **Hyper-V Manager**, select the virtual machine.
2.	Right-click the checkpoint, and then select **Rename**.
3.	Enter in the new name for the checkpoint. It must be less than 100 characters, and the field cannot be empty.
4.	Click **ENTER** when you are done.

By default, the name of a checkpoint is the name of the virtual machine combined with the date and time the checkpoint was taken. This is the standard format: 

```
virtual_machine_name (MM/DD/YYY –hh:mm:ss AM\PM)
```

Names are limited to 100 characters or less, and the name cannot be blank. 


## Demonstrating checkpoints in Hyper-V Manager 

This exercise walks through creating and applying a standard checkpoint versus a production checkpoint.  For this example, you will make a simple change to the virtual machine and observe the different behavior. 

### Standard checkpoint

1. Log into your virtual machine and create a text file on the desktop.

2. Open the file with Notepad and enter the text ‘This is a Standard Checkpoint.’  
  **do not save the file or close Notepad**.  

3. Change the checkpoint to standard -- instructions [here](checkpoints.md#changing-the-checkpoint-type-using-hyper-V-manager).

4. Create a new checkpoint 
  Once created, the checkpoint will be listed under the Checkpoints tree view of Hyper-V Manager. The checkpoint is given an auto generated name with a timestamp indicating the time at which the checkpoint was created.
  
  ![](media/std_checkpoint_upd.png) 

**Apply the Standard Checkpoint with Hyper-V Manager**

Now that a checkpoint exists, make a modification to the virtual machine and then apply the checkpoint to revert the virtual machine back to the saved state. 

1. Close the text file if it is still open and delete it from the virtual machines desktop.

2. Open Hyper-V Manager, right click on the standard checkpoint, and select Apply.

3. Select Apply on the Apply Checkpoint notification window.

![](media/apply_standard_upd.png) 

Once the checkpoint has been applied, notice that not only is the text file present, but the system is in the exact state that it was when the checkpoint was created. In this case Notepad is open and the text file loaded.

## Working with Production Checkpoints in Hyper-V Manager

Let’s now examine production checkpoints. This process is almost identical to working with a standard checkpoint, however will have slightly different results. Before beginning make sure you have a virtual machine and that you have changes the checkpoint type to Production checkpoints.

**Modify the virtual machine and Create a Production Checkpoint**

1. Log into the virtual machine and create a new text file. If you have been following along in this exercises you can use the existing text file.

2. Enter ‘This is a Production Checkpoint.’ into the text file, save the file but **do not close Notepad**.

3. Open up Hyper-V Manager > right click on the virtual machine > select **Checkpoint**.

4. Click **OK** on the Production Checkpoint Created Window.

![](media/production_Checkpoin_upd.png) 
	
**Apply the Production Checkpoint with Hyper-V Manager**

Now that a checkpoint exists make a modification to the system and then apply the checkpoint to revert the virtual machine back to the saved state. 

1. Close the text file if it is still open and delete it from the virtual machines desktop.

2. Open up Hyper-V Manager, right click on the production checkpoint, and select **Apply**.

3. Select **Apply** on the Apply Checkpoint notification window.

Once the production checkpoint has been applied, noticed that the virtual machine is in an off state.

1. Start and log into the virtual machine.

2. Take note that the text file has been restored. But unlike the standard checkpoint, Notepad is not open.   