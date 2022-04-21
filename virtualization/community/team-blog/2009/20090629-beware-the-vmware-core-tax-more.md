---
title:      "Beware The VMware Core Tax & More"
description: Two factors that have fueled virtualization have been the rise of 64-bit (x64) computing and the rapid growth of multi-core processors.
author: scooley
ms.author: scooley
date:       2009-06-29 02:18:00
ms.date: 06/29/2009
categories: hp
---
# Beware The VMware Core Tax & More

Virtualization Nation,

We'd like to again offer congratulations to [AMD on the release of their new 6-core Opteron ("Istanbul") processors](http://sites.amd.com/us/atwork/promo/Pages/six-core-opteron.aspx). [As Bryon mentioned](https://blogs.technet.com/virtualization/archive/2009/06/09/Windows-Server-2008-R2-Hyper_2D00_V-and-AMD_2700_s-6_2D00_core-Opteron.aspx), Hyper-V R2 goes hand in hand with these new processors with support for AMD's Rapid Virtualization Indexing, advanced power savings with Core Parking and, of course, more cores means compute resources to run more virtual machines. In fact, two factors that have fueled virtualization have been the rise of 64-bit (x64) computing and the rapid growth of multi-core processors.

**Bring On The Cores**

Even an entry level laptop these days is dual-core. On desktops, the news is even better. I saw an ad in the paper a few days ago for a very powerful HP desktop system with an AMD quad-core processor and 8 GB of memory that runs Hyper-V like a champ for $600. Well, the news is only getting better. Our partners at AMD and Intel are continuing to ratchet up the core counts and if you've been reading any of the popular tech sites around the web you may have read that we'll soon be seeing processors with **_8+ cores per processor_**. That's a tremendous amount of compute power. In fact, with all this compute power, you're going to be more inclined to virtualize than ever. This is great news for our customers who are trying to lower cost.

However, one question that has hit our inboxes recently has been, "Does Hyper-V have a core tax?"

Huh?

**Core Tax? What's that?**

At Microsoft, we don't license per core, generally, we license per server or per processor. In this case of Windows Server:

  * Windows Server 2008 Standard is licensed _per physical server_ and supports up to 4 physical processors **_whether there are 1, 2, 4, 6 or 8+ cores per processor_**
  * Windows Server 2008 Enterprise Edition is licensed _per physical server_ up to 8 physical processors **_whether there are 1, 2, 4, 6 or 8+ cores per processor_**
  * Windows Server 2008 Datacenter Edition is licensed _per processor_ _**whether there are 1, 2, 4, 6 or 8+ cores per processor**_



**_This is great for our customers_**. As they invest in newer hardware with greater capabilities, performance, scalability there's no penalty for moving to the latest cutting edge systems with ever increasing core counts. After being questioned about a "core tax," I looked into why this was being asked.

Now I know.

**VMware & The Core Tax**

With VSphere, VMware only supports 6 cores per processor for most of their versions. If you want support for more than 6 cores per processor you have to upgrade from:

  * Standard ($795 per processor) to Advanced ($2245 per processor) **a _282% increase_** (no, that's not a typo) OR 
  * Enterprise ($2875 per processor) to Enterprise Plus ($3495 per processor) **a _22% increase_**



Ouch.

From their website:

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NoHyperVCoreTaxHere_BADB/image_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/NoHyperVCoreTaxHere_BADB/image_3.png)

 

**What do Analysts Think?**

In a recent blog, Scott Lowe (virtualization analyst) wrote:

> _What's up with Advanced having a 12-core limit, but Enterprise having a 6-core limit? Because existing VI3 Enterprise customers will be grandfathered into vSphere 4 Enterprise if they have an active SnS [VMware Support and Subscription], this strikes me as nothing more than an attempt to **extort** more licensing fees._

Extort? Ouch.

**How The Enterprise Plus SKU Affects Enterprise Customers**

