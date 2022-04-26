---
title: Beta of Hyper-V Server 2008 R2
keywords: virtualization, virtual server, blog
description: The R2 Beta release adds some highly anticipated features including live migration, increased memory/processor support, and an updated configuration utility.
author: scooley
ms.author: scooley
ms.date: 1/15/2009
ms.topic: article
ms.prod: virtualization
ms.assetid: 
---

# Beta of Hyper-V Server 2008 R2

Hello fellow virtualization fans,

Bryon here [again](https://blogs.technet.com/virtualization/archive/2009/01/16/winserver-2k8-hyper-v-is-alive.aspx). With all the excitement around the [beta release of Windows Server 2008 R2](https://blogs.technet.com/windowsserver/archive/2009/01/07/announcing-windows-server-2008-r2-beta.aspx), it’s important to call attention to another important beta release: Microsoft Hyper-V Server 2008 R2! 

To ensure there is no confusion, let me be clear that I’m talking about **Microsoft Hyper-V Server 2008 R2**.  **Not Hyper-V the feature of Windows Server 2008 R2**.  Alessandro’s [post](http://www.virtualization.info/2009/01/microsoft-releases-stand-alone-hyper-v.html) did a good job showing the differences. Microsoft Hyper-V Server 2008 R2 is the next generation of the standalone hypervisor based product. ~~

~~

Building on the solid virtualization platform of Microsoft Hyper-V Server 2008, the R2 Beta release adds some highly anticipated features including live migration, increased memory/processor support, and an updated configuration utility. Let’s take a closer look at each of these:

§  Failover Clustering/Live Migration: With the addition of host clustering technology, Microsoft Hyper-V Server 2008 R2 beta provides support for unplanned downtime and planned migrations.  Live migration enables customers to move running virtual machines between servers without any perceived downtime or dropped network connections.

§  Process/Memory Support: Microsoft Hyper-V Server 2008 R2 beta now provides native support for up to 32-cores and up to 1TB of RAM on a physical system enabling even greater consolidation.

§  Updated Configuration Utility:  Since Microsoft Hyper-V Server 2008 is command line only, the configuration utility is designed to simplify the most common initial configuration tasks.  It helps you configure the settings without having to type long command-line strings.  Microsoft Hyper-V Server 2008 R2 beta adds new options to ease the configuration of options such as remote management, failover clustering, and software update installation just to name a few.

So make sure to check out more information on Microsoft Hyper-V Server and download R2 Beta at the [Microsoft Hyper-V Website](https://www.microsoft.com/hvs).

Additionally, the beta can be downloaded by subscribers on [TechNet](https://technet.microsoft.com/subscriptions/downloads/default.aspx?pv=1:352) and [MSDN](https://msdn.microsoft.com/subscriptions/downloads/default.aspx?pv=1:352). 


Virtually Yours,

Bryon Surace 

Senior Program Manager for Microsoft Virtualization



**UPDATE** : Hey MountainDrew, sorry to respond so late. HVS supports up to 16 nodes. Thanks for the Q.
