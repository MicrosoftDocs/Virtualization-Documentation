---
title: HvCallUnmapStatsPage
description: HvCallUnmapStatsPage hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/01/2025
ms.topic: reference

---

# HvCallUnmapStatsPage

`HvCallUnmapStatsPage` unmaps a previously mapped statistics page from the caller's guest physical address space.

## Interface

```c
HV_STATUS
HvCallUnmapStatsPage(
    _In_ HV_STATS_OBJECT_TYPE      StatsType,
    _In_ HV_STATS_OBJECT_IDENTITY  ObjectIdentity
);
```

## Call Code

`0x006D` (Simple)

## Input Parameters

| Name           | Offset | Size | Information Provided |
|----------------|--------|------|----------------------|
| StatsType      | 0      | 4    | Object category to unmap |
| ObjectIdentity | 4      | 16   | Object identity (partition id, VP index, etc) |

## See also

* [HV_STATS_OBJECT_TYPE](../datatypes/hv_stats_object_type.md)
* [HV_STATS_OBJECT_IDENTITY](../datatypes/hv_stats_object_identity.md)
* [HV_STATUS](../datatypes/hv_status.md)
* [HvCallMapStatsPage2](HvCallMapStatsPage2.md)
