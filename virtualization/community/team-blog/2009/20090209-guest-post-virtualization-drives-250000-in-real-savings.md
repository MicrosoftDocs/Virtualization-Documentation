---
title:      "Guest post&#58; Virtualization drives $250,000 in real savings"
date:       2009-02-09 01:00:00
categories: esx
---
I’m David Straede, president of SBWH.com, a Windows managed server provider.  Virtualization using Hyper-V and System Center is the most exciting thing SBWH has been a part of since we started beta testing IIS 4.0 in 1997. 

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/telligent.evolution.components.attachments/13/5434/00/00/03/19/92/87/SBWH97.JPG)  SBWH in 1999

Twelve years ago we got 15 servers in a rack.  Today, we can put 960 in one rack! It’s easier than we expected, and it is saving us hundreds of thousands of dollars.  Let me explain why we moved to Hyper-V.  In late 2007 SBWH had been using HP BL20P Blade Servers for some time.  We were getting 48 servers per rack, and adding more racks as customers came our way.

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/telligent.evolution.components.attachments/13/5434/00/00/03/19/92/88/SBWH09.JPG)   SBWH in 2007

Larger contracts can take months for customers to get approved, and a University had notified us they were ready to sign.  When we went to order a new rack and power for it, the facility we were in advised us they were at capacity.   To keep from losing the business, we suggested virtualization.  Since they were “using VMware," we priced out the costs to setup the host systems.   The VMware ESX solution came to over $30,000.  When we went back to the University, they laughed, and said “We can’t afford that, we just use the free version.  The features of ESX did not justify the cost.”    Since we knew they were six months away from a go live, and we had just started testing Hyper-V Beta 1, we offered them a deal to be a pilot customer. 

Knowing we needed a rock solid solution with our reputation on the line straying from the market leader in virtualization, we started deploying internal servers on Hyper-V.  Things like domain controllers, external DNS, POP3 mail servers, stats servers, monitoring and other management servers were all moved to Hyper-V.  We were blown away by how easy and how stable the beta was.  We continued to load up the HP BL460c dual quad core servers that had 32 GB of RAM with guest operating systems.   We found 15 guests per host to be the sweet spot. 

To be honest, we were so focused on the need to expand without using more power, we did not look at cost savings until Microsoft asked us to do a total cost of ownership and return on investment study.  We spent two days pulling bills, calculating power, cooling, equipment lease costs, and detailing the time we spent setting up and managing servers.  The savings are huge.  

To make a long and detailed study short, 120 operating system environments running on 120 HP BL460c servers (1 quad core, 2 GB RAM, 146 GB local disk) along with power, cooling, floor space, etc. came to about $190 per server per month.   For the Hyper-V solution, we used faster dual quad core servers, 32 GB RAM each, connected to a mid-range HP SAN.  Loading each host to only 10 guest systems, the cost per server came down to $65 per system per month.   That’s $180,000 in annual savings!

Our saving became even greater when we detailed the management costs.   Virtual servers require management.  Without configuration, operations monitoring, backups, and tools to manage the virtualization, you turn any system admin’s job in to a headache.  Without getting in to the details of service provider license agreements, we saved another $70,000 by using Microsoft’s System Management Suite Enterprise. 

One final story I will share for today.   I went to a large customer’s place to talk about virtualization in mid-2008.  Two different divisions came to my talk, one that had implemented VMware ESX and one that needed to be virtualized.   I connected to some of our Hyper-V systems, showed them how it was installed, configured a new guest, and explained costs.  A guy from the ESX side said, “well you can’t move a live system from one server to another.”   So I asked if they had ever used that feature.    “Well once, when we needed to replace some RAM”.  I asked him when he did that, and he replied 5 pm.  Why at 5pm?  “Well it is rare, but the move can crash the OS”.  Given the option to do a fast move in Hyper-V, would two or three minutes of down time be an issue after hours?   Most folks I ask that say no. 

We are testing Windows Server 2008 R2 now with Live Migration.  Need I say more? 

David Straede

_For more  on how customers are saving with virtualization, _[_click here_](http://www.prnewswire.com/mnr/microsoft/36562/) _  and watch this video_:

  
[Cost Savings with Microsoft Virtualization](http://www.microsoft.com/video/en/us/details/47304891-46fa-4763-95f4-65329870b7b7?vp_evt=eref&vp_video=Cost+Savings+with+Microsoft+Virtualization)
