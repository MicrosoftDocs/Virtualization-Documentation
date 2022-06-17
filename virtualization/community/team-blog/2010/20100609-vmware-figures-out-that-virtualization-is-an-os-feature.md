---
title:      "VMWare figures out that virtualization is an OS feature"
description: Every now and again, we like to use this forum to provide commentary and context on happenings in the industry.
author: scooley
ms.author: scooley
date:       2010-06-09 11:21:00
ms.date: 06/09/2010
categories: citrix
---
# VMWare figures out that virtualization is an OS feature

Every now and again, we like to use this forum to provide commentary and context on happenings in the industry. [Today’s news](http://www.marketwatch.com/story/vmware-and-novell-expand-strategic-partnership-to-deliver-and-support-suser-linux-enterprise-server-for-vmware-vspheretm-environments-2010-06-09?reflink=MW_news_stmp) from Waltham, Mass. and Palo Alto, Calif. is a good example. On the one hand, there’s a [Microsoft competitor](http://blog.seattlepi.com/microsoft/archives/208984.asp#extended). On the other hand, there’s a [Microsoft partner](http://www.moreinterop.com/community.aspx) (see [today’s joint webcast](http://fcw.com/webcasts/2010/06/from-collaboration-to-the-private-cloud-future-proofing-your-data-center.aspx?tc=page0)). And if there’s such a thing as a third hand, there are [implications for Red Hat](http://searchservervirtualization.techtarget.com/news/article/0,289142,sid94_gci1514432,00.html), perhaps even IBM. 

So what’s our take?

First, the Microsoft and Novell alliance has been very successful. It’s been 3.5 years since the big announcement with Novell, and we have more than 475 customers who’ve chosen to work with Microsoft and Novell. We’ll continue to work with Novell around technical support and interoperability. The joint interoperability lab in Cambridge is very active, and [we recently announced](http://www.prnewswire.com/news-releases/microsoft-and-novell-collaborate-to-deliver-hybrid-options-for-high-performance-computing-95296474.html) work together in high-performance computing. Oh, and did I mention today’s joint webcast on heterogeneous datacenter ;-)

Second, the vFolks in Palo Alto are further isolating themselves within the industry. Microsoft’s interop efforts have provided more choice and flexibility for customers, including our work with Novell. We’re seeing VMWare go down an alternate path. As one of many examples of our work with open source communities, we’re adding functionality to the Linux Integration Services for Hyper-V. In fact, we have an [RC version of the Linux Integration Services](https://blogs.technet.com/b/virtualization/archive/2010/05/05/linux-integration-services-v2-1-release-candidate-now-available.aspx), which support Linux virtual machines with up to 4 virtual CPUs. In fact, we’ll talk more of this on [June 25 at Red Hat Summit](http://www.redhat.com/promo/summit/2010/sessions/). For more meat, see [Matthew’s post](http://blog.allanglesit.com/Blog/tabid/66/EntryId/59/Eight-Things-You-Need-To-Know-About-Linux-on-Hyper-V.aspx) about what you need to know about Linux on Hyper-V. And if you’re talking about technical support, let’s not forget the [Server Virtualization Validation Program](http://windowsservercatalog.com/results.aspx?&bCatID=1521&cpID=0&avc=0&ava=0&avq=0&OR=1&PGS=25), which includes Red Hat, VMWare, Novell, Cisco and others.

Third, looks like VMWare finally determined that virtualization is a server OS feature. I’m sure we’ve said that once or twice over the years ;-). The vFolks now plan to ship a full version of a server OS with vSphere, and support it, to fulfill their application development and application deployment plans. 

Fourth, this is a bad deal for customers as they’re getting locked into an inflexible offer. Check out the [terms and conditions.](http://www.vmware.com/landing_pages/sles-for-vmware/index.html) For example: “Customers may run SLES with the accompanying patches and updates subscription entitled by a VMware purchase only in virtual machines running on VMWare vSphere 4.0 and 4.1 hosts that have active vSphere SnS with VMware.” So be sure not to drop support or you’ll invalidate your license. Or maybe just stick with small deployments.

Last, the vFolks have no public cloud offering, like Windows Azure, like Amazon EC2. While we’re demoing and building capabilities so customers have a common and flexible application and [management model](https://www.microsoft.com/presspass/presskits/cloud/videogallery.aspx?contentID=cloud_MMS2010_day1KeynoteClip4&WT.z_convert=Share) across on-premises and cloud computing, they’re stitching together virtual appliances to fill the void. Don’t forget – the next version of System Center Virtual Machine Manager will configure VMs from VMWare and Citrix.

What are your thoughts?

Patrick O’Rourke, director of communications, Server and Tools Business
