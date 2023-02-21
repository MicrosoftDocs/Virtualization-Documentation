---
title:      "Repost&#58; Dynamic Memory Coming to Hyper-V Part 5…"
description: In my last blog, we covered some follow-up questions about Page Sharing. Today, we’ll discuss Second Level paging.
author: scooley
ms.author: scooley
date:       2010-05-20 05:52:00
ms.date: 05/20/2010
categories: dynamic-memory
ms.prod: virtualization
---
# Repost: Dynamic Memory Coming to Hyper-V Part 5

_=====================================================================_

_Preamble: The point of this series, and the spirit in which it is written, is to take a holistic approach at the issues facing our customers, discuss the complexities with regard to memory management and explain why we ’re taking the approach we are with Hyper-V Dynamic Memory. This isn’t meant to criticize anyone or technology, rather to have an open and transparent discussion about the problem space._

_=====================================================================_

__

In my last blog, we covered some follow-up questions about Page Sharing. Today, we’ll discuss Second Level paging. To discuss the implications of using Second Level Paging, let’s put virtualization aside, take a step back and level set and start by discussing Virtual Memory and Paging.

**Virtual Memory At A High Level**

Modern operating systems employ virtual memory. Virtual memory is a way of extending the effective size of a computer’s memory by using a disk file (as swap space) to simulate additional memory space. The operating system keeps track of which memory addresses actually reside in memory and which ones must be brought in from disk when needed. Here are a few of the common memory management functions performed by modern operating systems:

  * Allow multiple applications to coexist in the computer's physical memory (enforce isolation) 
  * Use virtual addressing to hide the management of physical memory from applications 
  * Extend the system's memory capacity via swapping 



**Virtual Memory In Depth**

