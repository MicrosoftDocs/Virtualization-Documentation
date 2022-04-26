---
title:      "Microsoft Hyper-V Server 2008 R2 RTM & More."
description: Microsoft Hyper-V Server 2008 R2 RTM post announcement quotes and boot from flash.
author: mattbriggs
ms.author: mabrigg
date:       2009-07-30 14:14:00
ms.date: 07/30/2009
categories: uncategorized
---
# Microsoft Hyper-V Server 2002 R2 Overview and Announcements
Virtualization Nation,

It's been a very good busy since the Windows Server 2008 R2 & Microsoft Hyper-V Server 2008 R2 RTM announcements. We're pleased that these releases have been warmly met by our early adopter customers and industry analysts alike. A few quotes include:

> _**"Market dominant VMware has something to fear." -PC Magazine**_
> 
> _**"Unlike VMware's offering, [Hyper-V] Live Migration doesn't cost extra and isn't particularly difficult to configure." -ZDNet**_
> 
> " ** _Windows Server 2008 R2 is Microsoft's Best-Ever Server OS." ChannelWeb_**

In short, Windows Server 2008 R2 is getting rave reviews and Hyper-V is just one part of this extraordinary server release. For more info on the all up [Windows Server 2008 R2 release](https://blogs.technet.com/windowsserver/archive/2008/10/28/announcing-windows-server-2008-r2.aspx), here's a good blog and for more on [Windows Server 2008 R2 Hyper-V check out this blog](https://blogs.technet.com/virtualization/archive/2009/07/22/windows-server-2008-r2-hyper-v-server-2008-r2-rtm.aspx).

**Thanks To The Folks At Veeam**

I'd also like give a shout out to the folks at Veeam. We're pleased by their announcement that their [developing solutions for Windows Server 2008 R2 Hyper-V and Microsoft Hyper-V Server 2008 R2](https://blogs.technet.com/virtualization/archive/2009/07/23/r2-veeam-too.aspx). [While VMware is dissuading companies from developing for their free ESXi](http://searchservervirtualization.techtarget.com/news/article/0,289142,sid94_gci1358344,00.html) and making many question whether the free version is even supported or not, we are actively encouraging developers to develop for both Windows Server 2008 R2 Hyper-V and the free Microsoft Hyper-V Server 2008 and yes, MS Hyper-V Server 2008 R2 is a fully supported offering. Speaking Of Microsoft Hyper-V Server 2008 R2.

**Microsoft Hyper-V Server 2008 R2 RTM Overview**

With our customers input first and foremost, we developed Microsoft Hyper-V Server 2008 R2 to meet their requirements and you can see the results are dramatic. 

 

[![Physical processor support image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_thumb_5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_12.png)

Let me be very clear about line 1 "physical processor support" above. That refers to the number of **physical processors (sockets)** that Hyper-V Server supports, regardless of how many cores each processor up to a total of 64 logical processors. So, no [Core Tax here](https://blogs.technet.com/virtualization/archive/2009/06/28/Beware-the-VMware-Core-Tax-and-More.aspx). 

**One More Thing.**

One thing our customers and partners requested was the ability to boot from flash. Customers told us they would like to purchase a server from their hardware partner of choice with Hyper-V included and they wanted the ability to choose whether it was on traditional spinning media or flash media. 

You got it. 

**_ANNOUNCING: MICROSOFT HYPER-V SERVER 2008 R2 BOOT FROM FLASH!_**

Microsoft Hyper-V Server 2008 R2 includes the unique ability (compared to Windows Server Hyper-V) to boot from flash. We're making the documentation available to our OEM partners as part of the OEM Preinstallation Kit (OPK). Boot from flash is specifically designed for our OEM partners who want to ship an embedded Hyper-V hypervisor and thus will be supported via our OEM partners. 

**Microsoft Hyper-V Server 2008 R2 Features**

**Live Migration[![Live Migration image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_2.png)**

  * #1 Customer Requested Feature 
  * [Processor Compatibility Mode](https://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)



**New Processor Support**

  * Improved Performance 
  * Lower Power Costs



**[Enhanced Scalability (4x Improvement)](https://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)**

  * [Support for 64 Logical Processors](https://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)
  * Support for up to 384 Running VMs or up to 512 virtual processors 
  * Greater VM Density 
  * Lower TCO



**Networking Enhancements**

  * Improved Network Performance 
  * 10 Gb/E Ready



**Dynamic Virtual Machine Capabilities**

  * Live Migration 
  * Hot Add/Remove Virtual Storage



**Boot From Flash**

**Usability Enhancements**

  * SCONFIG Enhancements



 

In short, Microsoft Hyper-V Server 2008 R2 addresses all the top customer asks: Live Migration, High Availability, Major Scalability Improvements **and much more all while keeping it FREE**. VMware's isn't even close to matching this value. 

**The Cost Of Live Migration**

A few weeks ago, I blogged how [Microsoft Hyper-V Server 2008 R2 would include Live Migration and High Availability at no cost. No strings attached](https://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx). I did a simple comparison showing how much it costs to get Live Migration capability from Microsoft and VMware. Here's the summary:

 

[![Diagram displaying the cost of migration](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_thumb_3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/2e228c9394fd_6A6B/image_8.png)

Since I wrote that blog, I've read interesting articles where VMware is trying to divert the discussion as far from cost as far as possible and trying to develop new and interesting ways to justify the fact that VMware Live Migration costs a minimum of $2245 per processor. Despite the fact that $13,470, $26,940, $22,450 and $44,900 in licensing costs to use Live Migration are greater than $0, VMware claims to cost less.

(As a reminder, the numbers above are just the cost (tax) of the _**_virtualization layer_**_. This doesn't include hardware, storage or any of software running within the VM.)

**What Do The Analysts Think?**

Here's a quote from a recent article (May 2009), on ServerWatch from Schorschi Decker: 

> _... **VMware just costs way too much**. This view of mine was reinforced in a recent meeting with VMware, where the discussion of VMware feature set, and the associated pricing became, well, to be fair, enthusiastic to be sure. It was professional, it was honest, and it was quite clear, **_that VMware was not hearing us_**. VMware has for the last 5 or 6 years, continued to add features, failed to enhance existing features in reference to scale and scope, for enterprise clients._

**Let's Look At This Another Way**

I thought I'd look at this from a completely different viewpoint. Simply stated:

**_With the money saved by using our freely available_**

**_Microsoft Hyper-V Server 2008 R2,_**

**_how much server hardware could you purchase?_**

**Server Hardware Anyone?**

I went up to HP.com a few weeks ago and spec'd out a few systems at various price points. Here are a few guidelines I used when I spec'd out these systems:

  * a minimum of 2 GB of memory per core 
  * a local drive for boot from because when you use Live Migration, virtual machines reside on shared storage 
  * added a quad-port 1Gb/E to all configurations to help mitigate against network I/O bottlenecks 
  * on the high end system added a dual-port 8 Gb FC card to use with Multi-Path IO (MPIO) to enable failover and aggregation at the storage I/O layer



_(BTW: Third party MPIO support from VMware jacks up the price yet again forcing you to the Enterprise Plus Edition at $3495 per processor which raises the price in the table above from ** _$44,900 to $69,900 (a 56% increase)_** , but I digress.)_

**Server Configurations**

**Configuration 1: For $13,833 ($4611 each), you could buy _three HP ProLiant DL360 G5 servers_ , each configured with**

* Dual socket/Quad-Core Intel Xeon Processors E5405, each configured with 
  * 16 GB of memory 
  * 72 GB 10,000 RPM Drive 
  * Dual 1Gb/E 
  * Quad Port 1Gb/E PCI-E NIC 
  * Redundant Power Supply



OR

**Configuration 2: For $15,606 ($5202 each), you could buy _three HP ProLiant DL365 G5 servers_ , each configured with**

  * Dual socket/Quad-Core AMD Opteron Processors x2356 
  * 16 GB of memory 
  * 72 GB 10,000 RPM Drive 
  * Dual 1Gb/E 
  * Quad Port 1Gb/E PCI-E NIC 
  * Redundant Power Supply



OR

**Configuration 3: For $21,291 ($7097 each), you could buy _three HP ProLiant DL360 G6 servers_ , each configured with**

  * Dual socket/Quad-Core Intel Xeon Processors x5550 
  * 16 GB of memory 
  * 72 GB 10,000 RPM Drive 
  * Dual 1Gb/E 
  * Quad Port 1Gb/E PCI-E NIC 
  * Redundant Power Supply



OR

**Configuration 4: For $45,900 (15,300 each), _three HP ProLiant DL 585 G5 servers_ , each configured with**

  * Quad socket/Quad-Core AMD Opteron Processors x8354 
  * 32 GB of memory 
  * 72 GB 10,000 RPM Drive 
  * Dual 1Gb/E 
  * Quad Port 1Gb/E PCI-E NIC 
  * Dual Port 8 Gb PCI-E Fiber Channel 
  * Redundant Power Supply



That's a heck of a lot of incredibly powerful, server systems to choose from. By using Hyper-V instead of VMware you can use the substantial $$$$ saved to reinvest in new server hardware. At this point, you just need to pick out a SAN. 

**Failover Cluster Configuration Program**

One commonly asked question we hear is, "Do I need special storage to work with Live Migration? Is there a special Hyper-V Logo program?" NO. There are a couple of different options. To make things easy, you can choose a SAN that's validated via the [Failover Cluster Configuration Program (FCCP)](https://www.microsoft.com/windowsserver2008/en/us/failover-clustering-program-partners.aspx) from our partners like Compellent, Dell, EMC, Fujitsu, Fujitsu Siemens, Hitachi, IBM, NetApp ([Microsoft Storage Partner of the Year](https://www.microsoft.com/presspass/press/2009/jun09/06-24POTY09PR.mspx)) or NEC for starters and you're ready to go. That said, FCCP is not required for support. Windows offers the largest, broadest ecosystem and our customers like having multiple options based on their business needs. To see if your storage is supported for Hyper-V Live Migration and Failover Clustering all you need to do is run the [Microsoft Cluster Validate Tool provided in the OS to insure that the cluster is validated and thus supported](https://technet.microsoft.com/library/cc732035\(WS.10\).aspx). 

**Customers Win**

In short, Microsoft Hyper-V Server 2008 R2 delivers more of everything compared to Microsoft Hyper-V Server 2008 V1: 

  * Capabilities 
  * Efficiency 
  * Performance 
  * Scalability 
  * Flexibility 
  * Ease of use



and Microsoft Hyper-V Server 2008 R2 also happens to be the ideal foundation for a VDI infrastructure.

More on that in a future blog.

Cheers,

> __

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
