ms.ContentId: 2A12ACDB-37A1-449C-A73F-72CB81CCD5E9
title: Step 6: Experiment with checkpoints

# Step 6: Experiment with checkpoints #
There are two types of checkpoints, production and standard. Standard checkpoints are the default for Hyper-V Client on Windows 10.


## Create a standard checkpoint ##
Since standard checkpoints are the default, we just need to right-click the VM and click **Checkpoint**.

When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 

## Create a production checkpoint ##
First we will need to change the type of checkpoint that we want to take.

1.	Right-click the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select production checkpoints and then make sure to clear the fall-back option. If the system can't take a production checkpoint, we want it to fail instead of taking a standard checkpoint.
4.	When you are done, click **OK** to close the dialog box.
5.	Right-click the VM again and select **Checkpoint** to create the production checkpoint.

## Apply the production checkpoint ##


1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the one titled **Production Checkpoint** and click **Apply**.
3.	In the pop-up dialog, pick **Apply**. 
4. When this finishes, right-click the VM and the click **Connect** to launch the VM. 
	

## Apply the standard checkpoint ##


## Rename a checkpoint ##
RIght-click the last checkpoint in the tree and click Rename.
Name the checkpoint **Delete this one**.

## Delete a checkpoint ##
The previous step has probably given you a hint about what we will do next. We are going to delete the checkpoint that you just renamed.


# Next Steps: #
[Step 7: Export and import a virtual machine](step7.md)


