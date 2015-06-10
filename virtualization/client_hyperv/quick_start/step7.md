ms.ContentId: 66A69B50-7388-48EF-B490-9F8464AD51ED
title: Step 7: Export and import a virtual machine


# Step 7: Export and import a virtual machine #

You can quickly copy a virtual machine or move a virtual machine by using the export and import functionality.

Exporting a virtual machine exports all of the pieces of the VM, including the checkpoints.

## Export a VM ##
1. In Hyper-V Manager, right-click **Windows Walkthrough VM** and select **Export**.
2. Click Browse in the dialog box. The default path for exporting is C:\Users\Public\Export. 
3. In the Select Folder dialog, click on New Folder and type in **Windows Walkthrough VM** for the name and then click **Select Folder**.
4. In the **Export Virtual Machine** dialog, click **Export**.
5. To verify that the virtual machine was exported, right-click on your Start menu and select File Explorer.
6. Navigate to \Users\Public\Export\Windows Walkthrough VM.
7. You should see another folder called Windows Walkthrough VM and inside that folder should be three folders with the files for your exported virtual machine:
 - Snapshots
 - Virtual Hard Disks
 - Virtual Machines 

## Import the VM ##


## Did it work? ##

To make sure the import worked, just right-click the imported VM in **Hyper-V Manager** and click **Connect**. 


# Next Step: #
[Step 8: Create a Linux guest virtual machine](step8.md)