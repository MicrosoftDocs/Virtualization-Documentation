---
title:      "Dynamic Memory Coming to Hyper-V Part 4"
author: sethmanheim
ms.author: sethm
description: Dynamic Memory Coming to Hyper-V Part 4
ms.date: 04/21/2010
date:       2010-04-21 07:39:00
categories: dynamic-memory
ms.prod: virtualization
---
# Dynamic Memory Coming to Hyper-V Part 4

_=====================================================================_ _Preamble: The point of this series, and the spirit in which it is written, is to take a holistic approach at the issues facing our customers, discuss the complexities with regard to memory management and explain why we're taking the approach we are with Hyper-V Dynamic Memory. This isn't meant to criticize anyone or technology, rather to have an open and transparent discussion about the problem space._ _=====================================================================_ In my last blog, we discussed Page Sharing in depth. To say this was a popular blog post would be a gross understatement. We received a lot of great feedback and a number of questions. So, I thought we'd close the loop on these questions about Page Sharing before getting to Second Level Paging in the next blog. **Questions** Q: When you say that Hyper-V R2 supports Large Memory Pages does that mean Hyper-V uses 2 MB memory page allocations or does that it mean it provides Large Memory Pages to the guest or both? A: Both. 

  1. Hyper-V R2 supports Large Memory Pages meaning that if the underlying hardware platform provides this capability, Hyper-V R2 will automatically take advantage of this feature in its memory allocations. It's important to note that by virtue of Hyper-V R2 running on Large Memory Page capable platforms, virtualized workloads will benefit and don't have to be large page aware to benefit from Hyper-V's usage of Large Pages to back guest RAM. 
  2. If the guest operating system and applications support Large Memory Pages (and of course the underlying hardware platform support Large Memory Pages), then those virtualized workloads can use Large Memory Page allocations within the guest as well. 

=================================================== Q: So, to take advantage of Large Memory Pages do applications have to be rewritten to use this functionality? A: No. While having the guest operating system and applications use Large Memory Pages can be a good thing, it's important to note that applications _**don't have to be large page aware to benefit from Hyper-V's usage of Large Pages to back guest RAM.**_ =================================================== Q: You mentioned that SuperFetch can impact Page Sharing efficacy as it eliminates zero pages. Isn't that a Windows specific feature, do other operating systems employ similar techniques? A: Yes, other operating systems use similar techniques. For example, Linux has a feature called "Preload." Preload is an "adaptive readahead daemon" that runs in the background of your system, and observes what programs you use most often, caching them in order to speed up application load time. By using Preload, it utilizes unused RAM, and improves overall system performance. BTW: OSNews said this about SuperFetch: 

> _SuperFetch is something all operating systems should have. I didn't buy 4GB of top-notch RAM just to have it sit there doing nothing during times of low memory requirements. SuperFetch makes my applications load faster, which is really important to me - I come from a BeOS world, and I like it when my applications load instantly._
> 
> _SuperFetch' design makes sure that it does not impact the system negatively, but only makes the system smoother. Because it runs at a low-priority, its cache doesn't take away memory from the applications you're running._

<http://www.osnews.com/story/21471/SuperFetch_How_it_Works_Myths> =================================================== Q: You didn't mention Address Space Layout Randomization (ASLR) and if it impacts Page Sharing, does it? A: I didn't cover ASLR because the blog was pretty long already, but since you asked... Yes, ASLR does impact the Page Sharing efficacy, but first a quick description of ASLR from a [TechNet article written by Mark Russinovich](https://technet.microsoft.com/magazine/2007.04.vistakernel.aspx): 

> _The Windows Address Space Layout Randomization (ASLR) feature makes it more difficult for malware to know where APIs are located by loading system DLLs and executables at a different location every time the system boots. Early in the boot process, the Memory Manager picks a random DLL image-load bias from one of 256 64KB-aligned addresses in the 16MB region at the top of the user-mode address space. As DLLs that have the new dynamic-relocation flag in their image header load into a process, the Memory Manager packs them into memory starting at the image-load bias address and working its way down._

Mark continues with... 

> _In addition, ASLR's relocation strategy has the secondary benefit that address spaces are more tightly packed than on previous versions of Windows, creating larger regions of free memory for contiguous memory allocations, reducing the number of page tables the Memory Manager allocates to keep track of address-space layout, and minimizing Translation Lookaside Buffer (TLB) misses._

Today, the impact of ASLR on Page Sharing is relatively low ~10% compared to Large Memory Pages and SuperFetch, but it is indeed another factor that impacts Page Sharing efficacy. Moreover, that's not to say that future improvements in ASLR won't impact Page Sharing efficacy further. =================================================== Q: You mention that Large Memory Page Support in included in the last few generations of Opterons and Intel has added support in the new "Nehalem" processors. Do you mean older Intel x86/x64 do not support Large Memory Pages? A: 5/6/2010: CORRECTION: Actually, older x86/x64 processors _do support_ Large Memory Pages going back many generations. However, 32-bit systems generally didn't support generous amounts of memory (most maxed out at 4 GB which is  a small fraction of what 64-bit systems support) so support for Large Memory Pages wasn't as crucial as it is now with 64-bit servers being the norm. In my next blog we'll discuss Second Level Paging... Jeff Woolsey Principal Group Program Manager Windows Server, Virtualization 

P.S. Here are the links to all of the posts in this blog series:

  * Part 1: <https://blogs.technet.com/virtualization/archive/2010/03/18/dynamic-memory-coming-to-hyper-v.aspx>
  * Part 2: <https://blogs.technet.com/virtualization/archive/2010/03/25/dynamic-memory-coming-to-hyper-v-part-2.aspx>
  * Part 3: <https://blogs.technet.com/virtualization/archive/2010/04/07/dynamic-memory-coming-to-hyper-v-part-3.aspx>


