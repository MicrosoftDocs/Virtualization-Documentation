---
title: HvCallAssertVirtualInterrupt
description: HvCallAssertVirtualInterrupt hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallAssertVirtualInterrupt

HvCallAssertVirtualInterrupt asserts a virtual interrupt to another partition.

## Interface

 ```c
HV_STATUS
HvCallAssertVirtualInterrupt(
    _In_ HV_PARTITION_ID         TargetPartition,
    _In_ HV_INTERRUPT_CONTROL    InterruptControl,
    _In_ UINT64                  DestinationAddress,
    _In_ HV_INTERRUPT_VECTOR     RequestedVector,
    _In_ HV_VTL                  TargetVtl,
    _In_ UINT8                   ReservedZ0,
    _In_ UINT16                  ReservedZ1
    );
 ```

## Call Code

`0x0094` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `TargetPartition`       | 0          | 8        | Specifies the ID of the target partition. |
| `InterruptControl`      | 8          | 8        | Specifies control flags for the interrupt. |
| `DestinationAddress`    | 16         | 8        | Specifies the destination address for the interrupt. |
| `RequestedVector`       | 24         | 4        | Specifies the requested interrupt vector. |
| `TargetVtl`             | 28         | 1        | Specifies the target VTL.                 |
| `ReservedZ0`            | 29         | 1        | Reserved. Must be zero.                   |
| `ReservedZ1`            | 30         | 2        | Reserved. Must be zero.                   |

## See also

[HV_INTERRUPT_CONTROL](../datatypes/hv_interrupt_control.md)
[HV_INTERRUPT_TYPE](../datatypes/hv_interrupt_type.md)
[HV_INTERRUPT_VECTOR](../datatypes/hv_interrupt_vector.md)