---
title: Windows Server virtualization at WinHEC
description: post id 3983
keywords: virtualization, blog
author: scooley
ms.date: 5/23/2006
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 
---

# Windows Server virtualization at WinHEC

Hello and welcome to the Microsoft virtual machine team's blog! On Monday the 22nd, as part of the WinHEC conference, we [announced](http://www.microsoft.com/presspass/features/2006/may06/05-22Virtualization.mspx) the next steps in our virtualization strategy and outlined our roadmap of products. As we march towards release, we are starting a team blog to discuss machine virtualization plans at Microsoft in more detail. As the Product Unit Manager for the team, I've been asked to provide the first post for the team and kick off the blog. Welcome!

In future posts I plan to talk more about Microsoft's strategy in this space, industry efforts, opportunities for our partners, what the technology is, what it can do for customers, but for the first installment I wanted to focus on the team and the technology they are building. On Monday we announced Windows Server virtualization, which was codenamed "Viridian". This will be the first release of the Windows hypervisor-based design and represents the hard work of a very talented and dedicated group of people. As part of Bill Gates opening keynote at WinHEC we publicly demoed Windows Server virtualization with the hypervisor for the first time. Jeff Woolsey and Mike Sterling did an outstanding job showing just a fraction of the amazing capabilities we have in the works. If you didn't catch the demo this morning, you can watch the webcast [here](http://www.microsoft.com/events/executives/billgates.mspx).

The virtual machine team was formed after the acquisition of Connectix a little over three years ago. Our team develops Virtual PC, Virtual Server and the Windows machine virtualization technology. We have an outstanding group of developers, testers and program managers that work on this effort. Additionally we are supported by a wide range of people across the company, including our product marketing team, PR team, sales and customer support. While all of these functions are critical for the technology's success I'm going to focus on the VM team.

During the keynote, we showed four VMs running on the hypervisor. The hypervisor runs beneath all of the operating systems running on the machine and the kernel interfaces with the hypervisor to provide the best overall performance and scalability. In many ways the hypervisor is like a kernel, it manages memory, schedules threads (virtual processors) and handled basic functionality of the system. Thus it makes total sense that the VM team is a peer to the Windows kernel team in the core operating system division. The hypervisor team and members of the kernel team work together on the development of this thin but important layer of software.

Also as part of the demo you'll also see us show off some of the dynamic features of our new I/O architecture. A major area of investment has been in the development of the new I/O architecture for virtualization. In the demo we showed the use of VMBus to hot add a NIC to a running VM with no downtime. The new I/O architecture that our device virtualization team is developing allows the hot-plug of disk and networking devices. The hot-plug features leverage the Windows Plug and Play subsystem to allow the VM configuration to be much more dynamic. Additionally, use of synthetic devices provides an optimized device model for the VM, which reduces overhead and improves performance compared with device emulation. The device virtualization team provides these new synthetic devices for disk, networking, video and input with more in the future.

Also shown in the keynote was the completely new UI for Windows server virtualization. This UI works with the virtualization stack to configure and manage the VMs via the new MMC snap-in model. The virtualization stack provides a standards-based management API for all management components to interface with. The virtualization stack team is working with other virtualization vendors and our partners to define this industry standard API as part of the DMTF. While the virtualization stack provides the API to the rest of the ecosystem, it also has many features of its own. In future posts we'll talk about its clustering capabilities, snapshotting, and live migration of VMs between hosts just to name a few. The virtualization stack team has the unique challenge of developing technology that goes from a C# based UI to driver level interfaces with the hypervisor but they make it all look easy.

As you can see there are many facets to the platform we are building. As we move towards private beta at the end of the year, we will be providing more details on the technology. Most of the team's PMs will be blogging about the effort, but this only represents a fraction of the extended team. It is the VM team that will be bringing this platform to you and I wanted to make sure their hard work is recognized! Congratulations to the team on a successful public unveiling! We are all looking forward to the day when everyone has the opportunity to use our work!

Sincerely,  
Mike Neil  
Product Unit Manager, Windows Virtualization

[Original post](https://blogs.technet.microsoft.com/virtualization/2006/05/23/windows-server-virtualization-at-winhec/)