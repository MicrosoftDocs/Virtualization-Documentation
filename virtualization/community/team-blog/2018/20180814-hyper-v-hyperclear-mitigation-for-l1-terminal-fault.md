---
title: Hyper-V HyperClear Mitigation for L1 Terminal Fault
description: Learn about the mitigation effort for Hyper-V to address the new execution side channel vulnerability.
keywords: virtualization, virtual server, virtual pc, blog
author: scooley
ms.author: scooley
ms.date: 8/14/2018
ms.topic: article
ms.assetid: 
---

# Hyper-V HyperClear Mitigation for L1 Terminal Fault

## Introduction

A new speculative execution side channel vulnerability was announced recently that affects a range of Intel Core and Intel Xeon processors. This vulnerability, referred to as L1 Terminal Fault (L1TF) and assigned CVE 2018-3646 for hypervisors, can be used for a range of attacks across isolation boundaries, including intra-OS attacks from user-mode to kernel-mode as well as inter-VM attacks. Due to the nature of this vulnerability, creating a robust, inter-VM mitigation that doesn’t significantly degrade performance is particularly challenging.

For Hyper-V, we have developed a comprehensive mitigation to this attack that we call HyperClear. This mitigation is in-use by Microsoft Azure and is available in Windows Server 2016 and later. The HyperClear mitigation continues to allow for safe use of SMT (hyper-threading) with VMs and, based on our observations of deploying this mitigation in Microsoft Azure, HyperClear has shown to have relatively negligible performance impact.

We have already shared the details of HyperClear with industry partners. Since we have received questions as to how we are able to mitigate the L1TF vulnerability without compromising performance, we wanted to broadly share a technical overview of the HyperClear mitigation and how it mitigates L1TF speculative execution side channel attacks across VMs.

## Overview of L1TF Impact to VM Isolation

