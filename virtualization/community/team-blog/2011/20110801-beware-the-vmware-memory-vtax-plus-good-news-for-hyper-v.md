---
title:      "BEWARE THE VMWARE MEMORY VTAX; PLUS--GOOD NEWS FOR HYPER-V..."
date:       2011-08-01 05:28:00
categories: blogs
---
Virtualization Nation,

The last few weeks have been buzzing with virtualization news. Just two examples are the Windows Server “ _8_ ” Hyper-V Sneak Peek at the Microsoft Worldwide Partner Conference (WPC) and VMware’s creation of the Memory vTax.

**WPC: A Sneak Peek at Windows Server “ _8_ ” Hyper-V**

At WPC, I participated in a keynote and got to demo the first sneak peek at the next version of Hyper-V. If you’d like to see the Windows Server “ _8_ ” sneak-peek demo, go [here](http://digitalwpc.com/Videos/AllVideos/Permalink/3cb3788c-5c47-4b9e-987c-0dec4194058b/#fbid=xeCtyhEp9Qw) and fast forward to 36:50 of this online video. Don’t wait. I don’t know how long the video will be up. Judging by the _tens of thousands_ of views in the first couple of weeks, I think there ’s a bit of interest.

Here’s what we showed:

  * **Greater than 16 virtual processors _within_ a Hyper-V VM**. We are keenly aware that our customers want more virtual processors within a virtual machine to support large scale up workloads and the new version goes above and beyond in addressing that need. I demoed a 16-virtual-processor virtual machine under heavy load. I pointed out that 16 virtual processors is **_not_** the maximum number of virtual processors. It was simply the largest server I was able to ship for the demo. As for support for more virtual processors, I ’ll just say, “Stay Tuned” for some good news.
  * **Hyper-V Replica**. It ’s time to democratize VM replication. Hyper-V Replica is asynchronous, application consistent, virtual machine replication. Hyper-V Replica lets you replicate a virtual machine from one location to another, using Hyper-V and a network connection. Hyper-V Replica works with virtually any vendor’s server hardware, networking and storage products. In addition, we will provide **_unlimited VM replication in the box._** What do I mean by unlimited VM replication? I mean exactly that. Replicate as many virtual machines as you want. Whether it ’s 1, 100, or 10,000 VMs, replicate as much as you want. Would you like to replicate VMs:
    * from your primary site to your secondary site?
    * from your branch office to your corporate office? Vice versa?
    * to a private cloud hoster?



We think you should be able to do those things—without paying a per-VM Replication Tax.

This is what our valued customers have asked for, and what we’re delivering.

**The VMware Memory Entitlement (vTax)**

We’ve been _deluged_ with email this week asking about the new VMware vRAM entitlement which has quickly been dubbed the  “VMware vTax.” Here’s a quick description From VMware vSphere 5.0 Licensing, Pricing and Packaging, p. 3

> _“ vSphere 5.0 will be licensed on a per processor basis with a vRAM entitlement. Each vSphere 5.0 CPU license will entitle the purchaser to a specific amount of vRAM, or memory configured to virtual machines.”_

I’ll get into the details below, but specifically, here’s what folks are asking:

  1. What do you think about the new VMware vSphere 5.0 Licensing Changes?
  2. Does this make sense to you?



In a word, NO. But don’t take my word for it. Let’s see what VMware’s customers, think of these changes, starting with Twitter.

**\-----------------------------------------------------------------------------------------**

**Twitter: #vTAX**

**\-----------------------------------------------------------------------------------------**

On Twitter, folks have created a new hashtag devoted to the new vSphere Memory Tax topic [#vtax](https://twitter.com/#!/search?q=%23vTax).  Many of the Tweets contain language that is not appropriate for this blog, but here are a few tweets that I’m able to copy and paste.

[![clip_image001](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7215.clip_image001_thumb_2DABDC82.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1832.clip_image001_75013274.png)

[![clip_image002](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5187.clip_image002_thumb_006BA851.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5504.clip_image002_79B89ECD.png)[![clip_image003](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5584.clip_image003_thumb_0DD1BB57.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2376.clip_image003_071EB1D4.png)

[![clip_image004](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0880.clip_image004_thumb_06464BEA.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0702.clip_image004_51A5EFAE.png)[![clip_image005](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0285.clip_image005_thumb_0C8D2278.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7144.clip_image005_57ECC63C.png)

[![clip_image006](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1362.clip_image006_thumb_57146052.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1778.clip_image006_506156CF.png)[![clip_image007](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7144.clip_image007_thumb_647A7358.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2055.clip_image007_5DC769D5.png)

So VMware customers immediately grasped the cost implications of this new model and were not hesitant to make their feelings known. But the broader IT community also expressed concern.

**\-----------------------------------------------------------------------------------------**

**Industry Reaction**

**\-----------------------------------------------------------------------------------------**

A few days after the appearance of VMware press releases on the vSphere 5 launch, press and analysts are now chiming in about the customer backlash on the licensing changes. Here’s a sampling of quotes from just a few articles.

1\. The Register: [VMware Taxes your Virtual Memory](http://www.theregister.co.uk/2011/07/13/vmware_esxi_5_0_analysis/)

> Customer Comment: “ _We are getting Dell R800's: Two 10 core cpu's and 512 GB of ram. That gives us 20 real cores and 40 from a scheduling perspective. We rarely need CPU, so you can oversubscribe the crap out of it. What we need is memory. With 4.x we needed 2 Enterprise Plus licenses. **Now we need 10. A 500% increase so that the cost of the license is now significantly more than the hardware**. ”_

2\. ZDNet: [Customers Wary of vSphere 5’s Revamped Pricing Model](http://www.zdnet.co.uk/news/business-of-it/2011/07/13/customers-wary-of-vsphere-5s-revamped-pricing-model-40093401/?s_cid=938)

> _"This new licensing model is going to hurt small shops the most I think. We currently have over 40 VMs [virtual machines] running each dual CPU 128GB RAM host," TysonL[wrote on the forum](http://communities.vmware.com/thread/320877?start=0&tstart=0) on Tuesday. "To fully use the RAM in our servers we will have to pay 50 percent more [than] currently budgeted. Seeing as I work at a public university that is going to be fun to try and justify."_
> 
> _...and …_
> 
> _VMware has said the pricing change is designed to simplify the cost of licensing its hypervisor, but some customers view it as a tax on server RAM._
> 
> _...and …_
> 
> _"Very shocked here, I can't go to my boss and explain that our recent investment in three new bladeservers with 128GB memory and 2 CPUs has to be licensed with extra VMware licences because there's 'so much RAM' in it," Vince77 wrote on the forum on[Wednesday](http://communities.vmware.com/thread/320877?start=30&tstart=0)._

3\. CRN: [VMware Customers Fuming over VSphere Licensing Changes](http://www.crn.com/news/data-center/231001634/vmware-customers-fuming-over-vsphere-5-licensing-changes.htm;jsessionid=OvB1S3S+aV9DGvb+vycWTQ**.ecappj02?cid=nl_alert)

> _VMware customers are venting their spleen over the licensing changes coming in vSphere 5, which in some cases will amount to a significant price hike._
> 
> _… and…_
> 
> _Evidence of customers' frustration can be found on Twitter, where the[#Vtax](http://www.crn.com/news/data-center/231001634/%20http:/twitter.com/#!/search?q=%23vTax) hashtag has sprung up and attracted a steady stream of vitriolic -- and sometimes colorful -- commentary. "Meet us at Boston Harbor -- we are dumping copies of VMware Workstation. _

4\. ITNews: [VMware Users Rail Against Licensing Changes](http://www.itnews.com.au/News/263512,vmware-users-rail-against-licensing-changes.aspx)

> _“ Some required to double, triple VMware licenses.”_

5\. TechTarget: [VMware Pricing Changes Add Cost To The Cloud](http://itknowledgeexchange.techtarget.com/cloud-computing/vmware-pricing-changes-add-cost-to-cloud/)

> Analyst Comment: _“ **VMware ’s controversial licensing and pricing changes in vSphere 5, [leaked today](http://searchservervirtualization.techtarget.com/news/2240034504/) are positively uncloud-like when it comes to cost…”**_

6\. Ars Technica: [What Will the VMware vSphere 5 Licensing Changes Mean For You](http://arstechnica.com/business/news/2011/07/what-will-the-vmware-vsphere-5-licensing-changes-mean-for-you.ars?comments=1#comments-bar)

> Comment: _“ We literally just deployed a few million dollars worth of Cisco B230 M2 blades with dual E7-2850s and 256GB each. We're already pushing north of 20:1 consolidation ratio and if this licensing stands, our VMware bill will _more than double_. <Expletive Deleted> VMware.”_

The preceding links and quotes are just a few from industry sites. There are plenty more. Customers on VMware’s community forums are generally supportive. In this case—not so much.

**\-----------------------------------------------------------------------------------------**

**VMware ’s Community Forums**

**\-----------------------------------------------------------------------------------------**

In just over two weeks since the release of vSphere 5.0, VMware’s own community forum has over 83 pages with over 1250 posts (~75 a day) from disgruntled customers. Their comments and colorful metaphors express their lack of enthusiasm for the new vSphere 5 licensing model. Below are just a few comments:

[http://communities.vmware.com/thread/320877?start=0&tstart=0](http://communities.vmware.com/thread/320877?start=0&tstart=0)

**Comment 1** :

> _I took a minute to read the licensing guide for vSphere 5 and I'm still trying to pull my jaw off the floor. VMware has completely screwed their customers this time. Why?_
> 
> _What I used to be able to do with 2 CPU licenses now takes 4. Incredible._
> 
> _Today_
> 
> _BL460c G7 with 2 sockets and 192G of memory = 2 vSphere Enterprise Plus licenses  
>  DL585 G7 with 4 sockets and 256G of memory = 4 vSphere Enterprise Plus licenses_
> 
> _Tomorrow_
> 
> _BL460c G7 with 2 sockets and 192G of memory = 4 vSphere Enterprise Plus licenses  
>  BL585 G7 with 4 sockets and 256G of memory = 6 vSphere Enterprise Plus licenses_
> 
> _So it's almost as if VMware is putting a penalty on density and encouraging users to buy hardware with more sockets rather than less._
> 
> _I get that the vRAM entitlements are for what you use, not necessarily what you have, but who buys memory and doesn't use it?_
> 
> _Forget the hoopla about a VM with 1 TB of memory. Who in their right mind would deploy that using the new license model? It would take 22 licenses to accommodate! You could go out and buy the physical box for way less than that today, from any hardware vendor._
> 
> _Anyone else completely shocked by this move?_

**Comment #2** :

> **_[Re: vSphere 5 Licensing](http://communities.vmware.com/message/1789392#1789392)_** __
> 
> _It isn't just you. We just purchased ten dual-socket servers with 192GB RAM each (enterprise license level) and we'll need to triple our license count to be able to use all available RAM if allocated by VMs. Ridiculous_

**Comment #3** :

> _The new licensing model is even worse on the SMB side:_
> 
> _Today:_
> 
> _2 x DL380 G7, 2 CPUs and 96 GB RAM each = Essentials Plus Kit_
> 
> _Tomorrow:_
> 
> _2 x DL380 G7, 2 CPUs and 96 GB RAM each = Standard Kit_
> 
> _That is about 300% (yes, THREE HUNDRED PERCENT) increase in price. Good luck explaining the added cost to your boss_

**Comment #4** :

> _> Anyone else completely shocked by this move?_
> 
> _Yes, I am totally floored by it... We're going to end up with 6 dual CPU servers with 1.5TB of memory (so 12 CPU Enterprise Plus licences). With the new scheme, it looks like we're going to have to purchase an additional 20 CPU licences just to use what we have._
> 
> _We were looking to move an SQL over to ESXi - it's a 256GB monster, so we were going to dedicate a host for it (it's good for DR). Rather than the 2 CPU licences we would have needed, we're going to need 6 now - just for the one server. So three times as many licences now._

**Comment #5** :

Also, from the [VMware Community Forum](http://communities.vmware.com/thread/320877?start=120&tstart=0).

> _Okay, here is a real world scenario for you:_
> 
> · _7 Dell PowerEdge R815s with 512GB of memory each (448 usable with spare row configured), and 4 cpus_
> 
> · _4 Dell PowerEdge R715s with 128GB of memory each and 2 cpus._
> 
> _With vSphere 4.x, this takes 36 Enterprise Plus licenses and gives us access to all the memory._
> 
> _Assuming we hold out 448GB of memory (the largest increment) in reserve for failover, we will have 3200GB of memory available for use._
> 
> _After upgrading to vSphere 5.x, we will only be licensed for 1728GB NOT the previous 3200GB._
> 
> _We will have to purchase 31 additional Enterprise Plus licenses to regain the ability to use all of that memory._
> 
> That’s an additional **_$108,345_** in licensing the customer will need to pay VMware to use the memory they already paid for and we ’re using with their previous version.

**Comment #6** :

[![clip_image008](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1832.clip_image008_thumb_41C4F90B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2821.clip_image008_2D3FA98D.png)

**Comment #7** : Here’s another comment from [VMware’s public blog](http://blogs.vmware.com/virtualreality/2011/07/setting-microsoft-straight-on-the-vmware-service-provider-program-vspp.html#comments):

> _VMware, I know you ’re looking for ANY reason to divert attention from the vsphere 5 Licensing Disaster, but this article isn’t going to do it. Can we just call a spade a spade? The vsphere 5 licensing change is a plain money grab/<expletive deleted> customers by VMware and you guys are pitching this as good for me. STOP INSULTING MY INTELLIGENCE._
> 
> _You have stated that most people will not be affected. Is anyone from VMware reading their own forums? There are 50+ pages of ticked off VMware customers. Twitter has started numerous hash tags including VTAX and the VMware response is, “no really, it’s not that bad” or “it’s your fault right size your vms,” or “scale out not up.”_
> 
> _THIS IS HOW YOU TREAT US?_
> 
> _If you think about what you ’re saying, the guidance vmware has been giving their customers for years and how vmware is marketed you realize just how ridiculous, misguided and insulting this licensing is to customers._
> 
> _VMware says the new VTAX/Memory Tax is “really not that bad.” This is simply not true. Read your own forums. We’ve done the math and we’re going to see just over a 300% increase. 300%. My boss is <expletive deleted> beyond words._
> 
> _Vmware states “Vsphere 5 for desktops is great for VDI.” Haven’t looked and don’t even care. The last thing we’re going to do is even consider VMware for VDI (or anything else) after this. NOT A CHANCE. We’re not going to take the chance of deploying vmware for VDI only to have you jack up the price the next time around._
> 
> _VMware says: “Hardware constraints have been removed.” This is a shell game. No, you have replaced one dumb constraint that you created with a new worse constraint and you’re telling us this is good for us. SERIOUSLY, DO YOU THINK WE’RE STUPID? I loathe writing in all caps, but considering there are 50 pages in the forums that are saying the same exact thing (which you are ignoring), maybe this will get someone’s attention._
> 
> _VMware says: “This new licensing is great for cloud computing.” If this new licensing is a step toward cloud computing, we’re in big trouble. Virtualization has been helping us save money. We run more apps on fewer servers. You’re now saying that’s not true anymore. The more apps, the more it costs. Say again? Why am I moving to the cloud? This contradicts everything vmware has said for years._
> 
> _VMware says: “Scale out over Scale Up.” I’ve been advocating scale out over scale up, but vmware has been telling us FOR YEARS to scale up so we the followed the guidance. That’s what we’ve been doing. Now you’re screwing us for FOLLOWING YOUR GUIDANCE._
> 
> _VMware says: “Enforce customers to better right size.” Isn’t virtualization supposed to help me with this? Aren’t all your memory optimizations supposed to do this for me? Oh thats right, now you’re penalizing me for this fact. BTW, thanks for calling us stupid and demanding more money. We, your customers, love that. We don’t know any better. Perhaps you’d like to kick my dog too._

That’s a small sampling of feedback from VMware’s customers, and there are hundreds of additional comments. It’s interesting to note that while VMware is telling the press that “the furor over the vTAX has died down,” public sentiment shows quite the opposite.

**\-----------------------------------------------------------------------------------------**

**How Does VMware Respond?** ****

**\-----------------------------------------------------------------------------------------**

Here are some public reactions from VMware, including quotes from a Co-President and their CEO.

**Response #1** : In response to the scathing and derisive customer feedback, VMware held an online webinar on 6/18/2011. The speaker repeated the same licensing and messaging. [Here’s what one VMware customer had to say (in VMware’s Community Forum) after attending this webcast](http://communities.vmware.com/thread/320877?start=660&tstart=0):

[![clip_image009](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3808.clip_image009_thumb_40EC9321.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5148.clip_image009_3A39899E.png)

**Response #2:** In a video interview with CRN, VMware Co-President Carl Eschenbach (@2:45 in the video) says,

[![clip_image010](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6204.clip_image010_12930D74.png)](http://www.crn.com/video/index1.htm?searchVideoContent=1057465579001)

**[“ I actually think our channel and customers are excited about this change” (the new licensing).](http://www.crn.com/video/index1.htm?searchVideoContent=1057465579001)**

**-VMware Co-President, Carl Eschenbach**

**Response #3** : In another interview with CRN, VMware CEO, [Paul Maritz, says in an interview with CRN](http://www.crn.com/news/data-center/231002148/vmware-ceo-maritz-tries-to-clear-air-on-vsphere-licensing.htm;jsessionid=VUIogF1qA47edvIsQkS5QQ**.ecappj02):

> _"We believe that 95 percent of customers will see no change in their licensing costs. From our calculations, most customers will see no change and won't be required to pay us more money," Maritz said in a Q &A during VMware's Q2 earnings call._
> 
> _"It ’s a metric that reflects the value [customers are] getting out of the software as opposed to the hardware packaged underneath it. That is the whole direction that cloud in general is heading -- pay as you drink, provisioning everything up front," said Maritz. "It's not so much that we're trying to give customers a better or worse deal, we're trying to change the metric we use to measure value."_

It appears Mr. Maritz, Mr. Eschenbach and VMware are not in sync with their customers.

**\-----------------------------------------------------------------------------------------**

**Examining the Facts: Preface**

**\-----------------------------------------------------------------------------------------**

Now that we’ve reviewed customer feedback, let’s analyze a few configurations and _include real world figures_. Before we do, let me be transparent as to what we ’re comparing. VMware will be the first to tell you that their new licensing model isn’t based on physical memory. Here’s an exact quote from VMware’s licensing documentation.

> **_VMware vSphere 5.0: Licensing, Pricing and Packaging p.3_**
> 
> _The new vSphere licensing model eliminates the restrictive physical entitlements of CPU cores and physical RAM per server, replacing them with a single virtualization-based entitlement process of pooled virtual memory (vRAM)._

While I understand and acknowledge their licensing isn’t based on physical memory, this begs a few questions:

  * How many people purchase servers and do not try to fully utilize them?
  * What’s the point of purchasing a server and loading it with memory if not to _use it_?
  * Isn’t better hardware utilization one of the many great reasons we use virtualization?



In fact, according to VMware’s own website, [the top reason touted for virtualization is](http://www.vmware.com/virtualization/):

> _“ Reduce costs by increasing energy efficiency and requiring less hardware with server consolidation.”_

So, for the analysis below, I’m going to make the _rash assumption_ that you would like to fully utilize the memory in the system. If you disagree, please feel free to consider your memory utilization rate and apply some sort of discount. I don ’t know what your target utilization is and I’m not going to guess, so I’m going to assume maximum utilization.

**\-----------------------------------------------------------------------------------------**

**Examining the Facts: Putting this in Perspective**

**\-----------------------------------------------------------------------------------------**

**Example 1: vSphere 5.0 & Monster VMs**

VMware has touted vSphere 5.0 as providing “Monster VMs.” If by Monster VMs they mean, _vSphere 5.0 will devour budget faster than ever_ , then I understand the analogy. VMware is touting virtual machines with up 1 Terabyte of memory. Let’s analyze the licensing implications and cost of a 1 TB VM with real world figures.

**_To simply create and turn on a VMware virtual machine with 1 TB of memory on a single physical server,_** this costs:

  * $42,785 in VMware Licensing for vSphere 5.0 Standard
    * **$74,874** when you include the _required_ VMware Support and Subscription (SnS) license
  * $76,890 in VMware Licensing for vSphere 5.0 Enterprise Plus
    * **$134,558** when you include the _required_ VMware Support and Subscription (SnS) license



This is just VMware licensing costs to **_run one virtual machine_**.

Suppose you wanted to run this single VM with High Availability and for Live Migration, you need licenses for both servers.  For Enterprise Plus that costs over a **quarter of a million dollars, or $269,116 to be precise to run one virtual machine**. That's still without the cost of the  server, the physical memory, storage, hardware, guest OS, or apps to run in this 1 TB virtual machine.

Let that sink in for a moment.

**Example 2: Compare 1 Terabyte of Virtual RAM with 1 Terabyte of Physical RAM**

Let’s compare the aforementioned VMware Entitlement for 1 TB of RAM with an actual server with 1 TB of physical RAM. A 4 socket Dell R910 with 1TB RAM lists for approximately $85,000—so the new VMware licensing either increased the cost of the server by ~87% ($74,874 with SnS) or more than doubled the cost of the server ~158% ($134,558 with SnS) depending on which license you purchase.

**Example 3: A Common Server Configuration**

Now, let’s take a look at a common server configuration for virtualization: A dual socket, six core server with 192 GB of physical memory.

  * With vSphere 4.x, you would buy two standard licenses @$995 each because VSphere 4.x had no **memory tax.** **Total cost: $1990**.
  * With vSphere 5.x, you would need to buy 8 standard licenses @995 each because Standard only provides up to 24 GB of memory so you need to purchase 8 licenses to support 192 of memory in the hosts. **Total cost: $7960**.



**That ’s a 3x increase just for the virtualization layer. No hardware. No guest licensing. No apps.**

**\-----------------------------------------------------------------------------------------**

**So, What ’s Really Happening?**

**\-----------------------------------------------------------------------------------------**

Personally, here’s what I think is happening. It looks like VMware decided to release the new vSphere Licensing and push the licensing fees as high as possible. In many cases the price increase is 2x-4x (in some cases higher). Here’s a very simple example to illustrate this perception.

**Assuming a 2 CPU host, the vSphere 5 licenses cost increases 2x-4x from vSphere 4.1** as shown in the chart below. With vSphere 5, on a 2 CPU host with 128 GB RAM, the max vRAM entitlement is 96 GB (2 x 48GB for each CPU license), so to use the remaining 32 GB RAM, customers would need to buy an additional vSphere 5 Enterprise Plus license, something they wouldn ’t have required with 4.1.

 

**Edition/Memory**

| 

**96 GB**

| 

**128 GB**

| 

**192 GB**

| 

**256 GB**

| 

**384 GB**  
  
---|---|---|---|---|---  
  
# of vSphere 4.1 Enterprise Plus licenses

| 

2

| 

2

| 

2

| 

2

| 

2  
  
# of vSphere 5.0 Enterprise Plus licenses

| 

2

| 

3

| 

4

| 

6

| 

8  
  
I surmise that VMware knows full well they pushed these increases too high and will come back at VMWorld to “fix things.” I can see their CEO, Paul Maritz, start the conference by saying, “We heard you and tweaked the memory entitlement numbers. Now let’s stop talking about licensing and hey, look at this shiny thing over here…”

In essence, what all that would mean is that maybe VMware won’t get a 4x-8x price increase, but after they “fix things,” VMware still extracts a hefty 2x price hike and can hope their customers think a 2x price hike looks good in comparison—or better, don’t notice.

Now let’s do some comparisons of vSphere 5, Microsoft Hyper-V Server 2008 R2 SP1, and Windows Server 2008 R2 SP1.

**\-----------------------------------------------------------------------------------------**

**1 Server: vSphere 5 vs. Microsoft Hyper-V Server 2008 R2 SP1**

**\-----------------------------------------------------------------------------------------**

Let’s compare a _single server_ populated with various memory configurations.

In this first comparison, let’s analyze the effect of the VMware Memory Tax and focus on the hypervisor layer. For this comparison, I’m going to use VMware vSphere 5.0 and [Microsoft Hyper-V Server 2008 R2 SP1](http://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx). This comparison allows us to focus on the ability of the hypervisor to fully utilize memory resources in a physical server for virtual machines. Let me preface this example by stating, this comparison doesn’t include hardware, guest operating system licenses, storage, networking or systems management.

This comparison includes VMware’s Support and Subscription (SnS) licensing. I was going to be charitable and omit the SnS subscription, but then I read in the VMware vSphere 5.0 Licensing, Pricing and Packaging whitepaper at the bottom of pages 3-11 in the fine print it states, “ _SnS is required for all vSphere purchases_. ” Thus, I included the SnS License per VMware’s requirement. It should be noted that because the VMware Memory Tax requires purchasing more licenses for larger memory footprints and because " _a  Support and Subscription (SnS) contract is required for every vSphere Edition purchase"_, the SnS requirement acts as a subtle, additional tax even if the user is purchasing the extra license for vRAM capacity.

 The first comparison is vSphere 5 to [Microsoft Hyper-V Server 2008 R2 SP1](http://blogs.technet.com/b/virtualization/archive/2011/04/12/microsoft-hyper-v-server-2008-r2-sp1-released.aspx).

 

| 

**VSphere 5.0 Standard**

| 

**VSphere 5.0 Enterprise**

| 

**VSphere 5.0 Enterprise Plus**

| 

**Microsoft Hyper-V Server 2008 R2 SP1**  
  
---|---|---|---|---  
  
**Cost Per CPU**

| 

$995

| 

$2875

| 

$3495

| 

None ($0)  
  
**VMware SnS Per CPU (3 Years)**

| 

$746

| 

$2,156

| 

$2,621

| 

\--  
  
**Memory “Entitlement” (vTax)**

| 

24 GB

| 

32 GB

| 

48 GB

| 

**No Memory Tax**. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**. More than any standard vSphere 5 offering.  
  
**1 Physical Server (2 Sockets) with 128 GB RAM**

| 

6 licenses

$10,448

| 

4 licenses

$20,125

| 

3 licenses

$18,349

| 

Included  
  
**1 Physical Server (2 Sockets) with 192 GB RAM**

| 

8 licenses

$13,930

| 

6 licenses

$30,188

| 

4 licenses

$24,465

| 

Included  
  
**1 Physical Server (2 Sockets) with 256 GB RAM**

| 

11 licenses

$19,154

| 

8 licenses

$40,250

| 

6 licenses

$36,698

| 

Included  
  
**1 Physical Server (2 Sockets) with 384 GB RAM**

| 

16 licenses

$27,860

| 

12 licenses

$60,375

| 

8 licenses

$48,930

| 

Included  
  
**1 Physical Server (4 Sockets) with 512 GB RAM**

| 

22 licenses

$38,308

| 

16 licenses

$80,500

| 

11 licenses

$67,279

| 

Included  
  
**1 Physical Server (4 Sockets) with 768 GB RAM**

| 

32 licenses

$55,720

| 

24 licenses

$120,750

| 

16 licenses

$97,860

| 

Included  
  
**1 Physical Server (4 Sockets) with 1024 GB RAM**

| 

43 licenses

$74,874

| 

32 licenses

$161,000

| 

22 licenses

$134,558

| 

Included  
  
Table 1: Memory Tax: vSphere 5 vs. MS Hyper-V Server 2008 R2 SP1 (1 Server)

**\-----------------------------------------------------------------------------------------**

**10 Servers: vSphere 5 vs. Microsoft Hyper-V Server 2008 R2 SP1**

**\-----------------------------------------------------------------------------------------**

Now, let’s compare populating a _pool of virtualization servers_ with various memory configurations.

In this second comparison, let’s analyze the effect of the VMware Memory Tax on a 10 node cluster (or two 5 node clusters if you prefer). This second comparison also allows us to focus on the ability of the hypervisor to fully utilize memory resources in a pool of physical servers for virtual machines. Like the first example, let me preface this by stating, this comparison doesn’t include hardware, guest operating system licenses, storage, networking or systems management.

This comparison includes VMware’s Support and Subscription (SnS) licensing per VMware’s requirement because “ _SnS is required for all vSphere purchases_. ” It should be noted that because the VMware Memory Tax requires purchasing more licenses for larger memory footprints and because " _a Support and Subscription (SnS) contract is required for every vSphere Edition purchase"_, the SnS requirement acts as a subtle, additional tax even if the user is purchasing the extra license for vRAM capacity.

 

| 

**VSphere 5.0 Standard**

| 

**VSphere 5.0 Enterprise**

| 

**VSphere 5.0 Enterprise Plus**

| 

**Microsoft Hyper-V Server 2008 R2 SP1**  
  
---|---|---|---|---  
  
**Cost Per CPU**

| 

$995

| 

$2875

| 

$3495

| 

None ($0)  
  
**VMware SnS Per CPU (3 Years)**

| 

$746

| 

$2,156

| 

$2,621

| 

\--  
  
**Memory “Entitlement” (vTax)**

| 

24 GB

| 

32 GB

| 

48 GB

| 

**No Memory Tax**. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**. More than any standard vSphere 5 offering.  
  
**10 Physical Servers (2 Sockets) with 128 GB RAM**

| 

10 x 6 licenses

$104,480

| 

10 x 4 licenses

$201,250

| 

10 x 3 licenses

$183,490

| 

Included  
  
**10 Physical Servers (2 Sockets) with 192 GB RAM**

| 

10 x 8 licenses

$139,300

| 

10 x 6 licenses

$301,880

| 

10 x 4 licenses

$244,650

| 

Included  
  
**10 Physical Servers (2 Sockets) with 256 GB RAM**

| 

10 x 11 licenses

$191,540

| 

10 x 8 licenses

$402,500

| 

10 x 6 licenses

$366,980

| 

Included  
  
**10 Physical Servers (2 Sockets) with 384 GB RAM**

| 

10 x 16 licenses

$278,600

| 

10 x 12 licenses

$603,750

| 

10 x 8 licenses

$489,300

| 

Included  
  
**10 Physical Servers (4 Sockets) with 512 GB RAM**

| 

10 x 22 licenses

$383,080

| 

10 x 16 licenses

$805,000

| 

10 x 11 licenses

$672,790

| 

Included  
  
**10 Physical Servers (4 Sockets) with 768 GB RAM**

| 

10 x 32 licenses

$557,200

| 

10 x 24 licenses

$1,207,500

| 

10 x 16 licenses

$978,600

| 

Included  
  
**10 Physical Servers (4 Sockets) with 1024 GB RAM**

| 

10 x 43 licenses

$748,740

| 

10 x 32 licenses

$1,610,000

| 

10 x 22 licenses

$1,345,580

| 

Included  
  
Table 2: Memory Tax: vSphere 5 vs. MS Hyper-V Server 2008 R2 SP1 (10 Servers)

At this point, you’re may be thinking, “Doesn’t VMware offer a free ESXi version?”

Yes, and VMware has promptly downgraded it. The free version of vSphere ESXi 5 **_is limited to 8 GB of memory_**.

**\-----------------------------------------------------------------------------------------**

**1 Server: vSphere 5 vs. Windows Server 2008 R2 SP1**

**\-----------------------------------------------------------------------------------------**

In this next analysis, let’s look at the full stack and the effect of the VMware Memory Tax on the complete equation. For this comparison, I’m going to use VMware vSphere 5.0 and the Microsoft ECI Suite.

The Microsoft ECI Suite includes: Windows Server 2008 R2 SP1 Datacenter Edition and System Center Datacenter Edition and Forefront Security. At a very high level, this provides:

  * _Unlimited number of virtualized Windows Server instances_
  * _Management for an unlimited number of virtual machines (and more importantly the apps running within those VMs) for all of System Center including:_
    * _Operations Manager_
    * _Configuration Manager_
    * _Data Protection Manager_
    * _Service Manager_
    * _Opalis (Orchestrator)_
      * _Opalis was released this past year and added to the System Center Suite this past year. Existing customers received this automatically added at no additional cost._
    * _Virtual Machine Manager_
  * _Forefront for an unlimited number of virtual machines which provides a unified, multilayered, and highly manageable approach to protecting servers from malware_



The VMware figures below include VMware’s Support and Subscription (SnS) licensing per VMware’s requirement that “ _SnS is required for all vSphere purchases._ ” It should be noted that because the VMware Memory Tax requires purchasing more licenses for larger memory footprints and because " _a Support and Subscription (SnS) contract is required for every vSphere Edition purchase"_, the SnS requirement acts as a subtle, additional tax even if the user is purchasing the extra license for vRAM capacity. The VMware figures below also include the cost of providing unlimited Windows Server Datacenter instances to more closely match the Microsoft ECI offering. The VMware figures do not include System Center or Forefront licensing. Like the previous examples, this example doesn’t include server hardware or storage.

 

| 

**VSphere 5.0 Standard**

| 

**VSphere 5.0 Enterprise**

| 

**VSphere 5.0 Enterprise Plus**

| 

**MS Core Infrastructure Windows Server 2008 R2 SP1 Datacenter Edition, System Center Datacenter Edition & Forefront**  
  
---|---|---|---|---  
  
**Cost Per CPU**

| 

$995

| 

$2875

| 

$3495

| 

$4584  
  
**Guest Instance Cost per CPU (3 year cost including SA)**

| 

$4182

| 

$4182

| 

$4182

| 

Included Above  
  
**VMware SnS Per CPU (3 Years)**

| 

$746

| 

$2,156

| 

$2,621

| 

\--  
  
**Memory “Entitlement” (vTax)**

| 

24 GB

| 

32 GB

| 

48 GB

| 

No Memory Tax. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**. More than vSphere 5.  
  
**1 Physical Server (2 Sockets) with 128 GB RAM**

| 

6 licenses

$18,812

| 

4 licenses

$28,489

| 

3 licenses

$26,713

| 

2 licenses

$9,168  
  
**1 Physical Server (2 Sockets) with 192 GB RAM**

| 

8 licenses

$22,294

| 

6 licenses

$38,552

| 

4 licenses

$32,829

| 

2 licenses

$9,168  
  
**1 Physical Server (2 Sockets) with 256 GB RAM**

| 

11 licenses

$27,518

| 

8 licenses

$48,614

| 

6 licenses

$45,062

| 

2 licenses

$9,168  
  
**1 Physical Server (2 Sockets) with 384 GB RAM**

| 

16 licenses

$36,224

| 

12 licenses

$68,739

| 

8 licenses

$57,294

| 

2 licenses

$9,168  
  
**1 Physical Server (4 Sockets) with 512 GB RAM**

| 

22 licenses

$55,036

| 

16 licenses

$97,228

| 

11 licenses

$84,007

| 

4 licenses

$18,336  
  
**1 Physical Server (4 Sockets) with 768 GB RAM**

| 

32 licenses

$72,448

| 

24 licenses

$137,478

| 

16 licenses

$114,588

| 

4 licenses

$18,336  
  
**1 Physical Server (4 Sockets) with 1024 GB RAM**

| 

43 licenses

$91,602

| 

32 licenses

$177,728

| 

22 licenses

$151,286

| 

4 licenses

$18,336  
  
Table 3: Memory Tax: vSphere 5 vs. Microsoft ECI (1 Server)

 

**\-----------------------------------------------------------------------------------------**

**10 Servers: vSphere 5 vs. Windows Server 2008 R2 SP1**

**\-----------------------------------------------------------------------------------------**

In this final analysis, let’s look at the full stack and the effect of the VMware Memory Tax on the complete equation. For this comparison, I’m going to use VMware vSphere 5.0 and the Microsoft ECI Suite.

The Microsoft ECI Suite includes: Windows Server 2008 R2 SP1 Datacenter Edition and System Center Datacenter Edition and Forefront Security. At a very high level, this provides:

  * _Unlimited number of virtualized Windows Server instances_
  * _Management for an unlimited number of virtual machines (and more importantly the apps running within those VMs) for all of System Center including:_
    * _Operations Manager_
    * _Configuration Manager_
    * _Data Protection Manager_
    * _Service Manager_
    * _Opalis (Orchestrator)_
      * _Opalis was released and added to the System Center Suite this past year. Existing customers received this automatically added at no additional cost._
    * _Virtual Machine Manager_
    * _Forefront for an unlimited number of virtual machines which provides a unified, multilayered, and highly manageable approach to protecting servers from malware_



The VMware figures below include VMware’s Support and Subscription (SnS) licensing per VMware’s requirement that “ _SnS is required for all vSphere purchases_ ” and include the cost of providing unlimited Windows Server Datacenter instances to more closely match the Microsoft ECI offering. The VMware figures do not include System Center or Forefront licensing. Like the previous examples, this example doesn’t include server hardware or storage. Let’s take a look at a 10 node cluster (or two 5 node clusters if you prefer).

| 

**VSphere 5.0 Standard**

| 

**VSphere 5.0 Enterprise**

| 

**VSphere 5.0 Enterprise Plus**

| 

**MS Core Infrastructure Windows Server 2008 R2 SP1 Datacenter Edition, System Center Datacenter Edition & Forefront**  
  
---|---|---|---|---  
  
**Cost Per CPU**

| 

$995

| 

$2875

| 

$3495

| 

$4584  
  
**Guest Instance Cost per CPU (3 year cost including SA)**

| 

$4182

| 

$4182

| 

$4182

| 

Included Above  
  
**VMware SnS Per CPU (3 Years)**

| 

$746

| 

$2,156

| 

$2,621

| 

\--  
  
**Memory “Entitlement” (vTax)**

| 

24 GB

| 

32 GB

| 

48 GB

| 

No Memory Tax. Hyper-V supports up to 1 TB of physical memory per server and up to 64 GB per VM **today**. More than vSphere 5.  
  
**10 Physical Servers (2 Sockets) with 128 GB RAM**

| 

10 x 6 licenses

$188,120

| 

10 x 4 licenses

$284,890

| 

10 x 3 licenses

$267,130

| 

10 x 2 licenses

$91,680  
  
**10 Physical Servers (2 Sockets) with 192 GB RAM**

| 

10 x 8 licenses

$222,940

| 

10 x 6 licenses

$385,520

| 

10 x 4 licenses

$328,290

| 

10 x 2 licenses

$91,680  
  
**10 Physical Servers (2 Sockets) with 256 GB RAM**

| 

10 x 11 licenses

$275,180

| 

10 x 8 licenses

$486,140

| 

10 x 6 licenses

$450,620

| 

10 x 2 licenses

$91,680  
  
**10 Physical Servers (2 Sockets) with 384 GB RAM**

| 

10 x 16 licenses

$362,240

| 

10 x 12 licenses

$687,390

| 

10 x 8 licenses

$572,940

| 

10 x 2 licenses

$91,680  
  
**10 Physical Servers (4 Sockets) with 512 GB RAM**

| 

10 x 22 licenses

$550,360

| 

10 x 16 licenses

$972,280

| 

10 x 11 licenses

$840,070

| 

10 x 4 licenses

$183,360  
  
**10 Physical Servers (4 Sockets) with 768 GB RAM**

| 

10 x 32 licenses

$724,480

| 

10 x 24 licenses

$1,374,780

| 

10 x 16 licenses

$1,145,880

| 

10 x 4 licenses

$183,360  
  
**10 Physical Servers (4 Sockets) with 1024 GB RAM**

| 

10 x 43 licenses

$916,020

| 

10 x 32 licenses

$1,777,280

| 

10 x 22 licenses

$1,512,860

| 

10 x 4 licenses

$183,360  
  
Table 4: Memory Tax: vSphere 5 vs. Microsoft ECI (10 Servers)

 

**\-----------------------------------------------------------------------------------------**

**Your Questions Answered**

**\-----------------------------------------------------------------------------------------**

So let’s return to your two questions:

  1. What do you (Microsoft) think about the new VMware vSphere 5.0 Licensing Changes?
  2. Does this make sense to you?



There’s very little to say that hasn’t already been said by VMware’s own customers.

VMware’s Licensing changes lay the foundation to lock customers into high priced software and into a business model that is based on taxing customers for achieving greater density and maximizing hardware resources. These changes fly in the face of the benefits of virtualization and cloud computing. Specifically, the vSphere Licensing Model has devolved from per processor with physical core restrictions, commonly referred to as the VMware Core Tax, to per processor with vRAM entitlements, a new VMware Memory Tax. VMware’s Memory tax fundamentally goes _against ****_ the economics of the private cloud and undermines what you have come to expect from virtualization. Namely, you want to _maximize hardware utilization, drive up density and reduce costs_.

What’s unfathomable is that we’re having this conversation at all. Increased hardware utilization, better density and lower costs are why people gravitated to virtualization in the first place. This is Virtualization 101.

VMware also fails to recognize what is important in virtualized environments today, especially as we move towards private cloud solutions. Aspects such as management and monitoring of applications and cross-platform support have been overlooked, and with vCloud Director, VMware’s private cloud story is still focused on VMware-only infrastructures. vSphere 5 is the latest VMware toll booth erected on the road to the private cloud in a history where increased licensing costs are a regular occurrence. Two years ago it was the [Core Tax](http://blogs.technet.com/b/virtualization/archive/2009/06/28/beware-the-vmware-core-tax-and-more.aspx) where many saw there licensing increase over 200% and now it’s the Memory Tax where many are seeing licensing increases of upwards of 200-400% and higher.

With Microsoft, customers can build scalable virtualized infrastructures on Hyper-V and with System Center, accelerate their progression towards private cloud environments with deep application monitoring, protection and management along with rich self-service capabilities. All of this, without the restrictive licensing that accompanies vSphere, ensures that a Microsoft private cloud provides the greatest value at the lowest costs.

As for scalability, you should know that scalability and performance are ongoing development activities at Microsoft. Scalability and performance work is _never_ complete. If you look at Windows Server, we have improved the scalability, performance, and capabilities in every release. Needless to say, the next version of Windows Server will improve on these numbers and you can expect even more capabilities.

At the Worldwide Partner Conference 2011, we demonstrated some of the new capabilities of **Windows Server “ _8_ ,” specifically around Hyper-V**.  **With an ability to create VMs with more than 16 virtual processors and built-in replication with Hyper-V Replica,** Microsoft is showcasing its deep commitment to its customers, and our relentless pursuit to provide even more value, at no extra cost.  **These are just 2 of the _hundreds_ of features coming in the Microsoft Private Cloud, of which you ’ll be able to find out more at [Microsoft’s BUILD conference](http://www.buildwindows.com/), September 13th-16th in Anaheim, CA.**

Finally, I don’t understand how VMware can claim a memory tax benefits customers. I’ve had the privilege of working on virtualization for over a decade and **_not once_** has a customer told me,  “I really wish you would license virtualization by the memory assigned to a VM.”

Not once.

Next question: Does Microsoft plan to do anything similar to the vTax?

NO, we have no intention of imposing:

  * A VM Memory vTax
  * A VM Core vTax
  * A VM Replication vTax



Per VM taxes are what virtualization vendors do, not strategic cloud providers.

See you at [Build](http://www.buildwindows.com/),

Jeff Woolsey

Windows Server & Cloud

P.S. YES, the amount of memory in a Hyper-V “ _8_ ” VM is going to go up. Way up.
