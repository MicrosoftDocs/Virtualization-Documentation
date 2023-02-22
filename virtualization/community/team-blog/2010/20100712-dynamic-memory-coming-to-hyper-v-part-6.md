---
title:      "Dynamic Memory Coming to Hyper-V Part 6…"
description: Dynamic memory is an enhancement to Hyper-V R2 which pools all the memory available on a physical host and dynamically distributes it to virtual machines running on that host as necessary.
author: scooley
ms.author: scooley
date:       2010-07-12 22:17:00
ms.date: 07/12/2010
categories: uncategorized
ms.prod: virtualization
---
# Dynamic Memory Coming to Hyper-V Part 6
_======================================================_

_Preamble: The point of this series, and the spirit in which it is written, is to take a holistic approach at the issues facing our customers, discuss the complexities with regard to memory management and explain why we ’re taking the approach we are with Hyper-V Dynamic Memory. This isn’t meant to criticize anyone or technology, rather to have an open and transparent discussion about the problem space._

_======================================================_

In the past few blogs we’ve covered Page Sharing and Second Level Paging. Today, let’s dig into what we’re delivering with Hyper-V Dynamic Memory in [Windows Server 2008 R2](/virtualization/community/team-blog/2009/20090722-windows-server-2008-r2-hyper-v-server-2008-r2-rtm) SP1 as well as our free hypervisor [Microsoft Hyper-V Server 2008 R2](/virtualization/community/team-blog/2009/20090730-microsoft-hyper-v-server-2008-r2-rtm-more) SP1. So what is Dynamic Memory?

**Dynamic memory** is an enhancement to Hyper-V R2 which pools all the memory available on a physical host and dynamically distributes it to virtual machines running on that host as necessary. That means based on changes in workload, virtual machines will be able to receive new memory allocations _without a service interruption_ through Dynamic Memory Balancing. In short, Dynamic Memory is exactly what it ’s named.

Let’s dive in an explain how all this works starting with the new Dynamic Memory settings. Here are the new settings available on a per virtual machine basis. Here’s a screenshot:



**Dynamic Memory In Depth**

With Hyper-V (V1 & R2), memory is _statically_ assigned to a virtual machine. Meaning you assign memory to a virtual machine and when that virtual machine is turned on, Hyper-V allocates and provides that memory to the virtual machine. That memory is held while the virtual machine is running or paused. When the virtual machine is saved or shut down, that memory is released. Below is a screenshot for assigning memory to a virtual machine in Hyper-V V1/R2:


With Hyper-V Dynamic Memory there are two values: **Startup RAM** and **Maximum RAM** and it looks like this: 



**Startup RAM** is the _initial/startup_ amount of memory assigned to a virtual machine. When a virtual machine is started this is the amount of memory the virtual machine will be allocated. In this example, the virtual machine will start with 1 GB.

The **Maximum RAM** setting is the maximum amount of memory that the guest operating system can grow to, up to 64 GB of memory (provided the guest OS supports that much memory). Based on the settings above, here ’s an example of what the memory allocation _could_ look like over a workday...



As you can see, the workload is dynamically allocated memory based on demand.

Next, let’s look at the Memory Buffer.

**Memory Buffer** : In one of the earlier blogs posts in this series, we discussed the complexity of capacity planning in terms of memory. To summarize, there is no “one size fits all” answer for every workload as deployments can vary based on scale and performance requirements. However, one consistent bit of feedback was that customers always felt more comfortable by providing additional memory headroom ‘just in case.’

We completely agree.

The point being you want to avoid a situation where a workload needs memory and Hyper-V has to start looking for it. You want some set aside memory as buffer for these situations, especially for bursty workloads.

The Dynamic Memory buffer property specifies the amount of memory available in a virtual machine for file cache purposes (e.g. SuperFetch) or as free memory. The range of values are from 5 to 95. A target memory buffer is specified in percentages of free memory and is based on current runtime memory usage. A target memory buffer percentage of 20% means that in a VM where 1 GB is used, 250 MB will be ‘free’ (or available) ideally for a total amount of 1.25 GB in the virtual machine. By default, Hyper-V Dynamic Memory uses a default buffer allocation of 20%. If you find this percentage is too conservative or not conservative enough, you can adjust this setting on the fly while the virtual machine is running without downtime.



This takes us to the last Dynamic Memory setting, Memory Priority.

**Memory Priority:** By default, all virtual machines are created equal in terms of memory prioritization. However, it ’s very likely you’ll want to prioritize memory allocation based on workload. For example, I can see a scenario where one would give domain controllers greater memory priority than a departmental print server. Memory Priority is a per virtual machine setting which indicates the relative priority of the virtual machine's memory needs measured against the needs of other virtual machines. The default is set to ‘medium’. If you find that you need to adjust this setting, you can adjust this setting on the fly while the virtual machine is running without downtime.



**Dynamic Memory Works Over Time With A Few VMs …**

