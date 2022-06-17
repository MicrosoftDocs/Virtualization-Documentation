---
title: Virtual Server Maximums
description: post id 3903
keywords: virtualization, virtual server, blog
author: scooley
ms.author: scooley
ms.date: 8/14/2007
ms.topic: article
ms.prod: virtualization
ms.assetid: f6dca287-3422-4445-a8b3-4d8b722f6f68
---

# Virtual Server Maximums

Virtualization Nation,

In my last blog, I discussed the fact that with Virtual Server R2 SP1 we increased the amount of physical memory that Virtual Server can address from 64 GB to 256 GB. I saw that this prompted questions about other maximums for storage, networking, etc, so I thought I’d provide a table with more details for Virtual Server.

If you’re like most folks who are using virtualization for server consolidation, you’ll see that Virtual Server provides plenty of capabilities for production environments. In fact, our own Microsoft IT uses Virtual Server with over 1200+ virtual machines _in production environments every day_. For more information on how our own Microsoft IT has deployed over 1200 virtual machines in production environments go here.

Cheers,  
Jeff

|Virtual Machine Maximums|Number|
|:----|:----|
|SCSI controllers per virtual machine | 4 |
|Devices per SCSI controller | 7 |
|Size of SCSI virtual hard disk | 2 TB |
|Maximum storage per virtual machine | 56 TB |
|Number of virtual CPUs per virtual machine | 1 |
|Maximum amount of memory per virtual machine | 3.6 GB |
|Number of virtual NICs per virtual machine | 4 |
|Number of IDE devices per virtual machine | 4 |
|Number of floppy devices per virtual machine | 1 |
|Number of parallel ports per virtual machine | 1 |
|Number of serial ports per virtual machine | 2 |

|Virtual Server Maximums |Number|
|:----|:----|
|Number of virtual networks | 128 |
|Maximum physical memory addressable for virtualization | 256 GB |
|Number of physical NICs | 9999 |
|Number of hosts per cluster for high availability and migration | 8 |

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/08/14/virtual-server-maximums/)