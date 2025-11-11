---
title: HvCallFlushVirtualAddressListEx
description: HvCallFlushVirtualAddressListEx hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallFlushVirtualAddressListEx

The HvCallFlushVirtualAddressListEx hypercall is similar to [HvCallFlushVirtualAddressList](HvCallFlushVirtualAddressList.md), but can take a variably-sized sparse VP set as an input.
The following checks should be used to infer the availability of this hypercall:

- ExProcessorMasks must be indicated via CPUID leaf 0x40000004.

## Interface

 ```c
HV_STATUS
HvCallFlushVirtualAddressListEx(
    _In_ HV_ADDRESS_SPACE_ID AddressSpace,
    _In_ HV_FLUSH_FLAGS Flags,
    _In_ HV_VP_SET ProcessorSet,
    _Inout_ UINT32* GvaCount,
    _In_reads_(*GvaCount) const HV_GVA* GvaRangeList
    );
 ```

## Call Code
`0x0014` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (a CR3 value). |
| `Flags`                 | 8          | 8        | Set of flag bits that modify the operation of the flush. |
| `ProcessorSet`          | 16         | Variable | Processor set indicating which processors should be affected by the flush operation. |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `GvaRange`              | 0          | 8        | GVA range                                 |

## See also

[HV_VP_SET](../datatypes/hv_vp_set.md)
