---
title:      "Virtualization Review's hypervisor test"
description: "A comparative performance test of three hypervisors: VMware ESX 3.5, Windows Server 2008 Hyper-V and Citrix XenServer."
author: scooley
ms.author: scooley
date:       2009-03-09 16:09:00
ms.date: 03/09/2009
categories: citrix
---
# Virtualization Review's hypervisor test

The other day, Virtualization Review published a comparative performance test of three hypervisors: VMware ESX 3.5, Windows Server 2008 Hyper-V and Citrix XenServer. You can see it [here](https://virtualizationreview.com/ "Virt Review test"). **NOTE** \- there are few independent, published performance reviews of hypervisors because including ESX in the review without VMware's permission violates the VMware EULA about posting benchmarks. VMark doesn't count as independent. Amongst reviewers, this EULA restriction is well-known and am told  serves as a deterrent to try to do performance comparatives. Rick Vanover and his editor, Keith Ward, deserve kudos for [securing VMware approval](https://virtualizationreview.com "Keith Ward's editorial") for the performance comparison without jeopardizing journalistic integrity. Way to go! 

OK, back to Rick Vanover's test. His test objectives:

> All the hypervisors offer essentially the same base functionality. In this series of tests, the objective was to put the same workloads on each one and see how they stack up. The types of workloads tested varied, to simulate a typical environment in which some virtual machines (VMs) are stressed, and some aren't. Each platform was subjected to the same test plan parameters, to give a fair accounting of their performance.

[Read](https://virtualizationreview.com/ "Virt Review website") about the comparison parameters, test environment and caveats. The results will be surprising (in a "man bites dog" sort of way) to many. Keith wrote:

> The results, from writer/online columnist Rick Vanover, were startling, to say the least. The Porsche of hypervisors? XenServer. Raise your hand if you saw that coming. It outperformed Hyper-V and ESX in most categories. The pokiest? ESX. Again, not at all what I expected. In fact, even in the few tests ESX came out on top, it barely edged out the competition. Microsoft did well across the board, and is definitely a fine product.

We're pleased to see Hyper-V won 4 of the 11 tests (the others going to XenServer by a less than a horse length). For example, test 2 focused on a large number of heavy workload systems: 1 database server running one midsize database and 12 VMs with a heavy workload of CPU, memory and disk operations. Key takeaways from this test:

·         Hyper-V completed SQLjob 52% faster than ESX.

·         Hyper-V is 2.3 times faster than VMware ESX in CPU oVirtualization Review's hypervisor testperations.

·         Hyper-V is 3 times faster than VMware ESX in test for average RAM operations.

 

At the end of the article, Rick ran one set of tests with 3 GB overcommit for ESX 3.5. Rick pointed out that this feature is useful to many in the data center, it does come at the expense of performance. The test showed that with ESX overcommit enabled:

·         Average CPU Operations per VM were 3x slower

·         Average Disk Operations per VM with 4.5x slower

·         Average SQLjob Completion Time was 33% slower

 

As Rick wrote:

Results showed that while you can load more guests onto the host, there's no free lunch. There was a dip in performance and database response time.

 

Patrick
