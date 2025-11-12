---
title: HvCallFinalizePartition
description: HvCallFinalizePartition hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallFinalizePartition

HvCallFinalizePartition prepares the partition for deletion, deleting any remaining VPs, ports and connections. After the finalize step, no additional activit for the partition is permitted other than deletion (including deposits).

## Interface

```c
HV_STATUS
HvCallFinalizePartition(
    _In_ HV_PARTITION_ID PartitionId
);
```

## Call Code

`0x0042` (Simple)

## Input Parameters

| Name          | Offset | Size | Information Provided |
|---------------|--------|------|----------------------|
| PartitionId   | 0      | 8    | Identifier of the partition to finalize. |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HvCallCreatePartition](HvCallCreatePartition.md)
- [HvCallInitializePartition](HvCallInitializePartition.md)
