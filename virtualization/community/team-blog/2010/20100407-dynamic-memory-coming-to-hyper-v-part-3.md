---
title:      "Dynamic Memory Coming to Hyper-V Part 3…"
author: mattbriggs
ms.author: mabrigg
description: Dynamic Memory Coming to Hyper-V Part 3
ms.date: 04/07/2010
date:       2010-04-07 06:03:00
categories: dynamic-memory
ms.service: virtual-machines
---
# Dynamic Memory Coming to Hyper-V Part 3

_======================================================_

_Preamble: The point of this series, and the spirit in which it is written, is to take a holistic approach at the issues facing our customers, discuss the complexities with regard to memory management and explain why we’re taking the approach we are with Hyper-V Dynamic Memory. This isn’t meant to criticize anyone or technology, rather to have an open and transparent discussion about the problem space._

_======================================================_

__

**Memory Overcommit, an Overloaded Term…**

When it comes to virtualization and memory, I regularly hear the term “memory overcommit” used as if it’s a single technology. The problem is that there are numerous techniques that can be employed to more efficiently use memory which has led to much confusion. Some customers think page sharing equals overcommit. Others think second level paging equals memory overcommit and so on.

So, to avoid any confusion, here’s the definition of overcommit according to the Merriam Webster dictionary online:

> <http://www.merriam-webster.com/dictionary/overcommit>
> 
> Main Entry: **over·com·mit**
> 
> **:** to commit excessively: as **a** **:** to obligate (as oneself) beyond the ability for fulfillment **b** **:** to allocate (resources) in excess of the capacity for replenishment

Memory overcommit simply means to allocate more memory resources than are physically present. In a physical (non-virtualized) environment, the use of paging to disk is an example of memory overcommit. Now that we’ve defined it, I’m done using this term to avoid the aforementioned confusion. From here on, I’m going to refer to specific memory techniques.

In a virtualized environment, there are a variety of different memory techniques that can be employed to more efficiently use memory such as page sharing, second level paging and dynamic memory balancing (e.g. ballooning is one technique, hot add/remove memory is another). Each one of these methods has pros and cons and varying levels of efficacy.

Today we’ll discuss Page Sharing in detail. 

BTW, before we dive in, let me state at the onset that we have spent a lot of time looking at this technology and have concluded that it is not the best option for us to use with dynamic memory. Hopefully, this will explain why…

**How Page Sharing Works**

Page Sharing is a memory technique where the hypervisor inspects and hashes all memory in the system and stores it in a hash table. Over time, which can be hours, the hashes are compared and if identical hashes are found, a further bit by bit comparison is performed. If the pages are exactly the same, a single copy is stored and multiple VMs memory are mapped to this shared page. If any one of these virtual machines need to modify that shared page, copy on write semantics are used resulting in a new (and thus unshared) memory page.

Page Sharing is a well understood memory technique and there are a number of factors that contribute to its efficacy such as:

  1. Large Memory Pages 
  2. OS Memory Utilization & Zero Pages 



**Page Sharing, TLBs, Large Memory Pages & More…**

To discuss Large Memory Page Support and its implications on Page Sharing, let’s take a step back and level set. For that, I’m going to reference an excellent article written by Alan Zeichick from AMD in 2006. While the focus of this article discusses the implications of large memory pages and java virtual machines, it also applies to machine virtualization. I’m going to reference specific sections, but if you’d like to read the full article it is here:

<http://developer.amd.com/documentation/articles/pages/2142006111.aspx>

