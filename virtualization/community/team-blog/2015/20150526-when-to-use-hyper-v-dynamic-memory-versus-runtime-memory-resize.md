---
title: When to use Hyper-V Dynamic Memory versus Runtime Memory Resize
description: Learn about the appropriate situations when to use Hyper-V Dynamic Memory or Runtime Memory Resize.
author: sethmanheim
ms.author: sethm
date:       2015-05-26 14:30:14
ms.date: 05/26/2015
categories: dynamic-memory
ms.service: virtualization
---
# When to use Hyper-V Dynamic Memory versus Runtime Memory Resize

Starting in Windows 10/Windows Server Technical Preview, Hyper-V allows you to resize virtual machine memory without shutting down the virtual machine.  You might be thinking, "Hyper-V already has dynamic memory… what is this about?".  I get a lot of questions about why you would use memory resize if enabling dynamic memory already automatically adds or removes memory to meet only the virtual machine's needs.  To answer this, I'd like to tell a story about when I asked a similar question of my college roommate. 

 

## Are all wrenches the same?

I had a roommate in college who was a mechanical engineer, and one of his hobbies was modifying his car (and then driving it too fast). Living with essentially a part-time mechanic had its pros and cons: his expertise saved me from a few trips to the shop, but it also meant that he stored his huge toolset in our cramped dorm room.

The biggest part of the set was this enormous box of wrenches; the kind where each wrench had its special place in the box. I admit it was a beautiful set, but it also took up a lot of space. One day I asked him why he couldn't just use one adjustable wrench. Why did he need 100 different sizes? I thought I had stumped him.

He admitted that a wrench set and an adjustable wrench essentially fulfilled the same purpose. What I failed to realize however, was that there are scenarios which require a simple one-sized wrench. For example, applying too much torque to an adjustable wrench will break its threads. My roommate also pointed out that when you're trusting your life to a wrench (like when installing a seatbelt), you don't want the wrench to wiggle. He preferred a single piece of steel for those types of jobs.

 

The point is, just like wrenches, Hyper-V memory configurations are used in different scenarios. Dynamic memory is the adjustable wrench: it fits almost any situation. On the other hand, a VM without dynamic memory is like having one single-sized wrench: some situations call for it, but you're locked into the size you started with.

The ability to adjust the amount of memory at runtime is like having my roommate's fancy wrench set. A virtual machine without dynamic memory will no longer be locked into its initial memory allocation. Users can either add or remove memory based on their needs.

OK that's enough about wrenches; you get the idea. Let's talk about real use cases.

 

## Use Cases

Many types of Hyper-V users will benefit from this feature. However, there are two types that this feature especially applies to: desktop users and hosters.

### Desktop users

Imagine you're a desktop user, and you go to spin up a VM. It doesn't work because you were a little too ambitious allocating memory for the rest of the VMs, and so you've run out of memory to give.

Without this feature, you're stuck. You have enough memory to run all of your workloads, but it is tied up in VMs that don't need it. Your only option is to shut down your VMs and reallocate the memory when they're off. This means painful downtime for the workloads running on your machine. In the worst case, you have something critical running in those virtual machines. Best case scenario, this is just a huge hassle.

With runtime memory resize, you can simply remove memory from those other VMs without needing to stop anything. Once enough memory is freed up, you can go ahead and launch the new VM. This feature allows desktop users to create VMs without being locked down to the initial memory value.

### Hosters

Now picture you're a hoster.  Let's say a tenant wanted 60GB of memory in their VM at first, but they're quickly reaching that limit. Your tenant's service business is booming, and they need more memory in their VM. They can afford double the memory in their VM, but they can't afford to take their workload offline. Hopefully you can see how stressful this situation can be for hosters.

Before runtime memory resize, you would need to have a difficult conversation with your customer. You would need to explain that this is a complex change, and that it would likely mean downtime for their service (at a time when business is booming). Your tenant will certainly not be happy, and might reconsider buying a larger virtual machine.

With this new feature, selling more memory to existing tenants becomes trivial. You don't need to have that difficult conversation, you just need to ask "how much?" and make sure there is enough physical memory on the system. Runtime memory resize does away with the complexity of selling more memory, which means more revenue and happier tenants.

 

## Walk Through

Notes:

  * Runtime memory resize is only supported for Windows 10/Windows Server Technical Preview
  * If more memory is added than is available on the system, Hyper-V will add as much memory as it can and display an error dialogue.
  * Memory being used by the virtual machine at the time cannot be removed. In this case, Hyper-V will remove as much memory as it can and display an error dialogue.



#### Virtual Machine Settings

To adjust the amount of memory in a running virtual machine (without dynamic memory enabled), first open virtual machine settings. Enter the desired amount of memory in the "Startup RAM" field. The virtual machine's memory should adjust to the new value. In the screenshot below, note that the virtual machine is running but you can still adjust "Startup RAM".

<!-- [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/OnlineResizeUI.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/OnlineResizeUI.png) -->

#### PowerShell

To resize a virtual machine's memory in PowerShell, use the following cmdlet (example below):

Set-VMMemory -StartupBytes 

<!-- [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/OnlineResizePS.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/OnlineResizePS.png) -->

Theo Thompson  
Hyper-V Team
