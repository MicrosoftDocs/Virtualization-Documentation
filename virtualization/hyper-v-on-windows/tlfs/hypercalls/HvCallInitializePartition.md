---
title: HvCallInitializePartition
description: HvCallInitializePartition hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallInitializePartition

HvCallInitializePartition initializes a newly created partition.

## Usage Notes

- Invoke after setting all early partition properties. Early-only properties cannot be changed once initialization completes.

## Interface

```c
HV_STATUS
HvCallInitializePartition(
    _In_ HV_PARTITION_ID PartitionId
    );
```

## Call Code

`0x0041` (Simple)

## Input Parameters

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| PartitionId | 0      | 8    | Partition identifier to initialize. |

## See Also

- [`HV_PARTITION_ID`](../datatypes/hv_partition_id.md)
- [`HvCallCreatePartition`](HvCallCreatePartition.md)
- [`HvCallFinalizePartition`](HvCallFinalizePartition.md)
