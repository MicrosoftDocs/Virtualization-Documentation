---
title: System Center Virtual Machine Manager - Huge Announcements!
description: post id 3883
keywords: virtualization, scvmm, system center, virtual server, blog
author: scooley
ms.author: scooley
ms.date: 9/6/2007
ms.topic: article
ms.assetid: a6df27f5-cacb-4321-96f7-d6222c583815
---

# System Center Virtual Machine Manager Announcements

Hi - this is Chris Stirrat and I run the team that built System Center Virtual Machine Manager (also known as SCVMM or "Carmine").

I very excited to share a couple of _HUGE_ announcements with everyone around virtualization and SCVMM.  
**_First_** - I am extremely proud to announce that after 2 short (OK - it didn't always seem short...) years of customer focused development, **_SCVMM has been officially released_**!   It has been a long road and as many of our TAP and Beta customers can attest, we have come a long way.  It is not easy bringing a competitive version 1 product to market, especially in a newer industry that is moving quickly.

Here are some of the interesting details of the release:

* Throughout the release we have had over 32 TAP (Technology Adoption Partners) customers and 10 partners which have been testing, giving great feedback and creating solutions with the beta versions of SCVMM
* Microsoft's own internal IT group has been managing 100% of their virtual environment (86 physical hosts running 1224 VMs) in production with SCVMM since Beta2 with no (that is zero) impact on their SLAs
* To date we have over 20,678 public beta users of SCVMM
* SCVMM is available in 9 different languages

In addition here are some quotes from our Beta and TAP customers:

* "VMM came through for us "Big Time", I would have been doing this for many hours, 5 min opposed to many hours, what more can I say! VMM was the only reason I got sleep last night!"
* "We hadn’t used System Center software before, but we found it fairly easy to move from Linux to Virtual Server and adopt Virtual Machine Manager because VMM is so well designed and easy to administer."
* "Virtual Machine Manager handles so many tedious, yet critical, VM infrastructure tasks.  It makes VM management so easy, we’re ecstatic."
* "System Center Virtual Machine Manager provides us with many important benefits.  Its centralized management and sophisticated provisioning capabilities make it so much easier for us to manage and enhance our virtual infrastructure."

I want to thank all the TAP and Beta customers for all the great feedback – it has been a great partnership for us.  The release is now publicly available at [www.microsoft.com/scvmm](https://www.microsoft.com/scvmm), with general availability in October.

**_Second – we are announcing the pricing/licensing for SCVMM_**.  We learned from our customers that managing virtualization encompasses many things – provisioning, monitoring, optimizing, reporting, patching and backup/restore.  As we looked at the Microsoft assets across these areas, we created integration with some of the existing tools to help cover all the key scenarios for virtualization.  We have tight integration with Operations Manager to provide health monitoring, performance monitoring, eventing/alerts, and ultimately the combination of SCVMM and Operations Manager provides a powerful solution to continually optimize your virtualization environment.  In addition, with Operations Manager we can see a full picture of how an application running in a VM.  We monitor the application and combine that data with the VM and physical host data. For patching the VMs and images, we have integration with Configuration Manager that allows you to patch VMs including the ones not currently running.  For backup/restore, we have integration with Data Protection Manager that allows you to backup at the physical host level (which includes all the VMs running on that host). In order to make it easy for customers to manage their virtual environments and cover the key scenarios – we are announcing a new license to cover that situation.  We are announcing the System Center Management Suite Enterprise license which gives you everything you need to manage you virtual environment at a very reasonable price of $860 per physical host.

You get:

* System Center Virtual Machine Manager 2007 license
* Enterprise server management licenses for System Center Configuration Manager 2007, System Center Operations Manager 2007 and System Center Data Protection Manager 2007

One key thing to note – _the license is on the physical host and includes unlimited VMs running on that host_.   Also – one question I get pretty often is whether or not SCVMM requires the other tools in order to run.  
The answer is no – SCVMM is stand-alone and does not require the other System Center tools in order to run.  Having said that – there are many scenarios that are better and "light-up" when SCVMM is used in conjunction with the other System Center tools.

**_Third – we are announcing System Center Virtual Machine Manager 2007 Workgroup edition_**, which will be available in January 2008.  This edition is aimed at mid-market customers and allows them to manage up to five physical host servers and an _unlimited number of virtual machines_.   The only restriction in the software is the number of physical hosts you can manage (5) but everything else is full functionality.  The System Center Virtual Machine Manager 2007 Workgroup edition will be priced at $499 and will be available in January.

**_The fourth announcement centers on where we are taking SCVMM moving forward_**.   We are on a long roadmap with SCVMM and continue to get great feedback from customers about where to go.  Our next release is planned to coincide with the release of Windows Server Virtualization (codename Viridian) so that we can expose all the great features it provides.  In addition to Viridian support – we are also adding some key customer driven features. We have heard loud and clear from customers and partners that we need to manage other virtualization environments in addition to Windows virtualization.  They want a single management solution that manages all the different hypervisor technologies. So – in our next set of releases _will be adding support for non-Windows virtualization environments – specifically VMWare and Xen._  We listened to you!!!  And when I say we will manage these environments I mean really manage them – covering all the key scenarios they offer.  _From a single console and a single command-line you will be able manage Virtual Server, Viridian, VMWare and Xen_. We are finalizing the project plans and will announce specific details closer to our Beta release  – but we are very excited to get working on the next release.  The team is focused, hardworking and dedicated to providing a great solution.  We have fully recovered from our release celebration and are heads down cranking away.

For more information on Virtual Machine Manger and other Microsoft virtualization products please visit these sites [www.microsoft.com/scvmm](https://www.microsoft.com/scvmm) and [www.microsoft.com/virtualization](https://www.microsoft.com/virtualization).

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/09/06/system-center-virtual-machine-manager-huge-announcements/)