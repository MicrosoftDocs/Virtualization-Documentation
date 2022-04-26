---
title: Linux Integration Services Download 4.1.2-2 hotfix
description: Blog post that discusses the release of the Linux Integration Services version 4.1.2-2 hotfix and what issues it addresses.
author: scooley
ms.author: scooley
date: 2016-10-21 20:29:47
ms.date: 03/20/2019
categories: uncategorized
---

# Linux Integration Services Download 4.1.2-2 hotfix

We've just published a hotfix release of the Linux Integration Services download, version 4.1.2-2. This release addresses two critical issues: "Do not lose pending heartbeat vmbus packets" (for versions 5.x, 6.x, 7.x) Hyper-V hosts can be configures to sent "heartbeat" packets to guests to see if they are active, and reboot them when they do not respond. These heartbeat packets can queue up when a guest is paused expecting a response when the guest is re-activated, for example when a guest is moved by live migration. This fix corrects a problem where some of these packets could be dropped leading the host to reboot an otherwise healthy guest. "Exclude UDP ports in RSS hashing" (for version 6.x, 7.x) While improving network performance by taking advantage of host-supported offloads we had introduced a problem with UDP workloads on Azure. This change fixes excessive UDP packet loss in this scenario. Linux Integration Services 4.1.2-2 can be downloaded [here](https://www.microsoft.com/en-us/download/details.aspx?id=51612).