As documented [here](https://aka.ms/sescsrdl1tf), the fundamental premise of the L1TF vulnerability is that it allows a virtual machine running on a processor core to observe any data in the L1 data cache on that core.

Normally, the Hyper-V hypervisor isolates what data a virtual machine can access by leveraging the memory address translation capabilities provided by the processor. In the case of Intel processors, the Extended Page Tables (EPT) feature of Intel VT-x is used to restrict the system physical memory addresses that a virtual machine can access.

Under normal execution, the hypervisor leverages the EPT feature to restrict what physical memory can be accessed by a VM’s virtual processor while it is running. This also restricts what data the virtual processor can access in the cache, as the physical processor enforces that a virtual processor can only access data in the cache corresponding to system physical addresses made accessible via the virtual processor’s EPT configuration.

By successfully exploiting the L1TF vulnerability, the EPT configuration for a virtual processor can be bypassed during the speculative execution associated with this vulnerability. This means that a virtual processor in a VM can speculatively access anything in the L1 data cache, regardless of the memory protections configured by the processor’s EPT configuration.

Intel’s Hyper-Threading (HT) technology is a form of Simultaneous MultiThreading (SMT). With SMT, a core has multiple SMT threads (also known as logical processors), and these logical processors (LPs) can execute simultaneously on a core. SMT further complicates this vulnerability, as the L1 data cache is shared between sibling SMT threads of the same core. Thus, a virtual processor for a VM running on a SMT thread can speculatively access anything brought into the L1 data cache by its sibling SMT threads. This can make it inherently unsafe to run multiple isolation contexts on the same core. For example, if one logical processor of a SMT core is running a virtual processor from VM A and another logical processor of the core is running a virtual processor from VM B, sensitive data from VM B could be seen by VM A (and vice-versa).

<!--![Virtual processor architecture diagram](https://msdnshared.blob.core.windows.net/media/2018/08/VPdiagram-500x207.png)-->

Similarly, if one logical processor of a SMT core is running a virtual processor for a VM and the other logical processor of the SMT core is running in the hypervisor context, the guest VM could speculatively access sensitive data brought into the cache by the hypervisor.

## Basic Inter-VM Mitigation

To mitigate the L1TF vulnerability in the context of inter-VM isolation, the most straightforward mitigation involves two key components:

1. **Flush L1 Data Cache On Guest VM Entry** – Every time the hypervisor switches a processor thread (logical processor) to execute in the context of a guest virtual processor, the hypervisor can first flush the L1 data cache. This ensures that no sensitive data from the hypervisor or previously running guest virtual processors remains in the cache. To enable the hypervisor to flush the L1 data cache, Intel has released updated microcode that provides an architectural facility for flushing the L1 data cache.
2. **Disable SMT** – Even with flushing the L1 data cache on guest VM entry, there is still the risk that a sibling SMT thread can bring sensitive data into the cache from a different security context. To mitigate this, SMT can be disabled, which ensures that only one thread ever executes on a processor core.

The L1TF mitigation for Hyper-V prior to Windows Server 2016 employs a mitigation based on these components. However, this basic mitigation has the major downside that SMT must be disabled, which can significantly reduce the overall performance of a system. Furthermore, this mitigation can result in a very high rate of L1 data cache flushes since the hypervisor may switch a thread between the guest and hypervisor contexts many thousands of times a second. These frequent cache flushes can also degrade the performance of the system. 

## HyperClear Inter-VM Mitigation

To address the downsides of the basic L1TF Inter-VM mitigation, we developed the HyperClear mitigation. The HyperClear mitigation relies on three key components to ensure strong Inter-VM isolation:

1. Core Scheduler
2. Virtual-Processor Address Space Isolation
3. Sensitive Data Scrubbing

### Core Scheduler

The traditional Hyper-V scheduler operates at the level of individual SMT threads (logical processors). When making scheduling decisions, the Hyper-V scheduler would schedule a virtual processor onto a SMT thread, without regards to what the sibling SMT threads of the same core were doing. Thus, a single physical core could be running virtual processors from different VMs simultaneously.

Starting in Windows Server 2016, Hyper-V introduced a new scheduler implementation for SMT systems known as the "[Core Scheduler](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-scheduler-types)". When the Core Scheduler is enabled, Hyper-V schedules virtual cores onto physical cores. Thus, when a virtual core for a VM is scheduled, it gets exclusive use of a physical core, and a VM will never share a physical core with another VM.

<!--![Core scheduler](https://msdnshared.blob.core.windows.net/media/2018/08/CoreScheduler.png)-->

With the Core Scheduler, a VM can safely take advantage of SMT (Hyper-Threading). When a VM is using SMT, the hypervisor scheduling allows the VM to use all the SMT threads of a core at the same time.

Thus, the Core Scheduler provides the essential protection that a VM’s data won’t be directly disclosed across sibling SMT threads. It protects against cross-thread data exposure of a VM since two different VMs never run simultaneously on different threads of the same core.

However, the Core Scheduler alone is not sufficient to protect against all forms of sensitive data leakage across SMT threads. There is still the risk that hypervisor data could be leaked across sibling SMT threads.

### Virtual-Processor Address Space Isolation

SMT Threads on a core can independently enter and exit the hypervisor context based on their activity. For example, events like interrupts can cause a SMT thread to switch out of running the guest virtual processor context and begin executing the hypervisor context. This can happen independently for each SMT thread, so one SMT thread may be executing in the hypervisor context while its sibling SMT thread is still running a VM’s guest virtual processor context. An attacker running code in the less trusted guest VM virtual processor context on one SMT thread can then use the L1TF side channel vulnerability to potentially observe sensitive data from the hypervisor context running on the sibling SMT thread.

One potential mitigation to this problem is to coordinate hypervisor entry and exit across SMT threads of the same core. While this is effective in mitigating the information disclosure risk, this can significantly degrade performance.

Instead of coordinating hypervisor entry and exits across SMT threads, Hyper-V employs strong data isolation in the hypervisor to protect against a malicious guest VM leveraging the L1TF vulnerability to observe sensitive hypervisor data. The Hyper-V hypervisor achieves this isolation by maintaining separate virtual address spaces in the hypervisor for each guest SMT thread (virtual processor). When the hypervisor context is entered on a specific SMT thread, the only data that is addressable by the hypervisor is data associated with the guest virtual processor associated with that SMT thread. This is enforced through the hypervisor’s page table selectively mapping only the memory associated with the guest virtual processor. No data for any other guest virtual processor is addressable, and thus, the only data that can be brought into the L1 data cache by the hypervisor is data associated with that current guest virtual processor.

<!--![VM isolation](https://msdnshared.blob.core.windows.net/media/2018/08/VPASisolation.png)-->

Thus, regardless of whether a given virtual processor is running in the guest VM virtual processor context or in the hypervisor context, the only data that can be brought into the cache is data associated with the active guest virtual processor. No additional privileged hypervisor secrets or data from other guest virtual processors can be brought into the L1 data cache.

This strong address space isolation provides two distinct benefits:

1. The hypervisor does not need to coordinate entry and exits into the hypervisor across sibling SMT threads. So, SMT threads can enter and exit the hypervisor context independently without any additional performance overhead.
2. The hypervisor does not need to flush the L1 data cache when entering the guest VP context from the hypervisor context. Since the only data that can be brought into the cache while executing in the hypervisor context is data associated with the guest virtual processor, there is no risk of privileged/private state in the cache that needs to be protected from the guest. Thus, with this strong address space isolation, the hypervisor only needs to flush the L1 data cache when switching between virtual cores on a physical core. This is much less frequent than the switches between the hypervisor and guest VP contexts.

### Sensitive Data Scrubbing

There are cases where virtual processor address space isolation is insufficient to ensure isolation of sensitive data. Specifically, in the case of nested virtualization, a single virtual processor may itself run multiple guest virtual processors. Consider the case of a L1 guest VM running a nested hypervisor (L1 hypervisor). In this case, a virtual processor in this L1 guest may be used to run nested virtual processors for L2 VMs being managed by the L1 nested hypervisor.

<!--![Data scrubbing](https://msdnshared.blob.core.windows.net/media/2018/08/DataScrubbing.png)-->

In this case, the nested L1 guest hypervisor will be context switching between each of these nested L2 guests (VM A and VM B) and the nested L1 guest hypervisor. Thus, a virtual processor for the L1 VM being maintained by the L0 hypervisor can run multiple different security domains – a nested L1 hypervisor context and one or more L2 guest virtual machine contexts. Since the L0 hypervisor maintains a single address space for the L1 VM’s virtual processor, this address space could contain data for the nested L1 guest hypervisor and L2 guests VMs.

To ensure a strong isolation boundary between these different security domains, the L0 hypervisor relies on a technique we refer to as state scrubbing when nested virtualization is in-use. With state scrubbing, the L0 hypervisor will avoid caching any sensitive guest state in its data structures. If the L0 hypervisor must read guest data, like register contents, into its private memory to complete an operation, the L0 hypervisor will overwrite this memory with 0’s prior to exiting the L0 hypervisor context. This ensures that any sensitive L1 guest hypervisor or L2 guest virtual processor state is not resident in the cache when switching between security domains in the L1 guest VM.

<!--![Sharing memory state](https://msdnshared.blob.core.windows.net/media/2018/08/SharingMemoryState.png)-->

For example, if the L1 guest hypervisor accesses an I/O port that is emulated by the L0 hypervisor, the L0 hypervisor context will become active.  To properly emulate the I/O port access, the L0 hypervisor will have to read the current guest register contents for the L1 guest hypervisor context, and these register contents will be copied to internal L0 hypervisor memory. When the L0 hypervisor has completed emulation of the I/O port access, the L0 hypervisor will overwrite any L0 hypervisor memory that contains register contents for the L1 guest hypervisor context. After clearing out its internal memory, the L0 hypervisor will resume the L1 guest hypervisor context. This ensures that no sensitive data stays in the L0 hypervisor’s internal memory across invocations of the L0 hypervisor context. Thus, in the above example, there will not be any sensitive L1 guest hypervisor state in the L0 hypervisor’s private memory. This mitigates the risk that sensitive L1 guest hypervisor state will be brought into the data cache the next time the L0 hypervisor context becomes active.

As described above, this state scrubbing model does involve some extra processing when nested virtualization is in-use. To minimize this processing, the L0 hypervisor is very careful in tracking when it needs to scrub its memory, so it can do this with minimal overhead. The overhead of this extra processing is negligible in the nested virtualization scenarios we have measured.

Finally, the L0 hypervisor state scrubbing ensures that the L0 hypervisor can efficiently and safely provide nested virtualization to L1 guest virtual machines. However, to fully mitigate inter-VM attacks between L2 guest virtual machines, the nested L1 guest hypervisor must implement a mitigation for the L1TF vulnerability. This means the L1 guest hypervisor needs to appropriately manage the L1 data cache to ensure isolation of sensitive data across the L2 guest virtual machine security boundaries. The Hyper-V L0 hypervisor exposes the appropriate capabilities to L1 guest hypervisors to allow L1 guest hypervisors to perform L1 data cache flushes.

## Conclusion

By using a combination of core scheduling, address space isolation, and data clearing, Hyper-V HyperClear is able to mitigate the L1TF speculative execution side channel attack across VMs with negligible performance impact and with full support of SMT.
