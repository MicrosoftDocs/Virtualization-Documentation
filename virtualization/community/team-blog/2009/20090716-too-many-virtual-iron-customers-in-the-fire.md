---
title:      "Too many Virtual Iron customers in the fire?"
author: mattbriggs
ms.author: mabrigg
description: Learn about Virtual Iron customers.
ms.date: 07/16/2009
date:       2009-07-16 01:38:00
categories: esx
---
# Too many Virtual Iron customers in the fire?

With the recent announcement by Oracle to [stop](http://www.dabcc.com/article.aspx?id=10900) Virtual Iron development and sales, the past few weeks have certainly been eventful for Virtual Iron customers.  A [related announcement came out from VMware](http://www.virtualization.info/2009/07/oracle-and-vmware-dispute-virtual-iron.html) about a program to offer Virtual Iron customers discounts to move over.  But a closer look at the VMware offer shows some serious limitations.  These include:<?xml:namespace prefix = o ns = "urn:schemas-microsoft-com:office:office" /> 

·         Only Virtual Iron 4.0 or newer customers are eligible

·         Only those with active support subscriptions with Virtual Iron are eligible

·         Customers _must_ buy a VMware license for every socket on their Virtual Iron contract.   This effectively locks in the customer to VMware for size of their Virtual Iron contract.

·         The discount is 40% off the list price of the product but only 10% on one-year of support and subscription, 0% for more than one year of support subscription.

·         The offer isn’t valid on all SKUs.  This means for Virtual Iron customers who want to keep their Live Migration and CPU balancing capability, they need to buy vSphere Enterprise Plus, the most expensive SKU.

Even with the discounts, VMware is still very expensive.  For vSphere Advanced, the cost after discount is still $1,347 per processor without support, which has a very small discount.  For vSphere Enterprise Plus, which is required for DRS and other features, the cost is still $2,097 per processor without support.  With two years of support, it’s $3,722.64 per processor. 

As noted above, Virtual Iron customers must convert all their sockets to VMware and this can only be done once. 

As an alternative, I would recommend Virtual Iron customers try Microsoft solutions.  Our Hyper-V solutions are low cost, easy to use, and work well with Xen-based solutions like Virtual Iron.  In fact, many Virtual Iron users are already running their VMs in the VHD format that’s used with Hyper-V.

If Virtual Iron customers are running Windows Server 2008 in their VMs, they can leverage Windows Server 2008 Hyper-V and Windows Server 2008 R2 Hyper-V.  For those customers running non-Windows VMs or do not own Windows Server 2008, you can use the new Microsoft Hyper-V Server 2008 R2 hypervisor.  This is our free, standalone hypervisor, which now includes both high availability cluster and live migration at no cost.  Both are available for download, a trial for Windows Server 2008 Hyper-V and a full download for Microsoft Hyper-V Server 2008 R2.

Best of all, Virtual Iron customers can just try out the Microsoft solutions, see if it fits their needs, and migrate on their own schedule, all at a much lower cost than the VMware solution.

Edwin Yuen
