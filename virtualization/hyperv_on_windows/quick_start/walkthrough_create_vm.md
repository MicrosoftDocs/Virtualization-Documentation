ms.ContentId: 3C63F9A8-30E4-40F4-BC7B-A001C1E90779
title: Step 4: Create a Windows virtual machine from an .iso file

# Create a Windows virtual machine 

1. In Hyper-V Manager, click on the **Action** menu > **New** > **Virtual machine**. 
2. The default settings in the the virtual machine wizard are very close to the ones you'll use.  
For an easy to use test virtual machine, make the following selections:

    <table>
    <tr> <th>Page</th> <th>Entry</th> <th>Recomended Choice</th> </tr>
    <tr> <td>Specify Name and Location</td> <td>Name</td> <td>Name your VM  <b>Windows Walkthrough VM</b></td> </tr>
    <tr> <td>Specify Generation</td> <td>Generation</td> <td><b>Generation 2</b></td></tr>
    <tr> <td>Assign Memory</td> <td>Startup Memory</td> <td><b>1024</b> MB </td> </tr>
    <tr>  <td></td> <td>Use dynamic memory</td> <td>leave dynamic memory selected </td></tr>
    <tr><td>Configure Networking</td> <td>Connection</td> <td>Select <b>External</b> from the drop down</td> </tr>
    <tr> <td>Connect Virtual Hard Disk</td> <td><b>Create a virtual hard disk</b></td> <td>Select this to make a new VM.</td> </tr>
    <tr> <td></td> <td>Name</br> Location</br> Size</td><td>Keep the default values</td></tr>
    <tr> <td>Installation Options</td> <td>Install later</td> <td>You can create a VM with no operating system.</td> </tr>
    <tr> <td></td> <td>Install from bootable image</td> <td><b>This is the easy option.</br> See below for an iso.</b></td> </tr>
    </table>
  
3. When everything looks right, click **Finish**. 

## Help! I need an operating system for my new VM!
There are many postential operating systems to run in your virtual machine.  If you already have an image (.iso file) for an operating system, you can use that. If you have a DVD installer, insert the DVD and the mounted image is an iso.

If you don't have these, you can download a [Windows 8.1 Enterprise](http://www.microsoft.com/en-us/evalcenter/evaluate-windows-8-1-enterprise) image, an [Ubuntu image](http://www.ubuntu.com/download/desktop), or a plethora of other images.

## Next Step: 
[Step 5: Connect to the virtual machine and finish the installation](walkthrough_vmconnect.md)