---
title: "Hyper-V Winning Daily/VMware FUD Reaching New Heights."
description: I prefer to spend my time talking about the great things we're doing with Hyper-V and Microsoft virtualization. Unfortunately, I need to take a moment to respond to some VMware FUD circulating the web.
author: scooley
ms.author: scooley
date:       2009-05-09 10:08:00
ms.date: 05/09/2009
categories: uncategorized
---
# Hyper-V Winning Daily/VMware FUD Reaching New Heights

Virtualization Nation,

I prefer to spend my time talking about the great things we're doing with Hyper-V and Microsoft virtualization. We have a lot of very happy customers today with Hyper-V R1 and the upcoming R2 release delivers even more in terms of scalability, performance and new features like [Live Migration](https://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx) and much, much more. Unfortunately, I need to take a moment to respond to some VMware FUD circulating the web.

Out on the web, there's an "anonymous" video purporting to show a Hyper-V crash. When I heard, I was surprised and immediately wanted to know more. I haven't heard of _any_ such incidents with Hyper-V and the Hyper-V R1 release has been incredibly stable and reliable. So, what did I find? 

**The Video: No Facts Just FUD.**

Not much. Where are the details? There are no facts provided. What Hyper-V build was this? The beta? What was the configuration being tested? Who posted this? Why didn't they contact Microsoft support? I mean there's literally no data other than a defamatory statement at the beginning of the video implying that Hyper-V had something to do with some downtime at TechNet/MSDN. The SQL team and Operations [responded](http://sqlcat.com/faq/archive/2009/05/08/windows2008-r2-beta-download-runs-smoothly-now.aspx) to this days ago. In short, **_Hyper-V had nothing to do with the outage_**.

So, _why_ would someone create such a video? Let's dig a little deeper.

**The Poster.**

The poster, who doesn't appear on the video, doesn't state what company he works for or provide any context. Gee, I wonder where he works?

\<drum roll please>

Introducing Scott Drummonds, VMware Product Marketing.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/VirtualizationFUDreachingnewheights_64EC/image_thumb_1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/VirtualizationFUDreachingnewheights_64EC/image_4.png)

Gosh, I wonder why Scott didn't mention he works for VMware?

Very professional Scott.

No signs of desperation there at all.

Looks like I'll need to provide the facts here.

**What I Do Know.**

  1. In the first 7 months of Hyper-V RTM availability, we've had over **750,000 downloads of Hyper-V gold bits**. 
  2. **Hyper-V is the fastest growing x86/x64 hypervisor in history**. We are laser focused on our customers and providing high performance, high quality virtualization for everyone from small business to Fortune 500 customers. 
  3. We have hundreds of [**Hyper-V case studies from customers worldwide**](https://www.microsoft.com/virtualization/default.mspx) and we're winning new customers **daily**. 
  4. Hyper-V continues to power MSDN, TechNet and Microsoft.com as well as numerous other MS properties. Microsoft.com continues to receive over a BILLION hits per month and there **has been no downtime to any of these internet properties running atop Hyper-V**. **Period**. 
  5. Of those 750,000+ downloads, the number of support calls we have received on **Hyper-V is less than .02%**. (Yes, a minimal fraction of a percent.)



So, in terms of reliability, stability and support, not bad. (It's not like we released any patches resulting in days of downtime. [HERE](http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9112439), [HERE](http://www.techworld.com.au/article/257277/vmware_ceo_apologizes_virtual-server_bug), [HERE](http://blogs.zdnet.com/virtualization/?p=506), [HERE](http://marcusoh.blogspot.com/2008/08/dont-roll-vmware-update-2-yet.html), [HERE](http://communities.vmware.com/thread/162377), & [HERE](http://kb2.vmware.com/kb/1006716.html))

**Hmm. Still Want To Know More.**

All said, I still wasn't satisfied. On the Hyper-V team, we run **thousands of stress tests per week** and the stress tests we run are far more invasive than the test in this video. So, I consulted our Hyper-V Supportability Program Manager and dug deeper. I wanted to know if we've had any Hyper-V crashes reported. Here's what I found out.

Of the 750,000 downloads, we've had 3 reports of crashes under stress and with the same error code as seen in the video bugcheck (0x00020001). The solution in all three cases was to upgrade the server BIOS which solved the problem. This can happen as hypervisors interact very closely with the hardware and BIOS updates generally include updated microcode for processors oftentimes to address errata.

In case you're wondering, **_VMware has had similar crashes with older BIOSes as well_**. [Here](http://communities.vmware.com/thread/156694).

Those are the facts. Now back to our regularly scheduled Hyper-V goodness.

**TechEd Next Week!**

Next week is TechEd in Los Angeles and a number of us from the virtualization team will be there in Los Angeles. We've got numerous sessions covering Hyper-V R2, Virtual Machine Manager and more. Hope to see you there!

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_

P.S. It appears Keith Ward has seen through this veneer of FUD and blogged as well. [HERE](http://virtualizationreview.com/blogs/weblog.aspx?blog=3879).
