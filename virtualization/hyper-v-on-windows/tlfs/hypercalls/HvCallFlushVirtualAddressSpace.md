---
title: HvCallFlushVirtualAddressSpace
description: HvCallFlushVirtualAddressSpace hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallFlushVirtualAddressSpace

The HvCallFlushVirtualAddressSpace hypercall invalidates all virtual TLB entries that belong to a specified address space.

## Interface

 ```c
HV_STATUS
HvCallFlushVirtualAddressSpace(
    _In_ HV_ADDRESS_SPACE_ID AddressSpace,
    _In_ HV_FLUSH_FLAGS Flags,
    _In_ UINT64 ProcessorMask
    );
 ```

The virtual TLB invalidation operation acts on one or more processors.

If the guest has knowledge about which processors may need to be flushed, it can specify a processor mask. Each bit in the mask corresponds to a virtual processor index. For example, a mask of 0x0000000000000051 indicates that the hypervisor should flush only the TLB of virtual processors 0, 4, and 6. A virtual processor can determine its index by reading the HvRegisterVpIndex synthetic register (via [HvCallGetVpRegisters](HvCallGetVpRegisters.md)) or on x64 from the HV_X64_MSR_VP_INDEX MSR.

The following flags can be used to modify the behavior of the flush:

- HV_FLUSH_ALL_PROCESSORS indicates that the operation should apply to all virtual processors within the partition. If this flag is set, the ProcessorMask parameter is ignored.
- HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES indicates that the operation should apply to all virtual address spaces. If this flag is set, the AddressSpace parameter is ignored.
- HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY indicates that the hypervisor is required only to flush page mappings that were not mapped as "global" (on x64, the "G" bit in the page table entry; on ARM64, the nG bit). Global entries may be (but are not required to be) left unflushed by the hypervisor.

All other flags are reserved and must be set to zero.

This call guarantees that by the time control returns back to the caller, the observable effects of all flushes on the specified virtual processors have occurred.

If a target virtual processor’s TLB requires flushing and that virtual processor’s TLB is currently “locked”, the caller’s virtual processor is suspended. When the caller’s virtual processor is “unsuspended”, the hypercall will be reissued.

## Call Code
`0x0002` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (CR3 on x64, translation table base on ARM64). |
| `Flags`                 | 8          | 8        | Set of flag bits that modify the operation of the flush. |
| `ProcessorMask`         | 16         | 8        | Processor mask indicating which processors should be affected by the flush operation. |
