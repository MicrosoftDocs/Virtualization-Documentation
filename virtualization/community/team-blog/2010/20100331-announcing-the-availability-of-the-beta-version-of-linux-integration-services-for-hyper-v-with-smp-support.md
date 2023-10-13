---
title:      "Announcing the availability of the Beta version of Linux Integration Services for Hyper-V with SMP support"
author: sethmanheim
ms.author: mabrigg
description: Announcing the availability of the Beta version of Linux Integration Services for Hyper-V with SMP support
ms.date: 03/31/2010
date:       2010-03-31 02:00:00
categories: hyper-v-linux-novell-red-hat
---
# Announcing the availability of the Beta version of Linux Integration Services for Hyper-V with SMP support

[Windows Server 2008 R2 Hyper-V](https://www.microsoft.com/download/details.aspx?id=12601) and [Microsoft Hyper-V Server 2008 R2](https://www.microsoft.com/en-us/download/details.aspx?id=20196) provide robust virtualization for customers who have appreciated the capabilities that this solution provides. Virtualization decouples the operating system from the underlying hardware, and this decoupling creates a flexible and dynamic IT infrastructure. Customers who have a heterogeneous operating system environment desire their virtualization platform to provide support for all operating systems that they have in their datacenters. We have supported Linux as a guest operating system on our virtualization platform from the days of Virtual Server and continue to enhance our support in that regard. In July of last year, we submitted our Linux Integration Services for Hyper-V to the Linux community so that they can be included in the Linux kernel.  We have seen great support from the community, having received over 200 patches. As part of our continuing efforts to support Linux as a guest on Hyper-V, we are announcing the availability of the beta version of Linux Integration Services for Hyper-V (version 2.1). In addition to the existing features (networking, storage, and fastpath boot), the 2.1 release adds the following:

 

·         SMP support for Linux workloads

o   Linux virtual machines running on Hyper-V will be able to use up to 4 virtual CPU’s

·         Timesync

o   Linux VM’s running on Hyper-V will be able to synchronize their time with the parent partition.

·         Integrated Shutdown

o   You will be able to shut down a Linux virtual machine gracefully from the Hyper-V manager.

 

This version of the integration services for Hyper-V can be downloaded from here, and supports Novell SUSE Linux Enterprise Server 10 SP3, SUSE Linux Enterprise Server 11, and Red Hat Enterprise Linux 5.2 / 5.3 / 5.4.

 

To offer our customers the most flexibility when interacting with Hyper-V, the part of the code which communicates with Hyper-V is licensed under a dual license ([BSD](https://opensource.org/license/bsd-1-clause/) and [GPLv2](https://opensource.org/license/gpl-2-0/)), while the part that communicates and interacts directly with the Linux kernel is under GPLv2. 

 

These new capabilities will be submitted shortly to the Linux kernel as well. In fact the SMP patch has already been submitted by Greg Kroah-Hartman - thanks, Greg! 

 

**UPDATE #1** : Anton, thanks for reading the blog. Yes, we know there are lots of people watching how well, or poorly, Microsoft does maintaining the working relationship with the Linux kernel team and this work with the community is a learning process for us. That’s why there are Microsoft employees focused on this project, and focused to work with the kernel team. Hank Janssen and Haiyang Zhang who are listed as the maintainers of this code are dedicated to working on enhancing the Hyper-V integration services for Linux. If you are following the kernel mailing lists recently, you will have noticed that we have been actively contributing towards adding more capabilities and enhancing the code.
