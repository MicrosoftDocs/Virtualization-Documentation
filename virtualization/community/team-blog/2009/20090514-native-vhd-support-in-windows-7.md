---
layout:     post
title:      "Native VHD Support in Windows 7"
date:       2009-05-14 01:00:00
categories: hyper-v
---
_This blog entry describes the support in Windows 7 and Windows Server 2008 R2 for creating and managing Virtual Hard Disk (VHD) files as a native format, and booting a physical machine from a  VHD file.  Native VHD support helps our enterprise customers and developer community use a common image format and common tools to manage and deploy Windows images that run either in Hyper-V virtual machines or on physical machines._

The Microsoft Virtual Hard Disk file format (VHD) is a publicly available format specification that specifies a virtual hard disk encapsulated in a single file, capable of hosting native file systems and supporting standard disk operations. VHD files are used by Microsoft Windows Server 2008 Hyper-V, Microsoft Virtual Server and Microsoft Virtual PC for virtual disks connected to a virtual machine.   VHDs are useful containers and the VHD file format is also used by Microsoft Data Protection Manager, Windows Server Backup as well as many other Microsoft and Non-Microsoft solutions.  To create a VHD on Windows Server 2008, you install the Hyper-V Server role and use the Hyper-V Manager to create a VHD file, and then install a version of Windows onto a partition in the VHD. 

Many of our data center customers are transitioning to Hyper-V virtual machines (VMs) for server consolidation and lower energy costs.  While moving an increasing number of applications to virtual machines, they still operate a significant part of the data center on physical machines. Managing the system images that are deployed to physical and virtual machines can be challenging.  IT administrators have to maintain two sets of images: one set based on the WIM format for physical machines, another set based on the VHD format for virtual machines.  What IT administrators need is a common format and toolset to make image management simpler and reduce the number of images to catalog and maintain.

Developers and testers are using virtual machines to test new system and application software.   Virtual machines provide a convenient, isolated test environment and reduce the need for dedicated test hardware.  But sometimes you need to run tests on a physical machine to access a specific hardware device, like the graphics card, or to get accurate performance profiling.   A common image format that runs on both virtual and physical machines also benefits developers and testers. 

In this blog entry we are going to look at the goals for supporting VHDs as a native format, how the core operating system supports VHDs, and the key scenarios targeted for native VHD deployment.

**Goals for Native Support for VHDs in Windows Server 2008 R2 and Windows 7**

  1. Simplify the experience of creating, managing, and deploying Windows images across both physical and virtual machines using a single image format and common tools.   

  2. Enable systems to have multiple instances of Windows installed without using separate disk partitions for more flexibility to change server application workloads as needed.   

  3. Enable efficient development and testing for software that requires an isolated test environment using a common image that runs on either a physical or virtual machine.



**Creating and managing VHDs**

Windows 7 simplifies image management by adding support for virtual disks in the disk management tools.  You no longer need to install the Hyper-V Server role and use the Hyper-V Manager console to create VHDs.  The Disk Management console has an action to create a new VHD file, for either a fixed size or dynamically expanding VHD, which is uninitialized.  After creating the VHD file, the Attach VHD action makes the virtual disk available to the system as if you plugged in a hard disk drive. 

