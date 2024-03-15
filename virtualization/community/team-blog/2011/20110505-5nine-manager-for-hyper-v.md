---
title:      "5Nine Manager for Hyper-V"
author: sethmanheim
ms.author: sethm
description: 5Nine Manager for Hyper-V
ms.date: 05/05/2011
date:       2011-05-05 06:56:00
categories: hyper-v
---
# 5Nine Manager for Hyper-V

Virtualization Nation,

With the release of Microsoft Hyper-V Server 2008 R2 SP1, we have once again raised the bar for providing a robust, enterprise class virtualization platform at no cost. For example, did you realize that Microsoft Hyper-V Server 2008 R2 SP1 includes RemoteFX? This new feature provides Graphical Processing Unit (GPU) accelerated video _within a virtual machine_. VMware's flagship product VSphere Enterprise Plus ($3500 per processor) doesn't have this capability.

Let that sink in for a moment.

GPU accelerated video within a virtual machine is an important consideration when architecting a Virtual Desktop Infrastructure (VDI) deployment. Perhaps you decide you're willing to deploy VDI using 2D virtualized video today.  But what if you realize six months or a year down the road that you need 3D GPU accelerated graphics support? Do you really want to choose a virtualization platform for VDI that doesn't offer this capability today? Is VMware willing to provide this feature without requiring an upgrade ($$$)? In writing? [If you review their history, that seems highly unlikely](https://blogs.technet.com/b/virtualization/archive/2009/06/28/beware-the-vmware-core-tax-and-more.aspx). These are key factors that you should consider when making a decision for VDI.

For more info on Microsoft Hyper-V Server 2008 R2 and R2 SP1, check out these two blogs:

  * <https://blogs.technet.com/b/virtualization/archive/2009/07/30/microsoft-hyper-v-server-2008-r2-rtm-more.aspx>.
  * <https://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx>



 

**Microsoft Hyper-V Server User Experience**

If you've ever fired up the no-cost Hyper-V Server, you know that the UI is minimal. This is by design. The goal of Hyper-V Server is to make it easy for you to get the system configured and on the network for remote management. There's no Start menu or local GUI. Hyper-V Server instead includes a command line and SCONFIG, which is included to make it easy for you to configure the system for remote management functionality, such as:

  * Domain Join
  * Name the Computer
  * Add Local Administrator
  * Configure Remote Management
  * Configure Networking, IP Addresses, etc.
  * Enable Clustering for High Availability and Live Migration
  * Configure Automatic Updating via Windows Update



Here's a screenshot of SCONFIG:


Once you've configured Hyper-V Server for remote management, you can manage it in a number of ways:

  * Using Windows Server 2008 R2 SP1 Hyper-V Manager on a full version of Windows Server 2008 R2 SP1
  * [Using the Remote Server Administration Tools (RSAT) for Windows 7 & Windows 7 SP1](/troubleshoot/windows-server/system-management-components/remote-server-administration-tools)
  * System Center Virtual Machine Manager 2008 R2 SP1
  * System Center Virtual Machine Manager 2012 Beta



While these options work for most of you, a number of folks have asked for a local GUI that could be run directly on Hyper-V Server 2008 R2.

Wouldn't that be cool?

We think so too.  **That's exactly what our partners at 5nine built!**

 

**5Nine Hyper-V Manager**

The folks at 5Nine have developed a local GUI for Microsoft Hyper-V Server 2008 R2! With the 5Nine Hyper-V Manager you can create virtual machines, virtual networks, and more. In fact, 5Nine Hyper-V Manager supports Microsoft Hyper-V Server 2008 R2 SP1 and includes the ability to manage RemoteFX and Dynamic Memory settings.

Here's a screenshot of the 5nine Hyper-V Manager:

 

 Very cool. This is a great opportunity to point out what can be accomplished using the [public Hyper-V WMI APIs](/previous-versions/windows/desktop/virtual/windows-virtualization-portal) which have been documented since day one.

** **

**Download Links**

Here are the key links:

  * [Microsoft Hyper-V Server 2008 R2 SP1](https://www.microsoft.com/download/details.aspx?id=20196)
  * 5Nine Hyper-V Manager



 

Cheers,

Jeff Woolsey

Windows Server & Cloud

 

==============================================

**FAQ**

==============================================

Q: Did Microsoft develop this Hyper-V Manager for Microsoft Hyper-V Server 2008 R2?

A: No. The product is called **5Nine Hyper-V Manager** developed by our partners at 5Nine. 

===========================================================================

Q: How much does the 5Nine Hyper-V Manager cost? What are the system requirements?

A: 5Nine offers both a free version and a $99 version. The big difference is that the $99 version provides local access to the VM itself. 

Note: 5Nine Hyper-V Manager works with Microsoft Hyper-V Server 2008 R2 and later. It doesn't work with the original Microsoft Hyper-V Server 2008 because it requires some capabilities not included Hyper-V Server 2008, such as .NET Framework.

===========================================================================

Q: Does Microsoft support the 5Nine Hyper-V Manager?

A: The 5Nine Hyper-V Manager was developed by the folks over at 5Nine, however, the 5Nine Hyper-V Manager uses our published [Hyper-V WMI APIs](https://msdn.microsoft.com/library/cc136992\(VS.85\).aspx), which are fully supported by Microsoft.

===========================================================================

Q: Will Microsoft provide a local GUI?

A: Microsoft provides multiple ways to manage Microsoft Hyper-V Server remotely including:

  * Using Windows Server 2008 R2 SP1 Hyper-V Manager on a full version of Windows Server 2008 R2 SP1
  * [Using the Remote Server Administration Tools (RSAT) for Windows 7 & Windows 7 SP1](/troubleshoot/windows-server/system-management-components/remote-server-administration-tools)
  * System Center Virtual Machine Manager 2008 R2 SP1
  * System Center Virtual Machine Manager 2012 Beta



Microsoft has no plans to provide a local GUI for Microsoft Hyper-V Server, and we are pleased to see our partners provide a solution. 
