ms.ContentId: 61CCEA47-B840-4EFE-8388-CA1044C74D15
title: Checkpoints Overview

# Checkpoint operations #

Checkpoints provide a fast and easy way to revert the virtual machine to a previous state. You can apply several operations to production checkpoints and standard checkpoints. 

## Enable or disable checkpoints ##

To enable or disable checkpoints for a virtual machine 

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	To allow checkpoints to be taken off this virtual machine, make sure Enable Checkpoints is selected. To disable checkpoints, clear the **Enable Checkpoints** check box.
4.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Choose standard or production checkpoints ##

You can choose between standard and production checkpoints for each virtual machine.
Production checkpoints allow you to easily create point-in-time images of a virtual machine, which can be restored later in a way that is completely supported for all production workloads. This is achieved by using backup technology inside the guest operating system to create the checkpoint, instead of using saved-state technology. Production checkpoints are the default for new virtual machines. 

Standard checkpoints capture the state, data, and hardware configuration of a running virtual machine, and they are intended for use in development and test scenarios. Standard checkpoints can be very useful if you need to re-create a specific state or condition of a running virtual machine so that you can troubleshoot an issue.

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select either production checkpoints or standard checkpoints. 
If you choose production checkpoints, you can also specify whether the host should take a standard checkpoint if a production checkpoint cannot be taken. If you clear this check box and a production checkpoint cannot be taken, no checkpoint will be created.
4.	If you want to change the location where the configuration files for the checkpoint are stored, change the path in the **Checkpoint File Location** section.
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.



## Create a checkpoint ##
To create a checkpoint
1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	Right-click the name of the virtual machine, and then click **Checkpoint**.
3.	When the process is complete, the checkpoint will appear under **Checkpoints** in **Hyper-V Manager**. 


## Apply a checkpoint ##
If you want to revert your virtual machine to a previous point-in-time, you can apply an existing checkpoint.
To apply a checkpoint

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the checkpoint that you want to use and click **Apply**.
3.	A dialog box appears with the following options: 
	
    **Create Checkpoint and Apply**: Creates a new checkpoint of the virtual machine before it applies the earlier checkpoint. 

	**Apply**: Applies only the checkpoint that you have chosen. You cannot undo this action.

	**Cancel**: Closes the dialog box without doing anything.


##Delete a checkpoint ##
Checkpoints are stored as .avhdx files in the same location as the .vhdx files for the virtual machine. You should not delete the .avhdx files directly.
 
To cleanly delete a checkpoint

1.	In **Hyper-V Manager**, select the virtual machine.
2.	In the **Checkpoints** section, right-click the checkpoint that you want to delete, and click Delete. You can also delete a checkpoint and all subsequent checkpoints. To do so, right-click the earliest checkpoint that you want to delete, and then click ****Delete Checkpoint** Subtree**.
3.	You might be asked to verify that you want to delete the checkpoint. Confirm that it is the correct checkpoint, and then click **Delete**. 
4.	The .avhdx and .vhdx files will merge, and when complete, the .avhdx file will be deleted from the file system. 

**Tip** 
You can use Windows Powershell to delete a checkpoint by using the Remove-VMSnapshot cmdlet. 


## Change where checkpoint settings and save state files are stored ##
If the virtual machine has no checkpoints, you can change where the checkpoint configuration and saved state files are stored.

The default location for storing checkpoint configuration files is: %systemroot%\ProgramData\Microsoft\Windows\Hyper-V\Snapshots. This folder will contain the .VMRS file with the runtime and saved state data and a .VMCX configuration file, which uses the checkpoint GUID as the file name.

To change where the checkpoint configuration and saved state files are stored

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
	
2.	In the **Management** section, select **Checkpoints** or **Checkpoint File Location**.
	
4.	In **Checkpoint File Location**, enter the path to the folder where you would like to store the files.
	
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Rename a checkpoint ##
By default, the name of a checkpoint is the name of the virtual machine combined with the date and time the checkpoint was taken. This is the standard format: 

```virtual_machine_name (MM/DD/YYY –hh:mm:ss AM\PM) ```

Names are limited to 100 characters or less, and the name cannot be blank. 
To rename a checkpoint

1.	In **Hyper-V Manager**, select the virtual machine.
2.	Right-click the checkpoint, and then select **Rename**.
3.	Enter in the new name for the checkpoint. It must be less than 100 characters, and the field cannot be empty.
4.	Click **ENTER** when you are done.
