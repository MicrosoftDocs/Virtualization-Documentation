---
title: HvCallSetVirtualInterruptTarget
description: HvCallSetVirtualInterruptTarget hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallSetVirtualInterruptTarget

Sets the target VP for a virtual interrupt.

## Interface

 ```c
HV_STATUS
HvCallSetVirtualInterruptTarget(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_INTERRUPT_VECTOR InterruptId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_VTL Vtl
    );
 ```

## Call Code

`0x011F` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| PartitionId             | 0          | 8        | Specifies the partition ID               |
| InterruptId             | 8          | 4        | Specifies the virtual interrupt vector    |
| VpIndex                 | 12         | 4        | Specifies the target VP index            |
| Vtl                     | 16         | 1        | Specifies the target VTL                 |

## See Also

[HV_INTERRUPT_VECTOR](../datatypes/hv_interrupt_vector.md)
