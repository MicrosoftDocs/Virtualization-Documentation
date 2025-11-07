---
title: Virtualization Host
description: Virtualization Host
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# Virtualization Host

Virtualization Host capability refers to a partition's ability to create and manage child partitions when it has the CreatePartitions partition privilege (['HV_PARTITION_PRIVILEGE_MASK'](datatypes/hv_partition_privilege_mask.md)). 

This capability provides comprehensive partition lifecycle management, memory pool management, address space control, and inter-partition communication. A virtualization host maintains parent-child relationships with managed partitions and coordinates their execution, resource allocation, and communication.

## Windows compatibility

The hypercall interfaces are intended to be used when running non-Windows operating systems.

Windows applications MUST use the [Windows Hypervisor Platform](https://learn.microsoft.com/en-us/virtualization/api/hypervisor-platform/hypervisor-platform) APIs to implement a Virtualization Host. This guarantees full compatibility with other Windows features, such as Virtualization Based Security.

## Terminology

The following terminology is used to define virtualization host relationships:

| Term                   | Definition                                                              |
|------------------------|-------------------------------------------------------------------------|
| **Virtualization Host**| A partition with CreatePartitions privilege that manages child partitions. |
| **Parent Partition**   | A partition that has created and manages one or more child partitions.   |
| **Child Partition**    | A partition created and managed by another partition (its parent).      |
| **Root Partition**     | The partition that manages the bare-metal host. |
| **Virtual Processor (VP)** | Execution context within a partition that runs guest code.          |
| **Guest Physical Address (GPA)** | Physical memory address as seen by guest software.        |

## Partition Lifecycle Management

Partition lifecycle management encompasses the creation, configuration, execution, and cleanup of child partitions. The lifecycle follows a strict state model with defined transitions between states.

### Partition States

Child partitions progress through the following states:

| State          | Description                                           | Allowed Operations                    |
|----------------|-------------------------------------------------------|---------------------------------------|
| **Created**    | Partition exists but cannot execute code            | Configure properties, deposit memory  |
| **Initialized**| Configuration validated, ready for VP creation      | Create VPs, adjust properties*        |
| **Active**     | Ready for execution, configuration locked           | Execute guest code, runtime management |
| **Finalized**  | Resources cleaned up, prepared for deletion         | Withdraw memory, Delete partition      |
| **Deleted**    | Partition no longer exists                          | |

## Typical Usage Patterns

### Basic Partition Creation

The most common pattern for creating a child partition follows this sequence:

1. Call [`HvCallCreatePartition`](hypercalls/HvCallCreatePartition.md) to establish the partition
2. Call [`HvCallSetPartitionProperty`](hypercalls/HvCallSetPartitionProperty.md) to configure partition properties as needed for the guest workload
3. Call [`HvCallInitializePartition`](hypercalls/HvCallInitializePartition.md) to validate configuration and transition to active state
4. Call [`HvCallCreateVp`](hypercalls/HvCallCreateVp.md) for each required virtual processor
5. Configure initial VP state (registers, memory mappings, etc.)
7. Start VP0 by clearing the HvRegisterExplicitSuspend VP register. The guest handles starting the rest of the VPs.

### Partition Cleanup

When shutting down a child partition:

1. Stop all virtual processor execution
2. Call [`HvCallFinalizePartition`](hypercalls/HvCallFinalizePartition.md) to clean up VPs, ports, connections, and resources
3. Withdraw remaining partition memory
4. Call [`HvCallDeletePartition`](hypercalls/HvCallDeletePartition.md) to destroy the partition

## Memory Pool Management

Virtualization Hosts are expected to provide the hypervisor with sufficient memory to allow it to allocate its internal tracking structures on behalf of any given partition. The hypervisor maintains separate memory pools for each partition and the virtualization host provides memory to the hypervisor using the Deposit interfaces.

### Memory Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallDepositMemory`](hypercalls/HvCallDepositMemory.md) | Deposit memory for the target partition |
| [`HvCallWithdrawMemory`](hypercalls/HvCallWithdrawMemory.md) | Reclaim memory pages from child partition |
| [`HvCallGetMemoryBalance`](hypercalls/HvCallGetMemoryBalance.md) | Query current memory allocation and usage statistics |

When a page is deposited, the Virtualization Host loses access to it.

### Memory Management Patterns

#### Initial Memory Allocation

When creating a child partition:

1. Create and initialize the partition
2. Call [`HvCallDepositMemory`](hypercalls/HvCallDepositMemory.md) to provide initial memory allocation
3. Create virtual processors (which may require additional memory)
4. Finalize the partition

## Partition and VP Configuration

Partition and virtual processor configuration provides control over capabilities, features, isolation settings, and execution environments. Configuration properties must be set during specific partition states.

### Partition Properties

| Hypercall | Description |
|-----------|-------------|
| [`HvCallSetPartitionProperty`](hypercalls/HvCallSetPartitionProperty.md) | Configure partition capabilities, features, and behavior (small fixed-size values) |
| [`HvCallSetPartitionPropertyEx`](hypercalls/HvCallSetPartitionPropertyEx.md) | Extended variant for larger variable-size property values |
| [`HvCallGetPartitionProperty`](hypercalls/HvCallGetPartitionProperty.md) | Query current partition property values |

#### Usage Notes

- Early partition properties must be set before [`HvCallInitializePartition`](hypercalls/HvCallInitializePartition.md). See [HV_PARTITION_PROPERTY_CODE](datatypes/hv_partition_property_code.md) for more details.

### Virtual Processor State Management

| Hypercall | Description |
|-----------|-------------|
| [`HvCallGetVpRegisters`](hypercalls/HvCallGetVpRegisters.md) | Rep interface to read architectural register sets (batched) |
| [`HvCallSetVpRegisters`](hypercalls/HvCallSetVpRegisters.md) | Rep interface to write architectural register sets (batched) |
| [`HvCallGetVpCpuidValues`](hypercalls/HvCallGetVpCpuidValues.md) | Query CPUID values exposed to a VP |

## Address Space Management

Address space operations support both contiguous and sparse mapping patterns, enabling efficient memory layout for various guest configurations.

### Memory Mapping Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallMapGpaPages`](hypercalls/HvCallMapGpaPages.md) | Map contiguous GPA ranges to physical addresses |
| [`HvCallMapSparseGpaPages`](hypercalls/HvCallMapSparseGpaPages.md) | Map non-contiguous GPA pages with individual control |
| [`HvCallUnmapGpaPages`](hypercalls/HvCallUnmapGpaPages.md) | Remove GPA mappings and release resources |
| [`HvCallModifySparseGpaPages`](hypercalls/HvCallModifySparseGpaPages.md) | Modify existing sparse GPA page mappings |

### Memory Access Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallTranslateVirtualAddress`](hypercalls/HvCallTranslateVirtualAddress.md) | Translate guest virtual addresses to physical addresses |
| [`HvCallTranslateVirtualAddressEx`](hypercalls/HvCallTranslateVirtualAddressEx.md) | Extended guest address translation with additional control |

## Interception and Monitoring

Interception capabilities enable parent partitions to monitor and control child partition access to various system resources including MSRs, IO ports, and CPUID instructions.

| Hypercall | Description |
|-----------|-------------|
| [`HvCallInstallIntercept`](hypercalls/HvCallInstallIntercept.md) | Install intercepts for child partition resource access |
| [`HvCallInstallInterceptEx`](hypercalls/HvCallInstallInterceptEx.md) | Extended intercept installation |
| [`HvCallCheckForIoIntercept`](hypercalls/HvCallCheckForIoIntercept.md) | Check if IO port access should be intercepted |
| [`HvCallRegisterInterceptResult`](hypercalls/HvCallRegisterInterceptResult.md) | Register result handlers for specific intercept types |
| [`HvCallUnregisterInterceptResult`](hypercalls/HvCallUnregisterInterceptResult.md) | Remove previously registered intercept result handlers |

## Capability & Privilege Discovery

- System-wide optional features (e.g., supported intercept classes) are enumerated via architecturally defined CPUID leaves and other documented discovery mechanisms.
- Per-partition privileges (CreatePartitions, AccessVpRegisters, StartVirtualProcessor, etc.) are reflected in the privilege mask property.
- A virtualization host should degrade gracefully when optional capabilities are absent.

### Usage Notes

- Cache static capability indicators for the boot lifetime; avoid re-querying in hot paths.

## Cache and TLB Management

Cache and TLB invalidation operations provide control over processor caching behavior for virtual machines.

| Hypercall | Description |
|-----------|-------------|
| [`HvCallFlushVirtualAddressSpace`](hypercalls/HvCallFlushVirtualAddressSpace.md) | Invalidate virtual address mappings in guest TLBs |
| [`HvCallFlushVirtualAddressList`](hypercalls/HvCallFlushVirtualAddressList.md) | Invalidate specific virtual address ranges in guest TLBs |

## Statistics and Monitoring

Statistics and monitoring provide visibility into partition and virtual processor performance, resource utilization, and operational metrics.

### Statistics Collection

| Hypercall | Description |
|-----------|-------------|
| [`HvCallMapStatsPage2`](hypercalls/HvCallMapStatsPage2.md) | Map partition statistics page for performance monitoring |
| [`HvCallMapVpStatePage`](hypercalls/HvCallMapVpStatePage.md) | Map virtual processor statistics page for detailed metrics |
| [`HvCallUnmapVpStatePage`](hypercalls/HvCallUnmapVpStatePage.md) | Remove VP statistics page mappings |

Statistics pages provide real-time metrics including execution time, interrupt counts, hypercall statistics, and resource utilization data.

## Partition Enumeration

| Hypercall | Description |
|-----------|-------------|
| [`HvCallGetNextChildPartition`](hypercalls/HvCallGetNextChildPartition.md) | Enumerate child partitions managed by this virtualization host |

## Virtual Interrupt Management

Virtual interrupt management enables control and coordination of interrupt delivery between partitions.

### Interrupt Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallAssertVirtualInterrupt`](hypercalls/HvCallAssertVirtualInterrupt.md) | Deliver virtual interrupts from parent to child partitions |

### Virtual Interrupt Resource Management (ARM64)

| Hypercall | Description |
|-----------|-------------|
| [`HvCallSetVirtualInterruptTarget`](hypercalls/HvCallSetVirtualInterruptTarget.md) | Configure target VP for virtual interrupt routing |

## Port Management and Inter-Partition Communication

Port management provides the foundation for structured communication between partitions. 

### Port Lifecycle Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallCreatePort`](hypercalls/HvCallCreatePort.md) | Create communication ports for inter-partition communication |
| [`HvCallDeletePort`](hypercalls/HvCallDeletePort.md) | Remove ports and release associated resources |

### Connection Management

| Hypercall | Description |
|-----------|-------------|
| [`HvCallConnectPort`](hypercalls/HvCallConnectPort.md) | Establish active communication channels between partitions |
| [`HvCallDisconnectPort`](hypercalls/HvCallDisconnectPort.md) | Terminate connections while preserving port infrastructure |

### Direct Communication Operations

| Hypercall | Description |
|-----------|-------------|
| [`HvCallPostMessageDirect`](hypercalls/HvCallPostMessageDirect.md) | Post messages directly to VP message queues |

