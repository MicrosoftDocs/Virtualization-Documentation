---
title: HvCallDeleteVp
description: HvCallDeleteVp hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallDeleteVp

HvCallDeleteVp removes a virtual processor from a partition.

## Interface

 ```c
HV_STATUS
HvCallDeleteVp(
    _In_ HV_PARTITION_ID         PartitionId,
    _In_ HV_VP_INDEX             VpIndex
    );
 ```

## Call Code

`0x004f` (Simple)

## Input Parameters

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| PartitionId | 0      | 8    | Partition containing the VP. |
| VpIndex     | 8      | 4    | Index of VP to delete. |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HV_VP_INDEX](../datatypes/hv_vp_index.md)
- [HvCallCreateVp](HvCallCreateVp.md)
