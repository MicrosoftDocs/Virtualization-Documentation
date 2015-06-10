ms.ContentId: 2A12ACDB-37A1-449C-A73F-72CB81CCD5E9
title: Step 6: Experiment with checkpoints

# Step 6: Experiment with checkpoints #
There are two types of checkpoints, production and standard. Standard checkpoints are the default for Hyper-V Client on Windows 10.

## Open Notepad to test checkpoints ##
In order to see if something is actually happening when we take and apply checkpoints. In the virtual machine, open Notepad by clicking on the Start menu and typing Notepad and hen select it from the results. In Notepad,  type something like **Checkpoint testing 1, 2, 3**. Don't save the file and don't close Notepad, just leave it running in the virtual machine.

## Create a standard checkpoint ##
Since standard checkpoints are the default, we just need to right-click the VM and click **Checkpoint**.

When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 

To make it easier to keep track of our checkpoints, right-click the checkpoint and click **Rename**. Type in **Standard Checkpoint** and hit **Enter**.

## Create a production checkpoint ##
First we will need to change the type of checkpoint that we want to take.

1.	Right-click the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select production checkpoints and then make sure to clear the fall-back option. If the system can't take a production checkpoint, we want it to fail instead of taking a standard checkpoint.
4.	When you are done, click **OK** to close the dialog box.
5.	Right-click the VM again and select **Checkpoint** to create the production checkpoint.
6.	When the checkpoint has been created, right-click it and then click **Rename** and type **Production Checkpoint**.

## Make some changes in the virtual machine ##
In order to see if out checkpoints are working, we should go in and make some changes that we can check after we apply the checkpoint.

1. Open Notepad and type **This is a test**. 

## Apply the production checkpoint ##

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the one titled **Production Checkpoint** and click **Apply**.
3.	In the pop-up dialog, pick **Apply**. 
4. When this finishes, right-click the VM and the click **Connect** to launch the VM. 
	

## Apply the standard checkpoint ##


## Rename a checkpoint ##
Right-click the last checkpoint in the tree and click Rename.
Name the checkpoint **Delete this one**.

## Delete a checkpoint ##
The previous step has probably given you a hint about what we will do next. We are going to delete the checkpoint that you just renamed.


# Next Steps: #
[Step 7: Export and import a virtual machine](step7.md)


