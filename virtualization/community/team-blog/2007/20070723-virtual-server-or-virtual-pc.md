---
title: Virtual Server or Virtual PC?
description: post id 3943
keywords: virtualization, virtual server, virtual pc, blog
author: scooley
ms.date: 7/23/2007
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 25f3dc96-4913-41bb-9d29-69835e2ded52
---

# Virtual Server or Virtual PC

In my first couple of blogs, I wanted to remind everyone of the recent release of Virtual PC 2007 and Virtual Server 2005 R2 SP1. I received feedback asking about some of the differences between the two and compatibility of virtual machines between the two. So, here are the answers...

Q: I'm interested in evaluating Microsoft virtualization, which should I use, Virtual PC or Virtual Server?

A: The answer to this question really depends on your application and usage. Both Virtual PC and Virtual Server are powerful, easy to use products that offer unique features and functionality.  
For example:

* Virtual PC offers an intuitive, local UI designed for a single user while Virtual Server offers a Web Administration application allowing multiple users to administer Virtual Servers remotely.
* Virtual Server is designed with extensibility in mind and includes a fully documented COM interface in the _Virtual Server Programmer's Guide_. So, if you're interested in developing your own scripts to configure, create virtual machines, Virtual Server is the way to go.
* Virtual Server is heavily threaded and designed to take advantage and scale on multi-processor computers with large amounts of memory. In fact, Virtual Server can use up to 256 GB of physical memory with the latest version.

---------------------------------------------------------------------------------------------------------------------------------

Q: From a virtual machine perspective, what are the differences between a Virtual PC virtual machine and a Virtual Server virtual machine? Are they compatible?

A: Yes, virtual machines with either product are compatible, but when using Virtual Server and Virtual PC together, there are several points to consider:  

**Sound cards**:  Virtual Server does not include an emulated sound card in its virtual machines, while Virtual PC does. If you plan on using a virtual machine with both Virtual Server and Virtual PC, you should disable the emulated sound card in Virtual PC. This will prevent the sound card's Plug and Play capability from causing errors on the virtual machine that you created with Virtual Server.

**SCSI support**: Virtual Server provides SCSI support while Virtual PC does not. If you create a virtual machine with virtual SCSI disks on Virtual Server, the SCSI disks will be ignored if you move the virtual machine to Virtual PC. This can lead to negative consequences in many situations, for example if the virtual machine page file is on the SCSI disk or if you are trying to use a SCSI disk as the startup disk. If you plan to regularly move virtual hard disks between machines created with Virtual PC and Virtual Server, we recommend that you attach the virtual hard disks only to a virtual IDE bus in Virtual Server.

**CD-ROM drives**: Although Virtual Server allows for virtual machines with multiple CD-ROM drives, Virtual PC supports virtual machines with only one CD-ROM drive. If you are moving virtual machines between the two products, you should use the default setting which is a single CD-ROM drive on the virtual machine attached to secondary channel 0.

**Saved States**: Save-state (.vsv) files between Virtual PC and Virtual Server are incompatible. When moving a virtual machine between products, be sure to completely shut down the guest operating system.

**Networking**: When moving virtual machines between Virtual PC and Virtual Server, the virtual machine's network will be disconnected. You will need to configure the virtual machine's network connectivity appropriately.

---------------------------------------------------------------------------------------------------------------------------------

If after reading everything above you still don't know which product to use, start with Virtual PC because of its local interface. As a reminder,

Virtual PC 2007 can be downloaded from [here](http://www.microsoft.com/windows/products/winfamily/virtualpc/default.mspx)  
Virtual Server R2 SP1 can be downloaded from [here](http://www.microsoft.com/technet/prodtechnol/eval/virtualserver/default.mspx)

Cheers,  
Jeff

[Original link](https://blogs.technet.microsoft.com/virtualization/2007/07/23/virtual-server-or-virtual-pc/)