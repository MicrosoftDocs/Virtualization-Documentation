---
title: HvCallFlushVirtualAddressSpaceEx
description: HvCallFlushVirtualAddressSpaceEx hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallFlushVirtualAddressSpaceEx

The HvCallFlushVirtualAddressSpaceEx hypercall is similar to [HvCallFlushVirtualAddressSpace](HvCallFlushVirtualAddressSpace.md), but can take a variably-sized sparse VP set as an input.

The following checks should be used to infer the availability of this hypercall:

- UseExProcessorMasks must be indicated (on x64 via CPUID leaf 0x40000004, on ARM64 via HvRegisterFeaturesInfo).

## Interface

 ```c
HV_STATUS
HvCallFlushVirtualAddressSpaceEx(
    _In_ HV_ADDRESS_SPACE_ID AddressSpace,
    _In_ HV_FLUSH_FLAGS Flags,
    _In_ HV_VP_SET ProcessorSet
    );
 ```

## Call Code

`0x0013` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (CR3 on x64, translation table base on ARM64). |
| `Flags`                 | 8          | 8        | Set of flag bits that modify the operation of the flush. |
| `ProcessorSet`          | 16         | Variable | Processor set indicating which processors should be affected by the flush operation. |

## See also

[HV_VP_SET](../datatypes/HV_VP_SET.md)
