---
title:      "Hypervisor Footprint Debate Part 1 UPDATE&#58; Microsoft Hyper-V Server 2008 & VMware ESXi 3.5"
description: Comparison, analysis, and debate of the Hypervisor disk footprint Part 1 Update
author: sethmanheim
ms.author: sethm
date:       2009-08-13 17:56:00
ms.date: 08/13/2009
categories: esx
---
# Hypervisor Footprint Debate Part 1 Update: Microsoft Hyper-V Server 2008 & VMware ESXi 3.5
Virtualization Nation,

In my last blog post, I started an in depth analysis tackling VMware’s claims head on that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure. I read some posts on the blogosphere that had questions about the methodology. Let’s dive in.

**Didn’t Compare The Number Of Reboots**

You’re right I didn’t. I didn’t think comparing the number of reboots was needed after:

  * establishing that VMware’s own patches caused customers two days of downtime without the use of VMotion to mitigate that downtime 
  * referring to VMware’s own updates that caused VMs to spontaneously reboot due to bugs in VMware HA 
  * pointing out that every ESXi patch requires a reboot 



Even if every Microsoft Hyper-V Server 2008 patch came out on a different day (that wasn’t the case most of the patches came out in groups) and required a reboot at the time, there’s no way on earth that the cumulative time would be in the ball park of **two days per server.**

**Service Pack 2**

You’re right I didn’t include Service Pack 2. Service Pack 2 is an optional download **.** You can test this out very easily. Go to any server running Microsoft Hyper-V Server 2008 or Windows Server 2008 and run Windows Update.

Here’s what I included:

> _Both Microsoft and VMware also have optional patches, but I didn't include this type because they are optional, so we could focus on the most acute patches. Finally, let me very clear about the Microsoft patches. **These counts include ALL critical and recommended patches, _meaning if there was a critical patch for IE or some other Windows component I counted it_**. Had I ignored these types of patches, that wouldn’t be a fair comparison._

However, for the sake of comparison and transparency, I added Service Pack 2 to the count and here’s what we found:

  * Microsoft Hyper-V Server 2008: 27 patches, totaling 845 MB. 
  * VMware ESXi 3.5: 13 patches, totaling over **_2.7 GB_**.



To put it another way,

  * **__VMware ESXi 3.5 still had a 4.3x greater patch footprint__**



**Microsoft Hyper-V Server 2008 RTM’d Later Than Windows Server 2008**

That’s a great point and my mistake. I apologize for that error and have corrected it. (BTW: It doesn’t take me a month to apologize and make corrections, but I digress..)

Let me tell you how this happened.

In doing the patch comparison, I started with VMware’s favorite example, VMware ESXi 3.5 and Windows Server 2008 which RTM’d in Q4 2007. I wanted to take a reasonable, historical sample size of both platforms. Going back 18 months ensures the sample set covers the majority of Windows Server 2008 time in market and tackles VMware’s fundamental claim that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure. **If anything this should work in VMware’s favor.**

As I pored through data I realized I wanted to do the full matrix and include:

  1. VMware ESXi 
  2. VMware ESX 
  3. Windows Server 2008 (Full) 
  4. Windows Server 2008 (Core) 
  5. and finally Microsoft Hyper-V Server 2008 



This way, customers get the most comprehensive data and can make an informed decision. As you can see, MS Hyper-V Server 2008 was at the end of the analysis and this mistake crept because it slipped my mind that MS Hyper-V Server 2008 shipped after Windows Server 2008. (For example, MS Hyper-V Server 2008 R2 and Windows Server 2008 R2 are sim shipping this time around…)

**The Notion Of Truth**

This is an ideal time to make an important and fundamental point about competitive comparisons. The reason we’re able to perform this analysis and debate this topic openly is **_because the facts are freely available in the public domain without restriction_**. I’m happy to discuss the methodology used and make corrections as needed, but the point is **_we can have these discussions_**.

This point may sound obvious, reasonable and rational, but it’s not what VMware believes when it comes to competitive benchmarking. VMware has decided that they want to tightly control the concept of truth and only want the public to hear **_the VMware version of the truth_**. This is an unfortunate situation for customers who value open debate and basic fairness.

That’s another blog for another time.

Cheers, -Jeff
