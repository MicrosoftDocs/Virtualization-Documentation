---
title:      "Hyper-V VM Density, VP&#58;LP Ratio, Cores and Threads..."
date:       2011-04-25 06:18:00
categories: dynamic-memory
---
Virtualization Nation,

 

With Windows Server 2008 R2 SP1 Hyper-V and Microsoft Hyper-V Server 2008 R2 SP1, we focused Hyper-V development on enhancing Virtual Desktop Infrastructure (VDI) scenarios, which resulted in the introduction of Dynamic Memory and RemoteFX. In addition, we increased the maximum number of running virtual processors (VP) per logical processor (LP) from 8:1 to 12:1 when running Windows 7 as the guest operating system for VDI deployments. In making this change and discussing the VP:LP ratio with you, I’ve noticed that there’s some confusion as to what this metric really means and how it compares to other virtualization vendors. Let’s discuss.

 

I’ve noticed differences in how Microsoft--versus other virtualization vendors--expresses the maximum number of virtual processors that can run on a physical processor. It seems we’ve inadvertently created some confusion as to the maximum number of supported virtual processors on a server running Hyper-V. Here’s the crux of the problem:

·         Other virtualization vendors provide a maximum for virtual processors **_per core_**.

·         Microsoft provides a maximum for virtual processors **_per_ _logical processor_** , where a logical processor **_equals a core, or thread_**.

 

What ends up happening is that customers ask about the ratios and here’s what happens:

1.       Vendor A responds 16:1 (with the qualifier that your mileage will vary…).

2.       Microsoft responds 12:1 for Win7 for VDI and 8:1 for Non-VDI and all other guest OSs.

 

The issue is we’re comparing apples and oranges. When we talk about physical processors, that includes symmetric multi-threading where there are two threads (i.e., logical processors) per core. Remember, Microsoft provides a maximum of virtual processors **_per_ _logical processor_** where a logical processor **_equals a core or thread_**. To do apples-to-apples comparison, when you ask about the **_maximum virtual processors per core for Hyper-V_** , the answer really is:

·         Up to 24:1 for Win 7 for VDI and 16:1 for non-VDI (all other guest operating systems)

 

…and up to a maximum of 384 running virtual machines and/or 512 virtual processors per server (whichever comes first). To make things easy to understand, I’ve provided the formulas and tables below.

 

==============================================

 **Window 7 as Guest OS for VDI

**

==============================================

In the case of a VDI scenario with Windows 7 as the guest with a 12:1 (VP:LP) ratio, here’s the formula and the table:

 

(Number of processors) * (Number of cores) * (Number of threads per core) * 12

 

 **Table 1 Virtual Processor to Logical Processor Ratio & Totals (12:1 VP:LP ratio for Windows 7 guests)

**

**Physical Processors

**

| 

**Cores per processor

**

| 

**Threads per core

**

| 

**Max Virtual Processors Supported

**  
  
---|---|---|---  
  
2

| 

2

| 

2

| 

96  
  
2

| 

4

| 

2

| 

192  
  
2

| 

6

| 

2

| 

288  
  
2

| 

8

| 

2

| 

384  
  
 

| 

 

| 

 

| 

   
  
4

| 

2

| 

2

| 

192  
  
4

| 

4

| 

2

| 

384  
  
4

| 

6

| 

2

| 

512 (576)1  
  
4

| 

8

| 

2

| 

512 (768)1  
  
 

1Remember that Hyper-V R2 supports up to a maximum of up to 512 virtual processors per server so while the math exceeds 512, they hit the maximum of 512 running virtual processors per server.

 

==============================================

 **All Other Guest OSs

**

==============================================

For all other guest operating systems, the maximum supported ratio is 8:1. Here’s the formula and table.

 

(Number of processors) * (Number of cores) * (Number of threads per core) * 8

 

 **Table 2: Virtual Processor to Logical Processor Ratio & Totals (8:1 VP:LP ratio)

**

**Physical Processors

**

| 

**Cores per processor

**

| 

**Threads per core

**

| 

**Max Virtual Processors Supported

**  
  
---|---|---|---  
  
2

| 

2

| 

2

| 

64  
  
2

| 

4

| 

2

| 