With vSphere, VMware created a new, higher end tier, Enterprise Plus, so that Enterprise customers, who used to be the top tier customers and paid for a VMware Support and Subscription (SnS) contract to be eligible for free major and minor version upgrades, are finding that they will _**have to pay for an upgrade to Enterprise Plus**_ when they decide to move to newer more powerful hardware with more cores. Thus, the **Core Tax for VMware users.**

**What Do VMware Customers Think?**

From [HERE](http://searchservervirtualization.techtarget.com/news/article/0,289142,sid94_gci1359167,00.html). 

> _The enforced SnS renewal is particularly galling for companies that just recently renewed their contracts, said Andrew Storrs, and independent consultant in Vancouver, Canada. "It's not so bad if you only have six months left [on SnS], but what if you have 2.5 years left?" To take advantage of the upgrade promotion, IT managers are in the awkward position of having to ask to for more money for their SnS, "just for the privilege of using a normal [VMware] edition next year."_
> 
> _"A lot of people are pretty p@#$%d about it," he added._

**What about VMware "Standard" Customers?**

In addition, VMware has very quietly _removed_ some features (such hot add virtual disks) that used to be in VMware Standard and pushed those up to Advanced. _**_So, VMware Standard customers are LOSING FUNCTIONALITY "upgrading" to VSphere_. If you want those hot add capabilities back, VMware Standard Customers will need to pay for an upgrade from VSphere Standard ($795 per processor) to Advanced ($2245 per processor). **_

_**A 282% increase.**_

Think that's bad? VMware didn't stop there.

**The News Gets Worse (Hope You're Sitting Down)**

Two things that are interesting:

  1. It's odd that Enterprise Edition supports fewer cores per processor than Advanced. Paying more and getting less isn't exactly customer friendly. **To add insult to injury, _VMware is dropping the Enterprise SKU altogether this year to force customers to purchase an upgrade to Enterprise Plus_. ([HERE](http://searchservervirtualization.techtarget.com/news/article/0,289142,sid94_gci1359167,00.html) & [HERE](http://technodrone.blogspot.com/2009/04/will-we-be-forced-to-pay-more-pt-2.html)) Double ouch**. 
  2. It's also interesting that VMware caps the number of cores per processor at 12. What happens when a processor comes out that includes more than 12 cores? 16? 24? 32? More? Will that require an upgrade to _Enterprise Super Plus_?



I'll let you draw your own conclusions, but VMware's track record speaks for itself.

**CUSTOMERS: FIRST & FOREMOST**

**No Core Tax**. At Microsoft, we don't license per core, generally, we license per server or per processor. When we do license per processor, it's per _processor_ regardless of how many cores are present. I should also point out that the **_[FREE standalone Microsoft Hyper-V Server 2008 R2 supports up 8 physical processors whether there are 1, 2, 4, 6 or 8+ cores per processor](https://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx)_** ** __**as well.

Read that last sentence again.

**Microsoft Enterprise Customers with Software Assurance** : For our valued customers that purchased Windows Server 2008 with their Microsoft Enterprise Agreement & Software Assurance, here's **just a fraction of the new Hyper-V R2 capabilities** you'll be receiving with your upgrade to Windows Server 2008 R2 **__included_ as part of your agreement_** :

  * Live Migration 
  * Major Scalability Boosts 
  * Green IT Enhancements 
  * 10 Gb/E Ready 
  * Cluster Shared Volumes 
  * Hot Add Virtual Disks 
  * and this is just for starters



In addition, I **haven't even started discussing the new capabilities in Windows Server 2008 R2** outside of Hyper-V such as:

  * Powerful Hardware and Scaling Capabilities 
  * Reduced Power Consumption 
  * Connection Broker for a Virtual Desktop Infrastructure (VDI) 
  * Ubiquitous Remote Access 
  * Improved Branch Office Performance and Management 
  * Simplified Management for SMBs 
  * Remote Application and Desktop Access 
  * and much, much more



**__included_ as part of your agreement._** That's taking care of your customers.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
