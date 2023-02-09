---
title:      "SCVMM and VMware ESX management"
description: The threat of virtualization sprawl was a theme my colleagues heard last week at IDC's Directions conference in San Jose CA.
author: scooley
ms.author: scooley
date: 2009-03-09 22:43:00
ms.date: 03/09/2009
categories: cross-platform-management
---
# SCVMM and VMware ESX management

The threat of virtualization sprawl. That was a theme my colleagues heard last week at IDC's "Directions" conference in San Jose. And true to IDC's form, they backed up their predictions with some numbers. Here's an excerpt from one article: 

> Virtualization has often been seen as something of a magic bullet to this problem, promising to consolidate a number of low-utilization servers onto a single piece of hardware. But the average number of virtual machines per server is only five, Bailey noted, with that number going to eight by 2012.  So much for the vision of consolidating dozens of servers onto one machine. More important, though, was that IDC found that just going from five virtual machines to eight means there will be 100 million new servers by 2012, and "all of them still need to be managed." That's a problem, she said, since the tools to do this are not keeping pace. 

Our customers have referred to this issue as "islands," referring to the need for different management tools, interfaces, etc. to manage their heterogeneous environment. After all, customers and partners tell us, they're trying to manage services, no matter if the applications run on Windows or non-Windows, physical or virtualized.  For those of you in that last camp, like Atlanta Journal Constitution, Mamut and Maxol, you know that Microsoft and some other systems management vendors are creating tools to keep pace with heterogeneous hypervisors and VMs, and as well traditional physical systems and non-virtualized applications. System Center is one such management tool; VMware vCenter isn't yet], according to Alessandro). To elaborate on this point, check out RakeshM's latest blog post [here](/archive/blogs/rakeshm/scvmm-2008-and-vmware-management-we-must-be-doing-something-right "RakeshM technet blog post"). Here's an excerpt from his intro: 

> Put simply, people _want to use a single primary console for day to day management of virtual machines across multiple hypervisors_ so we went after this problem. As a result, multi-hypervisor management via SCVMM 2008 has proven to be enormously popular with customers and partners alike.

Rakesh sheds light on VMware's concocted "demos" (nice touch using Microsoft exec names "muglia" and "ballmer" as host names) and [conjecture](https://vcritical.com/2009/03/managing-vi3-with-scvmm-considered-harmful/ "Eric gray blog"). Rakesh summarizes his post with the following: 

> If you are thinking of using SCVMM 2008 to manage VMware because you have a mixed environment (and we have _many many_ customers who are doing just that), keep in mind that SCVMM does not require you to uninstall or remove VMware Virtual Center from your environment. In fact, you have to keep Virtual Center around because VMware does not expose some APIs (like Vmotion) through ESX. [We’re a manager of managers](https://blogs.technet.com/rakeshm/archive/2008/07/28/vmware-and-scvmm-why-do-we-require-virtual-center.aspx "blog") so it is nearly risk free to try it out and make up your own mind about how effective we are. 

Oh, and by the way, Rakesh also says that the beta of SCVMM 2008 r2 will be coming this month. I can't wait to see what demos VMware concocts next to counter the physical/virtual management sales and marketing by HP, IBM, CA and BMC. HP's Peter Spielvogel tips his hand with HP's reaction. I'm sure this reaction will become stronger once VMware crosses the line to be more competitor than partner. 

Patrick