[![vhd1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd1_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd1_2.jpg)

Figure 1. Creating a VHD using the Disk Management console 

After attaching a new virtual disk, you create a partition and format an NTFS volume in the VHD just like a physical disk.  The VHD is ready for a Windows image to be applied to the volume and initialized for boot. 

Server administrators often prefer command line tools, and you can do the same VHD operations using the diskpart command.  Diskpart also accepts a script to automate the steps to create and format a VHD. When a VHD containing a file system volume is attached, Windows automatically recognizes the volume and provides an option to explore the contents. 

[![vhd2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd2_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd2_2.jpg)

Figure 2.  Using the Diskpart command to create a VHD 

**Core Storage System Support  
  
** Access to VHD file contents is provided by a completely new mini-port driver in the storage stack for VHD files.  The VHD driver is what enables I/O requests to files in the VHD to be sent down to the host NTFS file system on the physical partition where the VHD file is located.  VHD operations can also be performed on a remote share. 

With Windows Server 2008 R2, Hyper-V now uses the new native support for VHDs in the core operating system.  We have done extensive testing on a wide range of I/O test scenarios and the native VHD support is incredibly efficient.   Read and write performance for different I/O block sizes, for both sequential and random I/O is comparable with physical disk performance.  The following graphs show some of the preliminary results from performance tests comparing throughput to Fixed and Dynamic VHD files in Windows Server 2008 R2 Beta with Windows Server 2008 Hyper-V.   The “Bare Metal” columns show the maximum I/O throughput to the physical disk device without using a VHD file.   Lower write throughput to dynamic VHDs is due to multiple I/Os required to expand the file as new blocks are written to the virtual disk. 

[![vhd4](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd4_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd4_2.jpg)

 

[![vhd5](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd5_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd5_2.jpg)

Operating system support for VHD as a native format provides opportunities for management ISVs to bring added value to their customers without introducing complexity with new image formats.  There are new [Win32 APIs](http://msdn.microsoft.com/en-us/library/dd323684\(VS.85\).aspx) for VHD operations that enable image management tools to support the VHD file format in their management framework. 

**Native VHD Boot**   
  
Native VHD boot enables the seamless transition to virtualization using a single image format that boots on both physical and virtual machines.  Native VHD boot means that the Windows image in a VHD file can boot on a physical machine without starting a Hyper-V virtual machine. VHD image files make it easy for a single physical machine to have multiple instances of the operating system available to boot at any time.   Multiple boot support has been available in Windows for many releases, but required a separate disk partition for each installed operating system.  Native VHD boot supports all three types of VHD files: fixed, dynamic, and differencing disks.  

Developers and testers can use native VHD boot to run test versions of new device drivers or other software for Windows with full access to the hardware devices connected to the system.  A differencing VHD file provides a convenient way of initializing a test environment, performing tests and reverting back to a clean or baseline state after testing is complete.  Executing tests will result in updates being made only to the differencing disk. Once the testing is complete you can revert back to the clean state in the parent VHD by simply throwing away the differencing file and creating a new one. 

Native VHD boot enables IT Administrators to quickly repurpose a machine for different roles.  Servers can have multiple application workloads in separate VHD files available and switch between workloads to adjust to demand.   The flexibility of multiple boot using VHD files also makes it easy to keep a previous Windows image available to use as a fall-back in the event of a problem with a new image. 

Native VHD boot depends on enhancements to the Boot Configuration Data (BCD) to represent the VHD file as a boot device rather than a physical disk partition.  The following image shows an example of a multiple boot configuration with a VHD boot entry.

[![vhd6](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd6_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NativeVHDSupportinWindows7_E936/vhd6_2.jpg)

Figure 3. Multiple boot configuration with VHD boot entry 

The Windows 7 boot manager and loader can now read the files required to start the operating system from the Windows image inside a VHD file.  When Windows boots from a VHD file, all the ‘disk I/O’ to load the kernel device drivers, start system services, and run applications is translated to I/O to the VHD file initially, and then to I/O to the NTFS volume and the physical disk.    On shutdown, all outstanding write operations flush to the VHD file and underlying physical partition in the proper order before the storage stack shuts down the disk device.  Because of these enhancements to core parts of the system, native VHD boot only works for VHDs containing Windows 7 or Windows Server 2008 R2 and not earlier versions of Windows.  Native VHD boot in this release does not support BitLocker, or hibernation (which includes resuming from hibernate).

**Deploying Images**

To put a Windows 7 or Windows Server 2008 R2 operating system image in the VHD file, you have to _apply_ an image to the partition in the VHD file. Running Setup from the install DVD and selecting a partition in a VHD file for installation is **_not_** supported. Here are two ways you can apply a  WIM image to a VHD: 

  1. Use the [Install-WindowsImage](http://code.msdn.microsoft.com/InstallWindowsImage) Powershell script from the MSDN Code Gallery.  

  2. Or use the Imagex deployment tool from the Windows Automated Installation Kit (WAIK).



The Install-WindowsImage Powershell script uses the wimgapi.dll in Windows 7 to apply a WIM to a VHD. Use the script if you are not familiar with the WAIK and Imagex.exe tool, or do not have the WAIK available.

See the document _[Using Install-WindowsImage](http://code.msdn.microsoft.com/InstallWindowsImage/Release/ProjectReleases.aspx?ReleaseId=2662)_ , on the Install-WindowsImage site for step-by-step instructions on how to create a VHD and apply a WIM image for VHD boot.

IT professionals will be interested in using the WAIK deployment tools to customize and capture a reference Windows image and deploy the image in VHD format to either physical or virtual machines. The [basic deployment steps](http://technet.microsoft.com/en-us/library/dd349348.aspx) for the IT Administrator to prepare a custom Windows image includes the following:

  * Install Windows to a partition on a physical machine first as a reference.
  * Customize the reference image settings and installing the applications you want.
  * Run the sysprep command on the reference system to _generalize_ the image, which resets some of the system state and device configuration in Windows specific to that machine and shuts down.
  * Capture the reference image from the physical partition into a Windows image file that you copy to a server share.
  * Apply the Windows image to a VHD file and initialize the VHD boot environment.



The VHD file with a generalized image can be copied to and used on multiple physical or virtual machines. A generalized image is required to avoid system startup issues because the hardware on the new system is different, and to avoid having multiple copies of Windows with the same machine identity (name and security identities), on the network. During the first boot of Windows from the VHD file on a different physical or virtual machine, Windows will _specialize_ the image for the new machine, configure devices, and prepare for first use. Copying the reference VHD file is quick way to get a new Windows 7 or Windows Server 2008 R2 image to a machine for development, testing, or staging for servers.

If you want to deploy Windows images to many machines, you can leverage the Windows Deployment Service (WDS) feature of Windows Server 2008 R2. WDS is enhanced with the ability to add VHD image files to the WDS image catalog. The WDS administrator creates image groups for VHD files that are ready to deploy to machines that use network boot, or “PXE boot”. When WDS deploys a VHD image, the client agent copies the VHD file locally and configures the boot environment to boot from the VHD. All the applications and system settings are configured in the master reference image in the VHD file. When Windows boots from the VHD file for the first time, the system is specialized as mentioned above, for the physical devices on the target machine and then is ready for use. That’s pretty convenient and goes a long way toward rapid deployment.

While native VHD format support and specifically native VHD boot opens up a lot of usage scenarios, our goals with this technology are fairly specific: simplify image management for enterprise customers migrating server workloads to virtual machines, and enable efficient development and testing of software in an isolated environment on either physical or virtual machines. The support for VHD as a native format targets key scenarios in the enterprise where the IT staff is well versed with different imaging technologies and tools to manage their client and servers. A managed enterprise environment also employs technologies like folder redirection and roaming profiles to manage the user’s data outside the deployed VHD images.  Developers will appreciate the ability to quickly update or replace a private VHD image during development. Test environments can use multiple VHD images and differencing disks for more efficient use of test machines.

Hopefully this blog posting gives you an idea of how Windows 7 and Windows Server 2008 R2 supports VHD files as a native format and why the common image format for physical and virtual machines will be interesting for many customer environments.

_Mike Kolitz  
Software Design Engineer in Test  
_ _Hyper-V Test Tools and Infrastructure_

**Update** : A few people have asked me whether this information applies to Microsoft Hyper-V Server 2008 R2 as well.  Yes, it does.
