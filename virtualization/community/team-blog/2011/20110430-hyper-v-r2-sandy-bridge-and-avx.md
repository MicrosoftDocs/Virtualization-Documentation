---
title:      "Hyper-V R2, Sandy Bridge and AVX..."
author: mattbriggs
ms.author: mabrigg
description: Hyper-V R2, Sandy Bridge and AVX
ms.date: 04/30/2011
date:       2011-04-30 12:05:00
categories: hyper-v
---
# Hyper-V R2, Sandy Bridge and AVX

Virtualization Nation,

Intel has recently released their new “Sandy Bridge” processors which is the second generation of the Core i3/i5/i7 processors. Most of these new processors hitting the market with the first wave of product released are designed for notebooks and a few for desktops with server processors on the way.  An easy way to identify the new Sandy Bridge processors is that the processor models are 4 digits. For example, you’ll see processors such as the i7-2600k or i5-2500k and so on. There are a number of good articles on these new processors ([like this](http://news.softpedia.com/news/Intel-Sandy-Bridge-Review-Core-i7-2600K-and-Core-i5-2500K-175630.shtml)) so take a look if you’re interested in what’s new.

I’m raising this topic because I want you to be aware of an issue with both Windows Server 2008 R2 Hyper-V and Microsoft Hyper-V Server 2008 R2 and the new Sandy Bridge processors and provide the solutions.

**Issue** : When you attempt to start a VM running on a system with a Sandy Bridge processor, the virtual machine will not start. If you go to the Event Viewer you will see an error that states: “\<VM Name\> could not initialize” error.

**Cause** : Fundamentally, this is a chicken and egg problem. :-)

  * Windows Server 2008 R2 was released in mid-2009.
  * Sandy Bridge was released in early 2011.



Here’s the scoop. The new Sandy Bridge processors include a new extension to the x86 instruction set known as Advanced Vector Extensions (AVX). AVX is designed to improve performance for applications that are floating point intensive such as scientific simulations, analytics and 3D modeling. Since Windows Server 2008 R2 was released a few years prior to the release of AVX equipped processors, Windows Server 2008 R2 and Microsoft Hyper-V Server 2008 R2 don’t understand this new functionality and Hyper-V **_correctly_** prevents starting the virtual machine. This behavior is  by design as we wouldn’t want to start a virtual machine with unknown and untested processor capabilities. The good news is that solutions are available.

**Solution** : There are two solutions. The recommended solution is option 1.

  * Option 1:  Upgrade Windows Server 2008 R2 and Microsoft Hyper-V Server 2008 R2 **with Service Pack 1** which properly supports the new Sandy Bridge Processors. After installing Windows Server 2008 R2 SP1, **_it adds support for the AVX instructions in the parent partition and within the virtual machine for guest operating systems_**.
  *  Option 2: Apply this [hotfix](https://support.microsoft.com/kb/2517374) to Windows Server 2008 R2. After installing this hotfix, it adds support for the AVX instruction in the parent partition, but **does NOT present AVX instructions within the virtual machine for guest operating systems.**



** **

==============================================

**FAQ**

==============================================

Q: Do the AVX instructions improve performance?

A: The AVX instructions **_can_** improve performance if applications and workloads have been designed to use these instructions.

===========================================================================

Q: Does the Hyper-V Processor Compatibility feature have any bearing on this matter?

[![Hyper-V Processor compatibility](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3247.Processor%20Compatibility.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3247.Processor%20Compatibility.png)

A: No. The Hyper-V Processor Compatibility feature is orthogonal to this matter. The fundamental issue is that Windows Server 2008 R2 and Microsoft Hyper-V Server 2008 R2 were released years before processors with AVX instructions were available and didn’t includes support for the AVX instructions in the _parent operating system_.

The Hyper-V Processor Compatibility feature normalizes the processor feature set and only exposes guest visible processor features that are available on all Hyper-V enabled processors of the same processor architecture, i.e. AMD or Intel. This allows the VM to be migrated to any hardware platform of the same processor architecture. For more info on Hyper-V Processor Compatibility here are some links ([here ](https://blogs.technet.com/b/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)and [here](https://download.microsoft.com/download/F/2/1/F2146213-4AC0-4C50-B69A-12428FF0B077/VM%20processor%20compatibility%20mode.doc)).

Cheers,

Jeff Woolsey

Windows Server & Cloud
