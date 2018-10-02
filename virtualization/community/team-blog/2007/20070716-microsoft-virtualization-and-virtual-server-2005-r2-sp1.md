---
title: Microsoft Virtualization and Virtual Server 2005 R2 SP1
description: post id 3953
keywords: virtualization, blog
author: scooley
ms.date: 7/16/2007
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 
---

# Microsoft Virtualization and Virtual Server 2005 R2 SP1

In my last post, I reminded everyone about our very successful Virtual PC 2007 release and for this post, I wanted to alert you to the recent release of Virtual Server R2 SP1. While there’s a lot of attention right now on Windows Server Virtualization, let’s not forget that we have a free, solid, production ready technology in Virtual Server that’s even better with the new Virtual Server R2 SP1 release. In fact, our own Microsoft IT uses Virtual Server with over 1200+ virtual machines in **_production environments every day_. Yes, read that again: _over 1200 virtual machines in production environments every day_.**

If you want to know more about Microsoft using Virtual Server in production, check out this interview with Devin Murray [here](http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9020679&pageNumber=1).

As for the new release of Virtual Server, we released Virtual Server R2 SP1 on Monday June 11th and you can download it [here](http://www.microsoft.com/technet/prodtechnol/eval/virtualserver/default.mspx)

Here's a list of some of the new features:

1. **Support for hardware-assisted virtualization technology (AMD-V and Intel VT)**
  Hardware assisted virtualization technology support greatly improves the performance for installing operating systems and substantially improves the overall performance of non-Microsoft operating systems such as Novell Suse Linux.

2. **Support for greater than 64 virtual machines on x64-based hosts**
  Virtual Server R2 SP1 now supports up to 256 GB of physical memory and can run up to 512 virtual machines concurrently.

3. **VHD Mount command-line tool and APIs** This allows you to mount a virtual hard disk (vhd) so you can easily add/remove files in a virtual machine without having to instantiate a virtual machine.

4. **Interoperability with Volume Shadow Copy Service**
  By integrating with Volume Shadow Services, Virtual Server now supports industry standard Microsoft Volume Shadow Service technology so you can take a snapshot of a Virtual Server host and ensure you create consistent snapshots of the virtual machines as well. For example, the current beta of System Center Data Protection Manager 2007 includes Virtual Server VSS support today.

5. **Support for additional guest and host operating systems**
  This release includes support for Windows Server 2003 SP2 as host and guest operating system as well as Novell Suse Linux Enterprise Server 10. For a full list, see the release notes.

6. **Host clustering white paper**
  If you're interested in being able to quickly migrate virtual machines from one server to anther for free, we've included all of the step-by-step instructions. I'll be discussing this in depth in a future blog.

7. **Larger default size for dynamically expanding virtual hard disks**
  Virtual Server now defaults to creating 127 GB virtual hard disks by default.

8. And, yes there more, just check out the release notes

Finally, to our millions of customers who have downloaded Virtual Server and Virtual PC, a huge THANKS. It's your feedback that drove this Service Pack Release and the feature set for Windows Server 2008 virtualization.

Cheers,  
Jeff

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/07/16/microsoft-virtualization-and-virtual-server-2005-r2-sp1/)