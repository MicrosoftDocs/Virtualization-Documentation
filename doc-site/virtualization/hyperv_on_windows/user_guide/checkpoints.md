ms.ContentId: 8D89E9D8-2501-46A7-9304-2F19F37AFC85
title: Working with checkpoints

# Using checkpoints to revert virtual machines to a previous state

Checkpoints provide a fast and easy way to revert the virtual machine to a previous state. This is especially helpful when you are about to make a change to a virtual machine and you want to be able to roll-back to the present state if that change cause issues.


## Enable or disable checkpoints

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	To allow checkpoints to be taken off this virtual machine, make sure Enable Checkpoints is selected -- this is the default behavior.  
To disable checkpoints, deselect the **Enable Checkpoints** check box.
4.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Choose standard or production checkpoints

There are two types of checkpoints:
*  **Production checkpoints** -- Used mainly on servers in production environments as a form of backup.
*  **Standard checkpoints** -- Used in development or testing environments to allow rollback if a change fails. 

Both types of checkpoints restore a virtual machine to a previous state.

Production checkpoints create an application-consistent checkpoint of a virtual machine.  That means the saved virtual machine will resume with no application state.  

Standard checkpoints (formerly known as snapshots) capture the exact memory state of your virtual machine.  That means the virtual machine will restore with **exactly** the same state in which the checkpoint was taken down to the exact application state.  
Standard checkpoints may contain information about client connections, transactions, and the external network state. This information may not be valid when the checkpoint is applied.  Additionally, if a checkpoint is taken during an application crash, restoring that checkpoint will be in the middle of that crash.

The presence of a standard checkpoint for a virtual machine may impact the disk performance of the virtual machine.  We do not recommend using standard checkpoints on virtual machines when performance or the availability of storage space is critical.


Applying a production checkpoint involves booting the guest operating system from an offline state. This means that no application state or security information is captured as part of the checkpoint process. 

The following table shows when to use production checkpoints or standard checkpoints, depending on the state of the virtual machine.

|   **Virtual Machine State** | **Production Checkpoint** |  **Standard Checkpoint** |
|:-----|:-----|:-----|
|**Running with Integration Services**| Yes | Yes 
|**Running without Integration Services** | No | Yes 
|**Offline - no saved state**| Yes | Yes 
|**Offline - with saved state**| No | Yes 
|**Paused** | No| Yes |

To see the difference between Standard and Production checkpoints, look at the [checkpoints walkthrough](../quick_start/walkthrough_checkpoints.md).

## Set a default checkpoint type

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select either production checkpoints or standard checkpoints. 
If you choose production checkpoints, you can also specify whether the host should take a standard checkpoint if a production checkpoint cannot be taken. If you clear this check box and a production checkpoint cannot be taken, no checkpoint will be selected.
4.	If you want to change the location where the configuration files for the checkpoint are stored, change the path in the **Checkpoint File Location** section.
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.

The default behavior in Windows 10 for new virtual machines is to create production checkpoints with fallback to standard checkpoints


## Create a checkpoint
To create a checkpoint
1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	Right-click the name of the virtual machine, and then click **Checkpoint**.
3.	When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 


## Apply a checkpoint
If you want to revert your virtual machine to a previous point-in-time, you can apply an existing checkpoint.

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the checkpoint that you want to use and click **Apply**.
3.	A dialog box appears with the following options: 

```	
**Create Checkpoint and Apply**: Creates a new checkpoint of the virtual machine before it applies the earlier checkpoint. 

**Apply**: Applies only the checkpoint that you have chosen. You cannot undo this action.

**Cancel**: Closes the dialog box without doing anything.
```

##Delete a checkpoint

To cleanly delete a checkpoint: 

1.	In **Hyper-V Manager**, select the virtual machine.
2.	In the **Checkpoints** section, right-click the checkpoint that you want to delete, and click Delete. You can also delete a checkpoint and all subsequent checkpoints. To do so, right-click the earliest checkpoint that you want to delete, and then click ****Delete Checkpoint** Subtree**.
3.	You might be asked to verify that you want to delete the checkpoint. Confirm that it is the correct checkpoint, and then click **Delete**. 
4.	The .avhdx and .vhdx files will merge, and when complete, the .avhdx file will be deleted from the file system. 

> **Tip:** You can use Windows Powershell to delete a checkpoint by using the **Remove-VMSnapshot** cmdlet. 
 
 Checkpoints are stored as .avhdx files in the same location as the .vhdx files for the virtual machine. You should not delete the .avhdx files directly.
 

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


