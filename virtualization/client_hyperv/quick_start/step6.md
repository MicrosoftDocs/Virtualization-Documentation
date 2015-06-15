ms.ContentId: FCC6F388-DD06-4810-9BCB-7A163DB2C57F
title: Step 6: Experiment with checkpoints

# Step 6: Experiment with checkpoints #

Checkpoints can be helpful to use when you are about to make a change to a virtual machine and you want to be able to roll-back to the present state if the updates cause issues. There are two types of checkpoints:

•	**Production checkpoints**: Used mainly on servers in production environments 

•	**Standard checkpoints**: Used in development or testing environments 


Producton checkpoints are the default for Hyper-V Client on Windows 10.

For more information about checkpoints, see [../about/checkpoints_overview.md](../about/checkpoints_overview.md "Checkpoints Overview")


## Change the checkpoint type ##
We will start by trying out the older style of checkpoints, **standard checkpoints**. Since production checkpoints are the default, we need to go into the settings for the VM and change the checkpoint type.

1. Right-click on **Windows Walkthrough VM** and select **Settings**.
2. In the **Management** section, select **Checkpoints**.
3.	Select Standard checkpoints. 
4.	Click **OK** to close the dialog box.

## Open Notepad to test checkpoints ##
In order to see what happens with each type of checkpoint, we need to run an application in the VM. 
1. Right-click on **Windows Walkthrough VM** and select **Connect**.
2. In the virtual machine, open **Notepad** by clicking on the **Start** menu and typing **Notepad** and then select it from the results. 
3. In Notepad,  type **This is a test of checkpoints.** 
4. Save the file as **test.txt**, but don't close Notepad. Leave it running in the virtual machine.

## Create a standard checkpoint ##
To create the checkpoint, we just need to right-click the VM and click **Checkpoint**. In the checkpoint name dialog, type **Standard**.

When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**. 

## Make another change in Notepad ##

Go back to the VM and in Notepad, type another line that reads **This is a test of a production checkpoint** and save the file again. Then, close VMConnect. The VM will continue running, you just won't be connected to it anymore.

## Create a production checkpoint ##
Now, we need to change change the type of checkpoint that we want to take back to **Production checkpoints** before we take another checkpoint.

1.	Right-click the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select **Production checkpoints** and then make sure to clear the fall-back option. If the system can't take a production checkpoint, we want it to fail instead of taking a standard checkpoint.
4.	When you are done, click **OK** to close the dialog box.
5.	Right-click the VM and select **Checkpoint** to create the production checkpoint.
6.	When the checkpoint has been created, right-click it and then click **Rename** and type **Production Checkpoint**.

## Apply the standard checkpoint ##

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the one titled **Standard** and click **Apply**.
3.	In the pop-up dialog, pick **Apply**. 
4. When this finishes, right-click the VM and the click **Connect** to launch the VM. 


## Apply the production checkpoint ##

1.	In **Hyper-V Manager**, under **Virtual Machines**, select the virtual machine.
2.	In the Checkpoints section, right-click the one titled **Production Checkpoint** and click **Apply**.
3.	In the pop-up dialog, pick **Apply**. 
4. When this finishes, right-click the VM and the click **Connect** to launch the VM. 
	


## Rename a checkpoint ##
Right-click the last checkpoint in the tree and click Rename.
Name the checkpoint **Delete this one**.

## Delete a checkpoint ##
The previous step has probably given you a hint about what we will do next. We are going to delete the checkpoint that you just renamed.


# Next Steps: #
[Step 7: Export and import a virtual machine](step7.md)


