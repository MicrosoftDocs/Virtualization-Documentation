ms.ContentId: C5DAC361-D339-4C3B-90E4-2C133BE6812E
title: Step 4: Create a Windows virtual machine from an .iso file

# Create a Windows virtual machine from an .iso file #

For this step, if you already have a .iso file for a supported operating system, you can use that. If not, you can download the .iso for [Windows 8.1 Enterprise](http://www.microsoft.com/en-us/evalcenter/evaluate-windows-8-1-enterprise). For this step, we will assume that your .iso file is in the Downloads directory, just replace this path in the instructions with the path to your file if you have it stored somewhere else.

1. In Hyper-V Manager, click on the **Action** menu > **New** > **Virtual machine**. 
2. In the virtual machine wizard, make the following choices:


	| **Page** | **Entry** |
	|:-----|:-----|
	|Name:						|Type in **Windows Walkthrough VM** 										|
	|Generation: 				|**Generation 2** 													|
	|Startup Memory:			|**1024** and don't select dynamic memory 							|
	|Configure networking: 		|**External** (this is the Virtual Switch you created in Step 3)	|
	|Connect virtual hard disk: |**Create a virtual hard disk** (keep the other default values) 	|
	|Installation Options:		|**Install an operating system from a bootable CD/DVD-ROM**. Under **Media**, select **Image file (iso)** and then click **Browse** to point to the .iso file. 			|
3. The Summary page of the wizard should look like this:
	
	<!-- need screenshot -->
4. When everything looks right, click **OK**. 

# Next Step: #
[Step 5: Connect to the virtual machine and finish the installation](step5.md)