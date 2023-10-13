---
title:      "Linux ICs for Hyper-V and GPLv2"
author: sethmanheim
ms.author: mabrigg
description: Learn about Linux ICs for Hyper-V and GPLv2
ms.date: 07/20/2009
date:       2009-07-20 13:06:00
categories: hyper-v
---
# Linux ICs for Hyper-V and GPLv2

A funny thing happened on the way to work this morning ... the Hyper-V Linux integration components (ICs) appeared in [Greg Kroah-Hartman's](http://en.wikipedia.org/wiki/Greg_Kroah-Hartman "Wikipedia") tree (aka, the Linux Driver Project) of the Linux community. This is the first time Microsoft is contributing code to the Linux kernel. The Hyper-V Linux device drivers will be licensed under GPLv2. That's 20,000 lines of code that provide the synthetic device drivers and VM bus implementation needed for a Linux guest OS to run "enlightened" on either Windows Server 2008 Hyper-V or Microsoft Hyper-V Server 2008. Greg's tree is for all Linux device drivers being contributed to the community. I'm told that within 24-48 hours it will begin to be picked up by other developers in the community, and that it won't land in the mainline tree (Torvald's tree) until it has been generally accepted in other trees along the way. So what does this mean? Here are a few thoughts: 

  * I'll be waiting to see the reaction from the Linux community and commercial Linux companies. There should be some positive comments in there along with the expected conspiracy theories ;-)
  * there's a mutual benefit for Linux distis who want to broaden their work with Windows Server, and for customers to broaden the opportunity for Linux as a guest OS running on Hyper-V
  * Customers will have another cost-cutting tool because Linux OS will run as a first-class citizen on Hyper-V, and they be able to manage Windows and non-Windows applications and hypervisors using System Center. IT system consolidation, reduce heat in the data center, optimize power draw.
  * Two Microsoft employees are listed as the maintainers of the Linux ICs, and will continue to enhance the ICs and contribute to the code. I'm sure SMP support will be high on the list.
  * Microsoft currently distirbutes ICs for SLES 10 sp2. With the release of WS08 R2 version of the ICs, we'll also add support for SLES 11 and RHEL 5.2 and 5.3. A list of suppoted products (via SVVP) can be seen [here](http://www.windowsservercatalog.com/results.aspx?&bCatID=1521&cpID=0&avc=0&ava=0&avq=0&OR=1&PGS=25 "SVVP products page").

You can watch/listen to Sam and Tom discuss today's news on Channel 9 [here](/shows/ "Channel 9 interview"). 

Patrick
