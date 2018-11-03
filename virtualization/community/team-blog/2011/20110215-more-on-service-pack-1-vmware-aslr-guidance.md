---
layout:     post
title:      "More on Service Pack 1 & VMware ASLR Guidance"
date:       2011-02-15 09:00:00
categories: dynamic-memory
---
Virtualization Nation,  
  
In my last blog, we announced the RTM (Release to Manufacturing) of Service Pack 1 for Windows 7 and Windows Server 2008 R2 SP1. The bits will be available for download on Feb. 22, so mark your calendars. 

A frequent follow-up question to hit my inbox was from folks interested in a list of documented changes included in Windows 7 and Windows Server 2008 R2 SP1 in addition to Dynamic Memory and RemoteFX.

No problem.

Here’s the link to the [documentation for Windows 7 and Windows Server 2008 R2 SP1 (KB976932)](http://www.microsoft.com/downloads/en/details.aspx?FamilyID=61924cea-83fe-46e9-96d8-027ae59ddc11&displaylang=en). This KB includes:

  * Hotfixes and Security Updates
  * Notable Changes
  * Test Guidance



While the current version posted is for the Service Pack 1 Release Candidate, the final version will be available shortly for the RTM version.  
  
 **VMware and ASLR Follow-Up**

[In my last blog](http://blogs.technet.com/b/virtualization/archive/2011/02/09/windows-7-and-windows-server-2008-r2-sp1-add-new-virtualization-innovations.aspx), I discussed the importance of Address Space Layout Randomization (ASLR) as an effective, transparent security mitigation built-into Windows 7. I noted that independent security analysts wholeheartedly agree on the importance of ASLR. I also stated we have serious concerns that VMware was recommending customers disable ASLR to achieve better density.  
  
Following that blog post, we were contacted by Jeff Buell from VMware.

_From Jeff Buell, Perf Engineering at VMware_

_I'm from the performance engineering team at VMware.  We take both performance recommendations and security very seriously.  As you state, ASLR is a good security feature. VMware has never recommended disabling it.  If you have a reference saying otherwise, I'd love to see it.  _

First, let me say thank you to Jeff Buell for his swift response. I’m glad to see that Microsoft and VMware Engineering _**agree that ASLR is a good security feature**_ and that disabling ASLR is a terrible suggestion. Jeff appears to be concerned and willing to rectify this situation. Again, thank you Jeff. Here are the specifics.

**Looks Like It Started Here …**

It appears that the suggestion to disable ASLR began right here on VMware’s public blog page.

<http://blogs.vmware.com/view/2009/04/vista-and-vmware-view.html>

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/4186.img%201.png)

The post casually mentions that disabling ASLR will “lower overall security,” and then continues to make things worse by telling people to disable NX and DEP, two additional security mitigations. Because of this post, others picked up on this recommendation (such as in VMware’s community forums) and promoted this idea without anyone from VMware disputing this unfortunate suggestion:

<http://communities.vmware.com/message/1294525#1294525>

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8585.img%202.png)

At first, I thought these were isolated incidents, but then I started receiving regular inquiries from customers who said they were considering a VDI deployment and specifically asking if Microsoft had a recommendation or support stance regarding ASLR. Considering the fact that ASLR is transparent and you have to go out of your way to disable it (you have to be admin and then go to the Registry), I knew this wasn’t isolated anymore.

Finally, at VMworld 2010 in Europe, VMware Director of Product Marketing, Eric Horschman, delivered session TA8270 titled, **Get the Best VM Density From Your Virtualization Platform.**

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0755.img%203.png)

 In this session, a slide was presented with the following:

_**Best practices  
**_ **  
** _> Blame storage first - avoid bottlenecks  
> Upgrade to vSphere 4.1 for memory compression  
> Install VMware tools in guest OSes to enable ballooning  
> Protect your critical VMs  
> Add VMs until “active” memory overcommit is reached  
> Allow DRS to balance VMs across your cluster_

**_Advanced techniques_**

_> Use flash solid state disks for ESXi swapfile datastore (for overcommitted hosts)  
> Adjust HaltingIdleMsecPenalty (KB article 1020233)  
> Consolidate similar guest OSes and applications to assist Transparent Page Sharing  
> Disable ASLR in windows 2008/Windows 7 guests for VDI workloads_

When a VMware Director is promoting such poor advice, we were concerned our customers were putting themselves in undue risk and wanted to clearly articulate the Microsoft position. There is an apparent disconnect between VMware engineering and marketing on this topic, and I’m glad to see the engineering team speak out.

Again, my thanks to Jeff Buell from VMware Engineering for his quick response to this matter. I’m going to assume that VMware will clarify their position internally and appropriately message their position externally by fixing these external links. I’d be relieved to see VMware no longer recommend users disable fundamental security mitigations, such as ASLR, any further.

In my next blog, I’ll discuss some points you should consider make when determining what guest OS to deploy for VDI.

Cheers,

Jeff Woolsey  
Group Program Manager, Hyper-V  
Windows Server & Cloud

 
