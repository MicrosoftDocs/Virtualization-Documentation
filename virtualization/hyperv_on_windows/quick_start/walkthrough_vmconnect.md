ms.ContentId: 178899C9-8EA6-4D82-A0B0-8BE4DDD78DAE
title: Step 5: Connect to the virtual machine and finish the installation

# Step 5: Connect to the virtual machine and finish the installation #

In order to finish building your virtual machine, you need to start the VM and walk through the operating system installation.

## Connect to the VM ##
1. In **Hyper-V Manager**, right-click the virtual machine and then click **Connect**. 

2. In VMConnect, click on the green start button ![](media\start.png). This is like hitting the power button on a physical computer. 

3. The VM will boot into setup and you can walk through the installation like you would on a physical computer.


## Other stuff you can do in VMConnect ##


| **To do this…** | Click this...| **Or, do this…** |
|:-----|:-----:|:-----:|
| Start the virtual machine | ![](media/start.png)	 | CTRL+S | 
| Turn off the VM | ![](media/turnoff.png) 	|   |
| Shut down a VM | ![](media/shutdown.png) 	|  |
| Save | ![](media/save.png) 	|  |
| Pause | ![](media/pause.png) 	|  |
| Reset | ![](media/reset.png) 	|  |
| Mouse release | ![](media/ctrlaltdel.png) 	 |CTRL+ALT+LEFT arrow |
| CTRL+ALT+DELETE for a physical computer |  |CTRL+ALT+END |
| Switch from full-screen mode back to windowed mode |  | CTRL+ALT+BREAK | 
| Use enhanced session mode | ![](media/rdp.png) 	|	| 
| Open the settings for the virtual machine |  | CTRL+O | 
| Create a checkpoint | ![](media/checkpoint.png) 	 | CTRL+N or select **Action** > **Checkpoint**| 
| Revert to a checkpoint | ![](media/revert.png)	 | CTRL+E | 
| Do a screen capture |  | CTRL+C | 
| Return mouse clicks or keyboard input to the physical computer |  |Press CTRL+ALT+LEFT arrow and then move the mouse pointer outside of the virtual machine window. This is the **mouse release key combination** and it can be changed in the **Hyper-V settings** in **Hyper-V Manager**. |
| Send mouse clicks or keyboard input to the virtual machine |  |Click anywhere in the virtual machine window. The mouse pointer may appear as a small dot when you connect to a running virtual machine. |
| Change the settings of the virtual machine |  | Select **File** > **Settings**.
| Connect to a DVD image (.iso file) or a virtual floppy disk (.vfd file) |  | Click **Media** on the menu. Virtual floppy disks are not supported for generation 2 virtual machines.|



## Next Step: ##
[Step 6: Experiment with checkpoints](walkthrough_checkpoints.md)