I’ve explained the per VM settings and shown how this would work with a single virtual machine, but how does Dynamic Memory work with multiple virtual machines? Below is an example to show just how Dynamic Memory works. I’ve kept this example simple on purpose to avoid confusion. Let’s assume I have a small server with 8 GB of memory. I’m going to run three virtual machines, one from Finance, Sales and Engineering. Each virtual machine is given the same settings: Startup RAM = 1 GB and Maximum RAM = 4 GB. With these settings, each virtual machine will start 1 GB and can grow up to 4 GB as needed.

**Virtual Machine Start**. On the left graphic below, you can see three virtual machines starting. Each virtual machine is consuming 1 GB of memory for Startup RAM. On the right graphic below, you can see the total amount of memory being used in the entire system ~3 GB.



**15 minutes later**. The Finance VM is running reports while the Engineering VM starts an analysis job. With Dynamic Memory, the Finance VM is allocated 3 GB of memory, the Engineering VM is allocated 2 GB of memory while the Sales VM remains at 1 GB. System wide, the server is now using 6 GB of its 8 GB or 75% of the total physical memory.



**30 minutes later**. The Finance VM is running reports while the Engineering VM starts an analysis job. With Dynamic Memory, the Finance VM is allocated  2 GB of memory, the Engineering VM is allocated 3.5 GB of memory while the Sales VM remains at 1 GB and a fourth VM, Service VM is started using 1 GB of memory. System wide, the server is now using 7.5 GB of its 8 GB of memory for VMs. At this point the server is fully allocated in terms of memory and is using its memory most efficiently.

<!--- ![placeholder](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5672.image_7E73B7E4.png)  --->

<!--- ![image not found](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/8765.DM%20Over%20Time%2030%20Minutes.jpg) --->

At this point, the question I’m always asked is, “What now? What if a virtual machine still needs more memory? Does the parent start paging?”

No.

At this point, Dynamic Memory will attempt to reclaim pages from other virtual machines. However, in the absolute worst case where no free pages are available, the **guest operating** system will page as needed, not the parent. This is important because the guest operating system knows best what memory should and shouldn ’t be paged. (I covered this back in [Part 5](https://techcommunity.microsoft.com/t5/virtualization/repost-dynamic-memory-coming-to-hyper-v-part-5-8230/ba-p/381751)...) Finally, when free memory does become available from other virtual machines, Dynamic Memory will move memory as needed.

**Over-Subscription & the CPU Analogy**

One argument we routinely hear is that there’s nothing wrong with over-subscription. Customers tell us that they take a bunch of physical servers, virtualize them and run the server with over-subscribed CPUs without issue, so why is this an issue with memory?

Great analogy, wrong conclusion.

Example 1: Suppose you are running 8 physical servers at 10% utilization, virtualize them and run those 8 virtual machines on a single server for a total of ~85% utilization. In this example, you’re not over-subscribing the CPU and the server still has 15% CPU headroom.

Over-subscription is this…

Example 2: Suppose you are running 8 physical servers at **50% utilization** , virtualize them and run those 8 virtual machines on a single server. The single server would max out at 100% utilization, but because the workloads require ~400% utilization, **performance would be terrible**. What would you do? Move virtual machines to other servers of course to _avoid over-subscription_. In short, what you really want to do is maximize resource utilization to get the best balance of resources and performance.

That’s exactly what we’re doing with Hyper-V Dynamic Memory.

**Customer Requirements & Dynamic memory**

When it comes to virtualization and memory, virtualization users have repeatedly provided the following requirements: 

  1. **Use physical memory as efficiently and dynamically as possible with minimal performance impact.** Customers investing in virtualization hosts are purchasing systems with larger memory configurations (32 GB, 64 GB, 128 GB and more) and want to fully utilize this system asset. At the same time, they’re purchasing this memory to provide superior performance and to avoid paging. 
  2. **Provide consistent performance and scalability.** One frequent comment from virtualization users is that they don’t want a feature with a performance cliff or inconsistent, variable performance. That’s makes it more difficult to manage and increases TCO. 



You got it. Here’s why we’ve chosen the path we have with Dynamic Memory.

  1. Dynamic Memory is truly a dynamic solution. Memory is allocated to virtual machines on the fly without service interruption based on policy. 
  2. Dynamic Memory avoids significant performance penalties by not adding additional levels of paging which can significantly impact performance 
  3. Dynamic Memory takes advantage of Large Memory Pages and is, in fact, optimized for Large Memory Pages 
  4. Dynamic Memory is a great solution for virtualizing servers and desktops (BTW, Dynamic Memory works fine with SuperFetch) 



Cheers,

Jeff Woolsey

Principal Group Program Manager

Windows Server & Cloud, Virtualization

P.S. Here are the links to all of the posts in this blog series:

  * [Part 1](/virtualization/community/team-blog/2010/20100318-dynamic-memory-coming-to-hyper-v)
  * [Part 2](/virtualization/community/team-blog/2010/20100325-dynamic-memory-coming-to-hyper-v-part-2)
  * [Part 3](/virtualization/community/team-blog/2010/20100407-dynamic-memory-coming-to-hyper-v-part-3)
  * [Part 4](/virtualization/community/team-blog/2010/20100421-dynamic-memory-coming-to-hyper-v-part-4)
  * [Part 5](/virtualization/community/team-blog/2010/20100520-repost-dynamic-memory-coming-to-hyper-v-part-5)


