---
title: HvCallSignalEventDirect
description: HvCallSignalEventDirect hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 11/03/2025
ms.topic: reference

---

# HvCallSignalEventDirect

The HvCallSignalEventDirect hypercall signals an event directly to a specified virtual processor in a target partition.

The event is signaled by setting the target flag within the [SIEF page](../inter-partition-communication.md) of the specified virtual processor and VTL, and asserting the target SINT. The hypercall returns whether the event was newly signaled or was already set.

## Interface

 ```c
HV_STATUS
HvCallSignalEventDirect(
    _In_ HV_PARTITION_ID TargetPartition,
    _In_ HV_VP_INDEX TargetVp,
    _In_ HV_VTL TargetVtl,
    _In_ UINT8 TargetSint,
    _In_ UINT16 FlagNumber,
    _Out_ BOOLEAN* NewlySignaled
    );
 ```

## Call Code

`0x00C0` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `TargetPartition`       | 0          | 8        | Specifies the partition ID of the target partition. |
| `TargetVp`              | 8          | 4        | Specifies the target virtual processor index. |
| `TargetVtl`             | 12         | 1        | Specifies the target Virtual Trust Level (VTL). |
| `TargetSint`            | 13         | 1        | Specifies the target synthetic interrupt source (SINT) index. |
| `FlagNumber`            | 14         | 2        | Specifies the event flag number to set within the target SIEF area. |

## Output Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `NewlySignaled`         | 0          | 1        | Indicates whether the event was newly signaled (TRUE) or was already set (FALSE). |

## See Also

[HvCallSignalEvent](HvCallSignalEvent.md)
[HvCallPostMessageDirect](HvCallPostMessageDirect.md)