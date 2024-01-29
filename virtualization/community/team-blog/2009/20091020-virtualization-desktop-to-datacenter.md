---
title:      "Virtualization&#58; desktop to datacenter"
author: sethmanheim
ms.author: sethm
description: Virtualization; desktop to datacenter
ms.date: 10/20/2009
date:       2009-10-20 14:54:00
categories: application-virtualization
---
# Virtualization; desktop to datacenter

It's been a while since I've [posted a blog](https://blogs.technet.com/virtualization/archive/2009/08/27/update-what-you-won-t-see-at-vmworld-2009.aspx "my pre-VMworld blog") ... but that one really caused a stir in the Virt circles in the Bay Area. Hopefully it doesn't mean I can't hit up those people for [Sharks](http://sharks.nhl.com/index.html "San Jose Sharks ice hockey site") tickets. I've stumbled across some interesting items that I wanted to share with you. 

Microsoft Desktop Optimization Pack 2009 R2 is now available. The big thing is support for Windows 7. Read the blog [here](https://blogs.technet.com/mdop/archive/2009/10/20/mdop-2009-r2-is-now-available.aspx "MDOP blog"). Here's an excerpt:

> _If you are an MDOP customer, you can download MDOP 2009 R2 through_[ _Microsoft Volume Licensing Site (MVLS)_](https://go.microsoft.com/fwlink/?LinkId=166331) _.   For others who wish to evaluate MDOP products, the MDOP software is available at _[_MSDN_](https://msdn.microsoft.com/subscriptions/downloads/default.aspx?PV=42:178) _and_[ _TechNet_](https://technet.microsoft.com/subscriptions/downloads/default.aspx?PV=42:178) _  (in accordance with your MSDN or TechNet agreements, except for AIS). _
> 
> _MDOP has been licensed for over 21 million desktops worldwide! In a recent survey completed for Microsoft by Answers Research, and including 1000 IT professionals across five countries/regions, we learned several interesting facts:_
> 
>   * _66% of MDOP customers deployed three or more of the MDOP products_
>   * _52% of them deployed MDOP across more than half of their PCs_
>   * _94% of MDOP customers said they would recommend MDOP to a colleague_
>   * _When comparing MDOP and non-MDOP customers, customer satisfaction with Software Assurance increases by 25%_
> 

> 
> _Microsoft Enterprise Desktop Virtualization (MED-V) V 1.0 SP1 - This updated tool will support Windows 7 and enable enterprise deployment of virtual Windows XP environments to support incompatible applications. A Beta version of MED-V 1.0 SP1 will be available by the end of 2009 and final release is scheduled for the first quarter of calendar year 2010. ___

On the server side, the latest is from Gartner Symposium in Orlando. Gartner[announced](https://www.techtarget.com/searchcio/news/1372112/Gartners-top-10-strategic-technologies-for-2010 "Gartner news release") their top 10 strategic technologies for 2010. Not surprisingly, virtualization is named or underlying several of the strategic technologies. And speaking of, Gartner also shared data on server virtualization adoption today and forecasted through 2012. Read [this article](https://virtualizationreview.com/articles/2008/04/03/gartner-virtualization-highest-impact-tech-through-2012.aspx "Network World article"). Here's an excerpt:

> _According to Gartner, 18% of_[ _server workloads_](https://www.reuters.com/article/urnidgns002570f3005978d80025765500510b19/gartner-server-virtualization-now-at-18-of-server-workload-idUS211522475720091020) _this year run on virtualized servers; that share will grow to 28% next year and reach almost half by 2012. But growth is anticipated among the small-to-midsize businesses (SMB), and it's in this segment that Microsoft has a good chance to build a customer base. By 2012, VMware's share is expected to shrink to 65% but the base of VMs will have grown to 58 million, a 10-fold leap. By that time, Gartner believes, Microsoft will hold 27% share, Citrix 6%, Red Hat 2% and others about 1%._

 Along those lines, I had a great email exchange a couple weeks ago with Steve at PoundHost in Maidenhead, UK. I was giving a presentation at IP Expo / VM Expo conference in London, and wanted to highlight PoundHost's business results since switching to Hyper-V and System Center away from VMware tools, and since PoundHost has deployed the [Dynamic Datacenter Tookit](https://www.microsoft.com/hosting/dynamicdatacenter/Home.html "website") for hosters. PoundHost has a very compelling story of how technology can really help a business transform itself and create new opportunities. The [Microsoft case study](https://www.microsoft.com/casestudies/Case_Study_Detail.aspx?casestudyid=4000004741 "MS case study on PoundHost") doesn't really do it justice. Here's some of what Steve shared with me:

  * Cost. "It meant we could offer Linux and Windows at the same price (when we went live with the beta of R2 we had Linux guests but we don't now). It means we can offer low cost VMs on high quality (and cost!) host servers which ultimately give the end user a better experience. [It] works out about £1.00 per guest assuming 60 guests per host."

  * Common management tools. "We were also very impressed with a demo we had seen of System Center Virtual Machine Manager and Ops Manager so we now use both in our infrastructure."

  * Choice. "I'm a VCP and have a lot of experience with ESX but I'd never use it again now I've used Hyper-V under R2"

  * Grow business. "[We've] expanded our Hyper-V/System Center offerings into our managed services company Server Arcade "

  * Grow business: profitability boost by 55%

  * Customer service. "We're also doing the customer control panel now for Poundhost which is based on the Dynamic Datacenter Toolkit."


 Check out more about the Dynamic Datacenter toolkits and partner alliance at [their blog](/archive/blogs/ddcalliance/ "Dynamic Datacenter alliance blog").

Patrick O'Rourke
