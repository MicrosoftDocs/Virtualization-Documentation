---
title:      "Guest post&#58; Storage Loves Dynamic Memory"
description: A guest post by Alex Miroshnichenko of Virsto Software, about Dynamic Memory.
author: mabriggs
ms.author: mabrigg
date:       2010-09-14 09:32:00
ms.date: 09/14/2010
categories: dynamic-memory
---
# Guest post: Storage Loves Dynamic Memory

Hi, I’m Alex Miroshnichenko, chief technology officer of [Virsto Software](https://virsto.com/). One of the most exciting events of my summer was the announcement of Microsoft Windows Server 2008 R2 Service Pack 1 (SP1). Though still in beta, SP1’s stability has lived up to production standards in Virsto’s test labs.

SP1 brings Dynamic Memory to Microsoft Hyper-V.  In practical terms, you should be able to run meaningfully more virtual machines on the same server hardware, since static memory limits are gone.

Dynamic Memory also eliminates a key argument that competitors have held against Hyper-V. We should not expect the competition to stop the FUD completely. However, it will become increasingly difficult to use the “memory overcommit” argument against Hyper-V being a true enterprise grade virtualization solution.

Why would a storage guy like me be so excited about dynamic memory? It is rather straightforward: now that memory is no longer an issue for increasing virtual machine (VM) density per physical host, the next major obstacle becomes the storage architecture. The technology we have developed at Virsto Software removes that obstacle. 

Virtualized hosts drive storage traffic differently than physical servers because they run multiple instances of independent operating system (OS) images. We call this effect the “[VM I/O Blender](https://virsto.com/solutions/storage-performance-problems)”. Each OS instance optimizes its I/O patterns on the assumption it owns the hardware; however, the virtual machine hardware itself is virtual. The I/O streams are “blended” in the  virtualization layer, making the I/O pattern through the physical storage interconnect highly random. As we all know, storage devices are much worse at random I/O than sequential – as much as two orders of magnitude slower.

The more virtual machines per physical server, the more random the storage I/O stream becomes, and the more the VM I/O Blender will hinder server performance. Half, even 80%, of a server’s storage throughput can be lost.

How might you solve this problem? The simplest (and may I say the worst) way is to throw money at the problem: buy expensive storage. And when I say “expensive” I mean it.  A smarter way is to install a storage software solution that is specifically designed to handle the unique storage I/O patterns and lifecycle of virtual machines. By removing storage bottlenecks, Virsto One software for Hyper-V can deliver three to four times the effective VM density while providing other [features](https://www.virsto.com/products) essential for VM storage management. 

The VM I/O Blender is an artifact of _all_ hypervisors, easily demonstrated on any virtualization platform. We ’re pleased to be working with Microsoft to obliterate it on Hyper-V. We have performance comparisons using Hyper-V with Virsto One versus competitive hypervisors that spew about “memory overcommit advantages”: Hyper-V is several _times_ faster. Try it for yourself.

Alex
