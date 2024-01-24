---
title:      "Linux Integration Services 3.5 Announcement"
author: sethmanheim
ms.author: sethm
ms.date: 01/02/2014
categories: uncategorized
description: This article covers the new features and information about the Linux Integration Services version 3.5.
---
# Linux Integration Services 3.5

We are pleased to announce the release of Linux Integration Services version (LIS) 3.5. As part of this release not only have we included several awesome features much desired by our customers but we have also expanded our distribution support to include Red Hat Enterprise Linux/CentOS 5.5 and Red Hat Enterprise Linux/CentOS 5.6. This release is another significant milestone in our ongoing commitment to provide great support for open source software on Microsoft virtualization platforms. The following paragraphs provide a brief overview of what is being delivered as part of this release. **Download Location** The LIS binaries are available as RPM installables in an ISO file which can be downloaded. As always, a ReadMe file has also been provided to provide information on installation procedure, feature set and known issues.  In the true spirit of open source development, we now also have a github repository hosted at the following [link](https://github.com/microsoft/LIS3.5). All code has been released under the GNU Public License v2. We hope that many of you will use it for your custom development and extension. **Supported Linux Distributions and Windows Server Releases** LIS 3.5 supports the following guest operating systems:

  * Red Hat Enterprise Linux (RHEL) 5.5-5.8, 6.0-6.3 x86 and x64
  * CentOS 5.5-5.8, 6.0-6.3 x86 and x64

All of the above distributions are supported on the following Windows Server releases:

  * Windows Server 2008 R2 Standard, Windows Server 2008 R2 Enterprise, and Windows Server 2008 R2 Datacenter
  * Microsoft Hyper-V Server 2008 R2
  * Windows 8 Pro
  * Windows 8.1 Pro
  * Windows Server 2012
  * Windows Server 2012 R2
  * Microsoft Hyper-V Server 2012
  * Microsoft Hyper-V Server 2012 R2

**Feature Set** The LIS 3.5 release brings much coveted features such as dynamic memory and live virtual machine backup to older RHEL releases. The check marks in the table below indicate the features that have been implemented in LIS 3.5. For comparative purposes we also provide the feature set of LIS 3.4 so that our customers can decide if they need to upgrade the current version of their LIS drivers. More details on individual features can be found at [here](/windows-server/virtualization/hyper-v/Feature-Descriptions-for-Linux-and-FreeBSD-virtual-machines-on-Hyper-V) . **Table Legend** **√** \- Feature available  ( _blank_ ) - Feature not available **Feature**

| 

**Hyper-V Version**

| 

**RHEL/CentOS 6.0-6.3**

| 

**RHEL/CentOS 5.7-5.8**

| 

**RHEL/CentOS 5.5-5.6**  
  
---|---|---|---|---  
  
**Availability**

| 

 

| 

**LIS 3.5**

| 

**LIS 3.4**

| 

**LIS 3.5**

| 

**LIS 3.4**

| 

**LIS 3.5**

| 

**LIS 3.4**  
  
**Core**

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
**Networking**

| 

   
  
Jumbo frames

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
VLAN tagging and trunking

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
Live Migration

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
Static IP Injection

| 

2012 R2, 2012

| 

**√ ** Note 1

| 

**√ ** Note 1

| 

**√ ** Note 1

| 

** **

| 

**√ ** Note 1

| 

** **  
  
**Storage**

| 

   
  
VHDX resize

| 

2012 R2

| 

**√**

| 

** **

| 

**√**

| 

** **

| 

**√**

| 

** **  
  
Virtual Fibre Channel

| 

2012 R2

| 

**√** Note 2

| 

** **

| 

**√** Note 2

| 

** **

| 

**√** Note 2

| 

** **  
  
Live virtual machine backup

| 

2012 R2

| 

**√** Note 3, 4

| 

** **

| 

**√** Note 3, 4

| 

** **

| 

**√** Note 3, 4

| 

** **  
  
TRIM support

| 

2012 R2

| 

** **

| 

** **

| 

** **

| 

** **

| 

** **

| 

** **  
  
**Memory**

| 

   
  
Configuration of MMIO gap

| 

2012 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
Dynamic Memory – Hot Add

| 

2012 R2, 2012, 2008 R2

| 

** **

| 

** **

| 

** **

| 

** **

| 

** **

| 

** **  
  
Dynamic Memory – Ballooning

| 

2012 R2, 2012

| 

**√** Note 5

| 

** **

| 

**√** Note 5

| 

** **

| 

**√** Note 5

| 

** **  
  
**Video**

| 

   
  
Hyper-V Specific  Video device

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

** **

| 

**√**

| 

** **

| 

**√**

| 

** **  
  
**Miscellaneous**

| 

   
  
Key-Value Pair

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

** **

| 

**√**

| 

** **

| 

**√**

| 

** **  
  
Non-Maskable Interrupt 

| 

2012 R2

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

**√**

| 

** **  
  
PAE Kernel Support

| 

2012 R2, 2012, 2008 R2

| 

**√**

| 

**√**

| 

**√**

| 

** **

| 

**√**

| 

** **  
  
  **Notes**

  1. Static IP injection might not work if Network Manager has been configured for a given Hyper-V-specific network adapter on the virtual machine. To ensure smooth functioning of static IP injection, ensure that either Network Manager is turned off completely, or has been turned off for a specific network adapter through its Ifcfg-ethX file.
  2. When you use Virtual Fibre Channel devices, ensure that logical unit number 0 (LUN 0) has been populated. If LUN 0 has not been populated, a Linux virtual machine might not be able to mount Virtual Fibre Channel devices natively.
  3. If there are open file handles during a live virtual machine backup operation, the backed-up virtual hard disks (VHDs) might have to undergo a file system consistency check (fsck) when restored.
  4. Live backup operations can fail silently if the virtual machine has an attached iSCSI device or a physical disk that is directly attached to a virtual machine ("pass-through disk").
  5. LIS 3.5 only provides Dynamic Memory ballooning support—it does not provide hot-add support. In such a scenario, the Dynamic Memory feature can be used by setting the Startup memory parameter to a value which is equal to the Maximum memory parameter. This results in all the requisite memory being allocated to the virtual machine at boot time—and then later, depending upon the memory requirements of the host, Hyper-V can freely reclaim any memory from the guest. Also, ensure that Startup Memory and Minimum Memory are not configured below distribution recommended values.

**Customer Feedback** Customer can provide feedback through Linux Integration Services for Microsoft Hyper-V forum located on the [Windows Server Forum](https://social.technet.microsoft.com/Forums/windowsserver/en-us/home?forum=linuxintegrationservices). We are eager to listen to your experiences and any issues that you may face while using LIS 3.5. We hope that this release helps you maximize your investment in Hyper-V and Windows Server.

\- Abhishek Gupta  

