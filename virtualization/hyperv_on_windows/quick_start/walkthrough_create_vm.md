ms.ContentId: 3C63F9A8-30E4-40F4-BC7B-A001C1E90779
title: Step 4 - Deploy a Windows Virtual Machine

# Deploy a Windows Virtual Machine

You can create a Virtual Machine and deploy an operating system to it in many different ways, for example using Windows Deployment Services, attaching a prepared virtual hard drive, or manually stepping through the operating system deployment using the deployment media. This article will walk through creating a VM and deploying an operating system to the VM using the OS deployment media.

Before starting this exercise, you will need an .iso file for the operating system that you would like to deploy. If needed grab an evaluation copy of Windows 8.1 or Windows 10 from the [TechNet Evaluation Center](http://www.microsoft.com/en-us/evalcenter/).

## Creating a VM From Hyper-V Manager
These steps will walk through manually creating a virtual machine and deploying an operating system to this VM.

1. In Hyper-V Manager click **Action** > **New** > **Virtual Machine**.

2. Review the ‘Before You Begin’ content and click '**Next**'. 

3. Give the Virtual Machine a name. Note, this will be the name of the Virtual Machine and not the computer name given to the system once the operating system has been deployed.

4. Chose a location where the VM files will be stored such as **c:\virtualmachine**. You can also accept the default location. Click **Next** when done.
	
  ![](media/new_vm_upd.png)

5. Select a generation for the machine and click ‘**Next**’.  

  Generation 2 virtual machines were introduced with Windows Server 2012 R2 and provide a simplified virtual hardware model and some additional functionality. Generation 2 virtual machines do require a 64bit operation system. For more information on Generation 2 virtual machines see the [Generation 2 Virtual Machine Overview](https://technet.microsoft.com/en-us/library/dn282285.aspx).

6. Select **2048** for the Startup memory value and leave ‘**Use Dynamic Memory**,’ selected. Click the '**Next**' button.  

  Memory is shared between a Hyper-V host and the VM running on the host. The number of VM’s that can run on a single host is in part dependent on available memory. A virtual machine can also be configured to use Dynamic Memory. When enabled, dynamic memory will reclaim unused memory from the running virtual machine. This will allow more virtual machines to run on the host. For more information on Dynamic Memory see the [Hyper-V Dynamic Memory Overview](https://technet.microsoft.com/en-us/library/hh831766.aspx).

7. On the Configure Networking wizard, select the desired virtual switch for the virtual machine and click '**Next**'. Virtual switches have been covered in this guide in the following document [Create a Virtual Switch](walkthrough_virtual_switch.md).

8. Give the virtual hard drive a name, select a location or keep the default, and finally specify a size. Click '**Next**' when ready.

  A virtual hard drive provides storage for a VM similar to a physical hard drive. A virtual hard drive will be required so that you can install an operating system on the VM.
  
  ![](media/new_vhd_upd.png)  

9. On the Installation Options wizard, select ‘**Install an operating system from a bootable image file**' and then select an operating system .iso file. Click '**Next**' once completed.

  When creating a virtual machine, you can configure some operating system installation options. The three options available are:

  - **Install an operating system later** – this option will make no additional modification to the virtual machine.

  - **Install an operating system from a bootable image file** – this analogous to inserting a cd into the physical CD Rom drive of a physical computer. When configuring this option, you will select a .iso image and this image will be mounted to the virtual CD Rom drive of the virtual machine. The boot order of the VM will also be modified to boot first form the CD Rom drive.

  - **Install an operating system from a network-based installation server** – This option will not be available unless you have also connected the virtual machine to a network switch. In this configuration the virtual machine will attempt to boot from the network.
  
10. Review the VM details and click ‘**Finish**’ to complete the VM creation.

## Create VM with PowerShell

1. Open up the PowerShell ISE as Administrator.

2. Run the following script:

  ```powershell
$VMName = "TESTVM23"
New-VM -Name $VMName -MemoryStartupBytes 2147483648 -Generation 2 -NewVHDPath "D:\Virtual Machines\$VMName\$VMName.vhdx" -NewVHDSizeBytes 53687091200 -Path "D:\Virtual Machines\$VMName" -SwitchName 'External VM Switch'
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path 'C:\Users\Administrator\Desktop\en_windows_10_enterprise_x64_dvd_6851151.iso'
$DVDDrive = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive
  ```
  
## Complete the Operating System Installation

In order to finish building your virtual machine, you need to start the VM and walk through the operating system installation.

1. In Hyper-V Manager, double-click on the virtual machine. This will launch the VMConnect tool.

2. In VMConnect, click on the green Start button. This is like hitting the power button on a physical computer. You may be prompted to ‘Press any key to boot from CD or DVD’, go ahead and do so.

3. The VM will boot into setup and you can walk through the installation like you would on a physical computer.

  ![](media/OSDeploy_upd.png) 

> Note: Unless you're running a volume licensed version of Windows 10, you will need a seperate license for Windows running inside a virtual machine. The virtual machine's operating system is independent of the host operating system.

## Next Step - Virtual Machine Checkpoints
[Virtual Machine Checkpoints](walkthrough_checkpoints.md)