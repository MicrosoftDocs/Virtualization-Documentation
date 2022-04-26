---
title:      "Dynamic Memory Coming To Hyper-V"
author: mattbriggs
ms.author: mabrigg
description: Dynamic Memory Coming To Hyper-V
ms.date: 03/18/2010
date:       2010-03-18 07:02:00
categories: calista-technologies
---
# Dynamic Memory Coming To Hyper-V

Virtualization Nation,

I’ve had the pleasure of talking with customers in the last few months and the Hyper-V R2 reception has been nothing but unequivocally positive. Whether it’s been folks in small, medium or the enterprise, they appreciate the [new capabilities in Windows Server 2008 R2 Hyper-V](https://blogs.technet.com/virtualization/archive/2009/07/22/windows-server-2008-r2-hyper-v-server-2008-r2-rtm.aspx) and the free [Microsoft Hyper-V Server 2008 R2](https://blogs.technet.com/virtualization/archive/2009/07/30/microsoft-hyper-v-server-2008-r2-rtm-more.aspx). At the same time, we’re _always_ listening to our customers to better understand their business requirements and requests so we know what to build for subsequent releases. Today, we’re [pleased to announce](https://www.microsoft.com/Presspass/press/2010/mar10/03-18DesktopVirtPR.mspx) new capabilities that will enhance both virtualized server and virtualized desktop deployments:

  * **Remote FX** : With Microsoft RemoteFX, users will be able to work remotely in a Windows Aero desktop environment, watch full-motion video, enjoy Silverlight animations, and run 3D applications within a Hyper-V VM – all with the fidelity of a local-like performance. For more info, check out Max’s blog [here](https://blogs.technet.com/virtualization/archive/2010/03/18/Explaining-Microsoft-RemoteFX.aspx). 
  * **Hyper-V Dynamic Memory** : With Hyper-V Dynamic Memory, Hyper-V will enable greater virtual machine density suitable for servers and VDI deployments.



**What Virtualization Users Have Told Us**

When it comes to virtualization and memory, virtualization users have repeatedly provided the following requirements:

  1. **Use physical memory as efficiently and dynamically as possible _with minimal performance impact._** Customers investing in virtualization hosts are purchasing systems with larger memory configurations (32 GB, 64 GB, 128 GB and more) and want to fully utilize this system asset. At the same time, they’re purchasing this memory to provide superior performance and to avoid paging. 
  2. **Provide consistent performance and scalability.** One frequent comment from virtualization users is that they don’t want a feature with a performance cliff or inconsistent, variable performance. That’s makes it more difficult to manage and increases TCO. 



Their comments are clear: Maximize our investment in the hardware resources, provide high density, and with a minimal performance impact.

(Speaking of performance, Hyper-V R2 performance is exceptional. We recently released an in depth performance analysis on Windows Server 2008 Hyper-V R2 Virtual Hard Disk Performance using a variety of workloads including SQL, Exchange, Web and more. This is a must read: <https://download.microsoft.com/download/0/7/7/0778C0BB-5281-4390-92CD-EC138A18F2F9/WS08_R2_VHD_Performance_WhitePaper.docx>)

**Virtual Machine Performance & Density**

If you think about Virtual Machine Performance and Virtual Machine Density as a continuum and you can place the slider, where would you position the slider?

[![MaximumPerformance2_thumb1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/AnnouncingWindowsRemoteFXHyperVDynamicMe_87CE/MaximumPerformance2_thumb1_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/AnnouncingWindowsRemoteFXHyperVDynamicMe_87CE/MaximumPerformance2_thumb1_2.png)

Up to now, we’ve opted to err on the side of performance with excellent results. Now, customers are asking us to start moving that slider over to increase density and still minimize performance impact, so that’s what we’re doing.

So, what is Dynamic Memory? At a high level, Hyper-V Dynamic Memory is a memory management enhancement for Hyper-V designed for production use that enables customers to achieve higher consolidation/VM density ratios. In my next blog, we’ll dive deep into Hyper-V Dynamic Memory…

Cheers,

Jeff Woolsey

Windows Server
