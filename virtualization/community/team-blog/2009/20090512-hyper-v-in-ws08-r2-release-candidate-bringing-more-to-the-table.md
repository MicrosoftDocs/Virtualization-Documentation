---
title:      "Hyper-V in WS08 R2 Release Candidate&#58; Bringing More to the Table"
description: You'll want to read Isaac's blog post about the RC milestone of Windows Server 2008 R2.
author: scooley
ms.author: scooley
date:       2009-05-12 01:43:00
ms.date: 05/12/2009
categories: high-availability
---
# Hyper-V in WS08 R2 Release Candidate: Bringing More to the Table

You'll want to read Isaac's blog post about the RC milestone of Windows Server 2008 R2. His post focuses on 64 LP support and processor compatibility mode for live migration. Read the post [here](https://blogs.technet.com/windowsserver/archive/2009/05/11/hyper-v-in-ws08-r2-release-candidate-bringing-more-to-the-table.aspx "Isaac's post on Windows Server blog").

Here's an excerpt:

> **64LP Support**
> 
> We have seen processors grow from 1, 2, 4, and now 6 cores on a single processor, soon to hit 8.  Within the Windows Server 2008 R2 lifecycle, 64 logical processor servers will become commonplace (8 processors x 8 cores).  Virtualization is the natural fit for these next-gen servers, allowing them to consolidate a greater number of virtual machines on a single host. Hyper-V is in line with these hardware trends all with an eye towards bringing you greater VM density. The dev team has done a fantastic job in building and testing a platform that can scale.
> 
> Let's take a quick look at the history of logical processor support for Hyper-V:
> 
>   * Server 2008 Hyper-V                                         16 LP Support 
>   * Server 2008 Hyper-V +update ([KB95670](https://support.microsoft.com/kb/956710))      24 LP Support 
>   * Server 2008 **R2** Hyper-V Original POR            32 LP Support 
>   * Server 2008 **R2** Hyper-V RC/RTM                    **64 LP Support!**
> 

> 
> **Processor Compatibility Mode for Live Migration  **
> 
> Live Migration is the killer-feature in Windows Server 2008 R2!  Previous to the RC build of Windows Server 2008 R2, identical CPUs were needed across every node in the cluster in order to perform a live migration.  As we came closer to the RC milestone we got feedback from customers and partners asking, "What if I deploy additional nodes that contain newer processors with features not contained in the original nodes?"  Well, we've solved that problem due to tremendous effort by the Hyper-V development team. 
> 
> Processor compatibility mode is very straightforward. It enables live migration across different CPU versions within the same processor family (i.e. Intel-to-Intel and AMD-to-AMD). However, it does _NOT_ enable cross platform from Intel to AMD or vice versa. It works by abstracting the VM down to the lowest common denominator, in terms of instruction sets, which enables live migrations across a broader range of Hyper-V host hardware. 
> 
> There are a few things to note: Processor compatibility mode is disabled by default but you can configure it on a per-VM basis. There are no specific hardware requirements other than the CPUs must support hardware assisted virtualization (i.e. Intel's IVT and AMD's AMD-V).

Patrick
