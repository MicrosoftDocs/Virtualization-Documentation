---
title:      "Guest post&#58; &#34;Does my enterprise need internal cloud computing?&#34;"
description: With the latest announcement that I can buy an “Internal Cloud” for only $3,495 per CPU, I figured I’d share my thoughts about the real vs. perceived benefits of this new private compute cloud idea.
ms.date: 04/23/2009
date:       2009-04-23 11:45:00
categories: cloud-computing
---
# Guest post: Does my enterprise need internal cloud computing?

As the president and COO of a datacenter-based managed server provider, I’m constantly on the hunt for leading edge technology. I peruse every new IT technology announcement for the next cost-effective solution, for both internal needs, and for hosted solutions we can use to help customers.      

In my [previous blog](https://blogs.technet.com/virtualization/archive/2009/02/09/guest-post-virtualization-drives-250-000-in-real-savings.aspx "David Straede blog"), I talked about how cool Microsoft’s virtualization turned out to be, saving SBWH, and therefore our customers, time and money.  I started my virtualization research with VMware, but quickly became a fan of Hyper-V, ultimately deploying it in many production systems.  As a result of my experience, I get asked by industry analysts, press, and investors, “Why not VMware?”  With Palo Alto’s latest announcement that I can buy an “Internal Cloud” for only $3,495 per CPU, I figured I’d share my thoughts about the real vs. perceived benefits of this new private compute cloud idea.

Let me say that the private cloud concept seems to be more marketing than architecture.  The private cloud has many of the same load balancing, storage management, and provisioning that virtualization already offers.  Based on how the private cloud has been described so far, I have to say that the emperor, although not totally naked, seems somewhat thinly attired. 

Is this private cloud thing good for IT? The short answer is, money being no object, and assuming private cloud computing actually delivers something unique, maybe.  The long answer, based on the cards played so far, is no.  SBWH is not a fortune 100 company, and in this economy, we evaluate every cost.  We don’t have thousands of physical servers, and we don’t store 10 billion photos.  If I read the press release correctly, vSphere’s “private cloud” lets me combine, say, thirty-two 16-CPU servers and $1.8 million dollars in Enterprise Plus licensing, along with abundant training for a new tool set, to achieve “the mainframe of the 21st century.”  

I just don’t think SBWH needs that.

But wait…I’m a service provider and have been told that, over time, VMware will support such provider-centric features as federation between internal and external clouds.  However, these are promises and conceptual things, not capabilities delivered. I guess when _that_ time comes, we will see if the private cloud has something special to offer.

For now, SBWH will stick with Hyper-V.  We have highly available virtual machine clusters in production that automatically move virtual machines to new hosts if hardware fails, and will have live migration and load balancing in production this year.   Oh, and it’s all private. Already.

David Straede, president, SBWH.com

Microsoft case study [here](https://www.microsoft.com/casestudies/casestudy.aspx?casestudyid=4000002983 "MS case study on SBWH")
