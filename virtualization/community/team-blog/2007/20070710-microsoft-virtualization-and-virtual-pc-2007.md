---
title: Microsoft Virtualization and Virtual PC 2007
description: post id 3963
keywords: virtualization, virtual server, virtual pc, blog
author: scooley
ms.date: 7/10/2007
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 0c36290a-0790-4f64-ae63-0c5e90be116f
---

# Microsoft Virtualization and Virtual PC 2007

Greetings!

I'm Jeff Woolsey, a Senior Program Manager at Microsoft focused on Microsoft Virtualization. I've worked on virtualization technology for over ten years such as Virtual PC for Mac, Virtual PC for Windows and Virtual Server. These days I spend most of my time on Virtual Server and our new hypervisor based virtualization (codename "Viridian") which will be a key technology of Windows Server 2008.

I have the pleasure of regularly meeting with customers and partners and one bit of feedback I receive often is that folks want to hear more about what we're doing in terms of virtualization. With this in mind, I thought I'd take some time to start blogging about Microsoft virtualization. The focus of my blogs will be Virtual Server and our new hypervisor based virtualization in Windows Server 2008, but for this first article I thought I'd remind folks about one of our hottest downloads, Virtual PC 2007. Virtual PC 2007 was released in February 2007 and within the first 60 days **had over 1.8 million downloads**. We've hit well over 2 million downloads now and still climbing!

Virtual PC 2007 can be freely downloaded from [here](http://www.microsoft.com/windows/products/winfamily/virtualpc/default.mspx).

Here's a list of some of the new features:

1. **Support for hardware-assisted virtualization.**  
  Virtual PC 2007 includes support for virtualization technology from Intel and AMD. By default, hardware-assisted virtualization is enabled if the feature is enabled on the physical computer. You can turn this assistance on or off for each virtual machine by modifying the virtual machine settings.

2. **Support for Windows Vista.**  
  Virtual PC 2007 includes support for Windows Vista as a host and guest operating system within Virtual PC.

3. **Support for 64-bit host operating systems.**
  This release of Virtual PC 2007 supports 64-bit host operating systems. However, there is no support for 64-bit guest operating systems.

4. **Network-based installation of a guest operating system.**
  The virtual machine network adapter includes support for performing a PXE boot. This means that when the appropriate network infrastructure is in place, you can perform a network installation of a guest operating system without using a PXE boot floppy disk.

5. **Running virtual machines on multiple monitors.**
  Virtual PC 2007 includes support for viewing virtual machines on multiple monitors of a physical computer. If you have more than one monitor attached to your physical computer, you can view a virtual machine on one of the monitors, in either window mode or full-screen mode.

6. For more details, check out the release notes.

Generally, I'm going to focus on server virtualization so I'll be discussing Virtual Server and Windows Server virtualization. I may touch on Virtual PC now and then, but Ben Armstrong (VPC GUY) has done such a great job blogging on Virtual PC, that I'd rather point you to his excellent blog [here](http://blogs.msdn.com/virtual_pc_guy/default.aspx).

Finally, to our millions of customers who have downloaded Virtual PC, a huge THANKS. It's your feedback that drove this release.

Cheers,  
Jeff

[Original link](https://blogs.technet.microsoft.com/virtualization/2007/07/10/microsoft-virtualization-and-virtual-pc-2007/)