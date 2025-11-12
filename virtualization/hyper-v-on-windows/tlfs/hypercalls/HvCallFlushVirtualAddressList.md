---
title: HvCallFlushVirtualAddressList
description: HvCallFlushVirtualAddressList hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HvCallFlushVirtualAddressList

The HvCallFlushVirtualAddressList hypercall invalidates portions of the virtual TLB that belong to a specified address space.

## Interface

 ```c
HV_STATUS
HvCallFlushVirtualAddressList(
    _In_ HV_ADDRESS_SPACE_ID AddressSpace,
    _In_ HV_FLUSH_FLAGS Flags,
    _In_ UINT64 ProcessorMask,
    _Inout_ UINT32* GvaCount,
    _In_reads_(*GvaCount) const HV_GVA* GvaRangeList
    );
 ```

The virtual TLB invalidation operation acts on one or more processors.

If the guest has knowledge about which processors may need to be flushed, it can specify a processor mask. Each bit in the mask corresponds to a virtual processor index. For example, a mask of 0x0000000000000051 indicates that the hypervisor should flush only the TLB of virtual processors 0, 4 and 6.

The following flags can be used to modify the behavior of the flush:

- HV_FLUSH_ALL_PROCESSORS indicates that the operation should apply to all virtual processors within the partition. If this flag is set, the ProcessorMask parameter is ignored.
- HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES indicates that the operation should apply to all virtual address spaces. If this flag is set, the AddressSpace parameter is ignored.
- HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY does not make sense for this call and is treated as an invalid option.

All other flags are reserved and must be set to zero.

This call takes a list of GVA ranges. Each range has a base GVA. Because flushes are performed with page granularity, the bottom 12 bits of the GVA can be used to define a range length. These bits encode the number of additional pages (beyond the initial page) within the range. This allows each entry to encode a range of 1 to 4096 pages.

A GVA that falls within a “large page” mapping (2MB or 4MB) will cause the entire large page to be flushed from the virtual TLB.

This call guarantees that by the time control returns back to the caller, the observable effects of all flushes on the specified virtual processors have occurred.

Invalid GVAs (those that specify addresses beyond the end of the partition’s GVA space) are ignored.

If a target virtual processor’s TLB requires flushing and that virtual processor is inhibiting TLB flushes, the caller’s virtual processor is suspended. When TLB flushes are no longer inhibited, the virtual processor is “unsuspended” and the hypercall will be reissued.

## Call Code
`0x0003` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (a CR3 value). |
| `Flags`                 | 8          | 8        | Set of flag bits that modify the operation of the flush. |
| `ProcessorMask`         | 16         | 8        | Processor mask indicating which processors should be affected by the flush operation. |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `GvaRange`              | 0          | 8        | GVA range                                 |
