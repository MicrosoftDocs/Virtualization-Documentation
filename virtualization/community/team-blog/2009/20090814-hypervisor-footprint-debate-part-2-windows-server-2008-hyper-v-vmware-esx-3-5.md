---
title:      "Hypervisor Footprint Debate Part 2&#58; Windows Server 2008 Hyper-V & VMware ESX 3.5"
description: Comparison, analysis, and debate of the Hypervisor disk footprint Part 2
author: mattbriggs
ms.author: mabrigg
date:       2009-08-14 12:26:30
ms.date: 08/14/2009
categories: uncategorized
---
# Hypervisor Footprint Debate Part 2: Microsoft Hyper-V Server 2008 & VMware ESXi 3.5
Virtualization Nation,

In [part 1 of this series](https://techcommunity.microsoft.com/t5/virtualization/hypervisor-footprint-debate-part-1-update-microsoft-hyper-v/ba-p/381625), I started an in depth analysis tackling VMware’s claims head on that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure.

**The Thin Hypervisor Debate In A Nutshell**

Rather than attempt to restate VMware's argument, let's just use their exact verbiage. From VMware's website:



It's interesting to point out that VMware uses **ESX & ESXi 3.5** in the column title, but then only uses ESXi for comparison in the right hand column and then rushes to compares ESXi to Windows Server 2008 Hyper-V.

**Gosh, I wonder why ESX 3.5 isn't included?** We'll get to that in a sec.

> _****_

There are three metrics to VMware's argument: 

  1. **Disk footprint. Disk footprint. Disk footprint. They're quite fixated on that.**
  2. **Reduce the risk of downtime due to fewer patches (i.e. fewer patches is good)**
  3. **Increase reliability (and, in turn, availability)**



VMware's overarching point is because their disk footprint is smaller and ESX/ESXi is a single purpose hypervisor, they are therefore more secure. If that's the case, then it stands to reason that ESX/ESXi:

  * should have fewer patches (they have less code to patch) 
  * patches should be smaller in disk footprint (they have a smaller codebase and you want to keep code churn to a minimum; otherwise one could ship a 1k stub file and claim to be smaller) 
  * should offer higher availability, reliability and uptime 



We're going to put that to the test.

**Time For Some Analysis**

**With VMware's own metrics in mind** , I decided we should perform an apples to apples comparison. Specifically, **over an 18 month period from January 2008 to June 30th 2009** , comparing Windows Server 2008 (R1) and VMware ESX 3.5 in terms of numbers of patches, size of patches and availability. I specifically chose these versions because I wanted to take a reasonable, historical sample size (18 months) of both platforms. Going back 18 months ensures the sample set covers the majority of Windows Server 2008 time in market and tackles VMware’s fundamental claim that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure. **If anything this should work in VMware’s favor.** Finally, I didn’t use Hyper-V R2 and VSphere because they both RTM'd within the last 90 days and that wouldn't be statistically relevant.

**What did we compare?** Wanting to keep the comparisons as close as possible, here's what we analyzed:

  * VMware: Security and Critical Patches 
  * Microsoft: Critical and Important Patches 



Both Microsoft and VMware also have optional patches, but I didn't include this type because they are optional, so we could focus on the most acute patches. Finally, let me very clear about the Microsoft patches. **These counts include ALL critical and important patches, _meaning if there was a critical patch for IE or some other Windows component I counted it_**. Had I ignored these types of patches, that wouldn’t be a fair comparison.

**Comparison #2: Windows Server 2008 Hyper-V & VMware ESX 3.5**

Remember earlier how I thought it was interesting that VMware likes to use ESXi in its comparisons and that ESX is conspicuously absent?

Now I know why. 

Let’s take a look shall we. 

**Disk Footprint & Patch Count**: Here’s what we found: 

  * Windows Server 2008 Hyper-V (Full) Installation: 32 patches totaling 408 MB of patches 
  * Windows Server 2008 Hyper-V (Core) Installation: 26 patches totaling 82 MB of patches or ~20% fewer than a full installation 
  * VMware ESX 3.5: **_85 patches totaling over 3 GB_**



Yes, that’s right **_85 patches totaling over 3 GB_** . To put it a few other ways,

  * **__VMware ESX had 2.6x greater number of patches than Windows Server 2008 (Full)__**
  * **__VMware ESX had 7.3x greater patch footprint than Windows Server 2008 (Full)__**
  * **__VMware ESX had 3.2x greater number of patches than Windows Server 2008 (Core)__**
  * **__VMware ESX had 36x greater patch footprint than Windows Server 2008 (Core)__**


**The News Gets Worse**

In addition, **__VMware ESX averaged over a patch per week for 18 months with:__**

  * **__46 Critical patches (1.4 GB)__**
  * **__39 Security patches (1.6 GB) including__**



**__Guest code able to break out of VM and into the ESX Hypervisor__**

_**For those you who may not know, code running in a guest operating system that is able to break out of a VM and into a hypervisor is _THE WORST type of security flaw you can have for a virtualization platform_. Period. VMware has had exploits on both their “thin hypervisor (ESXi)” and on their “thick hypervisor (ESX)” _as recently as a few months ago_.**_

> _**For example, April 2009**_[ _ **CVE-2009-1244**_](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-1244) _ **: A critical vulnerability in the virtual machine display function allows a guest operating system users to execute arbitrary code on the host OS.**_
> 
> _**Impact: Provides administrator access, Allows complete confidentiality, integrity, and availability violation; Allows unauthorized disclosure of information; Allows disruption of service.**_

Something to consider when VMware wants to host your data in “the cloud.”

_(BTW: As mentioned above, I tried to keep this an apples to apples comparison and didn’t include VMware’s “General” Patches. Had I included those as well, that would have added another **83 general patches** and another 1 GB of patch footprint, but I digress…)_

In addition, don’t forget this one…

**Reliability/Availability**. With VMware ESX 3.5 Update 2, it included a serious flaw which resulted in **_two days of downtime_** for their customers including the loss of VMotion:

> _["Starting this morning, we could not power on nor VMotion any of our virtual machines," said someone identified as "mattjk" on a VMware support forum. "The VI Client threw the error 'A general system error occurred: Internal Error.'"](https://www.computerworld.com/article/2778399/vmware-licensing-bug-blacks-out-virtual-servers.html)_

It was so bad, VMware’s CEO had to apologize on numerous occasions. ([HERE](https://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9112439), [HERE](https://www.techworld.com.au/article/257277/vmware_ceo_apologizes_virtual-server_bug), [HERE](https://marcusoh.blogspot.com/2008/08/dont-roll-vmware-update-2-yet.html), [HERE](https://communities.vmware.com/t5/VI-VMware-ESX-3-5-Discussions/BIG-bug-in-ESX-3-5-Update-2-If-you-re-using-3-5u2-read-this-now/m-p/1548036)). VMware then rushed out the VMware ESX 3.5 Update 3 which introduced instability to VMware High Availability and **could cause virtual machines to spontaneously reboot**. ([HERE](https://kb.vmware.com/s/article/1007899) & [HERE](https://blog.scottlowe.org/2008/12/12/vmware-ha-problem-with-update-3/))

[Virtual machines that spontaneously reboot due to bugs in VMware high availability](https://en.wikipedia.org/wiki/Irony).

Now consider the fact that there were two significant quality and reliability issues with two major updates **_in a row_** (ESX/ESXi Update 2  & Update 3). While the initial Windows Server 2008 Hyper-V release didn’t provide Live Migration (Windows Server 2008 Hyper-V R1 had Quick Migration and [Windows Server 2008 Hyper-V R2 includes Live Migration for free](https://techcommunity.microsoft.com/t5/virtualization/windows-server-2008-r2-hyper-v-server-2008-r2-rtm/ba-p/381646)), it didn’t include two days of potential downtime and virtual machines unexpectedly rebooting either. For those that track availability in terms of nines (five nines is 5.26 minutes of downtime a year) VMware ESX 3.5 Update 2 dropped customers to “two nines” of availability.

**_Using VMware’s own metrics, Windows Server 2008 Hyper-V is clearly the winner over ESX 3.5 and by a pretty wide margin._**

In my next blog, we’ll analyze VMware’s favorite comparison, Windows Server 2008 Hyper-V and VMware ESXi 3.5.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
