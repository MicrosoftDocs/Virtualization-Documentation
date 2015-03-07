ms.ContentId: 14FAE32D-F71E-479A-B305-1094FA05E50A
title: Step 5: Create a Windows virtual machine from an .iso file

# Create a Windows virtual machine from an .iso file #

For this step, if you already have a .iso file for a supported operating system, you can use that. If not, you can download the .iso for [Microsoft Hyper-V Server 2012 R2](http://www.microsoft.com/en-us/evalcenter/evaluate-hyper-v-server-2012-r2). For this step, we will assume that your .iso file is in the Downloads directory, just replace this path in the instructons with the part you your file if you have it stored somewhere else.

1. In Hyper-V Manager, click on the **Action** menu > **New** > **Virtual machine**. 
2. In the virtual machine wizard, make the following choices:
	
	<table>
	<tr><td>Name:</td> <td><b>Windows Walkthrough VM</b></td></tr>
	<tr><td>Generation:</td> <td><b>Generation 2</b></td></tr>
	<tr><td>Startup Memory</td> <td><b>1024</b> and don't select dynamic memory</td></tr>
	<tr><td>Configure networking:</td> <td><b>External</b></td></tr>
	<tr><td>Connect virtual hard disk:</td> <td><b>Create a virtual hard disk</b> and keep the other default values</td></tr>
	<tr><td>Installation Options:</td> <td><b>Install an operating system from a bootable CD/DVD-ROM</b>. Under <b>Media</b>, select <b>Image file (iso)</b> and then click <b>Browse</b> to point to the .iso file.</td></tr>
</table>

3. The Summary page of the wizard should look like this:
	
	<!-- need screenshot -->
4. When everything looks right, click **OK**. 

# Next Step: #
Step 6: Connect to the virtual machine and finish the installation