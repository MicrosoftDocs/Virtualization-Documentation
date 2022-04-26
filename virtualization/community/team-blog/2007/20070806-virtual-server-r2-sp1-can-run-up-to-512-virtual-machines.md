---
title: Virtual Server R2 SP1 can run up to 512 virtual machines
description: post id 3913
keywords: virtualization, virtual server, blog
author: scooley
ms.author: scooley
ms.date: 8/6/2007
ms.topic: article
ms.prod: virtualization
ms.assetid: 3948a77e-8fef-4d7f-a007-672590765004
---

# Virtual Server R2 SP1 can run up to 512 virtual machines

Virtualization Nation,

In one of my earlier posts, I mentioned the fact that Virtual Server 2005 R2 SP1 now supports up to 256 GB of memory and can run 512 virtual machines simultaneously. I received some feedback asking me to compare this against Virtual Server 2005 R2, so let me do that.

**Virtual Server 2005 R2 running on Windows Server 2003 _32-bit_ (x86 editions).**  
Virtual Server R2 running on 32-bit Windows has a hard coded limit of running 64 virtual machines concurrently. In reality most people have difficulty reaching that number due to 32-bit kernel address space limitations. Specifically, the fact that:

* The total virtual address space (based on a single process) for 32-bit Windows is 4 gigabytes as opposed to 64-bit Windows where it is **_16 terabytes_**.
* The virtual address space per 32-bit process is 2 GB (3 GB if the system is booted with the /3GB switch enabled) and for 64-bit Windows it is **_8 terabytes_**.

Considering the fact that virtualization is designed to run on systems with large amounts of memory to support multiple operating systems running simultaneously, you can see why Virtual Server was one of the first Microsoft technologies to provide an x64 native version starting with Virtual Server 2005 R2 x64 Edition almost two years ago.

**Virtual Server 2005 R2 running on Windows Server 2003 _64-bit_ (x64 editions).**  
Virtual Server R2 running on Windows Server 2003 x64 Editions has a hard coded limit of running 64 virtual machines concurrently. Because x64 is becoming more common, we've had numerous customers (like our own Microsoft IT) hit the 64 virtual machine limit (with ample CPU, memory and storage resources to spare) and have requested we up this limit when running Virtual Server on Windows Server 2003 x64 Editions. We listened to our customers and did exactly that.

**Virtual Server 2005 R2 SP1 running on Windows Server 2003 _64-bit_ (x64 editions).**  
With Virtual Server 2005 R2 SP1, it now supports up to 256 GB of physical memory and we upped the limit to _512_ running virtual machines when running on Windows Server 2003 x64 Editions. Please note that the limit of 64 running virtual machines is unchanged when running on 32-bit (x86) Windows Editions.

Cheers,  
Jeff

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/08/06/virtual-server-r2-sp1-can-run-up-to-512-virtual-machines/)