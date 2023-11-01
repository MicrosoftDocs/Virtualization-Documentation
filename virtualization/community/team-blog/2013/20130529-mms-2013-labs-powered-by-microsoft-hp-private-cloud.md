---
title:      "MMS 2013 Labs&#58; Powered by Microsoft/HP Private Cloud..."
author: sethmanheim
ms.author: mabrigg
description: MMS 2013 Labs, Powered by Microsoft/HP Private Cloud
ms.date: 05/29/2013
date:       2013-05-29 06:54:00
categories: uncategorized
---
# MMS 2013 Hands On Labs

Virtualization Nation,

A few weeks ago we held the annual 2013 Microsoft Management Summit in Las Vegas. As in years past, the event sold out quickly and it was a very busy week. To everyone that attended, our sincere thanks. 

As usual, the hands-on labs and instructor-led labs continue to be some of the most popular offerings at MMS. MMS Labs offer folks the opportunity to kick the tires on a wide array of Microsoft technologies and products. As usual the lines started early. For the fourth year in a row, all of the MMS Labs were 100% virtualized using Windows Server Hyper-V and managed via System Center by our partners at Xtreme Consulting Group and using HP servers and storage. Of course, this year we upgraded to the latest version so everything was running on a Microsoft Cloud powered by Windows Server 2012 Hyper-V and System Center 2012 SP1.

