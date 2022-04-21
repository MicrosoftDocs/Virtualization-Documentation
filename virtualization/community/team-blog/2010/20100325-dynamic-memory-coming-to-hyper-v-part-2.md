---
title:      "Dynamic Memory Coming to Hyper-V Part 2…"
author: mattbriggs
ms.author: mabrigg
description: Dynamic Memory Coming to Hyper-V Part 2
ms.date: 03/25/2010
date:       2010-03-25 06:53:00
categories: dynamic-memory
---
# Dynamic Memory Coming to Hyper-V Part 2

_======================================================_ _Preamble: The point of this series, and the spirit in which it is written, is to take a holistic approach at the issues facing our customers, discuss the complexities with regard to memory management and explain why we ’re taking the approach we are with Hyper-V Dynamic Memory. This isn’t meant to criticize anyone or technology, rather to have an open and transparent discussion about the problem space._ _======================================================_ __Virtualization Nation, When it comes to virtualization and memory, customers want to use physical memory as efficiently and dynamically as possible with minimal performance impact and provide consistent performance and scalability. **Looking at the bigger picture** In addition to asking customers about memory and how it relates to virtualization, we took a step back and talked to our customers about the broader topic of memory and capacity planning. Let ’s remove virtualization from the equation for the moment. If you were to setup some new physical servers how would you do this? How would you determine the workload memory requirements and the amount of memory to purchase? For example, 

  * How much memory does a web server require? 
    * Is this for an internal LOB application? 
    * Is this a front end web server receiving hundreds/thousands/more hits a day? 
  * How much memory does a file server require? 
    * Is this a departmental file server serving a few dozen folks? 
    * Is this a corporate file server serving a few thousand folks? 
  * How about [Windows Server 2008 R2 BranchCache](https://www.microsoft.com/windowsserver2008/en/us/branch-cache.aspx)? 
  * Domain Controllers? 
  * Windows Server 2008 R2 [DirectAccess Servers](https://www.microsoft.com/windowsserver2008/en/us/R2-better-together.aspx)? 
  * Print Servers? 
  * <insert your application here>

If you answered, “it depends,” you’re correct. There isn’t one simple answer to this question. Your mileage will vary based on your workload and business requirements for scale and performance. When we ask customers how they tackle this problem, here are a few of the common answers: 
  * “I give all servers [pick one: 2 GB, 4 GB, 8 GB] of memory and add more if users complain.”
  * “I take the minimum system requirements and add [pick one: 25%, 50%, 100%] more. I have no idea what is happening with that memory, I just don’t want any trouble tickets.”
  * “I do what the vendor recommends. If it’s 4 GB, it’s at least 4GB and some extra as buffer. I don’t have time to test further.”

The result is far from optimal. Customers overprovision their hardware and don’t use it efficiently which in turn raises the TCO. Wouldn’t it be great if your workloads automatically and dynamically allocated memory based on workload requirements and you were provided a flexible policy mechanism to control how these resources are balanced across the system? We think so too. In my next blog, we’ll discuss the confusion that is “memory overcommit.” Cheers, Jeff Woolsey 

Windows Server Hyper-V
