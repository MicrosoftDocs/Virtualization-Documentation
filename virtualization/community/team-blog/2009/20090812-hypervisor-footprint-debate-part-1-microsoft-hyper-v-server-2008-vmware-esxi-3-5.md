---
title:      "Hypervisor Footprint Debate Part 1&#58; Microsoft Hyper-V Server 2008 & VMware ESXi 3.5"
description: Comparison, analysis, and debate of the Hypervisor disk footprint Part 1
author: mattbriggs
ms.author: mabrigg
date:       2009-08-12 11:13:00
ms.date: 08/12/2009
categories: esx
---
# Hypervisor Footprint Debate Part 1: Microsoft Hyper-V Server 2008 & VMware ESXi 3.5
Virtualization Nation,

After my [recent blog discussing the release of Microsoft Hyper-V Server 2008 R2](https://blogs.technet.com/virtualization/archive/2009/07/30/microsoft-hyper-v-server-2008-r2-rtm-more.aspx), we received _overwhelmingly positive feedback._ At the same time, there's still some skepticism about free Live Migration and almost daily we keep hearing, "This is too good to be true, is Live Migration really free? Is High Availability also free? What's the catch?" Yes, both Live Migration and HA are free. [Check out this earlier blog for details](https://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx).

At the same time, we've also received questions about Windows Server 2008 Hyper-V, Microsoft Hyper-V Server 2008 and VMware ESX/ESXi in terms of disk footprint. The disk footprint argument is a favorite bit of FUD by VMware which appears to making the rounds again in the blogosphere. In the past couple of weeks, I've seen a few articles reprinting this pabulum almost verbatim. So today, I thought we'd analyze the whole disk footprint argument and, as usual, **let's analyze the facts**.

**The Thin Hypervisor Debate In A Nutshell**

Rather than attempt to restate VMware's argument, let's just use their exact verbiage. From VMware's website:

[![image_thumb4](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart1_EAF7/image_thumb4_ffbc2d6a-6984-47e4-900f-91d590a920e0.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart1_EAF7/image_thumb4_ffbc2d6a-6984-47e4-900f-91d590a920e0.png)

It's interesting to point out that VMware uses **ESX & ESXi 3.5** in the column title, but then only uses ESXi for comparison in the right hand column and then rushes to compares ESXi to Windows Server 2008 Hyper-V.

**Gosh, I wonder why ESX 3.5 isn't included?** We'll cover that too.

Pay special attention to the last paragraph:

> _**"VMware ESXi is a fully functional hypervisor in a 32 MB disk footprint, which reduces the risk of down time and increases reliability."**_

There are three metrics to VMware's argument:

  1. **Disk footprint. Disk footprint. Disk footprint. They're quite fixated on that.**
  2. **Reduce the risk of downtime due to fewer patches (i.e. fewer patches is good)**
  3. **Increase reliability (and, in turn, availability)**



VMware's overarching point is because their disk footprint is smaller and ESX/ESXi is a single purpose hypervisor, they are therefore more secure. If that's the case, then it stands to reason that ESX/ESXi:

  * should have fewer patches (they have less code to patch) 
  * patches should be smaller in disk footprint (they have a smaller codebase and you want to keep code churn to a minimum; otherwise one could ship a 1k stub file and claim to be smaller) 
  * should offer higher availability, reliability and uptime 



We're going to put that to the test.

**Before We Get Started**

Before we delve into the analysis, I'd like to point out that VMware touts ESXi as a 32 MB hypervisor, yet the download is over 200 MB. So, are we too assume that the other 170+ MB doesn't count? I point this out because both Windows Server 2008 Hyper-V and Microsoft Hyper-V Server 2008 do have larger disk footprints, but also provide incredible value and capabilities that our customers desire such as driver compatibility with a vast catalog of hardware, widely used management interfaces, scripting capability (PowerShell anyone?), MPIO, High Availability, etc.

**__If you really want to focus on the disk footprint that matters, the amount of software that could be directly exposed to VM attack, the Hyper-V hypervisor and virtualization stack combined is about 20 MB, ~19.4 MB for the virtualization stack and ~600k for the hypervisor.__**

In short, VMware has focused on our entire footprint which is made up mostly of stuff that isn't exposed to VM traffic at all or only exposed indirectly, while ignoring the part that matters most and for which VMware doesn't have a strong track record.

**Time For Some Analysis**

**With VMware's own metrics in mind** , I decided we should perform an apples to apples comparison. Specifically, **over a 12 month period from June 30th 2008 to June 30th 2009** , comparing: Microsoft Hyper-V Server 2008 (R1) and VMware ESXi 3.5 in terms of numbers of patches, size of patches and availability. I specifically chose these versions because I wanted to take a reasonable, historical sample size (12 months) of both platforms. Both Hyper-V R2 and VSphere have RTM'd within the last 90 days and that wouldn't be statistically relevant.

**What did we compare?** Wanting to keep the comparisons as close as possible, here's what we analyzed:

  * VMware: Security and Critical Patches 
  * Microsoft: Critical and Important Patches 



Both Microsoft and VMware also have optional patches, but I didn't include this type because they are optional, so we could focus on the most acute patches.. Finally, let me very clear about the Microsoft patches. **These counts include ALL critical and recommended patches, _meaning if there was a critical patch for IE or some other Windows component I counted it_**. Had I ignored these types of patches, that wouldn’t be a fair comparison.

**Comparison #1: Microsoft Hyper-V Server 2008 & VMware ESXi 3.5**

**Disk Footprint & Patch Count. **Here's what we found:

  * Microsoft Hyper-V Server 2008: 26 patches, totaling **82 MB**.  
  * VMware ESXi 3.5: 13 patches, totaling over **_2.7 GB_**.



Yes, I said over **_2.7 GB_**. To put it another way,

  * **__VMware ESXi 3.5 had a 33x greater patch footprint__**



[![Microsoft Hyper-V Server 2008 and V M ware E S X i 3.5 footprint comparison image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HypervisorFootprintDebatePart1Microsof.5_6ED2/image_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HypervisorFootprintDebatePart1Microsof.5_6ED2/image_2.png) 

So much for the disk footprint argument. How can the ESXi patch footprint be so huge?

Because VMware releases a whole new ESXi image every time they release a patch. Furthermore, because VMware releases a whole new ESXi image every time they release a patch it also means that **_every ESXi patch requires a reboot_**. At this point, a VMware salesman, may concede the point that every ESXi server has to be rebooted for every patch, but they will then state that they have VMotion (Live Migration), so it doesn't affect their uptime.

Except when their own patches cause days of downtime and render VMotion impotent.

**Reliability/Availability**. With VMware ESXi 3.5 Update 2, it included a serious flaw which resulted in **_two days of downtime_** for their customers including the loss of VMotion:

> _["Starting this morning, we could not power on nor VMotion any of our virtual machines," said someone identified as "mattjk" on a VMware support forum. "The VI Client threw the error 'A general system error occurred: Internal Error.'"](http://www.computerworld.com/s/article/9112439/VMware_licensing_bug_blacks_out_virtual_servers)_

It was so bad, VMware's CEO had to apologize on numerous occasions. ([HERE](http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9112439), [HERE](http://www.techworld.com.au/article/257277/vmware_ceo_apologizes_virtual-server_bug), [HERE](http://blogs.zdnet.com/virtualization/?p=506), [HERE](http://marcusoh.blogspot.com/2008/08/dont-roll-vmware-update-2-yet.html), [HERE](http://communities.vmware.com/thread/162377), & [HERE](http://kb2.vmware.com/kb/1006716.html)). VMware then rushed out the VMware ESXi 3.5 Update 3 which introduced instability to VMware High Availability and **could cause virtual machines to spontaneously, unexpectedly reboot**. ([HERE](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1007899) & [HERE](http://blog.scottlowe.org/2008/12/12/vmware-ha-problem-with-update-3/))

[Virtual machines that unexpectedly reboot due to bugs in VMware high availability](http://en.wikipedia.org/wiki/Irony). Think about that for a minute.

**The News Gets Worse**

Not only did VMware ESXi have a 31x greater patch footprint, but they also had the most serious virtualization security flaws. Specifically,

**__Guest code able to break out of VM and into the ESX Hypervisor__**

_**For those you who may not know, code running in a guest operating system that is able to break out of a VM and into a hypervisor is _THE WORST type of security flaw you can have for a virtualization platform_. Period. VMware has had exploits on both their "thin hypervisor (ESXi)" and on their "thick hypervisor (ESX)" _as recently as a few months ago_.**_

> _**For example, April 2009**_[ _ **CVE-2009-1244**_](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-1244) _ **: A critical vulnerability in the virtual machine display function allows a guest operating system users to execute arbitrary code on the host OS.**_
> 
> _**Impact: Provides administrator access, Allows complete confidentiality, integrity, and availability violation; Allows unauthorized disclosure of information; Allows disruption of service.**_

Something to consider when VMware wants to host your data in "their cloud."

Now consider the fact that there were two significant quality and reliability issues with two major updates **_in a row_** (ESX/ESXi Update 2  & Update 3). While the initial Microsoft Hyper-V Server 2008 release didn't offer Live Migration ([MS Hyper-V Server 2008 R2 now includes Live Migration/HA for free](https://blogs.technet.com/virtualization/archive/2009/07/30/microsoft-hyper-v-server-2008-r2-rtm-more.aspx)), it didn't include two days of potential downtime and virtual machines unexpectedly rebooting either. For those that track availability in terms of nines (five nines is 5.26 minutes of downtime a year) VMware Update ESXi 3.5 Update 2 dropped customers to "two nines" of availability.

**_Using VMware's own metrics, Microsoft Hyper-V Server 2008 is clearly the winner over ESXi 3.5._**

**One more interesting observation**

After VMware released Update 2, which affected both ESXi & ESX, they rushed to get a fix out the door and did so in a few days. One interesting thing I noticed was that in the span of a few days, **_the patch grew 17 MB_**.

**_17 MB in a few days????_**

Now, I'm not sure what's in that 17 MB (potentially more than 50% of their hypervisor footprint could have been churned using VMware's 32 MB hypervisor claim, but I digress.), but if I had just released a patch that resulted in multiple days of downtime for my customers let me tell you what I would have done:

**Created a highly scoped, well tested, surgical fix with minimal code churn.**

To see a 17 MB change in just a few days would be cause for concern and an immediate code review.

Maybe that's just me.

[![Hypervisor footprint debate image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HypervisorFootprintDebatePart1Microsof.5_6ED2/image_thumb_1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HypervisorFootprintDebatePart1Microsof.5_6ED2/image_4.png)

In my next blog, we'll compare Windows Server 2008 Hyper-V and VMware ESX 3.5.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
