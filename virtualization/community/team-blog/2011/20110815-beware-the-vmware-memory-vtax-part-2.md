---
title:      "Beware the VMware Memory vTax Part 2…"
author: mattbriggs
ms.author: mabrigg
description: Beware the VMware Memory vTax Part 2
ms.date: 08/15/2011
date:       2011-08-15 06:46:00
categories: uncategorized
---
# Beware the VMware Memory vTax Part 2

Virtualization Nation,

In my last blog, [Beware the VMware Memory Tax; Plus Good News for Hyper-V…](https://blogs.technet.com/b/virtualization/archive/2011/08/01/beware-the-vmware-memory-vtax-plus-good-news-for-hyper-v.aspx), I responded to the flood of emails we’ve received about the VMware Memory Tax introduced in vSphere 5. We discussed the changes in the new vSphere 5 Licensing model and reviewed a number of additional items including:

  * Reaction from the industry
  * Feedback from VMware customers
  * VMware’s response
  * Responded to questions from you



Moreover, we included analysis comparing vSphere 5 and its new Memory vTax with both Microsoft Hyper-V Server 2008 R2 SP1 and Microsoft ECI, a suite that includes unlimited licenses for Windows Server, System Center and ForeFront. Since I posted my last blog and after widespread customer outrage, VMware has retreated from the unfathomable original vSphere 5 terms. Here’s what VMware said:

> _[“ Partners, OEMs and others … quite frankly were much more forthcoming with additional information than they were before we announced,” said Alberto Farronato, a senior product marketing manager for VMware.](http://searchservervirtualization.techtarget.com/news/2240039150/VMware-blinks-on-vSphere-5-licensing)_

After backpedaling from the original, _vSphere 5 Licensing 1.0 Terms (announced July 12 th, 2011)_, VMware is now back with new _vSphere 5 Licensing 2.0 Terms (announced August 3 rd, 2011)_. I’ve coined the terms _vSphere 5 Licensing 1.0 Terms and 2.0 Terms_ to be clear which VMware Licensing terms I ’m referring to. I’ve also done so in case VMware attempts to fix their licensing terms again with _vSphere 5 Licensing 3.0_ terms.

While VMware is delivering their best marketing spin to the situation claiming they are “customer focused,” trumpeting “they listened,” and hoping that the furor will die down, VMware is continuing to misjudge the situation and engage in selective listening with their customers. Even after modifying the vSphere 5.0 memory entitlements, the fundamental tax on memory still exists, which is an anathema to customers, and VMware is still receiving colorful feedback from their customers.

With the release of the _vSphere 5 Licensing 2.0 Terms_ , we’ve been flooded with email again asking what we think of these changes. Let’s take a quick look at what changed, examine those modifications, perform some analysis based on the new _VMware vSphere 5 Licensing 2.0 Terms_ and answer your questions. I ’ll get into the details, but specifically, here’s what you’re asking:

  1. _“ What do you think of these changes?”_
  2. _“ Will you confirm that after the recent VMware licensing changes [referring to the Aug 3rd update], that Microsoft is not considering any type of memory entitlements or other such vTax?”_



In a word, NO. Let me confirm and reiterate emphatically, that we have no intention of imposing a VM Memory vTax, a VM Core vTax or a VM Replication vTax. Let’s discuss.

**\---------------------------------------------------------------------------------------**

**Overview of vSphere 5 Licensing 2.0 Terms**

**\---------------------------------------------------------------------------------------**

For a full description of the changes in the vSphere Licensing 2.0 Terms, you can read their [announcement](http://blogs.vmware.com/rethinkit/2011/08/changes-to-the-vram-licensing-model-introduced-on-july-12-2011.html). Here’s an abridged version summarizing the changes:

> _… we are announcing three changes to the vSphere 5 licensing model that address the three most recurring areas of customer feedback:_
> 
>   * _We ’ve increased vRAM entitlements for all vSphere editions, including the doubling of the entitlements for vSphere Enterprise and Enterprise Plus._
>   * _We ’ve capped the amount of vRAM we count in any given VM, so that no VM, not even the “monster” 1TB vRAM VM, would cost more than one vSphere Enterprise Plus license._
>   * _We adjusted our model to be much more flexible around transient workloads, and short-term spikes that are typical in test & dev environment_ _s for example. We will now calculate a 12-month average of consumed vRAM to rather than tracking the high water mark of vRAM._
> 


Let’s take a closer look at each one of these changes.

 

**\---------------------------------------------------------------------------------------**

**Change #1: Upped the Memory Entitlement**

**\---------------------------------------------------------------------------------------**

Below is a table from VMware detailing the new memory entitlements with _[vSphere 5 Licensing 2.0 Terms](http://blogs.vmware.com/partner/2011/08/vmware-vsphere-5-licensing-and-pricing-update.html)_. BTW, I ’ve seen it reported in a number of places that VMware doubled the memory entitlements. That’s partially true. vSphere Standard only got an 8 GB bump, only Enterprise and Enterprise Plus were doubled. Here are the changes from VMware:

> _“ To recap, here is a comparison of the previously announced and the currently unveiled vSphere 5 vRAM entitlements per vSphere edition.”_

##### vSphere Edition

| 

##### Previous vRAM Entitlement

##### _(vSphere 5 1.0 Licensing)_

| 

#####  New vRAM Entitlement

##### _(vSphere 5 2.0 Licensing)_  
 


 
|Name|Size|Size|
|---|---|---|  
|**vSphere Enterprise+** |  48 GB | 96 GB | 
|**vSphere Enterprise** |  32 GB | 64 GB  |
|**vSphere Standard** |  24 GB | 32 GB  |
|**vSphere Essentials+** |  24 GB | 32 GB|  
|**vSphere Essentials** |  24 GB | 32 GB  |
|**Free vSphere Hypervisor** |  8 GB | 32 GB(ii)|
|**vSphere Desktop** |  Unlimited | Unlimited  |


 
> ii - **Free vSphere Hypervisor**: This limit is GB of physical RAM per physical server

While an improvement, the memory entitlements are still a tax on memory. In addition, VMware fails to recognize or even acknowledge that, from a memory standpoint, vSphere 5 is a **_downgrade_** _._ No matter how hard VMware tries to spin this change, folks see right through this.

 

**\---------------------------------------------------------------------------------------**

**Change #2: Capped the Amount of vRAM for Monster VMs**

**\---------------------------------------------------------------------------------------**

With the original vSphere 5 Licensing 1.0 running a single “monster” virtual machine with 1 TB of memory cost over $70,000 in licensing costs alone. After customers pointed out how ridiculous this was, VMware improved their licensing scenario for running large VMs. While this is an improvement, the change addresses an edge case. The more common scenario is that you have servers with large amounts of physical memory running lots of virtual machines. The real effect of this change is relatively minimal for customers compared to the fact that VMware still taxes you on the more common scenario running large physical memory footprints running lots of VMs.

Which option would you prefer?

  1. Paying more for _large_ VMs
  2. Paying more for running _more_ VMs
  3. Neither, licensing the whole server and running your VMs as you see fit



Me too.

 

**\---------------------------------------------------------------------------------------**

**Change #3: Added Variable Pricing for Transient Workloads**

**\---------------------------------------------------------------------------------------**

The third change is required to deal with fundamental issues created by the vTax and _adds_ new problems of its own. Here ’s the change:

> _“ We’ve adjusted our model to be much more flexible around transient workloads, and short-term spikes that are typical in test & development environments for example. We will now calculate a 12-month average of consumed vRAM to rather than tracking the high water mark of vRAM.”_

While it a nice gesture to see that a customer won’t get a $70,000 budget hit for simply turning on a 1 TB VM, the whole concept of a **_rolling average_** creates new problems like variable pricing. The rolling average vTax adds complexity and variability. How do you budget for this? Assume worst case and hope for the best? What about unplanned capacity needs? In the past, you likely added more physical memory to your servers and ran some more VMs. Now, it ’s likely you’ll need to pay a tithe to VMware first. How do you effectively plan for the future?

**_How does this benefit you?_**

 

**\---------------------------------------------------------------------------------------**

**Expect More vTaxes in the Future**

**\---------------------------------------------------------------------------------------**

Here’s what VMware said with the introduction of vSphere 5 and the move to the memory vTax: ****

> _” With the introduction of VMware vSphere 5, VMware is evolving the product’s licensing to lay the foundation for customers to adopt a more cloud-like IT cost model based on consumption and value rather than physical components and capacity” \- _**_Mark Peek, VMware CFO_** ****

And here’s what you think of this new cost model:

> _[VMware says: “This new licensing is great for cloud computing.” If this new licensing is a step toward cloud computing, we’re in big trouble. Virtualization has been helping us save money. We run more apps on fewer servers. You’re now saying that’s not true anymore. The more apps, the more it costs. Say again? Why am I moving to the cloud? This contradicts everything vmware has said for years.](http://blogs.vmware.com/virtualreality/2011/07/setting-microsoft-straight-on-the-vmware-service-provider-program-vspp.html#comments)_

With the _vSphere 5 Licensing 2.0 Terms_ has anything fundamentally changed? No.

If you’re wondering if VMware’s vTaxes are here to stay, wonder no more. This statement says it all:

> _[“ We are confident that our vSphere 5 licensing model based on pooled vRAM is the right one for the cloud computing era.”](http://blogs.vmware.com/rethinkit/2011/08/changes-to-the-vram-licensing-model-introduced-on-july-12-2011.html) \- **Bogomil Balkansky, VMware VP**_

Despite customers explicitly telling VMware in no uncertain terms that **_the vTax model is the problem_** , VMware has reiterated that the new vTax model is here to stay. Considering VMware’s regular licensing increases, one can easily expect further vTaxes in the future. Today, it’s the VMware Memory vTax. I wouldn’t be surprised to see additional taxes in the future such as a:

  * VMware Storage vTax
    * Capacity? IOPs?
  * VMware Network vTax
    * …and more…



 

**\---------------------------------------------------------------------------------------**

**Twitter: #vTax**

**\---------------------------------------------------------------------------------------**

After the vSphere 5 Licensing 1.0 Terms were announced, users quickly created a new hashtag devoted to the new vSphere Memory Tax topic [#vtax](https://twitter.com/#!/search?q=%23vTax) and roundly derided the new vTax. This time, with the release of the vSphere Licensing 2.0 announcement, VMware quickly flooded Twitter [#vtax](https://twitter.com/#!/search?q=%23vTax) with VMware employees trumpeting that “VMware heard their customers” in a desperate effort to sweep this mess under the rug.

 

**\---------------------------------------------------------------------------------------**

**Industry Reaction**

**\---------------------------------------------------------------------------------------**

A few days after VMware backed down from the _vSphere 5 1.0 Licensing Terms_ and announced the release of the _vSphere 5 Licensing 2.0 Terms_ , press and analysts point out that **the _vSphere 5 Licensing 2.0 Terms_ still results in a price increase**. Here are some examples and a sampling of quotes from a few articles:

[ http://www.infoworld.com/d/open-source-software/vmware-backs-down-vsphere-5-pricing-only-partway-169030](http://www.infoworld.com/d/open-source-software/vmware-backs-down-vsphere-5-pricing-only-partway-169030)

> _“ As a result, this example customer is paying 50 percent more under the revised vSphere 5 license than with vSphere 4 -- but at least it’s not 300 percent more, as was the case with the original vSphere 5 licensing model.”_

And…

> _In explaining the change, VMware said customers could use a 1TB VRAM virtual machine while reducing their vRAM allotment by only 96GB from the total VRAM pool. **Customers would still need sufficient vSphere CPU-based licenses to use the 1TB (or however much) of physical RAM available on the system. In other words, this change applies only to how much VRAM is used from within the VRAM pool. Thus, you may need additional vSphere CPU-based licenses if you exceed the total pooled VRAM allotment later on.**_

And…

> **_Despite the changes, your costs go up, so don't put all your eggs in the VMware basket_** _  
>  But the cost still goes up for many customers. And risk remains that it will continue to go up: Although VMware backed off somewhat from its original fee structure, the new licensing may change in the future, after customers are heavily reliant on VMware for even their Tier 1 applications._

[http://www.theregister.co.uk/2011/08/04/vmware_vsphere_price_change/](http://www.theregister.co.uk/2011/08/04/vmware_vsphere_price_change/)

> _In this case, vSphere 5 Enterprise Plus would have cost $150,285 – that's eight licenses to cover the eight sockets in the sever with 48GB each plus another 35 licenses to boost the memory to 2TB. After these changes, vSphere 5 just costs $27,960 - **exactly what vSphere 4 cost with half as much physical and virtual memory supported**._

[http://arstechnica.com/business/news/2011/08/vmware-capitulates-over-vsphere-5-pricing-kinda.ars](http://arstechnica.com/business/news/2011/08/vmware-capitulates-over-vsphere-5-pricing-kinda.ars)

_[BulkRate](http://arstechnica.com/civis/memberlist.php?mode=viewprofile&u=23019&sid=71a0e7cac15d6a30b06a002a92413fc9)_ _Registered: Sep 9, 2003_ _Posts: 511_ __ _[Posted: Fri Jul 29, 2011 2:10 pm](http://arstechnica.com/civis/viewtopic.php?p=21904689&sid=71a0e7cac15d6a30b06a002a92413fc9#p21904689)_ __  

_It still feels like a money-grab, now with a hamfisted manipulation attempt added in via the "piss 'em off with the crazy limits first, then announce the ones we'd intended all along" approach. It means I'm not actualy regarded as one of VMware's customers, nor are my needs or strategies based upon their product taken into account in any meaninful way._ _This change repairs some of the damage to our existing Essentials+ cluster's operational lifetime plan (RAM upgrade in 1+ year), but I'm still not seeing whether the Hypervisor standalone product remains capped into uselessness at 8GB, or bumps up to 12GB in line with the other changes._ _Either way, they've tried this once and will likely do so again. Damage done and now they're on my "Vendors to Anticipate Screwage From" list. Next version (v3) of Hyper-V gets an honest evaluation spot in our environment plus migration plan. When our support's up in about 2 years we'll be ready._ __  
  
**Ars Technica Comment 1:**

[![clip_image002](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4403.clip_image002_thumb_33360A8A.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8306.clip_image002_0C823A53.jpg)

**Ars Technica Comment 2:**

> _I'm something that VMware seems care even less for; one of their SMB customers with fewer than 20 physical servers._ A little over a year ago I convinced my company to BUY a PAID suite (Essentials+) that met our needs initially and have watched its long-term viability decline with the v5 license changes. I've no issue with the performance or reliability of VMware's product, but there's seriously mixed signals from v4 to v5 on how buinsesses are expected to make production use of virtualization. The loss of that focus is disconcerting for someone tasked with extracting actual value from an IT infrastructure...i.e. "work". As it is, we'll adapt, in this case likely by choosing a less capable but adequate product instead of drinking the "best of breed" kool-aid in the future.In the last month, VMware made a hell of a lot of extra work for me instead of "freeing IT up to focus on productivity". In fact, no one should expect to have a vendor yank the carpet out from under them on a product they've already bought. As for my complaints on the Hypervisor product, I'm using said product for its advertised purpose as a low-cost entry-level hypervisor and proof of concept to spur virtualization adoption in our enterprise. What do you know, it DID result in the purchase of their paid product at our headquarters.VMware's chiseling began in earnest right after we bought a paid product. I lost the ability to manage/perform backups in a streamlined manner on our remote office servers (i.e. VMware made 3rd party backup API access a violation of license), the ability to run a free vCLI appliance on my free hypervisor (an upgoming gem in the v5 license) in my remote offices, and now 4GB of already installed RAM in each server will effectively go dark if I upgrade (again due to license stipulations in v5). See a trend? I am. **Successful products are supposed to increase in capability over time, not stagnate or decline**.

**Ars Technica Comment 3:**

> _...Please allow me to remove your confusion. Or at least let you know how an IT department on a limited budget operates. We plan for things, usually the more money being spent, the more planning has to be done. It's reasonable to have a set of expectations for how you'll use a product over the term of support for said product. You can't plan for what was changed in v5. It's upset me. Upset people complain._ _I bought Essentials+, and 3 years of support about a year ago. I justified the cost of paying in advance in the fair certainty that at least one major new version of the software would be released during over 2010-2013. In order to leaverage one of the prime benefits of having that ongoing support, you'd expect to be able to upgrade to newer versions/capabilities over the covered term. The newly introduced original entitlements of v5 limit blew the living snot out of our scale-up plans...you know the whole marketing drivel VMware spouted about upgrading host machines to meet client performance expectations rather than adding costly servers as of v4 and over the past 5-7 years?_ _Staying pat (and eventually dropping off the edge of support) IS an answer, but not a very palatable one. It's the response I'd expect coming from the licensing vendor, not from someone such as yourself. Forgive me my surprise._ _It's a little better with the likely announcement this thread references...but it is galling treatment from a vendor._

**Ars Technica Comment 4:**

[![clip_image003](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7043.clip_image003_thumb_3910AE23.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1460.clip_image003_19E84D59.png)

[ http://www.gabesvirtualworld.com/vmware-changes-vram-licensing-on-vsphere-5-after-customer-feedback-on-vtax/](http://www.gabesvirtualworld.com/vmware-changes-vram-licensing-on-vsphere-5-after-customer-feedback-on-vtax/)

[![clip_image005](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4810.clip_image005_thumb_05D474BA.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7635.clip_image005_5D504EBB.jpg)

[http://www.crn.com/news/data-center/231300048/vmware-changing-vsphere-5-licensing-to-allow-monster-vms.htm;jsessionid=Va3NR0st+JroIy7vS9Iyug**.ecappj01](http://www.crn.com/news/data-center/231300048/vmware-changing-vsphere-5-licensing-to-allow-monster-vms.htm;jsessionid=Va3NR0st+JroIy7vS9Iyug**.ecappj01)

> _Given the amount of heat VMware[ took from customers and partners](http://www.crn.com/news/data-center/231001634/vmware-customers-fuming-over-vsphere-5-licensing-changes.htm) after revealing the vSphere 5 licensing changes, it's not surprising to see VMware change its terms, one channel partner told CRN. _
> 
> __  
> _"Aside from the customers yelling, I imagine that the server manufacturers were also screaming their heads off about the initial vSphere 5 limitations," said the source, who requested anonymity. "I could see customers calling their server manufacturers and trying to return the RAM they purchased because they couldn't even use it."_

Let’s now take a look at VMware’s own Community Forums.

**\---------------------------------------------------------------------------------------**

**VMware ’s Community Forums**

**\---------------------------------------------------------------------------------------**

**VMware vSphere 5 Licensing 1.0 Terms** : In the first two and a half weeks after the release of vSphere 5 Licensing 1.0 and VMware’s _first_ attempt at new licensing increases, VMware ’s own community forum had over 83 pages with over 1250 posts (~75 a day) from disgruntled customers. Their comments and colorful metaphors expressed their lack of enthusiasm for the new vSphere 5 licensing model.

From: [http://communities.vmware.com/thread/320877?start=1305&tstart=0](http://communities.vmware.com/thread/320877?start=1305&tstart=0)

With the release of the updated _vSphere 5 Licensing 2.0 Terms_ and VMware promising that the new announcement would  “ _address all your concerns, ”_ surely the thread would die down and customers would be supportive.

**VMware vSphere 5 Licensing 2.0 Terms** : Despite VMware’s assurances, __ VMware customers clearly feel otherwise. Generally, customers on VMware’s community forums are supportive, but for the second time in a row—not so much. Since the release of the _vSphere 5 Licensing 2.0 Terms_ , the thread has now grown to over 100 pages with over 1500 posts. Below are just a few comments:

**Comment 1:**

[![clip_image006](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5086.clip_image006_thumb_048FDBDB.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6558.clip_image006_71696B44.png)

**Comment 2:**

[![clip_image007](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6567.clip_image007_thumb_74A09716.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0207.clip_image007_42377FAD.png)

**Comment 3:**

[![clip_image008](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5700.clip_image008_thumb_5340F17A.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6253.clip_image008_4F315FBE.png)

**Comment 4:**

[![clip_image009](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1680.clip_image009_thumb_3828226C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0714.clip_image009_5578364C.png)

**Comment 5:**

[![clip_image010](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1261.clip_image010_thumb_1583E3F1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7242.clip_image010_0DB6AD65.png)

**Comment 6:**

[![clip_image011](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5074.clip_image011_thumb_1A19EEAB.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2845.clip_image011_25DA17C0.png)

**Comment 7:**

[![clip_image012](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2742.clip_image012_thumb_3817FC9F.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5187.clip_image012_374A7898.png)

**Comment 8:**

[![clip_image013](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7115.clip_image013_thumb_1DD7937B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7651.clip_image013_729DDE56.png)

**Comment 9:**

[![clip_image014](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8611.clip_image014_thumb_344A3202.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5078.clip_image014_0AC148B2.png)

This last comment got me wondering if VMware has any licensing sessions at the upcoming VMworld 2011 conference (in a couple weeks) to further explain and clarify the new licensing model and listen to any additional customer feedback.

**\---------------------------------------------------------------------------------------**

**VMworld 2011 Licensing Sessions?**

**\---------------------------------------------------------------------------------------**

I did a quick search in the VMworld Session Builder to check and yes, there is a new session titled, “What’s New with VMware vSphere 5.0 Licensing and Pricing (Twitter hashtag: [#PAR2368](https://twitter.com/#!/search/%23par2368)).”

Unfortunately, it’s a session in the _Partner Track_ and customers aren ’t allowed. I suppose VMware isn’t interested in anymore feedback. Maybe next time.

[![clip_image016](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5875.clip_image016_thumb_18C52FFF.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5504.clip_image016_09E8E2C8.jpg)

**\---------------------------------------------------------------------------------------**

**Follow-Up From the Last Blog: So What ’s Really Happening**

**\---------------------------------------------------------------------------------------**

In the preceding blog, “Beware the VMware Memory Tax,” I wrote this:

> _Personally, here ’s what I think is happening. It looks like VMware decided to release the new vSphere Licensing and push the licensing fees as high as possible. In many cases the price increase is 2x-4x (in some cases higher)._  
>  __
> 
> _I surmise that VMware knows full well they pushed these increases too high and will come back at VMWorld to “fix things.” I can see their CEO, Paul Maritz, start the conference by saying, “We heard you and tweaked the memory entitlement numbers. Now let’s stop talking about licensing and hey, look at this shiny thing over here…”_  
>  __
> 
> _In essence, what all that would mean is that maybe VMware won ’t get a 4x-8x price increase, but after they “fix things,” VMware still extracts a hefty 2x price hike and can hope their customers think a 2x price hike looks good in comparison—or better, don’t notice._

I revisit this topic up because I read this post in VMware’s Community Blog which appears to confirm my suspicion. Note the highlighted area.

[![clip_image017](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6052.clip_image017_thumb_3B39BEBA.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8233.clip_image017_102FB956.png)

BTW, I was mistaken about one thing, the timeline. It’s now abundantly clear that VMware is trying to sweep this under the rug as quickly as possible **_and before VMworld_** so Mr. Maritz and VMware can avoid the vTax topic altogether.

**\---------------------------------------------------------------------------------------**

**Examining the Facts: Preface**

**\---------------------------------------------------------------------------------------**

Now that we’ve reviewed customer feedback, let’s analyze a few configurations and include real world figures. Before we do, let me be transparent as to what we’re comparing. VMware will be the first to tell you that their new licensing model isn’t based on physical memory. Here’s an exact quote from VMware’s licensing documentation.

> **_VMware vSphere 5.0: Licensing, Pricing and Packaging p.3_** _VMware vSphere 5 is licensed on a per-processor basis with a vRAM entitlement. Each VMware vSphere 5 processor license comes with an entitlement to a certain amount of vRAM capacity, or memory configured to virtual machines._

While I understand and acknowledge their licensing isn’t based on physical memory, this begs a few questions:

  * How many people purchase servers and do not try to fully utilize them?
  * What’s the point of purchasing a server and loading it with memory if not to use it?
  * Isn’t better hardware utilization one of the many great reasons we use virtualization?



In fact, according to VMware’s own website, [the top reason touted for virtualization is](http://www.vmware.com/virtualization/):

> _“ Reduce costs by increasing energy efficiency and requiring less hardware with server consolidation.”_

So, for the analysis below, I’m going to make the _rash_ assumption that you would like to fully utilize the memory in the server or pool. If you disagree, for example:

  * You want to calculate for active & passive failover nodes
    * 4 Active Nodes + 1 Passive Node
    * 8 Active Nodes + 2 Passive Nodes
    * Etc.
  * You only want to target 60%/75%/ \<insert your own value here\> of physical memory use per node



…please feel free to do so and apply some sort of discount. I don’t know what your target utilization is and I’m not going to guess, so I’m going to assume maximum utilization.

The analysis below is all based on the _vSphere 5 Licensing 2.0 Terms_ announced on August 3 rd 2011.

**\---------------------------------------------------------------------------------------**

**1 Server: vSphere 5 vs. Microsoft Hyper-V Server 2008 R2 SP1**

**\---------------------------------------------------------------------------------------**

Let’s compare a _single server_ populated with various memory configurations.

In this first comparison, let’s analyze the effect of the VMware Memory Tax and focus on the hypervisor layer. For this comparison, I’m going to use VMware vSphere 5.0 and [Microsoft Hyper-V Server 2008 R2 SP1](https://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx). Microsoft Hyper-V Server 2008 R2 SP1 is our stand-alone hypervisor available as a free download. This comparison allows us to focus on the ability of the hypervisor to fully utilize memory resources in a physical server for virtual machines. Let me preface this example by stating, this comparison doesn’t include hardware, guest operating system licenses, storage, networking, or systems management.

This comparison includes VMware’s Support and Subscription (SnS) licensing. I was going to be charitable and omit the SnS subscription, but then I read in the VMware vSphere 5.0 Licensing, Pricing and Packaging whitepaper at the bottom of pages 3-11 in the fine print it states, “SnS is required for all vSphere purchases.” Thus, I included the SnS License per VMware’s requirement. It should be noted that because the VMware Memory Tax requires purchasing more licenses for larger memory footprints and because "a Support and Subscription (SnS) contract is required for every vSphere Edition purchase", the SnS requirement acts as a subtle, additional tax even if the user is purchasing the extra license for vRAM capacity.

The first comparison is vSphere 5 to [Microsoft Hyper-V Server 2008 R2 SP1](https://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx).

| **VSphere 5.0 Standard** ****| **VSphere 5.0 Enterprise** ****| **VSphere 5.0 Enterprise Plus** ****| **Microsoft Hyper-V Server 2008 R2 SP1** ****  
---|---|---|---|---  
**Cost Per CPU** ****|  $995 | $2875 | $3495 | None ($0)  
**VMware SnS Per CPU (3 Years)** ****|  $746 | $2,156 | $2,621 | \--  
**Memory “Entitlement” (vTax)** ****|  32 GB | 64 GB | 96 GB | **No Memory Tax**. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**.  
**1 Physical Server (2 Sockets) with 128 GB RAM** ****|  4 licenses $6,965 | 2 licenses $10,063 | 2 licenses $12,233 | Included  
**1 Physical Server (2 Sockets) with 192 GB RAM** ****|  6 licenses $10,448 | 3 licenses $15,094 | 2 licenses $12,233 | Included  
**1 Physical Server (2 Sockets) with 256 GB RAM** ****|  8 licenses $13,930 | 4 licenses $20,125 | 3 licenses $18,349 | Included  
**1 Physical Server (2 Sockets) with 384 GB RAM** ****|  12 licenses $20,895 | 6 licenses $30,187 | 4 licenses $24,465 | Included  
**1 Physical Server (4 Sockets) with 512 GB RAM** ****|  16 licenses $27,860 | 8 licenses $40,250 | 6 licenses $36,698 | Included  
**1 Physical Server (4 Sockets) with 768 GB RAM** ****|  24 licenses $41,790 | 12 licenses $60,375 | 8 licenses $48,930 | Included  
**1 Physical Server (4 Sockets) with 1024 GB RAM** ****|  32 licenses $55,720 | 16 licenses $80,500 | 11 licenses $67,279 | Included  
  
Table 1: Memory Tax: vSphere 5 vs. MS Hyper-V Server 2008 R2 SP1 (1 Server)

**\---------------------------------------------------------------------------------------**

**10 Servers: vSphere 5 vs. Microsoft Hyper-V Server 2008 R2 SP1**

**\---------------------------------------------------------------------------------------**

Now, let’s compare populating a _pool of virtualization servers_ with various memory configurations.

In this second comparison, let’s analyze the effect of the VMware Memory Tax on a 10 node cluster (or two 5 node clusters if your prefer). This second comparison also allows us to focus on the ability of the hypervisor to fully utilize memory resources in a pool of physical servers for virtual machines. Like the first example, let me preface this by stating, this comparison doesn’t include hardware, guest operating system licenses, storage, networking or systems management. This comparison does include VMware’s Support and Subscription (SnS) licensing per VMware’s requirement that “ _SnS is required for all vSphere purchases_. ”

| **VSphere 5.0 Standard** ****| **VSphere 5.0 Enterprise** ****| **VSphere 5.0 Enterprise Plus** ****| **Microsoft Hyper-V Server 2008 R2 SP1** ****  
---|---|---|---|---  
**Cost Per CPU** ****|  $995 | $2875 | $3495 | None ($0)  
**VMware SnS Per CPU (3 Years)** ****|  $746 | $2,156 | $2,621 | \--  
**Memory “Entitlement” (vTax)** ****|  32 GB | 64 GB | 96 GB | **No Memory Tax**. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**.  
**10 Physical Servers (2 Sockets) with 128 GB RAM** ****|  10 x 4 licenses$69,650 | 10 x 2 licenses $100,630 | 10 x 2 licenses $122,330 | Included  
**10 Physical Servers (2 Sockets) with 192 GB RAM** ****|  10 x 6 licenses $104,480 | 10 x 3 licenses $150,940 | 10 x 2 licenses $122,330 | Included  
**10 Physical Servers (2 Sockets) with 256 GB RAM** ****|  10 x 8 licenses $139,300 | 10 x 4 licenses $201,250 | 10 x 3 licenses $183,490 | Included  
**10 Physical Servers (2 Sockets) with 384 GB RAM** ****|  10 x 12 licenses $208,950 | 10 x 6 licenses $301,870 | 10 x 4 licenses $244,650 | Included  
**10 Physical Servers (4 Sockets) with 512 GB RAM** ****|  10 x 16 licenses $278,600 | 10 x 8 licenses $402,500 | 10 x 6 licenses $366,980 | Included  
**10 Physical Servers (4 Sockets) with 768 GB RAM** ****|  10 x 24 licenses $417,900 | 10 x 12 licenses $603,750 | 10 x 8 licenses $489,300 | Included  
**10 Physical Servers (4 Sockets) with 1024 GB RAM** ****|  10 x 32 licenses $557,200 | 10 x 16 licenses $805,000 | 10 x 11 licenses $672,790 | Included  
  
Table 2: Memory Tax: vSphere 5 vs. MS Hyper-V Server 2008 R2 SP1 (10 Servers)

At this point, you’re may be thinking, “Doesn’t VMware offer a free ESXi version?”

Yes, which VMware promptly downgraded from the previous version. The free version of vSphere ESXi 5 **_is now limited to supporting a total of 32 GB of physical memory_**.

**\---------------------------------------------------------------------------------------**

**1 Server: vSphere 5 vs. Windows Server 2008 R2 SP1**

**\---------------------------------------------------------------------------------------**

In this next analysis, let’s look at the full stack and the effect of the VMware Memory Tax on the complete equation. For this comparison, I’m going to use VMware vSphere 5.0 and the Microsoft ECI Suite.

The Microsoft ECI Suite includes: Windows Server 2008 R2 SP1 Datacenter Edition and System Center Datacenter Edition and Forefront Security. At a very high level, this provides:

  * _Unlimited number of virtualized Windows Server instances_
  * _Management for an unlimited number of virtual machines (and more importantly the apps running within those VMs) for all of System Center including:_
    * _Operations Manager_
    * _Configuration Manager_
    * _Data Protection Manager_
    * _Service Manager_
    * _Opalis (Orchestrator)_
      * _This product was released this past year and automatically added to the System Center Suite this past year. Existing customers received this automatically added at no additional cost._
    * _Virtual Machine Manager_
  * _Forefront for unlimited number of virtual machines which provides a unified, multilayered, and highly manageable approach to protecting servers from malware_



The VMware figures below include VMware’s Support and Subscription (SnS) licensing per VMware’s requirement that “ _SnS is required for all vSphere purchases_ ” and include the cost of providing unlimited Windows Server Datacenter instances to more closely match the Microsoft ECI offering. The VMware figures do not include System Center or Forefront licensing. Like the previous examples, this example doesn’t include server hardware or storage.

| **VSphere 5.0 Standard** ****| **VSphere 5.0 Enterprise** ****| **VSphere 5.0 Enterprise Plus** ****| **MS Core Infrastructure Windows Server 2008 R2 SP1 Datacenter Edition, System Center Datacenter Edition & Forefront** ****  
---|---|---|---|---  
**Cost Per CPU** ****|  $995 | $2875 | $3495 | $4584  
**Guest Instance Cost per CPU (3 year cost including SA)** ****|  $4182 | $4182 | $4182 | Included Above  
**VMware SnS Per CPU (3 Years)** ****|  $746 | $2,156 | $2,621 | \--  
**Memory “Entitlement” (vTax)** ****|  32 GB | 64 GB | 96 GB | No Memory Tax. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**.  
**1 Physical Server (2 Sockets) with 128 GB RAM** ****|  4 licenses $15,329 | 2 licenses $18,427 | 2 licenses $20,597 | 2 licenses $9,168  
**1 Physical Server (2 Sockets) with 192 GB RAM** ****|  6 licenses $18,812 | 3 licenses $23,458 | 2 licenses $20,597 | 2 licenses $9,168  
**1 Physical Server (2 Sockets) with 256 GB RAM** ****|  8 licenses $22,294 | 4 licenses $28,489 | 3 licenses $26,713 | 2 licenses $9,168  
**1 Physical Server (2 Sockets) with 384 GB RAM** ****|  12 licenses $29,259 | 6 licenses $38,551 | 4 licenses $32,829 | 2 licenses $9,168  
**1 Physical Server (4 Sockets) with 512 GB RAM** ****|  16 licenses $44,588 | 8 licenses $56,978 | 6 licenses $53,426 | 4 licenses $18,336  
**1 Physical Server (4 Sockets) with 768 GB RAM** ****|  24 licenses $58,518 | 12 licenses $77,103 | 8 licenses $65,658 | 4 licenses $18,336  
**1 Physical Server (4 Sockets) with 1024 GB RAM** ****|  32 licenses $72,448 | 16 licenses $97,228 | 11 licenses $84,007 | 4 licenses $18,336  
  
Table 3: Memory Tax: vSphere 5 vs. Microsoft ECI (1 Server)

**\---------------------------------------------------------------------------------------**

**10 Servers: vSphere 5 vs. Windows Server 2008 R2 SP1**

**\---------------------------------------------------------------------------------------**

In this final analysis, let’s look at the full stack and the effect of the VMware Memory Tax on the complete equation. For this comparison, I’m going to use VMware vSphere 5.0 and the Microsoft ECI Suite.

The Microsoft ECI Suite includes: Windows Server 2008 R2 SP1 Datacenter Edition and System Center Datacenter Edition and Forefront Security. At a very high level, this provides:

  * _Unlimited number of virtualized Windows Server instances_
  * _Management for an unlimited number of virtual machines (and more importantly the apps running within those VMs) for all of System Center including:_
    * _Operations Manager_
    * _Configuration Manager_
    * _Data Protection Manager_
    * _Service Manager_
    * _Opalis (Orchestrator)_
      * _This product was released this past year and automatically added to the System Center Suite this past year. Existing customers received this automatically added at no additional cost._
    * _Virtual Machine Manager_
  * _Forefront for unlimited number of virtual machines which provides a unified, multilayered, and highly manageable approach to protecting servers from malware_



The VMware figures below include VMware’s Support and Subscription (SnS) licensing per VMware’s requirement that “ _SnS is required for all vSphere purchases_ ” and include the cost of providing unlimited Windows Server Datacenter instances to more closely match the Microsoft ECI offering. The VMware figures do not include System Center or Forefront licensing. Like the previous examples, this example doesn’t include server hardware or storage. Let’s take a look at a 10 node cluster (or two 5 node clusters if your prefer).

| **VSphere 5.0 Standard** ****| **VSphere 5.0 Enterprise** ****| **VSphere 5.0 Enterprise Plus** ****| **MS Core Infrastructure Windows Server 2008 R2 SP1 Datacenter Edition, System Center Datacenter Edition & Forefront** ****  
---|---|---|---|---  
**Cost Per CPU** ****|  $995 | $2875 | $3495 | $4584  
**Guest Instance Cost per CPU (3 year cost including SA)** ****|  $4182 | $4182 | $4182 | Included Above  
**VMware SnS Per CPU (3 Years)** ****|  $746 | $2,156 | $2,621 | \--  
**Memory “Entitlement” (vTax)** ****|  32 GB | 64 GB | 96 GB | No Memory Tax. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**.  
**10 Physical Servers (2 Sockets) with 128 GB RAM** ****|  10 x 4 licenses $153,290 | 10 x 2 licenses $184,270 | 10 x 2 licenses $205,970 | 2 licenses $91,680  
**10 Physical Servers (2 Sockets) with 192 GB RAM** ****|  10 x 6 licenses $188,120 | 10 x 3 licenses $234,580 | 10 x 2 licenses $205,970 | 2 licenses $91,680  
**10 Physical Servers (2 Sockets) with 256 GB RAM** ****|  10 x 8 licenses $222,940 | 10 x 4 licenses $284,890 | 10 x 3 licenses $267,130 | 2 licenses $91,680  
**10 Physical Servers (2 Sockets) with 384 GB RAM** ****|  10 x 12 licenses $292,590 | 10 x 6 licenses $385,510 | 10 x 4 licenses $328,290 | 2 licenses $91,680  
**10 Physical Servers (4 Sockets) with 512 GB RAM** ****|  10 x 16 licenses $445,880 | 10 x 8 licenses $569,780 | 10 x 6 licenses $534,260 | 4 licenses $183,360  
**10 Physical Servers (4 Sockets) with 768 GB RAM** ****|  10 x 24 licenses $585,180 | 10 x 12 licenses $771,030 | 10 x 8 licenses $656,580 | 4 licenses $183,360  
**10 Physical Servers (4 Sockets) with 1024 GB RAM** ****|  10 x 32 licenses $724,480 | 10 x 16 licenses $972,280 | 10 x 8 licenses $840,070 | 4 licenses $183,360  
  
Table 4: Memory Tax: vSphere 5 vs. Microsoft ECI (10 Servers)

 

**\---------------------------------------------------------------------------------------**

**What History Tells Us About VMware**

**\---------------------------------------------------------------------------------------**

Here’s a quick overview of the past three VMware releases, how it impacts you and what it portends for the future.

**[VMware ESXi3: VMware Clamps Down on Development for Free Hypervisor](http://searchservervirtualization.techtarget.com/news/1358344/VMware-clampdown-on-free-ESXi-may-prompt-defection-to-Hyper-V)**

  * Veeam creates a backup product for VMware’s free hypervisor
  * VMware demands Veeam stop development for the free ESXi hypervisor
    * VMware prefers to upsell you on their solution for the paid for hypervisor
  * Veeam complies per VMware resulting in no more backup solutions for the free hypervisor



**[VMware Virtual Infrastructure 3.x (VI3) –> VMware vSphere 4.x](https://blogs.technet.com/b/virtualization/archive/2009/06/28/beware-the-vmware-core-tax-and-more.aspx)**

  * VMware adds a Core Tax
    * Standard & Enterprise Editions limited to 6 cores per processor
    * Advanced & Enterprise Plus Editions limited to 12 cores per processor
  * VMware adds new editions
    * vSphere Advanced Edition is added which costs less than Enterprise, but supports more cores per processor. The net effect is that a former top tier customer has been effectively downgraded and is required to pay for an upgrade to Enterprise Plus to fully utilize newer hardware with more cores.
  * VMware removes features from lower editions and moves them to higher editions to force customers to upgrade
    * Hot Add Virtual Disk removed from VI 3 Standard and moved to vSphere 4.x Advanced & Higher. For customers to regain the lost Hot Add Virtual Disk functionality is a 282% increase in licensing costs.



**VMware vSphere 4.x –>** **VMware vSphere 5**

  * VMware removes the Core Tax and Adds a Memory Tax
    * vSphere 5 Licensing Terms 1.0
      * [VMware introduces new, unspeakably awful licensing terms. Customers outraged](https://blogs.technet.com/b/virtualization/archive/2011/08/01/beware-the-vmware-memory-vtax-plus-good-news-for-hyper-v.aspx).
    * vSphere 5 Licensing Terms 2.0
      * VMware tweaks the terms in hopes to appease customers and ignores the fundamental issue of the tax on memory
  * The new VMware Memory vTax Licensing model also means that many vSphere 4.x customers who were licensed to fully utilize the memory in their systems cannot anymore without paying for an upgrade because the Memory Entitlements don’t fully cover the amount of physical memory in the existing system. The net effect is that customers are seeing a downgrade in the amount of memory they can use due to the new memory restrictions.



**_History clearly shows VMware has a pattern of reducing core functionality to force upgrades while changing the Licensing Terms to extract more revenue from their customers_**.

 

**\---------------------------------------------------------------------------------------**

**Microsoft Hyper-V Server: Customer Driven**

**\---------------------------------------------------------------------------------------**

In contrast, let’s compare the previous three Microsoft Hyper-V Server 2008 releases with VMware’s previous three releases. I chose to use Microsoft Hyper-V Server to point out how we’re focused on providing a high performance, enterprise class virtualization platform for _everyone_. 

  * Microsoft Hyper-V Server 2008
    * Released in October 2008
    * High performance, single purpose hypervisor
  * [Microsoft Hyper-V Server 2008 R2](https://blogs.technet.com/b/virtualization/archive/2009/07/30/microsoft-hyper-v-server-2008-r2-rtm-more.aspx)
    * Released July 2009
    * **_Per customer feedback_** we added:
      * Live Migration (aka VMotion)
      * High Availability
      * Support for 1 TB of physical memory
      * Support for VMs with up to 64 GB of memory each
      * Core Parking to further reduce power consumption
      * …and more…
  * [Microsoft Hyper-V Server 2008 R2 SP1](https://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx)
    * Released August 2011
    * **_Per customer feedback_** we added:
      * Dynamic Memory
      * [RemoteFX](https://blogs.technet.com/b/virtualization/archive/2011/05/05/5nine-manager-for-hyper-v.aspx)



**_Notice that every change has benefited you. More scale. More VM Mobility. More VM capabilities. All at no charge._**

In addition, Microsoft Hyper-V Server’s has a [publicly documented management interface](https://msdn.microsoft.com/library/cc136992\(VS.85\).aspx) and we _encourage_ , not discourage, folks to develop for our free hypervisor. Here’s just one example from [5Nine software](http://www.5nine.com/5nine-manager-for-hyper-v-free.aspx).

Here’s a table to illustrate just a few of the improvements over the last three versions.

[![clip_image019](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1667.clip_image019_thumb_33CDD940.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3343.clip_image019_681D0A36.jpg)

Microsoft Hyper-V Server 2008 has been flying under the radar for quite some time, but adoption is steadily and quietly increasing. More on this in a future blog.

**\---------------------------------------------------------------------------------------**

**What VMware Quietly Removed in the vSphere 5 Licensing 2.0 Terms**

**\---------------------------------------------------------------------------------------**

The first version of the _vSphere 5.0 Licensing 1.0 Terms_ contained this text in a number of places. It has been quietly removed in _vSphere 5.0 Licensing 2.0 Terms_.

[![clip_image020](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5481.clip_image020_thumb_7D7CB130.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3750.clip_image020_79213819.png)

It’s pretty obvious why this text was removed. These statements don’t ring true.

· **~~Simplicity~~ Complexity**. While the vSphere 5 Licensing removes the VMware Core Tax, it replaces the VMware Core Tax with a new VMware Memory Tax and attempts to sell this tax as a  “feature.” Now customers have to worry anytime they upgrade the physical memory in their servers to ensure they’re in compliance with the new VMware Memory Tax. Because of the complexity of the new vSphere 5 Licensing, VMware has had to create new tools to help customers. Worse, VMware has now added _variability_ to the equation. You can ’t just purchase a pool of servers, license them fully and use them in any way you see fit. Now, you can buy a pool of servers, license them per the new model and see licensing costs fluctuate and vary. Budgeting for the future is now more difficult. How do you budget for this? Assume worst case and hope for the best? What about unplanned capacity needs? In the past, perhaps you upgraded the memory and added ran some more VMs. Now, it’s likely you’ll need to pay a tithe to VMware first. How do you effectively plan for the future?

· **~~Flexibility~~ Inflexibility  & Intransigence**. The VMware Memory Tax introduces a new concept of limiting a fundamental server resource, memory, and discourages users from scaling up virtual machines. In addition, the new vTAX creates new artificial vRAM pools because you cannot mix and match different vSphere editions in the same pool. Want to run vSphere Enterprise Plus and a few copies of vSphere Standard to increase the memory in the pool and save some money?

Sorry, VMware doesn’t allow mixing and matching.

> **_VMware vSphere 5.0 Licensing, Pricing and Packaging p.7_** _“ Note that all hosts in a vRAM pool must be licensed with the same VMware vSphere edition or, in other words, VRAM entitlements are pooled by VMware vSphere Edition. It is possible to manage mixed environments of hosts licenses with different VMware vSphere Editions from the same vCenter, however this will create multiple vRAM pools. vRAM capacity can only be shared among servers licensed with the same VMware vSphere Edition.”_

The end result is that introduction of the VMware Memory Tax creates silos of vSphere hosts based on Edition reduces flexibility and increasing complexity.

· **~~Fairness~~ Unfair to customers**. With the new memory tax, if a customer decides to buy 4 servers with 32 GB of memory for virtualization and then upgrades the servers with more memory to run more or larger virtual machines in six months, they now have to go back to VMware and pay more licensing costs for the entitlement to use the memory they just purchased.

· **~~Evolution~~ De-Evolution**. The VMware Memory Tax flies in the face of cloud computing which is to maximize hardware utilization, drive up density and reduce costs. VMware is turning this model upside down taxing customers for achieving better density. This concept is exactly the opposite of cloud computing and an anathema to customers.

**How does this benefit you?**  
  


**\---------------------------------------------------------------------------------------**

**The Crux of the Problem: VMware ’s Model is Upside Down**

**\---------------------------------------------------------------------------------------**

The VMware _vSphere 5 Licensing 2.0 Terms_ are an attempt by VMware to sweep this debacle aside, get you to accept a new, more expensive way to purchase virtualization and tightly lock you into these new terms. From VMware:

> **_VMware vSphere 5.0: Licensing, Pricing and Packaging p.10_** _Q: When upgrading existing licenses for VMware vSphere 4.x or older to VMware vSphere 5.x, may I maintain the VMware vSphere 4.x licensing model?_  
>  _A: No. In order to complete the upgrade, the new VMware vSphere 5 EULA must be accepted._

Here’s the crux of the problem and why VMware wants to move you to these new terms. VMware’s new consumption based business model is completely upside down.

  * Consumption based costing works well _as a method of charging someone else for resources you own._ _For example, Windows Azure, AWS, Fasthosts and Rackspace provide 100% of the hardware resources and shoulder 100% of the operational costs and thus license based on consumption. This makes sense as a method of charging someone else for resources you own._
  * **_If you ’re building your own private cloud infrastructure, you **own** the hardware already.  In essence, VMware is telling you to pay 100% of the hardware and 100% of the operational costs and then attempting to rent back to you your own capacity._**



Read that last paragraph again.

Show your boss. Show your CFO. Ask them if this is the long term strategic decision your company wants to make. Make sure you go into this new licensing model with your eyes open. Because, like the last three releases, VMware will raise their licensing again. [Even VMware’s own Experts believe the new model is fundamental flawed](http://blog.peacon.co.uk/vsphere-5-where-were-at-with-licensing/).

**\---------------------------------------------------------------------------------------**

**Summary**

**\---------------------------------------------------------------------------------------**

There’s very little to say that hasn’t already been said by VMware’s own customers. VMware’s Memory tax fundamentally contradicts ** __** the economics of the private cloud and undermines what you have come to expect from virtualization. Namely, you want to _fully utilize your hardware to achieve better density and lower costs_.

What’s unfathomable is that we’re having this conversation at all. Increased hardware utilization, better density, and lower costs are why people gravitated to virtualization in the first place. This is Virtualization 101.

VMware also fails to recognize what is important in virtualized environments today, especially as we move towards private cloud solutions. Aspects such as management and monitoring of applications and cross-platform support have been overlooked, and with vCloud Director, VMware’s private cloud story is still focused on VMware-only infrastructures. vSphere 5 is the latest VMware toll booth erected on the road to the private cloud in a history where increased licensing costs are a regular occurrence. Two years ago it was the [Core Tax](https://blogs.technet.com/b/virtualization/archive/2009/06/28/beware-the-vmware-core-tax-and-more.aspx) where many saw there licensing increase over 200%, and now it’s the Memory Tax where many VMware customers are seeing licensing costs increase again.

With Microsoft, customers can build scalable virtualized infrastructures on Hyper-V and with System Center, accelerate their progression towards private cloud environments with deep application monitoring, protection and management along with rich self-service capabilities. All of this, without the restrictive licensing that accompanies vSphere, ensures that a Microsoft private cloud provides the greatest value at the lowest costs. 

As for scalability, you should know that scalability and performance are ongoing development priorities at Microsoft. Scalability and performance work is _never_ complete. If you look at Windows Server, we have improved the scalability, performance, and capabilities in every release. Needless to say, the next version of Windows Server will improve on these numbers, and you can expect even more capabilities.

At Microsoft’s Worldwide Partner Conference 2011, we demonstrated some of the new capabilities of **Windows Server “ _8_ ,” specifically around Hyper-V**.  **With an ability to create VMs with more than 16 virtual processors and built-in replication with Hyper-V Replica,** Microsoft is showcasing its deep commitment to its customers, and our relentless pursuit to provide even more value, at no extra cost.  **These are just 2 of the _hundreds_ of features coming in the Microsoft Private Cloud, of which you ’ll be able to find out more about at **[**Microsoft ’s BUILD conference**](http://www.buildwindows.com/) **, September 13 th-16th in Anaheim, CA.**

Finally, I don’t understand how VMware can claim a memory tax benefits customers. I’ve had the privilege of working on virtualization for over a decade and **_not once_** has a customer told me,  “I really wish you would license virtualization by the memory assigned to a VM.”

Not once.

I also want to reiterate loudly and clearly.

**_Question: Does Microsoft plan to do anything similar to the vTax?_**

Answer: NO, we have no intention of imposing a VM Memory vTax, a VM Core vTax or a VM Replication vTax.

Per VM taxes are what virtualization vendors do, not strategic cloud providers.

YES, the amount of memory in a Hyper-V “ _8_ ” VM is going to go up. Way up.

See you at [Build](http://www.buildwindows.com/),

Jeff Woolsey

Windows Server & Cloud
