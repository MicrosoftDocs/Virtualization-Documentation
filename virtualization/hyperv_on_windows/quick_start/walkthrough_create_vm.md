ms.ContentId: 3C63F9A8-30E4-40F4-BC7B-A001C1E90779
title: Step 4: Create a Windows virtual machine from an .iso file

# Step 4: Create a Windows virtual machine from an .iso file 

For this step, if you already have a .iso file for a supported 64-bit operating system, you can use that. If not, you can download the .iso for [Windows 8.1 Enterprise](http://www.microsoft.com/en-us/evalcenter/evaluate-windows-8-1-enterprise) and choose the 64-bit edition. 

1. In Hyper-V Manager, click on the **Action** menu > **New** > **Virtual machine**. 
2. In the virtual machine wizard, make the following choices:

    <table>
    <tr><th>Page</th><th>Entry</th></tr>
    <tr><td>Name:</td><td>Type in <b>Windows Walkthrough VM</b></td></tr>
    <tr><td>Generation:</td><td><b>Generation 2</b></td></tr>
    <tr><td>Startup Memory:</td><td><b>1024</b> and leave dynamic memory selected</td></tr>
	<tr><td>Configure Networking:</td><td><b>External</b> (this is the virtual switch you created in Step 3)</td></tr>
    <tr><td>Connect virtual hard disk:</td><td><b>Create a virtual hard disk</b> (keep the other default values) </td></tr>
    <tr><td>Installation Options:</td><td><b>Install an operating system from a bootable CD/DVD-ROM</b>. Under <b>Media</b>, select <b>Image file (iso)</b> and then click <b>Browse</b> to point to the .iso file.</td></tr>
    </table>
  
3. When everything looks right, click **Finish**. 

> **Note:** If you only have 32-bit version of Windows, you need to choose Generation 1 in the **Generation** section of the wizard. Generation 2 VMs only support 64-bit operating systems.

## Next Step: 
[Step 5: Connect to the virtual machine and finish the installation](walkthrough_vmconnect.md)