Let’s dive in deeper. For that, I’m going to reference a TechNet article that discusses the Windows Virtual Memory Manager. If you’d like to read the full article it is [here](/previous-versions//cc767886(v=technet.10)). A second article I highly recommend on virtual memory is [this one](https://blogs.technet.com/markrussinovich/archive/2008/11/17/3155406.aspx) from Mark Russinovich:

From the TechNet article:

> **_Sharing A Computer's Physical Memory_**

> _Operating systems that support multitasking allow code and data from multiple applications to exist in the computer's **physical memory** (random access memory) at the same time. It is the operating system's responsibility to ensure that physical memory is shared as efficiently as possible, and that no memory is wasted. As a result, an operating system's memory manager must contend with a problem called **memory fragmentation**. Memory fragmentation refers to the situation where free (available) memory becomes broken into small, scattered pieces that are not large enough to be used by applications. In the example shown here, free memory is separated into three separate blocks._
> 
> _Once free physical memory becomes fragmented, an operating system can consolidate free memory into a single, contiguous block by moving code and data to new **physical addresses**. In this case, the three blocks of free memory were consolidated into one larger block by moving system memory upward and application 1 downward in physical memory._
> 
> _If an application accesses its code or data using physical memory addresses, the application may encounter problems when the operating system moves its code and data. A mechanism must be provided for applications to access their code and data no matter where the operating system moves them in physical memory._
> 
> **_Virtualizing Access to Memory_**
> 
> _A common solution is to provide applications with a logical representation of memory (often called **virtual memory** ) that completely hides the operating system's management of physical memory. Virtual memory is an illusion that the operating system provides to simplify the application's view of memory. Applications treat virtual memory as though it were physical memory. Meanwhile, the operating system can move code and data in physical memory whenever necessary._
> 
> _In a virtual memory system, the addresses applications use to access memory are **virtual addresses** , not physical memory addresses. Every time an application attempts to accesses memory using a virtual address, the operating system secretly translates the virtual address into the physical address where the associated code or data actually resides in physical memory. Because the translation of virtual addresses to physical addresses is performed by the operating system, applications have no knowledge of (or need to be concerned with) where their code and data actually reside._
> 
> **_Extending Virtual Memory Through Swapping_**
> 
> _When applications access memory using virtual addresses, the operating system is responsible for translation of virtual addresses to physical addresses. As a result, the operating system has total control over where data and code are physically stored. This not only means that the operating system can move code and data in physical memory as it likes, but it also means that code and data don't need to be stored in physical memory at all!_
> 
> _A computer's processor can only access code and data that resides in physical memory (RAM). However, physical memory is relatively expensive so most computers have relatively little of it. Most multitasking operating systems extend their virtual memory management schemes to compensate for this scarcity of physical memory. They rely on a simple, but very important fact: Code and data only need to be in physical memory when the processor needs to access them! When not needed by the processor, code and data can be saved temporarily on a hard disk (or other device with abundant storage). This frees physical memory for use by other code and data that the processor needs to access. The process of temporarily transferring code and data to and from the hard disk to make room in physical memory is called **swapping**._
> 
> _Swapping is performed to increase the amount of virtual memory available on the computer. The memory manager performs swapping "behind the scenes" to make it appear as though the computer has more physical memory than it actually does. Effectively, the virtual memory available on a computer is equal to its physical memory plus whatever hard disk space the virtual memory manager uses to temporarily store swapped code and data._
> 
> **_Loading Swapped Code And Data On Demand_**
> 
> _If an application attempts to access code or data that is not in physical memory (it was swapped to disk) the virtual memory manager gets control. The virtual memory manager locates (or creates) an available block of physical memory, and copies the required code or data into the block so it can be accessed. Applications are not aware that their code and data were ever swapped to disk. The code and data are automatically loaded into physical memory by the virtual memory manager whenever the application needs to use them._

Key Points:

  * Operating system memory management abstracts physical memory application and enforces isolation 
  * The memory manager extends the system's memory capacity via swapping 



Ok, now that we’ve discussed how virtual memory and paging works, let’s relate this to virtualization.

**Static Memory & Guest Only Paging**

Today with Hyper-V (V1 & R2), memory is _statically_ assigned to a virtual machine. Meaning you assign memory to a virtual machine and when that virtual machine is turned on, Hyper-V allocates and provides that memory to the virtual machine. That memory is held while the virtual machine is running or paused. When the virtual machine is saved or shut down, that memory is released. Below is a screenshot for assigning memory to a virtual machine today:


This memory is 100% backed by physical memory and is never paged. Remember that the guest is actively determining which pages should and shouldn’t be paged as it manages all the memory it’s been allocated by the virtual machine and it knows best how to do so. Here’s a basic picture to illustrate what this looks like in a virtualization environment. There are four virtual machines running and each of the guest kernels are managing their own memory.


Ok, now let’s dive into Second Level Paging…

**Second Level Paging: What Is It?**

Second Level Paging is a technique where the virtualization platform creates a _second_ level of memory abstraction and swap files are created by the virtualization layer to page memory to disk when the system is oversubscribed. With SLP, you now have two tiers of paging to disk one within the guest and one below it at the virtualization layer. Here ’s another picture to illustrate how Second Level Paging fits in. Again, there are four virtual machines running and each of the guest kernels are managing their own memory. However, notice that below them is the Second Level of Paging managed independently by the virtualization platform.


One common argument used in favor of Second Level Paging I’ve heard is this “If Windows and modern OSes all use paging today, why is this bad with virtualization?"

Great question.

**Answer: Performance**.

With Second Level Paging, memory assigned to a virtual machine can be backed by memory or by disk. The result is that Second Level Paging _creates_ issues that are unique to a virtualized environment. When the system is oversubscribed, the virtualization layer can and will blindly and randomly swap out memory that the guest is holding even critical sections that the guest kernel is specifically holding in memory for performance reasons. Here ’s what I mean.

**Swapping the Guest Kernel**

Swapping the guest kernel is an example where virtualization is creating an issue that doesn’t exist on physical systems. In an OS kernel, there are specific critical sections in memory that an operating system kernel _never pages_ to disk for performance reasons. This is a _subject where Microsoft and VMware agree_ and VMware states as much in their documentation.

> _“ …hypervisor swapping is a guaranteed technique to reclaim a specific amount of memory within a specific amount of time. **However, hypervisor swapping may severely penalize guest performance. This occurs when the hypervisor has no knowledge about which guest physical pages should be swapped out, and the swapping may cause unintended interactions with the native memory management policies in the guest operating system. For example, the guest operating system will never page out its kernel pages since those pages are critical to ensure guest kernel performance. The hypervisor, however, cannot identify those guest kernel pages, so it may swap them out**. In addition, the guest operating system reclaims the clean buffer pages by dropping them. Again, since the hypervisor cannot identify the clean guest buffer pages, it will unnecessarily swap them out to the hypervisor swap device in order to reclaim the mapped host physical memory._

> _Understanding Memory Resource Management in VMware ESX Server p. 9-10;_[ _here_](https://www.vmware.com/techpapers/2009/understanding-memory-resource-management-in-vmware-10062.html)

Thus, the more you oversubscribe memory, the worse the overall performance because the system has to fall back to using disk and ultimately trade memory performance for disk performance. Speaking of comparing memory to disk performance...

**Memory vs Disk Performance**

Finally, there is the performance comparison, or, really lack thereof, because there is no comparison between memory and disk. This isn’t debatable. This is fact. Let’s do a little math. Let’s assume that the typical disk seek time is ~8 _milliseconds_. For memory access, here are the response times in _nanoseconds:_

  * DDR3-1600 = 5 nanoseconds 
  * DDR3-1333 = 6 ns 
  * DDR3-1066 = 7.5 ns 
  * DDR3-800 = 10 ns 



So, if you want to compare disk access to DDR-3 1600 memory access the formula is .008/.000000005. Here are the results:

  * **DDR3-1600 memory is 1,600,000 times faster than disk**
  * **DDR3-1333 memory is 1,333,333 times faster than disk**
  * **DDR3-1066 memory is 1,066,666 times faster than disk**
  * **DDR3-800 memory is 800,000 times faster than disk**



We’ve heard on many occasions that virtualization users have been told that performance of Second Level Paging “isn’t that bad.” I don’t know how anyone can say with a straight face that a performance penalty of greater than six orders of magnitude isn’t that bad. To put 1.6 million times faster in perspective, assume it took you an hour to walk one mile. If you traveled 1.6 million times faster, you could roughly travel to Saturn and back in an hour. ([Saturn is approximately 746 million miles away at its minimum distance to the Earth](https://www.britannica.com/place/Saturn-planet)).

**Microsoft & VMware Agree: Avoid Oversubscription**

The fact that swapping to disk carries a significant performance penalty and you should avoid it is another area **where Microsoft and VMware agree.** This isn’t new guidance so I’ve included examples from ESX 3 and VSphere.

From VMware: 

> _Example 1: Make sure the host has more physical memory than the total amount of memory that will be used by ESX plus the sum of the working set sizes that will be used by all the virtual machines running at any one time._

> _\--Performance Tuning Best Practices for ESX Server 3_

> _Example 2: if the working set is so large that active pages are continuously being swapped in and out (that is, the swap I/O rate is high), then performance may degrade significantly. To avoid swapping in specific virtual machines please configure memory reservations for them (through the VI Client) at least equal in size to their active working sets. But be aware that configuring resource reservations can limit the number of virtual machines one can consolidate on a system._

> _\--Performance Tuning Best Practices for ESX Server 3 page 15_

> _Example 3: ESX also uses host-level swapping to forcibly reclaim memory from a virtual machine. Because this will swap out active pages, it can cause virtual machine performance to degrade significantly._

> _\--Performance Tuning Best Practices for VSphere page 23_

Translation: Ensure that the memory used by ESX and its virtual machines reside in physical memory and avoid swapping to disk, i.e. **avoid oversubscribing memory**. 

**Final Points on Second Level Paging**

  * Second Level Paging breaks the fundamental assumption that Guest Operating Systems have an accurate representation of physical memory 
  * Performance of memory to disk ranges from 800,000 times to 1,600,000 times faster 
  * When the system is oversubscribed, Second Level Paging carries a significant performance hit. Simply stated, **the more the system is oversubscribed, the more it relies on swapping to disk and the worse the overall system performance**. 



The good news is that there are other ways to pool and allocate memory and Hyper-V Dynamic Memory is a good solution for desktop and server operating systems... In my next blog, we’ll explain Hyper-V Dynamic Memory.

Cheers,

Jeff Woolsey

Principal Group Program Manager

Windows Server, Virtualization
