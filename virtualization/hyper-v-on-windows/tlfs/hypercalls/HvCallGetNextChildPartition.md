---
title: HvCallGetNextChildPartition
description: HvCallGetNextChildPartition hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallGetNextChildPartition

HvCallGetNextChildPartition enumerates child partitions of the calling partition. This hypercall allows a parent partition to discover and iterate through all of its child partitions.

## Interface

 ```c
HV_STATUS
HvCallGetNextChildPartition(
    _In_  HV_PARTITION_ID  ParentPartitionId,
    _In_  HV_PARTITION_ID  PreviousChildPartitionId,
    _Out_ HV_PARTITION_ID* NextChildPartitionId
);
 ```

## Call Code

`0x0047` (Simple)

## Notes

- Specify `HV_PARTITION_ID_INVALID` for `PreviousChildPartitionId` to start the enumeration. 
- Set `PreviousChildPartitionId` = `NextChildPartitionId` to get the next partition.
- The hypercall returns `HV_PARTITION_ID_INVALID` when there are no more partitions to enumerate.

## Input Parameters

| Name | Offset | Size | Information Provided |
|------|--------|------|----------------------|
| ParentPartitionId | 0 | 8 | Parent (or SELF) |
| PreviousChildPartitionId | 8 | 8 | Last returned child or HV_PARTITION_ID_INVALID |

## Output Parameters

| Name | Offset | Size | Information Provided |
|------|--------|------|----------------------|
| NextChildPartitionId | 0 | 8 | Next child or HV_PARTITION_ID_INVALID if end |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HvCallCreatePartition](HvCallCreatePartition.md)
* [HvCallDeletePartition](HvCallDeletePartition.md)
