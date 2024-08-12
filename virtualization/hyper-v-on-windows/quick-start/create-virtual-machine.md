---
title: Create a virtual machine with Hyper-V on Windows 11
description: Create a Virtual Machine with Hyper-V and install an operating system on Windows 11.
keywords: windows 10, windows 11, hyper-v
author: scooley
ms.author: scooley
ms.date: 07/29/2024
ms.topic: article
ms.assetid: 66723f33-b12c-49d1-82cf-71ba9d6087e9
---

# Create a virtual machine with Hyper-V on Windows

Learn how to create a virtual machine and install an operating system in your new virtual machine. You'll need an **.iso** file for the operating system that you would like to run. If needed, grab an evaluation copy of Windows 11 from the [TechNet Evaluation Center](https://www.microsoft.com/evalcenter/).

## Create a virtual machine with Hyper-V Manager

1. Open Hyper-V Manager by either pressing the Window's key and typing "Hyper-V Manager" or by finding **Hyper-V Manager** in your applications.

1. In Hyper-V Manager, select **Action** > **New** > **Virtual Machine** to bring up the New Virtual Machine Wizard.

   ![Screenshot of the New Virtual Machine Wizard's Specify Name and Location tab with a focus on the Next option.](media/new-virtual-machine-wizard.png)

1. Review the ‘Before You Begin’ content and select **Next**.

1. Give the virtual machine a name.
   > **Note:** This is the name Hyper-V uses for the virtual machine, not the computer name given to the guest operating system that will be deployed inside the virtual machine.

1. Choose a location where the virtual machine files will be stored such as **c:\virtualmachine**. You can also accept the default location. Select **Next** when done.

1. Select a generation for the machine and select **Next**.  

   Generation 2 virtual machines were introduced with Windows Server 2012 R2 and provide a simplified virtual hardware model and some additional functionality. You can only install a 64-bit operating system on a Generation 2 virtual machine. For more information, see [Should I create a generation 1 or 2 virtual machine in Hyper-V?](/windows-server/virtualization/hyper-v/plan/Should-I-create-a-generation-1-or-2-virtual-machine-in-Hyper-V).
  
   > If the new virtual machine is configured as Generation 2 and will be running a Linux distribution, secure boot will need to be disabled. For more information on secure boot, see [Secure Boot](/previous-versions/windows/it-pro/windows-8.1-and-8/dn486875(v=ws.11)).
1. Select **2048** MB for the **Startup Memory** value and leave **Use Dynamic Memory** selected. Select the **Next** button.

   Memory is shared between a Hyper-V host and the virtual machine running on the host. The number of virtual machines that can run on a single host is in part dependent on available memory. A virtual machine can also be configured to use Dynamic Memory. When enabled, dynamic memory reclaims unused memory from the running virtual machine. This allows more virtual machines to run on the host. For more information on Dynamic Memory, see the [Hyper-V Dynamic Memory Overview](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831766(v=ws.11)).

1. On the Configure Networking wizard, select a virtual switch for the virtual machine and select **Next**. For more information, see [Create a Virtual Switch](connect-to-network.md).

1. Give the virtual hard drive a name, select a location or keep the default, and finally specify a size. Select **Next** when ready.

   A virtual hard drive provides storage for a virtual machine similar to a physical hard drive. A virtual hard drive is required so that you can install an operating system on the virtual machine.
  
   ![Screenshot of the New Virtual Machine Wizard's Connect Virtual Hard Disk task, with the Create a virtual hard disk option being selected.](media/connect-virtual-hard-disk.png)

1. On the Installation Options wizard, select **Install an operating system from a bootable image file** and then select an operating system .iso file. Select **Next** once completed.

   When creating a virtual machine, you can configure some operating system installation options. The three options available are:

   * **Install an operating system later** – this option makes no additional modification to the virtual machine.

   * **Install an operating system from a bootable image file** – this is similar to inserting a CD into the physical CD-ROM drive of a physical computer. To configure this option, select a .iso image. This image will be mounted to the virtual CD-ROM drive of the virtual machine. The boot order of the virtual machine is changed to boot first from the CD-ROM drive.

   * **Install an operating system from a network-based installation server** – This option is not available unless you have connected the virtual machine to a network switch. In this configuration, the virtual machine attempts to boot from the network.

1. Review the virtual machine details and select **Finish** to complete the virtual machine creation.

## Create a virtual machine with PowerShell

1. Open up PowerShell ISE as Administrator.

1. Run the following script.

  ``` powershell
  # Set VM Name, Switch Name, and Installation Media Path.
  $VMName = 'TESTVM'
  $Switch = 'External VM Switch'
  $InstallMedia = 'C:\Users\Administrator\Desktop\en_windows_10_enterprise_x64_dvd_6851151.iso'

  # Create New Virtual Machine
  New-VM -Name $VMName -MemoryStartupBytes 2147483648 -Generation 2 -NewVHDPath "D:\Virtual Machines\$VMName\$VMName.vhdx" -NewVHDSizeBytes 53687091200 -Path "D:\Virtual Machines\$VMName" -SwitchName $Switch

  # Add DVD Drive to Virtual Machine
  Add-VMScsiController -VMName $VMName
  Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

  # Mount Installation Media
  $DVDDrive = Get-VMDvdDrive -VMName $VMName

  # Configure Virtual Machine to Boot from DVD
  Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive
  ```

## Complete the operating system deployment

In order to finish building your virtual machine, you need to start the virtual machine and walk through the operating system installation.

1. In Hyper-V Manager, double-click on the virtual machine. This launches the Virtual Machine Connection tool.

1. Select **Start** button. Wait for the Hyper-V machine to boot This is like pressing the power button on a physical computer.

1. The virtual machine boots into setup and you can walk through the installation like you would on a physical computer.

  ![Screenshot of a Virtual Machine Connection window, showing the virtual machine's Windows Setup installation screen.](media/virtual-machine-setup.png)

  > **Note:** Unless you're running a volume-licensed version of Windows, you need a separate license for Windows running inside a virtual machine. The virtual machine's operating system is independent of the host operating system.
