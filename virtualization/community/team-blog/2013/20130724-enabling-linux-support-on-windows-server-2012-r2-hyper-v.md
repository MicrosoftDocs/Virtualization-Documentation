---
title:      "Enabling Linux Support on Windows Server 2012 R2 Hyper-V"
author: mattbriggs
ms.author: mabrigg
description: Enabling Linux Support on Windows Server 2012 R2 Hyper-V
ms.date: 07/24/2013
date:       2013-07-24 08:30:00
categories: uncategorized
---
# Enabling Linux Support on Windows Server 2012 R2 Hyper-V

_This post is a part of the nine-part “_ _What ’s New in Windows Server & System Center 2012 R2_ _” series that is featured on Brad Anderson ’s _[**_In the Cloud_**](https://blogs.technet.com/b/in_the_cloud/) _blog.   Today’s blog post covers Linux Support on Windows Server 2012 R2 and how it applies to Brad’s larger topic of “Transform the Datacenter”.  To read that post and see the other technologies discussed, read today’s post:  “_[ _What ’s New in 2012 R2:  Enabling Open Source Software_](https://blogs.technet.com/b/in_the_cloud/archive/2013/07/24/what-s-new-in-2012-r2-enabling-open-source-software.aspx) _. ”  _

The ability to provision Linux on Hyper-V and Windows Azure is one of Microsoft’s core efforts towards enabling great Open Source Software support. As part of this initiative, the Microsoft Linux Integration Services (LIS) team pursues ongoing development of enlightened Linux drivers that are directly checked in to the Linux upstream kernel thereby allowing direct integration into upcoming releases of major distributions such as CentOS, Debian, Red Hat, SUSE and Ubuntu.

The Integration Services were originally shipped as a download from Microsoft’s sites. Linux users could download and install these drivers and contact Microsoft for any requisite support. As the drivers have matured, they are now delivered directly through the Linux distributions. Not only does this approach avoid the extra step of downloading drivers from Microsoft’s site but it also allows users to leverage their existing support contracts with Linux vendors. 

For example Red Hat has certified enlightened drivers for Hyper-V on Red Hat Enterprise Linux (RHEL) 5.9 and certification of RHEL 6.4 should be complete by summer 2013. This will allow customers to directly obtain Red Hat support for any issues encountered while running RHEL 5.9/6.4 on Hyper-V.

To further the goal of providing great functionality and performance for Linux running on Microsoft infrastructure, the following new features are now available on Windows Server 2012 R2 based virtualization platforms:

 

  1. Linux Synthetic Frame Buffer driver – Provides enhanced graphics performance and superior resolution for Linux desktop users. 
  2. Linux Dynamic memory support – Provides higher virtual machine density/host for Linux hosters.
  3. Live Virtual Machine Backup support – Provisions uninterrupted backup support for live Linux virtual machines.
  4. Dynamic expansion of fixed size Linux VHDs – Allows expansion of live mounted fixed sized Linux VHDs.
  5. Kdump/kexec support for Linux virtual machines – Allow creating kernel dumps of Linux virtual machines.
  6. NMI (Non-Maskable Interrupt) support for Linux virtual machines – Allows delivery of manually triggered interrupts to Linux virtual machines running on Hyper-V.
  7. Specification of Memory Mapped I/O (MMIO) gap – Provides fine grained control over available RAM for virtual appliance manufacturers.



All of features have been integrated in to SUSE Linux Enterprise Server 11 SP3 which can be downloaded from [SUSE website](https://www.suse.com/products/server/). In addition integration work is in progress for the upcoming Ubuntu 13.10 and RHEL 6.5 releases.

 Further details on these new features and their benefits are provided in the following sections:

  **1.        ****Synthetic Frame Buffer Driver**

** ** The new synthetic 2D frame buffer driver provides solid improvements in graphics performance for Linux virtual machines running on Hyper-V. Furthermore, the driver provides full HD mode resolution (1920x1080) capabilities for Linux guests hosted in desktop mode on Hyper-V.

 One other noticeable impact of the Synthetic Frame Buffer Driver is elimination of the double cursor problem.  While using desktop mode on older Linux distributions several customers reported two visible mouse pointers that appeared to chase each other on screen. This distracting issue is now resolved through the synthetic 2D frame buffer driver thereby improving visual experience on Linux desktop users.

** ** **2.        ****Dynamic Memory Support**

 The availability of dynamic memory for Linux guests provides higher virtual machine density per host. This will bring huge value to Linux administrators looking to consolidate their server workloads using Hyper-V. In house test results indicate a 30-40% increase in server capacity when running Linux machines configured with dynamic memory.

 The Linux dynamic memory driver monitors the memory usage within a Linux virtual machine and reports it back to Hyper-V on a periodic basis. Based on the usage reports Hyper-V dynamically orchestrates memory allocation and deallocation across various virtual machines being hosted. Note that the user interface for configuring dynamic memory is the same for both Linux and Windows virtual machines.

 

The dynamic Memory driver for Linux virtual machines provides both Hot-Add and Ballooning support and can be configured using the Start, Minimum RAM and Maximum RAM parameters as shown in Figure 1. 

Upon system start the Linux virtual machine is booted up with the amount of memory specified in the Start parameter. 

If the virtual machine requires more memory then Hyper-V uses the Hot-Add mechanism to dynamically increase the amount of memory available to the virtual machine. 

On the other hand, if the virtual machine requires less memory than allocated then Hyper-V uses the ballooning mechanism to reduce the memory available to the virtual machine to a more appropriate amount.


<!-- [![Configuring a Linux virtual machine with Dynamic Memory](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2260.SettingsForOSTC.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2260.SettingsForOSTC.png) 

_**Figure** **1** **Configuring a Linux virtual machine with Dynamic Memory**_  -->

  
 Increase in virtual machine density is an obvious advantage of use of dynamic memory. Another great application is the use of dynamic memory in scaling application workloads. The following paragraphs illustrate an example of a web server that was able to leverage dynamic memory to scale operations in the event of increasing client workload.

 For illustrative purposes, two apache servers hosted inside separate Linux virtual machines were set up on a Hyper-V server. One of the Linux virtual machines was configured with a static RAM of 786 MB whereas the other Linux virtual machine was configured with dynamic memory. The dynamic memory parameters were setup as follows: Startup RAM was set to 786MB, Maximum RAM was set to 8GB and the Minimum RAM was set to 500MB. Next both apache server were subjected to monotonically increasing web server workload through a client application hosted in a Windows virtual machine.

 Under the static memory configuration, as the apache server becomes overloaded, the number of transactions/second that could be performed by the server continue to fall due to high memory demand. This can be observed in Figure 2 and Figure 3. Figure 2 represents the initial warm up period when there is ample free memory available to the Linux virtual machine hosting apache. During this period the number of transactions/second is as high as 103 with an average latency/transaction of 58ms. 

<!-- [![number of transactions](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6116.10.200.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6116.10.200.png) -->

<!-- [![Server and Client statistics during initial warm up period for the Linux apache server configured with static RAM](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2313.WindowsPowershell.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2313.WindowsPowershell.png) -->

  _ **Figure** **2** **Server and Client statistics during initial warm up period for the Linux apache server configured with static RAM**_

 As the workload increases and the amount of free memory becomes scarce, the number of transactions/second drops to 32 and the average latency/transaction increases to 485ms. This situation can be observed in Figure 3.

<!--[![As the workload increases and the amount of free memory becomes scarce, the number of transactions/second drops to 32 and the average latency/transaction increases to 485ms.](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6433.10.200.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6433.10.200.png)-->

<!-- [![Server and client statistics for an overloaded Linux apache server configured with static RAM](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2845.WindowsPowershell.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2845.WindowsPowershell.png) -->

  _ **Figure** **3** **Server and client statistics for an overloaded Linux apache server configured with static RAM**_

 Next consider the case of the apache server hosted in a Linux virtual machine configured with dynamic memory. Figure 4 shows that for this server the amount of available memory quickly ramps up through Hyper-V’s hot-add mechanism to over 2GB and the number of transactions/second is 120 with an average latency/transaction of 182 ms during the warm up phase itself.

<!--[![Server and client statistics during startup phase of Linux apache server configured with Dynamic RAM](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3731.10.200.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3731.10.200.png)[![Figure 4 part 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5381.WindowsPowershell.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5381.WindowsPowershell.png) -->

_**Figure** **4** **Server and client statistics during startup phase of Linux apache server configured with Dynamic RAM**_

 As the workload continues to increase, over 3GB of free memory becomes available and therefore the server is able to sustain the number of transactions/second at 130 even though average latency/transaction increases to 370ms. Notice that this memory gain can only be achieved if there is enough memory available on the Hyper-V server host. If the Hyper-V host memory is low then any demand for more memory by a guest virtual machine may not be satisfied and applications may receive no free memory errors.

<!-- [![Overloaded Linux apache server configured with Dynamic RAM](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8422.10.200.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8422.10.200.png)[![Figure 5 part 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1031.WindowsPowershell.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1031.WindowsPowershell.png)-->

_**Figure** **5** **Overloaded Linux apache server configured with Dynamic RAM**_

**3.        ****Live Virtual Machine Backup Support**

A much requested feature from customers running Linux on Hyper-V is the ability to create seamless backups of live Linux virtual machines. In the past customers had to either suspend or shutdown the Linux virtual machine for creating backups. Not only is this process hard to automate but it also leads to an increase in down time for critical workloads.

To address this shortcoming, a file-system snapshot driver is now available for Linux guests running on Hyper-V. Standard backup APIs available on Hyper-V can be used to trigger the driver to create file-system consistent snapshots of VHDs attached to a Linux virtual machine without disrupting any operations in execution within the virtual machine. 

The best way to try out this feature is to take a backup of a running Linux virtual machine through Windows Backup. The backup can be triggered from the Windows Server Backup UI as shown in Figure 6. As can be observed the live virtual machine labeled OSTC-Workshop-WWW2 is going to be backed up. Once the backup operation completes a message screen similar to Figure 7 should be visible.

 

<!-- [![Using Windows Server Backup to backup a live Linux virtual machine](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0574.Backup%20Wizard%201.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0574.Backup%20Wizard%201.png)  _ **Figure** **6** **Using Windows Server Backup to backup a live Linux virtual machine**_ -->

 <!-- [![More of using Windows Server Backup to backup a live Linux virtual machine](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5127.Backup%20Wizard%202.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5127.Backup%20Wizard%202.png) _ **Figure** **7** **Completion of backup operation for a live Linux virtual machine**_ --> 
  

  
One important difference between the backups of Linux virtual machines and Windows virtual machines is that Linux backups are file-system consistent only whereas Windows backups are file-system and application consistent. This difference is due to lack of standardized Volume Shadow Copy Service (VSS) infrastructure in Linux.

**4.        ****Dynamic Expansion of Live Fixed Sized VHDs**

The ability to dynamically resize a fixed sized VHD allows administrators to allocate more storage to the VHD while keeping the performance benefits of the fixed size format. The feature is now available for Linux virtual machines running on Hyper-V. It is worth noting that Linux file-systems are quite adaptable to dynamic changes in size of the underlying disk drive. To illustrate this functionality let us look at how a fixed sized VHD attached to a Linux virtual machine can be resized while it is mounted.

First, as shown in Figure 8, a 1GB fixed sized VHD is attached to a Linux virtual machine through the SCSI controller. The amount of space available on the VHD can be observed through the **df** command as shown in Figure 9.

<!-- [![Fixed Sized VHD attached to a Linux virtual machine through the SCSI Controller](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5850.figure%208.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5850.figure%208.png) -->

_**Figure** **8** **Fixed Sized VHD attached to a Linux virtual machine through the SCSI Controller**_

<!--[![Space usage in the Fixed Sized VHD](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6406.figure%209.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6406.figure%209.png) --> 

_**Figure** **9** **Space usage in the Fixed Sized VHD**_

Next, a workload is started to consume more space on the fixed sized VHD. While the workload is running, when the amount of used space goes beyond the 50% mark (Figure 10), the administrator may increase the size of the VHD to 2GB using the Hyper-V manager UI as shown in Figure 11.

<!-- [![Amount of used space goes beyond 50% of the current size of the Fixed Sized VHD](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6136.figure%2010.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6136.figure%2010.png) -->

_**Figure** **10** **Amount of used space goes beyond 50% of the current size of the Fixed Sized VHD**_

<!--![Expanding a Fixed Size VHD from 1GB to 2GB](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0334.figure%2011.1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0334.figure%2011.1.png) |  [![Figure 11 part 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8030.figure%2011.2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8030.figure%2011.2.png)  -->
 
  
_**Figure** **11** **Expanding a Fixed Size VHD from 1GB to 2GB**_  
  
Once the VHD is expanded, the **df** command will automatically update the amount of disk space to 2GB as shown in Figure 12. It is important to note that both the disk and the file-system adapted to the increase in size of the VHD while it was mounted and serving a running workload.

 <!-- [![Dynamically adjusted df statistics upon increase in size of Fixed Sized VHD](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0045.figure%2012.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0045.figure%2012.png) -->

_**Figure** **12** **Dynamically adjusted df statistics upon increase in size of Fixed Sized VHD**_

**5.        ****Linux kdump/kexec support**

One particular pain point for hosters running Linux on Windows Server 2012 and Windows Server 2008 R2 environments is that legacy drivers (as mentioned in [KB 2858695](https://support.microsoft.com/kb/2858695) ) must be used to create kernel dumps for Linux virtual machines. 

In Windows Server 2012 R2, the Hyper-V infrastructure has been changed to allow seamless creation of crash dumps using enlightened storage and network drivers and therefore no special configurations are required anymore. Linux users are free to dump core over the network or the attached storage devices.

**6.        ****NMI Support**

If a Linux system becomes completely unresponsive while running on Hyper-V, users now have the option to panic the system by using Non-Maskable Interrupts (NMI). This is particularly useful for diagnosing systems that have deadlocked due to kernel or user mode components.

The following paragraphs illustrate how to test this functionality. As a first step observe if any NMIs are pending in your Linux virtual machines by executing the command in a Linux terminal session shown in Figure 13:

<!-- [![Existing NMIs issued to the Linux virtual machine](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/4265.figure%2013.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/4265.figure%2013.png) -->

_**Figure** **13** **Existing NMIs issued to the Linux virtual machine**_

Next, issue an NMI from a powershell window using the command shown below:

Debug-VM -Name \<Virtual Machine Name\> -InjectNonMaskableInterrupt -ComputerName \<Hyper-V host name\> Confirm:$False –Force

Next check if the NMI has been delivered to the Linux VM by repeating the command shown in Figure 13. The output should be similar to what is shown in Figure 14 below:

 <!-- [![New NMIs issued to the Linux virtual machine](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5008.figure%2014.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5008.figure%2014.png) -->

_**Figure** **14** **New NMIs issued to the Linux virtual machine**_

**7.        ****Specification of Memory Mapped I/O (MMIO) gap**

Linux based appliance manufacturers use the MMIO gap (also known as PCI hole) to divide the available physical memory between the Just Enough Operating System (JeOS) that boots up the appliance and the actual software infrastructure that powers the appliance. Inability to configure the MMIO gap causes the JeOS to consume all of the available memory leaving nothing for the appliance’s custom software infrastructure. This shortcoming inhibits the development of Hyper-V based virtual appliances.

The Windows Server 2012 R2 Hyper-V infrastructure allows appliance manufacturers to configure the location of the MMIO gap. Availability of this feature facilitates the provisioning of Hyper-V powered virtual appliances in hosted environments. The following paragraphs provide technical details on this feature.

The memory of a virtual machine running on Hyper-V is fragmented to accommodate two MMIO gaps.  The lower gap is located directly below the 4GB address.  The upper gap is located directly below the 128GB address.  Appliance manufacturers can now set the lower gap size to a value between 128MB and 3.5GB. This indirectly allows specification of the start address of the MMIO gap. 

The location of the MMIO gap can be set using the following sample PowerShell script functions:

############################################################################  
  
## GetVmSettingData()  
  
## Getting all VM's system settings data from the host hyper-v server  
  
############################################################################

function GetVmSettingData([String] $name, [String] $server)  
{  
    $settingData = $null

    if (-not $name)  
    {  
            return $null  
    }

    $vssd = gwmi -n root\virtualization\v2 -class Msvm_VirtualSystemSettingData -ComputerName $server  
     if (-not $vssd)  
    {  
        return $null  
    }

    foreach ($vm in $vssd)  
    {  
        if ($vm.ElementName -ne $name)  
        {  
            continue  
        }

        return $vm  
    }

    return $null  
}

###########################################################################  
 
## SetMMIOGap()  
  
## Description:Function to validate and set the MMIO Gap to the linux VM  
  
###########################################################################  
function SetMMIOGap([INT] $newGapSize)  
{

    #  
    # Getting the VM settings  
    #  
    $vssd = GetVmSettingData $vmName $hvServer  
    if (-not $vssd)  
    {  
        return $false  
    }

    #  
    # Create a management object  
    #  
    $mgmt = gwmi -n root\virtualization\v2 -class Msvm_VirtualSystemManagementService -ComputerName $hvServer  
    if(-not $mgmt)  
    {  
        return $false  
    }

    #  
    # Setting the new MMIO gap size  
    #  
    $vssd.LowMmioGapSize = $newGapSize

    $sts = $mgmt.ModifySystemSettings($vssd.gettext(1))

       if ($sts.ReturnValue -eq 0)  
    {  
        return $true  
    }

    return $false  
}

The location of the MMIO gap can be verified by searching the keyword “pci_bus” in the post boot dmesg log of the Linux virtual machine. This output containing the keyword should provide the start memory address of the MMIO gap. The size of the MMIO gap can then be verified by subtracting the start address from 4GB represented in hexadecimal.

**Summary**

Over the past year, the LIS team added a slew of features to enable great support for Linux virtual machines running on Hyper-V. These features will not only simplify the process of hosting Linux on Hyper-V but will also provide superior consolidation and improved performance for Linux workloads. As of now the team is actively working with various Linux vendors to bring these features in newer distribution releases. The team is eager to hear customer feedback and invites any feature proposals that will help improve Linux hosters experience on Hyper-V. Customers may get in touch with the team through [linuxic@microsoft.com](mailto:linuxic@microsoft.com) or thorough the Linux Kernel Mailing List([here](https://lkml.org/)).

_To see all of the posts in this series, check out the_ _What ’s New in Windows Server & System Center 2012 R2_ _archive_
