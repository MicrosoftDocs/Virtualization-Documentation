---
title: HvCallDeletePartition
description: HvCallDeletePartition hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallDeletePartition

HvCallDeletePartition removes a child partition from the hypervisor.

## Interface

 ```c
HV_STATUS
HvCallDeletePartition(
    _In_ HV_PARTITION_ID         PartitionId
    );
 ```

## Call Code

`0x0043` (Simple)

## Input Parameters

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| PartitionId | 0      | 8    | Child partition identifier to delete (must not be `HV_PARTITION_ID_SELF`). |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HvCallCreatePartition](HvCallCreatePartition.md)