> _All x86 processors and modern 32-bit and 64-bit operating systems allocate physical and virtual memory in pages. The page table maps virtual address to physical address for each native application and "walking" it to look up address mappings takes time. To speed up that process, modern processors use the translation lookaside buffer (TLB), to cache the most recently accessed mappings between physical and virtual memory._
> 
> _Often, the physical memory assigned to an application or runtime isn't contiguous; that's because in a running operating system, the memory pages can become fragmented. But because the page table masks physical memory address from applications, apps think that they do have contiguous memory. (By analogy, think about how fragmented disk files are invisible to applications; the operating system's file system hides all of it.)_
> 
> _When an application needs to read or write memory, the processor uses the page table to translate the virtual memory addresses used by the application to physical memory addresses. As mentioned above, to speed this process, the processor uses a cache system—the translation lookaside buffers. If the requested address is in the TLB cache, the processor can service the request quickly, without having to search the page table for the correct translation. If the requested address is not in the cache, the processor has to walk the page table to find the appropriate virtual-to-physical address translation before it can satisfy the request._

> _**The TLB's cache is important, because there are a lot of pages! In a standard 32-bit Linux, Unix, or Windows server with 4GB RAM, there would be a million 4KB small pages in the page table. That's big enough—but what about a 64-bit system with, oh, 32GB RAM? That means that there are 8 million memory 4KB pages on this system.**_

Mr. Zeichick continues: 

> **_Why is it [Large Pages] better? Let's say that your application is trying to read 1MB (1024KB) of contiguous data that hasn't been accessed recently, and thus has aged out of the TLB cache. If memory pages are 4KB in size, that means you'll need to access 256 different memory pages. That means searching and missing the cache 256 times—and then having to walk the page table 256 times. Slow, slow, slow._**
> 
> **_By contrast, if your page size is 2MB (2048KB), then the entire block of memory will only require that you search the page table once or twice—once if the 1MB area you're looking for is contained wholly in one page, and twice if it splits across a page boundary. After that, the TLB cache has everything you need. Fast, fast, fast._**
> 
> **_It gets better._**
> 
> **_For small pages, the TLB mechanism contains 32 entries in the L1 cache, and 512 entries in the L2 cache. Since each entry maps 4KB, you can see that together these cover a little over 2MB of virtual memory._**
> 
> **_For large pages, the TLB contains eight entries. Since each entry maps 2MB, the TLBs can cover 16MB of virtual memory. If your application is accessing a lot of memory, that's much more efficient. Imagine the benefits if your app is trying to read, say, 2GB of data. Wouldn't you rather it process a thousand buffed-up 2MB pages instead of half a million wimpy 4KB pages?_**

Kudos, Mr. Zeichick.

I expanded on Mr. Zeichick’s physical memory to page table entry example and created this table to further illustrate the situation with 4KB pages at varying physical memory sizes.

**Physical Memory** | **Page Table Entries (4KB)**  
---|---  
4 GB | 1 million pages  
32 GB | 8 million pages  
64 GB | 16 million pages  
96 GB | 24 million pages  
128 GB | 32 million pages  
192 GB | 48 million pages  
256 GB | 64 million pages  
384 GB | 96 million pages  
512 GB | 128 million pages  
1 TB | 256 million pages  
  
When you consider that servers have supported 32/64 GB of memory for years now and that many industry standard servers shipping today, like the [HP DL 385 G6, support up to 192 GB](http://h10010.www1.hp.com/wwpc/us/en/sm/WF06a/15351-15351-3328412-241644-241475-3884082.html) of memory per server today you can quickly see that the time for larger memory page support is overdue. Take a look at the recently released Nehalem EX processor. The Nehalem EX supports up to _**256 GB of memory _per socket_.** _ You could theoretically have a 4 socket server with 1 TB of physical memory. Do you really want to access all this memory 4k at a time?

(Even with just 64 GB of physical memory in a server, think of this as filling up an Olympic size swimming pool with water one 8 ounce cup at a time and it just gets worse as you add and use more memory…)

Key Points: 

  * The TLB is a critical system resource that you want to use effectively and efficiently as possible as it can have significant impact on system performance. 
  * The use of 4k memory pages in a 32-bit world where systems max out at 4 GB of memory has been an issue for years now and the problem is far worse in a 64-bit world with systems easily capable of tens (if not hundreds) of gigabytes of memory. 
  * Using 4k memory pages on 64-bit systems with much greater memory support, drastically reduces the effectiveness of the TLB and overall system performance. 



**There’s More: SLAT, NPT/RVI, EPT and Large Pages…**

One point I want to add is how Large Pages and Second Level Address Translation (SLAT) hardware coexist. With nested paging, (AMD calls this Rapid Virtualization Indexing (RVI) and/or Nested Page Tables (NPT), while Intel calls this Extended Page Tables or EPT) a page table in the hardware takes care of the translation between the guest address of a VM and the physical address, reducing overhead. With SLAT hardware, performance is generally improved about 20% across the board, and can be much higher (independent third parties have reported 100%+ performance improvements) depending on how memory intensive the workload is. In short, SLAT hardware is goodness and if you’re buying a server today as a virtualization host you want to ensure you’re purchasing servers with this capability.

One important point that doesn’t appear to be well-known is that SLAT hardware technologies are _designed and optimized with Large Memory Pages enabled_. Essentially, the additional nesting of page tables makes TLB cache misses more expensive **resulting in about a ~20% performance reduction if you’re using SLAT hardware with Large Memory Page Support disabled**. **Furthermore, that’s not including the 10-20% average performance _improvement_ (could be more) expected by using Large Memory Pages in the first place. Potentially, we’re talking about a 40% performance delta running on SLAT hardware depending on whether Large Memory Pages are used or not.**

You may want to read those last two paragraphs again.

In short, using Large Memory Pages is a no brainer. You definitely want to take advantage of Large Memory Pages:

  * Improved performance (on average 10-20% & can be higher) 
  * More efficient TLB utilization 
  * Avoid a ~20% performance hit on SLAT hardware 



**HW Evolution, Large Memory Pages & the Implications on Page Sharing**

Computing hardware is in a constant state of evolution. Take networking for example. Originally, the frame size for Ethernet was 1518 bytes largely due to the fact that early networks operated at much lower speeds and with higher error rates. As networking evolved and improved (faster and with lower error rates), the 1518 byte size was recognized as a bottleneck and jumbo frames were introduced. Jumbo frames are larger, up to 9014 bytes in length, and deliver 6x more packets per payload and reduce CPU utilization by reducing the number of interrupts.

Large Memory Pages is a similar situation where server hardware is evolving to improve the overall system scale and performance. As a byproduct of this evolution, it changes some base assumptions. Specifically, Large Memory Pages changes the fundamental assumption of small 4k memory pages to larger and more efficient 2MB memory pages. However, there are implications to changing such fundamental assumptions. **While you can identify and share 4k pages relatively easily, the likelihood of sharing a 2MB page is very, very low (if not, zero). In fact, this is an area where Microsoft and VMware _agree_**. VMware acknowledges this point and states as much.

_From VMware:_

> _The only problem is that when large pages is used, Page Sharing needs to find identical 2M chunks (as compared to 4K chunks when small pages is used) and the likelihood of finding this is less (unless guest writes all zeroes to 2M chunk) so ESX does not attempt collapses large pages and thats [sic] why memory savings due to TPS goes down when all the guest pages are mapped by large pages by the hypervisor._
> 
> <http://communities.vmware.com/message/1262016#1262016>

**_Bottom Line: Page Sharing works in a legacy 4k Memory Page world, but provides almost no benefit in a modern 2MB Memory Page world._**

As stated previously, support for Large Memory Pages is a no brainer. In fact, when designing Hyper-V Dynamic Memory, we were sure to _optimize_ in the case where Large Memory Pages are present because we expect it will soon be standard. We are so confident in Large Memory Page support that:

  * Windows Server 2008/2008 R2 have Large Memory Pages enabled by default 
  * Windows Vista/7 have Large Memory Pages enabled by default 
  * Windows Server 2008 R2 Hyper-V added support for Large Memory Pages (surprise!) and is one of many new performance improvements in R2 



Memory page size is evolutionary. You can expect memory page size to grow beyond 2MB to even larger page sizes in the future. In fact, newer AMD64 processors can use 1GB pages in long mode and Intel is adding 1GB memory page support in their upcoming Westmere processors. (BTW, that’s not a typo, 1GB pages…) 

In addition to Large Page Memory, another factor impacting the efficacy of Page Sharing is OS Memory Utilization and Zero Pages.

**Page Sharing, OS Memory Utilization & Zero Pages**

One aspect of page sharing most people may not know is that the greatest benefit of page sharing comes from sharing zeroed pages. Let’s assume for a moment that I have a Windows XP system with 2GB of memory. As you can see in the screenshot below from a freshly booted system running Windows XP with no apps, the OS is using ~375MB of memory while the remaining memory ~1.8GB is unused and unfortunately wasted.

[![XP-Just Booted 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/DynamicMemoryComingtoHyperVPart3_A923/XP-Just%20Booted%202_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/DynamicMemoryComingtoHyperVPart3_A923/XP-Just%20Booted%202_2.png)

In reality, you want the operating system to take full advantage of all the memory in the system and use it as an intelligent cache to improve system performance and responsiveness. If you’re going to buy a brand new system (I see an online ad today for a brand new quad core system with 8 GB of memory for $499) don’t you want the OS to use that memory? Of course you do. That’s why we created SuperFetch.

**SuperFetch** keeps track of which applications you use most and loads this information in RAM so that programs load faster than they would if the hard disk had to be accessed every time. Windows SuperFetch prioritizes the programs you're currently using over background tasks and adapts to the way you work by tracking the programs you use most often and pre-loading these into memory. With SuperFetch, background tasks still run when the computer is idle. However, when the background task is finished, SuperFetch repopulates system memory with the data you were working with before the background task ran. Now, when you return to your desk, your programs will continue to run as efficiently as they did before you left. It is even smart enough to know what day it is in the event you use different applications more often on certain days. 

OK, so how is RAM usage affected? You may have noticed that Windows 7 tends to use a much greater percentage of system RAM than on Windows XP. It is not uncommon to view Task Manager on a Windows 7 system with several GB of RAM installed and less than 100MB of the RAM shows up as free. For instance, here is a screenshot of Task Manager from the machine I am working on now.

[![Win 7 Task Manager #2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/DynamicMemoryComingtoHyperVPart3_A923/Win%207%20Task%20Manager%20_2_thumb_bcd1746d-4a8f-4e5b-b83d-19d89dfbff6f.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/DynamicMemoryComingtoHyperVPart3_A923/Win%207%20Task%20Manager%20_2_2b5a8dfc-8897-423f-8e8f-cffd90e0a97a.png)

As you can see, this system has 8GB of physical memory and is using 3.29 GB. I'm running Windows 7 x64 Edition, Outlook, One Note, Word, Excel, PowerPoint, Windows Live Writer, Live Photo Gallery, several instances of IE with over a dozen tabs open and other day to day tools and you can see that it shows 0 MB of free physical memory. At first glance, this would seem to be something to worry about, but once you consider the impact of SuperFetch this condition becomes less of a concern. Notice that ~5827MB is being used for cache. 

Excellent.

Windows 7 is fully utilizing the system memory resources and intelligently caching so that I have a responsive system (fetching less from disk) with great performance and making it more likely the hard drive can spin down to save power to provide longer battery life.

So, why am I explaining Zero Pages and SuperFetch?

Because page sharing obtains the greatest benefit by page sharing zero pages running older operating systems and is less efficacious on modern operating systems. Like Jumbo Frame and Large Memory Pages, SuperFetch is another example of evolutionary changes in computing.

In talking with customers who are investigating hosting virtual desktops, they told us that Windows 7 is their overwhelming choice. This was another important data point in determining how we chose to implement dynamic memory because making the assumption that an OS will have lots of zero pages around isn’t a good one today or for the future.

**Final Points on Page Sharing**

To sum up…

Large Memory (2MB) Pages support is widely available in processors from AMD and Intel _today_.  AMD and Intel have included support for Large Memory Pages going back many generations of x86/x64 processors. However, 32-bit systems generally didn't support generous amounts of memory (most maxed out at 4 GB which is a small fraction of what 64-bit systems support) so support for Large Memory Pages wasn't as crucial as it is now with 64-bit servers being the norm.

  * **Page Sharing on systems with Large Memory Pages enabled results in almost _no shared pages_. **While you can identify and share 4k pages relatively easily, the likelihood of sharing a 2MB page is very, very low (if not, zero). Again, this is an area where Microsoft and VMware _agree_**.**
  * Read that last bullet item again 
  * Page Sharing works with small 4k memory pages. The downside to small memory pages is that they don’t efficiently use the TLB while Large Memory Pages more efficiently use the TLB and can significantly boost performance 
  * Using small 4k memory pages instead of Large Memory pages _reduces_ performance on SLAT hardware by ~20% 
  * Windows Server 2008/2008 R2 have Large Memory Pages enabled by default 
  * Windows Vista/7 have Large Memory Pages enabled by default 
  * Windows Server 2008 R2 Hyper-V added support for Large Memory Pages and is one of the many new performance improvements in R2 (surprise!) 
  * Page Sharing _efficacy is decreasing_ (irrespective of Large Memory Pages) as modern OSes take full advantage of system memory to increase performance 
  * The process of inspecting, hashing all the memory in the system, storing it in a hash table and then performing a bit-by-bit inspection **can take hours**. The time it takes is dependent on a number of variables such as the homogeneity of the guests, how busy the guests are, how much memory is physically in the system, if you’re load balancing VMs, etc. 
  * Page sharing isn’t a particularly dynamic technique, meaning, if the hypervisor needs memory for another virtual machine immediately, page sharing isn’t the best answer. The converse is true as well. If a virtual machine frees up memory which could be used by other virtual machines, page sharing isn’t the best answer here either.



I hope this blog demonstrates that we have spent a lot of time looking at this technology and after significant analysis concluded it is not the best option for us to employ with Hyper-V Dynamic Memory. Moreover, the case for supporting Large Memory Pages is a no brainer. We feel so strongly about supporting Large Memory Pages that when designing Hyper-V Dynamic Memory, we were sure to _optimize_ in the case where Large Memory Pages are present because we expect it to be standard. The benefits are too great to pass up. The good news is that there are other ways to pool and allocate memory and Hyper-V Dynamic Memory is a good solution for desktop and server operating systems.

In my next blog, we’ll discuss second level paging.

Jeff Woolsey

Windows Server Hyper-V