(BTW, I’ve blogged about this topic in the past years, if you’re interested the links are [here](https://techcommunity.microsoft.com/t5/virtualization/mms-2010-labs-powered-by-hyper-v-system-center-hp/ba-p/381766) and [here](https://techcommunity.microsoft.com/t5/virtualization/mms-2011-labs-powered-by-hyper-v-system-center-hp/ba-p/381842).) Before I jump into the Microsoft Private Cloud, let me provide some context about the labs themselves.

**What is a MMS  Hand On Lab?**

One of the reasons the MMS Hands on Labs are so popular is because it’s a firsthand opportunity to evaluate and work with Windows Server and System Center in a variety of scenarios at your own pace. Here’s a picture of some of the lab stations…

<!-- [![Picture of lab stations](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8182.1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8182.1.png) -->

With the hands on labs, we’ve done all the work to create these scenarios based on your areas of interest. So, what does one of these labs look like on the backend? Let’s be clear, none of these labs are a single VM. That’s easy. Been there, done that. When you sit down and **_request_** a specific lab, the cloud infrastructure provisions the lab on **_highly available_** infrastructure and deploys **_services_** that can be anywhere from 4  – 12 virtual machines in your lab in **_seconds_**. There are over 650 different lab stations and we have to account for all types of deployment scenarios. For example,

  1. In the first scenario, all users sit down at 8 am and provision exactly the same lab. Or,
  2. In the second scenario, all users sit down at 8 am and provision unique, different labs. Or,
  3. In the third scenario, all users sit down at 8 am and provision a mix of everything



The lab then starts each lab in a few **_seconds_**. Let ’s take a closer look at what some of the labs look like in terms of VM deployment. 

**MMS Lab Examples**

Let’s start off with a relatively simple lab. This first lab is a Service Delivery and Automation lab. This lab uses:

  1. Four virtual machines
  2. 16 virtual processors
  3. 15 GB of memory total
  4. 280 GB of storage
  5. 2 virtual networks



…and here’s what each virtual machine is running…

<!-- [![what each virtual machine is running](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3187.2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3187.2.png) -->

 

Interested in creating virtualizing applications to deploy to your desktops, tablets, Remote Desktop Sessions? This next lab is a Microsoft Application Virtualization (App-V) 5.0 Overview lab. This lab uses:

  1. Seven virtual machines
  2. 14 virtual processors
  3. 16 GB of memory total
  4. 192 GB of storage
  5. 2 virtual networks 



 <!--[![What te lab uses](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2703.3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2703.3.png) -->

How about configuring a web farm for multi-tenant applications? Here’s the lab which uses:

  1. Six virtual machines
  2. 24 virtual processors
  3. 16 GB of memory total
  4. 190 GB of storage
  5. 2 virtual networks



<!--[![Configuring a web farm for multi-tenant applications](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5707.4.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5707.4.png) -->

 

Ever wanted to enable secure remote access with RemoteApp, DirectAccess and Dynamic Access Control? Here’s the lab you’re looking for. This lab uses:

  1. Seven virtual machines
  2. 28 virtual processors
  3. 18 GB of memory total
  4. 190 GB of storage
  5. 2 virtual networks



 <!--[![Enabling secure remote access](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3716.5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3716.5.png) -->

Again, these are just a few of the dozens of labs ready for you at the hands on labs. ****

**MMS 2013 Private Cloud: The Hardware**

BTW, before I get to the specifics, let me point out that this Microsoft/HP Private Cloud Solution is an orderable solution available today...

**Compute.** Like last year, we used two HP BladeSystem c7000s for compute for the cloud infrastructure. Each c7000 had 16 nodes and this year we to upgraded to the latest BL460c Generation 8 Blades. All 32 blades were then clustered to create a 32 node Hyper-V cluster. Each blade was configured with:

  1. Two sockets with 8 cores per socket and thus 16 cores. Symmetric Multi-Threading was enabled and thus we had a total of 32 logical processors per blade.
  2. 256 GB of memory per blade with Hyper-V Dynamic Memory enabled
  3. 2 local disks 300 GB SAS mirrored for OS Boot per blade
  4. HP I/O Accelerator cards (either 768 GB or 1.2 TB) per blade



**Storage**. This year we wanted to have a storage backend that could take advantage of the latest storage advancements in Windows Server 2012 (such as Offloaded Data Transfer and SMI-S) so we decided to go with a 3Par StoreServ P10800 storage solution. The storage was configured as a 4 node, scale-out solution using 8 Gb fibre channel and configured with Multi-Path IO and two 16 port FC switches for redundancy. There was a total of 153.6 TB of storage configured with:

  1. 64 x 200 GB SSD disks
  2. 128 x 600 GB 15k FC disks
  3. 32 x 2 TB 7200k RPM SAS



As you can see, the 3Par includes SSD, 15k and 7200k disks. This is so the 3Par can provide automated storage tiering with HP’s Adaptive Optimization. With storage tiering, this ensures the most frequently used storage (the hot blocks) reside in the fastest possible storage tier whether that’s RAM, SSD, 15k or 7200k disks respectively. With storage tiering you can mix and match storage types to find the right balance of capacity and IOPs for you. In short, storage tiering rocks with Hyper-V. From a storage provisioning perspective, both SCVMM and the 3Par storage both support standards based storage management through SMI-S so the provisioning of the 3Par storage was done through System Center Virtual Machine Manager. Very cool.

**Networking**. From a networking perspective, the solution used VirtualConnect FlexFabric 10Gb/E and everything was teamed using Windows Server 2012 NIC Teaming. Once the network traffic was aggregated in software via  teaming, that capacity was carved up in software.

**Time for the Pictures …**

Here’s a picture of the racks powering all of the MMS 2013 Labs. The two racks on the left with the yellow signs are the 3Par storage while the two racks on the right contain all of the compute nodes (32 blades) and management nodes (a two node System Center 2012 SP1 cluster). What you don’t see are the crowds gathered around pointing, snapping pictures, and gazing longingly…

<!-- [![the racks powering all of the MMS 2013 Labs](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1588.6.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1588.6.png) -->

 

**MMS 2013: Management with System Center**. Naturally, the MMS team used System Center to manage all the labs, specifically Operations Manager, Virtual Machine Manager, Orchestrator, Configuration Manager, and Service Manager. System Center 2012 SP1 was completely virtualized running on Hyper-V and was running on a small two node cluster using DL360 Generation 8 rackmount servers.

Operations Manager was used to monitor the health and performance of all the Hyper-V labs running Windows and Linux. Yes, I said Linux. Linux runs great on Hyper-V (it has for many years now) and System Center manages Linux very well… J To monitor health proactively, we used the ProLiant and BladeSystem Management Packs for System Center Operations Manager. The HP Management Packs expose the native management capabilities through Operations Manager such as:

  * Monitor, view, and get alerts for HP servers and blade enclosures
  * Directly launch iLO Advanced or SMH for remote management
  * Graphical View of all of the nodes via Operations Manager



In addition, 3Par has management packs that plug right into System Center, so Operations Manager was used to manage the 3Par storage as well…

 <!--[![In addition, 3Par has management packs that plug right into System Center, so Operations Manager was used to manage the 3Par storage as well](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6371.7.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6371.7.png)-->

 

…having System Center integration with the 3Par storage came in handy when one of the drives died and Operations Manager was able to pinpoint exactly what disk failed and in what chassis…

<!-- [![having System Center integration with the 3Par storage came in handy when one of the drives died and Operations Manager was able to pinpoint exactly what disk failed and in what chassis](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7612.8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7612.8.png) -->

 

Of course, everything in this Private Cloud solution is fully redundant so we didn’t even notice the disk failure for some time…

In terms of managing the overall solution, here’s a view of some of the real time monitoring we were displaying and where many folks just sat and watched.

<!--[![real time monitoring](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/4628.9.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/4628.9.png) -->

 

Virtual Machine Manager was used to provision and manage the entire virtualized lab delivery infrastructure and monitor and report on all the virtual machines in the system. In addition, HP has written a Virtual Machine Manager plug-in so you can view the HP Fabric from within System Center Virtual Machine Manager. Check this out:

<!--[![Virtual machine manager](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5734.10.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5734.10.png) -->

 

It should go without saying that to support a lab of this scale and with only a few minutes between the end of one lab and the beginning of the next, automation is a key precept. The Hands on Lab team was positively gushing about PowerShell. “In the past, when we needed to provide additional integration it was a challenge. WMI was there, but the learning curve for WMI is steep and we’re system administrators. With PowerShell built-into WS2012, we EASILY created solutions and plugged into Orchestrator. It was a huge time saver.”

**MMS 2013: Pushing the limit …**

As you may know, Windows Server 2012 Hyper-V supports up to 64 nodes and 8,000 virtual machines in a cluster. Well, we have a history for pushing the envelope with this gear and this year was no different. At the very end of the show, the team fired up as many virtual machines to see how high we could go. (These were all lightly loaded as we didn’t have the time to do much more…) On Friday, the team fired up 8,312 virtual machines (~260 VMs per blade) running on a 32 node cluster. Each blade has 256 GB of memory each and we kept turning on VMs until all the memory was consumed.

**MMS 2013: More data …**

  * Over the course of the week, over 48,000 virtual machines were provisioned. This is ~8,000 more than last year. Here’s a quick chart. Please note that Friday is just a half day…



<!--[![Over the course of the week, over 48,000 virtual machines were provisioned](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2018.11.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2018.11.png) -->

  * Average CPU Utilization across the entire pool of servers during labs hovered around 15%. Peaks were recorded a few times at ~20%. In short, even with thousands of Hyper-V VMs running on a 32 node cluster, we were barely taxing this well architected and balanced system.
  * While each blade was populated with 256 GB, they weren’t maxed. Each blade can take up to 384 GB.
  * Storage Admins: Disk queues for each of the hosts largely remained at **1.0** (1.0 is nirvana). When 3200 VMs were deployed simultaneously, the disk queue peaked at **1.3**. Read that again. Show your storage admins. (No, those aren ’t typos.)
  * The HP I/O Accelerators used were the 768 GB version and 1.2 TB versions. The only reason we used a mix of different sizes because that’s what we had available.
  * All I/O was configured for HA and redundancy.
    * Network adapters were teamed with Windows Server 2012 NIC Teaming
    * Storage was fibre channel and was configured with Active-Active Windows Server Multi-Path I/O (MPIO). None of it was needed, but it was all configured, tested and working perfectly.
  * During one of the busiest days at MMS 2013 with over 3500 VMs running simultaneously, this configuration wasn’t even breathing hard. It’s truly a sight to behold and a testament to how well this Microsoft/HP Private Cloud Solution delivers.



From a management perspective, System Center was the heart of the system providing health monitoring, ensuring consistent hardware configuration and providing the automation that makes a lab this complex successful. At its peak, with over 3500 virtual machines running, you simply can’t work at this scale without pervasive automation.

From a hardware standpoint, the HP BladeSystem and 3Par storage are simply exceptional. Even at peak load running 3500+ virtual machines, we weren’t taxing the system. Not even close. Furthermore, the fact that the HP BladeSystem and 3Par storage integrate with Operations Manager, Configuration Manager and Virtual Machine Manager provides incredible cohesion between systems management and hardware. When a disk unexpectedly died, we were notified and knew exactly where to look. From a performance perspective, the solution provides a comprehensive way to view the entire stack. From System Center we can monitor compute, storage, virtualization and most importantly the workloads running **_within_** the VMs. This is probably a good time for a reminder …

If you’re creating a virtualization or cloud infrastructure, the best platform for Microsoft Dynamics, Microsoft Exchange, Microsoft Lync, Microsoft SharePoint and Microsoft SQL Server is Microsoft Windows Server with Microsoft Hyper-V managed by Microsoft System Center. This is the best tested, best performing, most scalable solution and is supported end to end by Microsoft.

**One More Thing...**

Finally, I’ve been talking about Windows Server and System Center as part of our Microsoft Private Cloud Solution. I’d also like to point out that Windows Server 2012 Hyper-V is the same rock-solid, high performing and scalable hypervisor we use to power Windows Azure too.

Read that again.

That’s right. Windows Azure is powered by Windows Server 2012 Hyper-V. See you at TechEd.

Jeff Woolsey  
Windows Server & Cloud

P.S. Hope to see you at the Hands on Lab at TechEd!

**** 

**More pictures below …**

Here’s a close up of one of the racks. This rack has one of the c7000 chassis with 16 nodes for Hyper-V. It also includes the two managements heads clustered used for System Center. At the bottom of the rack are the Uninterruptible Power Supplies.

 <!-- [![a close up of one of the racks](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5824.12.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5824.12.png) -->

 

 …and here’s the back of one of the racks that held a c7000…

 <!--[![the back of one of the racks that held a c7000](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5807.13.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5807.13.png)-->

 

HP knew there was going to be a lot of interest, so they created full size cardboard replicas diagraming the hardware in use.

<!-- [![full size cardboard replicas diagraming the hardware in use](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2630.14.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/2630.14.png) -->

…and here’s one more…

<!--  [![more of the full size cardboard replicas diagraming the hardware in use](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1258.15.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1258.15.png) -->

 

 

 

 
