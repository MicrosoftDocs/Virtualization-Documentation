---
title:      "Windows Server 2008 R2 Hyper-V and AMD's 6-core Opteron"
description: The recent announcement by AMD marks another milestone in AMD’s continued mission to create processors designed to provide performance, efficiency, and value.
author: scooley
ms.author: scooley
date:       2009-06-09 10:39:00
ms.date: 06/09/2009
categories: hyper-v
---
# Windows Server 2008 R2 Hyper-V and AMD's 6-core Opteron

Hello, this is Bryon Surace.  I’m a senior program manager on the Windows virtualization team at Microsoft. The recent announcement by AMD regarding the 6-core AMD Opteron processor (codenamed ‘Istanbul’) marks another milestone in AMD’s continued mission to create processors designed to provide performance, efficiency, and value.

The newly announced 6-core AMD Opteron processor will provide a total of 24 logical processors (cores) on a 4-socket system and 48 logical processors (cores) on an 8-socket system.  In a non-virtualized IT environment, there aren’t many apps/services that are designed to utilize these large system resources.  However, with Hyper-V in Windows Server 2008 R2, it’s a natural fit.   WS08 R2 Hyper-V provides support for these new processors allowing large resources to be used to consolidate potentially hundreds of virtual machines on a single host. 

Hyper-V, as part of Windows Server 2008 R2 ([RTM by end of July](https://blogs.technet.com/windowsserver/archive/2009/06/02/windows-server-2008-r2-rtm-and-general-availability.aspx)) will provide support for up 64 Logical processors (see blog announcement [here](https://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)).  As such, Hyper-V combined with AMD’s new 6-core Opteron processors provide a solid virtualization platform on which to consolidate large numbers of virtual workloads.  Combined with WS08 R2 Core Parking technology, cores on the new Opteron processors can be fully utilized during peak times, or can be put into a sleep state (‘parked’) during idle times further reducing power consumption. 

In addition to the increase of supported logical processors, WS08 R2 Hyper-V also takes full advantage of advancements included in the newest generation processors. Specifically Hyper-V will take advantage of Second Level Address Translation such as AMD’s Rapid Virtualization Indexing (RVI). Through RVI, the AMD processor provides two levels of address translation. This additional page table is used to translate guest physical addresses to system physical address allowing the guest to control its own page tables.  In WS08 R2, Hyper-V can use the AMD RVI technology to increase performance of the virtualization platform and results in system resource savings. These savings include a drop in Hypervisor CPU time as well as a reduction in memory overhead.

The cooperative development efforts between Microsoft and AMD continue to be highly valued and directly result in providing an industry-leading virtualization platform. 

Bryon
