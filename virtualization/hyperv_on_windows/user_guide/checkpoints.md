ms.ContentId: 8D89E9D8-2501-46A7-9304-2F19F37AFC85
title: Working with checkpoints

# Use checkpoints to revert virtual machines to a previous state #

Checkpoints provide a fast and easy way to revert the virtual machine to a previous state. For more information about how checkpoints work, see [Checkpoints Overview](..\about\checkpoints_overview.md).

## Enable or disable checkpoints ##

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	To allow checkpoints to be taken off this virtual machine, make sure Enable Checkpoints is selected. To disable checkpoints, clear the **Enable Checkpoints** check box.
4.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Choose standard or production checkpoints ##

You can choose between standard and production checkpoints for each virtual machine.

-  **Production checkpoints**: Used mainly on servers in production environments 
-  **Standard checkpoints**: Used in development or testing environments 



1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select either production checkpoints or standard checkpoints. 
If you choose production checkpoints, you can also specify whether the host should take a standard checkpoint if a production checkpoint cannot be taken. If you clear this check box and a production checkpoint cannot be taken, no checkpoint will be selected.
4.	If you want to change the location where the configuration files for the checkpoint are stored, change the path in the **Checkpoint File Location** section.
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.

### How are production checkpoints different from standard checkpoints?

Production checkpoints and standard checkpoints restore a virtual machine to a previous state. However, production checkpoints utilize the Volume Shadow Copy Service (VSS) to create an application-consistent checkpoint of a virtual machine. Standard checkpoints (formerly known as snapshots) capture the saved state of your virtual machine.

Standard checkpoints contain the memory state of a virtual machine, which may contain information about client connections, transactions, and the external network state. This information may not be valid when the checkpoint is applied. Applying a production checkpoint involves booting the guest operating system from an offline state. This means that no application state or security information is captured as part of the checkpoint process. 


## Create a checkpoint ##
To create a checkpoint
1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	Right-click the name of the virtual machine, and then click **Checkpoint**.
3.	When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 


## Apply a checkpoint ##
If you want to revert your virtual machine to a previous point-in-time, you can apply an existing checkpoint.

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the checkpoint that you want to use and click **Apply**.
3.	A dialog box appears with the following options: 
	
    **Create Checkpoint and Apply**: Creates a new checkpoint of the virtual machine before it applies the earlier checkpoint. 

	**Apply**: Applies only the checkpoint that you have chosen. You cannot undo this action.

	**Cancel**: Closes the dialog box without doing anything.


##Delete a checkpoint ##
Checkpoints are stored as .avhdx files in the same location as the .vhdx files for the virtual machine. You should not delete the .avhdx files directly.
 
To cleanly delete a checkpoint: 

1.	In **Hyper-V Manager**, select the virtual machine.
2.	In the **Checkpoints** section, right-click the checkpoint that you want to delete, and click Delete. You can also delete a checkpoint and all subsequent checkpoints. To do so, right-click the earliest checkpoint that you want to delete, and then click ****Delete Checkpoint** Subtree**.
3.	You might be asked to verify that you want to delete the checkpoint. Confirm that it is the correct checkpoint, and then click **Delete**. 
4.	The .avhdx and .vhdx files will merge, and when complete, the .avhdx file will be deleted from the file system. 

**Tip **
You can use Windows Powershell to delete a checkpoint by using the **Remove-VMSnapshot** cmdlet. 


## Change where checkpoint settings and save state files are stored ##
If the virtual machine has no checkpoints, you can change where the checkpoint configuration and saved state files are stored.

The default location for storing checkpoint configuration files is: %systemroot%\ProgramData\Microsoft\Windows\Hyper-V\Snapshots. This folder will contain the .VMRS file with the runtime and saved state data and a .VMCX configuration file, which uses the checkpoint GUID as the file name.

1.	In **Hyper-V Manager**, right-click the name of the virtual machine, and click **Settings**.
	
2.	In the **Management** section, select **Checkpoints** or **Checkpoint File Location**.
	
4.	In **Checkpoint File Location**, enter the path to the folder where you would like to store the files.
	
5.	Click **Apply** to apply your changes. If you are done, click **OK** to close the dialog box.


## Rename a checkpoint ##
By default, the name of a checkpoint is the name of the virtual machine combined with the date and time the checkpoint was taken. This is the standard format: 

*virtual_machine_name (MM/DD/YYY –hh:mm:ss AM\PM) *

Names are limited to 100 characters or less, and the name cannot be blank. 


1.	In **Hyper-V Manager**, select the virtual machine.
2.	Right-click the checkpoint, and then select **Rename**.
3.	Enter in the new name for the checkpoint. It must be less than 100 characters, and the field cannot be empty.
4.	Click **ENTER** when you are done.

