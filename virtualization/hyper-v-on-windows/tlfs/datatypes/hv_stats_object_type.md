---
title: HV_STATS_OBJECT_TYPE
description: HV_STATS_OBJECT_TYPE
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_STATS_OBJECT_TYPE

Defines the types of objects for which statistics can be collected.

## Syntax

```c
typedef enum _HV_STATS_OBJECT_TYPE
{
    HvStatsObjectPartition        = 0x00010001,
    HvStatsObjectVp               = 0x00010002
} HV_STATS_OBJECT_TYPE;
```

## Constants

| Name | Value | Description |
|------|-------|-------------|
| `HvStatsObjectPartition` | 0x00010001 | Partition-specific statistics |
| `HvStatsObjectVp` | 0x00010002 | Virtual processor statistics |

## Remarks

This enumeration defines the different types of objects for which the hypervisor can collect and report statistics. Access to each statistics object type is privilege-scoped:

| Object Type | Allowed Callers | 
|-------------|-----------------|
| Partition (`HvStatsObjectPartition`) | Parent for its children; partition itself for self |
| Vp (`HvStatsObjectVp`) | Parent for its children; partition itself for self |

Each object type requires different identification parameters in the corresponding `HV_STATS_OBJECT_IDENTITY` structure.

## See also

* [HV_STATS_OBJECT_IDENTITY](hv_stats_object_identity.md)

