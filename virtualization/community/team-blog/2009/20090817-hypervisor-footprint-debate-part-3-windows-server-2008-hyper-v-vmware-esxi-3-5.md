---
title:      "Hypervisor Footprint Debate Part 3&#58; Windows Server 2008 Hyper-V & VMware ESXi 3.5"
description: Comparison, analysis, and debate of the Hypervisor disk footprint Part 3
author: mattbriggs
ms.author: mabrigg
date:       2009-08-17 09:01:00
ms.date: 08/17/2009
categories: esx
---
# Hypervisor Footprint Debate Part 3: Microsoft Hyper-V Server 2008 & VMware ESXi 3.5
In my last two blog posts ([Part 1](https://blogs.technet.com/virtualization/archive/2009/08/12/hypervisor-footprint-debate-part-1-microsoft-hyper-v-server-2008-vmware-esxi-3-5.aspx) & [Part 2](https://blogs.technet.com/virtualization/archive/2009/08/14/hypervisor-footprint-debate-part-2-windows-server-2008-hyper-v-vmware-esx-3-5.aspx)), I started an in depth analysis tackling VMware's claims head on that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure. If that's the case, then it stands to reason that ESX/ESXi:

  * should have fewer patches (they have less code to patch) 
  * patches should be smaller in disk footprint (they have a smaller codebase and you want to keep code churn to a minimum; otherwise one could ship a 1k stub file and claim to be smaller) 
  * should offer higher availability, reliability and uptime



Using VMware's own metrics:

  * [In part 1, Microsoft Hyper-V Server 2008 clearly won over VMware ESXi 3.5](https://blogs.technet.com/virtualization/archive/2009/08/12/hypervisor-footprint-debate-part-1-microsoft-hyper-v-server-2008-vmware-esxi-3-5.aspx)
  * [In part 2, Windows Server 2008 Hyper-V clearly won over VMware ESX 3.5](https://blogs.technet.com/virtualization/archive/2009/08/14/hypervisor-footprint-debate-part-2-windows-server-2008-hyper-v-vmware-esx-3-5.aspx)



In part 3, lets take a look at VMware's favorite comparison Windows Server 2008 Hyper-V to ESXi 3.5. Let's have a look.

**Stacking The Deck In VMware's Favor**

In this last comparison, I will freely admit that this isn't an apples to apples comparison. In this comparison, **I gave ESXi 3.5 a 6 month advantage**. Here's what I mean. Specifically, I compare:

  * VMware ESXi 3.5 from June 30th 2008 to June 30th 2009 **( _a 12 month period_ )**
  * Windows Server 2008 Hyper-V January 1 2008 to June 30th 2009 **( _an 18 month period_ )**



Using an 18 month sample set for Windows Server 2008 covers the majority of its time in market and goes to the heart VMware's fundamental claim that because their disk footprint is smaller and ESX/ESXi are single purpose hypervisors, they are therefore more secure. **This tilts the scale in VMware's favor.**

**Windows Server 2008 Hyper-V to VMware ESXi 3.5**

**Disk Footprint & Patch Count. Here's what we found:**

  * Windows Server 2008 Full Installation: 32 patches totaling 408 MB of patches 
  * Windows Server 2008 Core Installation: 26 **patches totaling 82 MB of patches or (~20% fewer than a Windows Server 2008 full installation)** 
  * VMware ESXi 3.5: **_13 patches, totaling over 2.7 GB._**



Yes, I said over **_2.7 GB_**. To put it another way,

  * **__VMware ESXi 3.5 had a 6.6x greater patch footprint than Windows Server 2008 (Full)__**
  * **__VMware ESXi 3.5 had a 33x greater patch footprint than Windows Server 2008 (Core)__**



[![Disk footprint argument image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_3.png)

So much for the disk footprint argument. Again, how can the ESXi footprint be so huge?

Because VMware releases a whole new ESXi image every time they release a patch. Furthermore, because VMware releases a whole new ESXi image every time they release a patch it also means that every ESXi 3.5 server **requires a reboot**. At this point, a VMware salesman may actually concede that every ESXi server has to be rebooted for every patch, but they will then state that they have VMotion (Live Migration) so it doesn't affect their uptime.

Except when their own patches cause days of downtime and render VMotion impotent.

**Reliability/Availability**. With VMware ESXi 3.5 Update 2, it included a serious flaw which resulted in **_two days of downtime_** for their customers including the loss of VMotion:

> _["Starting this morning, we could not power on nor VMotion any of our virtual machines," said someone identified as "mattjk" on a VMware support forum. "The VI Client threw the error 'A general system error occurred: Internal Error.'"](http://www.computerworld.com/s/article/9112439/VMware_licensing_bug_blacks_out_virtual_servers)_

It was so bad, VMware's CEO had to apologize on numerous occasions. ([HERE](http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9112439), [HERE](http://www.techworld.com.au/article/257277/vmware_ceo_apologizes_virtual-server_bug), [HERE](http://blogs.zdnet.com/virtualization/?p=506), [HERE](http://marcusoh.blogspot.com/2008/08/dont-roll-vmware-update-2-yet.html), [HERE](http://communities.vmware.com/thread/162377), & [HERE](http://kb2.vmware.com/kb/1006716.html)). VMware then rushed out the VMware ESXi 3.5 Update 3 which introduced instability to VMware High Availability and **could cause virtual machines to spontaneously reboot**. ([HERE](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1007899) & [HERE](http://blog.scottlowe.org/2008/12/12/vmware-ha-problem-with-update-3/))

[Virtual machines that spontaneously reboot due to bugs in VMware high availability](http://en.wikipedia.org/wiki/Irony).

Now consider the fact that there were two significant quality and reliability issues with two major updates **_in a row_** (ESX/ESXi Update 2  & Update 3). While the initial Windows Server 2008 Hyper-V release didn't provide Live Migration (Windows Server 2008 Hyper-V R1 had Quick Migration and [Windows Server 2008 Hyper-V R2 includes Live Migration for free](https://blogs.technet.com/virtualization/archive/2009/07/22/windows-server-2008-r2-hyper-v-server-2008-r2-rtm.aspx)), it didn't include two days of potential downtime and virtual machines unexpectedly rebooting either. For those that track availability in terms of nines (five nines is 5.26 minutes of downtime a year) VMware Update 3.5 Update 2 dropped customers to "two nines" of availability.

**_Using VMware's own metrics, Windows Server 2008 Hyper-V is clearly the winner over ESXi 3.5._**

**The Facts Contradict VMware's Claims**

As stated at the beginning of this series, VMware's overarching point is because their disk footprint is smaller and ESX/ESXi is a single purpose hypervisor, they are therefore more secure. While VMware heavily touts this claim (it's in numerous location on their website for starters), the facts from this analysis directly contradict their claims. Specifically:

  1. The platform with the largest number of patches was **VMware ESX 3.5 with 85 Security & Critical Patches averaging over a patch per week.**
  2. The platform with the largest patch footprint **was VMware ESX 3.5 totaling over 3 GB worth of patches followed by VMware ESXi 3.5 with over 2.7 GB.** That's right, VMware's single purpose virtualization platforms that claims to have the smallest footprint had the two largest patch footprints by about a mile. (Graph below) 
  3. Both VMware ESX & ESXi had a recent case of the most severe virtualization flaw with guest code able to break out of the virtual machine and could potentially: 
    * Provides administrator access, Allows complete confidentiality, integrity, and availability violation; Allows unauthorized disclosure of information; Allows disruption of service. 
  4. VMotion/Live Migration is not a panacea to patching. It can help, but in the case of VMware's own self-inflicted faulty patch, it rendered their advantage impotent. 
  5. VMware had not just one, but two significant updates with serious quality and reliability issues with both ESX and ESXi. Specifically, ESX/ESXi Update 2 Issues: [HERE](http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9112439), [HERE](http://www.techworld.com.au/article/257277/vmware_ceo_apologizes_virtual-server_bug), [HERE](http://blogs.zdnet.com/virtualization/?p=506), [HERE](http://marcusoh.blogspot.com/2008/08/dont-roll-vmware-update-2-yet.html), [HERE](http://communities.vmware.com/thread/162377), & [HERE](http://kb2.vmware.com/kb/1006716.html) & ESX/ESXi Update 3 Issues: [HERE](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1007899) & [HERE](http://blog.scottlowe.org/2008/12/12/vmware-ha-problem-with-update-3/). 



[![Footprint debate part 3 image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_thumb_1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_7.png) 

**The Point Of This Series**

Say it with me:

**_>   Security is more than just disk footprint. <_**

Quoting disk footprint size alone is a nice pithy, superficial phrase, but it's also a boat load of bollocks. The next time some VMware representative throws out that argument, point them to this blog and tell them Jeff sent you. If you've ever spent anytime with a security expert, one of the first things they will tell you is that **_security is not a one time exercise_**. **_Security is an ongoing process that should be embedded throughout the entire development lifecycle_**. It's that belief that drove us to [develop the Microsoft Secure Development Lifecycle (SDL) and is publicly available](https://www.microsoft.com/en-us/securityengineering/sdl). 

**Microsoft Secure Development Lifecycle (SDL)**

The concepts that make up the Microsoft SDL were formed with the Trustworthy Computing (TwC) directive of January 2002. At that time, many software development groups at Microsoft instigated "security pushes" to find ways to improve the security of existing code. 

Becoming a mandatory policy in 2004, the SDL represents a major cultural evolution at Microsoft with regards to software security and privacy and has matured into a well defined methodology. A "security process by a software company," the SDL was designed as an integral part of the development process. The development, implementation and constant improvement of the SDL represents a strategic investment for Microsoft, and an evolution in the way that software is designed, developed, and tested. 

From a high level, the Microsoft SDL looks like this:

##### **The Microsoft Security Development Lifecycle**

![Software Development Lifecycle gradient image](https://i.msdn.microsoft.com/cc448177.SDL-Lifecycle-gradient_0609\(en-us,MSDN.10\).jpg)

Benefits of the Microsoft SDL:

  * Reducing the number of software vulnerabilities 

The SDL has played a critical role in embedding security and privacy into Microsoft software and culture, leading to measurable and widely [recognized security improvements](https://msdnlive.redmond.corp.microsoft.com/en-us/cc424866.aspx) in flagship products such as Windows and SQL Server and the proof is real. How about:

  * **[Windows XP to Vista a 45% decrease](https://www.microsoft.com/en-us/securityengineering/sdl)**

  * **SQL Server 2000 to 2005 91% decrease**



  * **Windows Server 2008 Full vs Server Core**
    * Reduction in patches by ~50% 
* Reducing the total cost of development 

The SDL reduces the "total cost of development" by finding and eliminating vulnerabilities early. According to the [National Institute of Standards and Technology (NIST)](http://www.nist.gov/director/prog-ofc/report02-3.pdf), eliminating vulnerabilities in the design stage **can cost 30 times less than fixing them post release.**




**Read that last sentence again**.

Thirty times.

I also want to point out that the Microsoft Security Development Lifecycle doesn't end once the bits are released. It also means having a well-established response mechanism including:

  * responding to potential security threats 
  * root cause analysis to understand why the issue occurred and ensure that issue isn't repeated 
  * issuing security patches 



The importance of a security development lifecycle cannot be understated. No matter how well you execute, **_there is no such thing as perfect code_**. Whether it's Microsoft, VMware,  `<insert software vendor here>`, having a rigorous security development practices in place is imperative. And, in case you think I'm satisfied with our patch numbers above, you'd be wrong. I don't ever want to get complacent and think for a moment that "security is done." Security is never done.

Let he who has written perfect code throw the first stone.

**Let's Have A Look At The VMware's Security Development Lifecycle**

So, where's the VMware Security Development Lifecycle? 

You're guess is as good as mine.

I went to VMware's site and searched for their security development lifecycle. I found the [VMWare Security Center](http://www.vmware.com/security/advisories/) which lists their patches, but that's just one small aspect to a security development lifecycle. I Bing searched "VMware security development lifecycle" and was returned a sales pitch from VMware to buy something at $1500 per processor.

No, I'm not kidding.

[![V M ware security development lifecycle image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_thumb_3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/HyperVESXESXiFootprintDebatePart3_EB95/image_9.png)

 

**Making The SDL Available To Our Partners**

After a significant investment in time, money, manpower we've developed and want to give back to our partners. A great place to start is the [Microsoft SDL Homepage](https://www.microsoft.com/en-us/securityengineering/sdl). Here you will find whitepapers, best practices, threat modeling tools, process guidance and much more. In addition, we recently released the Microsoft SDL Process Template for Visual Studio Team Systems. This template helps ease the adoption of the SDL, demonstrates security return on investment and provides auditable security requirements and status.

I'd be remiss if I didn't point out an excellent book aptly titled, **Writing Secure Code Vol. 2** and point to the blog of one of the authors, [Michael Howard](https://blogs.msdn.com/michael_howard/). More links below.

> _Microsoft SDL Homepage_ : <https://www.microsoft.com/en-us/securityengineering/sdl>
> 
> _Microsoft SDL Process Template for Visual Studio Team System_ : <https://www.microsoft.com/en-us/securityengineering/sdl>
> 
> _Writing Secure Code Volume 2:_<http://www.amazon.com/Writing-Secure-Second-Michael-Howard/dp/0735617228>
> 
> _Michael Howard's Blog:_<https://blogs.msdn.com/michael_howard/>

In my next blog, we'll discuss more free tools and programs available our partners.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
