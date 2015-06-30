ms.ContentId: FCC6F388-DD06-4810-9BCB-7A163DB2C57F
title: Step 6: Experiment with checkpoints

# Step 6: Experiment with checkpoints #

Checkpoints can be helpful to use when you are about to make a change to a virtual machine and you want to be able to roll-back to the present state if the updates cause issues. There are two types of checkpoints:

•	**Production checkpoints**: Used mainly on servers in production environments 

•	**Standard checkpoints**: Used in development or testing environments 


Producton checkpoints are the default for Hyper-V Client on Windows 10.

For more information about checkpoints, see [Checkpoints Overview](..\about\checkpoints_overview.md)


## Change the checkpoint type ##
We will start by trying out the older style of checkpoints, **standard checkpoints**. Since production checkpoints are the default, we need to go into the settings for the VM and change the checkpoint type.

1. Right-click on **Windows Walkthrough VM** and select **Settings**.
2. In the **Management** section, select **Checkpoints**.
3.	Select **Standard checkpoints**. The dialog should look like this:
![](media/standard.png)
4.	Click **OK** to close the dialog box.

## Open Notepad to test checkpoints ##
In order to see what happens with each type of checkpoint, we need to run an application in the VM. 
1. Right-click on **Windows Walkthrough VM** and select **Connect**.
2. In the virtual machine, open **Notepad** by clicking on the **Start** menu and typing **Notepad** and then select it from the results. 
3. In Notepad,  type **This is a test of checkpoints.** The file should look like this:
![](media/standard_notepad.png)
4. Save the file as **test.txt**, but don't close Notepad. Leave it running in the virtual machine.

## Create a standard checkpoint ##
1. To create the checkpoint, we just need to right-click the VM and click **Checkpoint**. 
2. In the checkpoint name dialog, type **Standard**. The dialog should look like this:
![](media/save_standard.png) 
3. When the process is complete, the checkpoint will appear under **Checkpoints** in the **Hyper-V Manager**.
![](media/standard_complete.png) 

## Create a production checkpoint ##
Now, we need to change change the type of checkpoint that we want to take back to **Production checkpoints** before we take another checkpoint.

1.	Right-click the virtual machine, and click **Settings**.
2.	In the **Management** section, select **Checkpoints**.
3.	Select **Production checkpoints** and then make sure to clear the fall-back option. If the system can't take a production checkpoint, we want it to fail instead of taking a standard checkpoint.
4.	When you are done, it should look like this:
![](media/production.png)
6.	click **OK** to close the dialog box.
7.	Right-click on the VM again and select **Connect**.
8.	In Notepad in the VM, type another line that reads **This is a test of a production checkpoint** and save the file again.
9.	Click on the ![](media/checkpoint_button.png) **Checkpoint** button in the menu bar.
10.	When asked, name it **Production** and then click **Yes**.
![](media/production_notepad.png) 
11. Close VMConnect. The VM will continue running, you just won't be connected to it anymore.
12. In Hyper-V manager, your list of checkpoints will now look like this:
![](media/production_complete.png)



## Apply the standard checkpoint ##

1.	In **Hyper-V Manager**, in the **Checkpoints** section, right-click the one titled **Standard** and click **Apply**.
3.	In the pop-up dialog, click **Create Checkpoint and Apply**. 
![](media/apply_standard.png)
4. When the finished, your list of checkpoints will now look something like this:
![](media/standard_applied.png)
5. When this finishes, right-click the VM and the click **Connect** to connect to the VM. 
6. When you connect to the VM, the VM should be running, with Notepad open, but the line about production checkpoints will be missing:
![](media/standard_applied_notepad.png)
7. Close VMConnect, but leave the VM running.


## Apply the production checkpoint ##
Now, let's go back to Hyper-V manager and apply the production checkpoint and see how our VM looks afterwards.

1.	In the Checkpoints section, right-click the one titled **Production Checkpoint** and click **Apply**.
2.	In the pop-up dialog, pick **Create Checkpoint and Apply**. 
3. When this finishes, right-click the VM and the click **Connect** to launch the VM. 
4. You will notice that the VM is not running. Click on the ![](media/vmconnect_start_button.png) Start button in the menu bar to start the VM.
5. Open open test.txt in Notepad. You should see the line in the file about testing production checkpoints:
![](media/production_notepad.png)
	

## Rename a checkpoint ##
1. Right-click the last checkpoint in the tree and click Rename.
2. Name the checkpoint **Delete me**.
![](media/delete_me.png)

## Delete a checkpoint ##
The previous step has probably given you a hint about what we will do next. We are going to delete the checkpoint that you just renamed.

1.Right-click on the checkpoint named **Delete me** and click **Delete**. 
![](media/delete_checkpoint.png)
2. In the warning dialong, click **OK**. 
![](media/delete_warn.png)
3. After the checkpoint is deleted, you list should look something like this:
![](media/after_delete.png)


# Next Steps: #
[Step 7: Export and import a virtual machine](step7.md)


