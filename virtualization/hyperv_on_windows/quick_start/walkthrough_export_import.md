ms.ContentId: B971C429-CEF0-4DAB-8456-3B08AEC0C233
title: Step 7: Export and import a virtual machine

# Step 7: Export and import a virtual machine 

You can quickly copy a virtual machine or move a virtual machine by using the export and import functionality.

## Export the VM 

Exporting a virtual machine exports all of the pieces of the VM, including the checkpoints.

1. In Hyper-V Manager, right-click the virtual machine and select **Export**.

  ![](media/select_export1.png)
2. Click **Browse** in the dialog box and navigate to  C:\Users\Public and then click **Select Folder**. 

3. In the **Export Virtual Machine** dialog, make sure the path looks okay and then click **Export**.

  ![](media/click_export.png)
4. While the VM is being exported, you can see the progress in the Status section:

  ![](media/export_progress.png) 

## Did the export work? 

To verify that the virtual machine was exported, right-click on your **Start** menu and select **File Explorer**.
1. Navigate to C:\Users\Public\Windows Walkthrough VM.
2. You should see another folder called Windows Walkthrough VM and inside that folder should be three folders with the files for your exported virtual machine:
 - Snapshots
 - Virtual Hard Disks
 - Virtual Machines 
 
  ![](media/export_confirm.png)

## Import the VM 

Before we import the VM, we are going to delete the original VM. Right-click on the VM and select **Delete**. 
1. In **Hyper-V Manager**, in the **Action** menu, click **Import Virtual Machine**.
2. In the **Locate Folder** section, click Browse and navigate to C:\Users\Public\Windows Walkthrough VM  and then click **Next**.
3. In the **Select virtual machine to import** screen click **Next**.
4. In the **Choose Import Type** section, select **Register the virtual machine in place** and then click **Next**. 
6. In the **Choose Destination** section, leave the default and click **Next**.
7. In Choose Storage folders, leave the default path and click **Next**.
8. On the summary page you'll see a list of the paths where the new VM files will be located. Click **Finish** to start the import.


## Did the import work? 

To make sure the import worked, just double-click the VM in **Hyper-V Manager** and launch VMConnect to check the VM. 

## Next Step: 
[Step 8: Experiment with Windows Powershell](walkthrough_powershell.md)