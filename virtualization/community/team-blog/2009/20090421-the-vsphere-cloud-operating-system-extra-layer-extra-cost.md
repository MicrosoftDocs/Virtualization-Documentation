---
title:      "The vSphere Cloud Operating System&#58; Extra Layer, Extra Cost?"
description: VMware adds an extra layer to the computing stack.
author: scooley
ms.author: scooley
date:       2009-04-21 04:30:00
ms.date: 04/21/2009
categories: cloud-computing
---
# The vSphere Cloud Operating System: Extra Layer, Extra Cost?

Hi, I’m David Greschler, director of Microsoft virtualization and management. Today VMware announced their new “Cloud OS,” called vSphere.  It’s an interesting announcement in that it points out more clearly than ever that VMware adds an extra layer to the computing stack. 

 

This extra layer, a virtualization “substrate” (VMware CEO Paul Maritz’s words), is inserted by VMware between hardware and the OS.  But is it really necessary to add an extra layer just to do virtualization and the cloud? Do we really need another operating system to effectively just host other operating systems?

 

I can see how initially this made sense when the industry was first experimenting with virtualization. But virtualization has now become mainstream, and as such it’s just another feature we should have as part of our computing process. As a result, Microsoft chose to take a more streamlined approach to virtualization. Instead of adding an additional layer of complexity, we’ve put the virtualization component inside the OS. We think this is a better approach as it means you have one less layer to manage, secure and pay for. (And at the cost of $3,495 per processor for vSphere Enterprise Plus, that’s a pretty expensive layer!).

 

But what about cloud? There’s a lot of talk about how vSphere lets enterprises build “private clouds.” This concept, of a dynamic datacenter where additional compute power can be provisioned on-demand, is something Microsoft has already been talking about for over six years with our Dynamic IT initiative. But does it need an extra layer? We have been developing Windows Server 2008 with System Center, as well as development tools and an application platform, with the Dynamic IT vision all along. The industry terms may have changed from “dynamic datacenter” to “private cloud” but the fact remains that these products today already provide the foundation for building a private – and hosted – cloud infrastructure. After all, the cloud isn’t about throwing away your old applications; it’s partly about taking your existing applications and making them more flexible, extensible and distributed. That’s what Windows Server 2008 and System Center are all about. And customers agree. Take a look at what [Kroll Factual Data](https://www.microsoft.com/infrastructure/casestudies/casestudy.mspx?UuId=cc19c9ce-b56c-4eed-873e-91021e1ba317) did with the two products to build their own private cloud. Check out what [Lionbridge Technologies](https://www.microsoft.com/Presspass/press/2009/feb09/02-23LionbridgePR.mspx) did with their Virtual Cloud Lab. 

 

In other words, you don’t need an extra “cloud operating system” to build a cloud running Windows Server. Just use Windows Server.

 

If you’re an existing VMware 3.x customer who’s considering migrating to VMware’s new Cloud OS, try the combination of Windows Server 2008 Hyper-V and System Center first. You’ll see that System Center can manage both your VMware and Hyper-V deployments from the same console, as well as both your virtual and physical infrastructure. And [compare costs](https://www.microsoft.com/virtualization/compare/vmware-cost-comparisons.mspx): VMware vSphere’s extra layer is approximately three to five times the cost of Microsoft’s solution, while just yesterday Zane Adam announced in this blog that Microsoft Hyper-V Server R2, which includes live migration and high availability, will be free of charge.

 

vSphere may be the best reason yet to move to Microsoft’s virtualization solution.

 

David Greschler
