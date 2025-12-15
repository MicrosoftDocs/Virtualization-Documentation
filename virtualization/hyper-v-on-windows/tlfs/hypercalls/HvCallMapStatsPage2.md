---
title: HvCallMapStatsPage2
description: HvCallMapStatsPage2 hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallMapStatsPage2

`HvCallMapStatsPage2` maps an statistics page for a specified object, providing access to detailed performance and operational metrics. This hypercall establishes a shared page between the hypervisor and the partition for collecting extended statistical information.

## Interface

```c
HV_STATUS
HvCallMapStatsPage2(
    _In_ HV_STATS_OBJECT_TYPE      StatsType,
    _In_ UINT32                    Reserved,
    _In_ HV_STATS_OBJECT_IDENTITY  ObjectIdentity,
    _In_ HV_GPA_PAGE_NUMBER        MapLocation
);
```

## Call Code

`0x0131` (Simple)

## Input Parameters

| Name           | Offset | Size | Information Provided |
|----------------|--------|------|----------------------|
| StatsType      | 0      | 4    | Object category |
| Reserved       | 4      | 4    | Must be zero |
| ObjectIdentity | 8      | 16   | Object identity (partition id, VP index, etc) |
| MapLocation    | 24     | 8    | Target GPA page |

## See also

* [HV_STATS_OBJECT_TYPE](../datatypes/hv_stats_object_type.md)
* [HV_STATS_OBJECT_IDENTITY](../datatypes/hv_stats_object_identity.md)
* [HV_GPA_PAGE_NUMBER](../datatypes/hv_gpa_page_number.md)
* [HV_STATUS](../datatypes/hv_status.md)
* [HvCallUnmapStatsPage](HvCallUnmapStatsPage.md)
