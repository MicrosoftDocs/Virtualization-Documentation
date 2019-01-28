---
title: Managing VMware
description: post id 3833
keywords: virtualization, virtual server, virtual pc, blog
author: scooley
ms.date: 1/14/2008
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 
---

# Managing VMware

If you haven't already, I recommend reading [Rakesh's post](http://blogs.technet.com/rakeshm/archive/2008/01/11/why-we-decided-to-manage-vmware.aspx) on why the System Center team decided to build out V2 of SCVMM so that customers can manage VMware ESX Server and VI3. Here's an excerpt:

> **Flexibility in Hypervisors  with a single management solution** - As I said above, we feel very confident that our hypervisor provides the best platform in the vast majority of customer use cases (that's for you to decide of course) but regardless, customers want to use a single management tool in mixed environments. You'll also be able to automate across hypervisors using a single Powershell interface that we provide. VMM will abstract the difference in hypervisor APIs for you. You simply run the "Stop-VM" cmdlet and we make sure that regardless of the hypervisor platform, the VM is stopped. No more code blocks that read "If (VMware)....elseif (VirtualServer)......elseif (Hyper-V)......"
>  
> Finally, I want to emphasize that when we say "manage VMware", we mean that day to day, you'll be able to use our console and command line interface to **fully** manage  your Virtual Infrastructure environment (including live migration), Virtual Server and Hyper-V environments seamlessly. In addition, we'll be able to extend the management capabilities that VMware offers today so you'll get an enhanced solution even on a non-Windows OS.

Cheers,  
Patrick O'Rourke

[Original post](https://blogs.technet.microsoft.com/virtualization/2008/01/14/managing-vmware/)