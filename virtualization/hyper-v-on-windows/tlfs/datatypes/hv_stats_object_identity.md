---
title: HV_STATS_OBJECT_IDENTITY
description: HV_STATS_OBJECT_IDENTITY
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_STATS_OBJECT_IDENTITY

Identifies a specific object for statistics collection.

## Syntax

```c
typedef union
{
    struct
    {
        UINT64  ReservedZ0;
        UINT32  ReservedZ1;
        UINT16  ReservedZ2;
        UINT8   ReservedZ3;
        UINT8   StatsAreaType;
    } Hypervisor;

    struct
    {
        HV_PARTITION_ID         PartitionId;
        UINT32                  ReservedZ1;
        UINT16                  ReservedZ2;
        UINT8                   ReservedZ3;
        UINT8                   StatsAreaType;
    } Partition;

    struct
    {
        HV_PARTITION_ID         PartitionId;
        HV_VP_INDEX             VpIndex;
        UINT16                  ReservedZ2;
        UINT8                   ReservedZ3;
        UINT8                   StatsAreaType;
    } Vp;

} HV_STATS_OBJECT_IDENTITY;
```

## Fields

The structure used depends on the `HV_STATS_OBJECT_TYPE`:

### Hypervisor

| Field | Description |
|-------|-------------|
| `ReservedZ0-ReservedZ3` | Reserved fields, must be zero |
| `StatsAreaType` | Type of statistics area |

### Partition

| Field | Description |
|-------|-------------|
| `PartitionId` | ID of the partition |
| `ReservedZ1-ReservedZ3` | Reserved fields, must be zero |
| `StatsAreaType` | HvStatsObjectPartition  |

### Vp

| Field | Description |
|-------|-------------|
| `PartitionId` | ID of the partition containing the VP |
| `VpIndex` | Index of the virtual processor |
| `ReservedZ2-ReservedZ3` | Reserved fields, must be zero |
| `StatsAreaType` | HvStatsObjectVp |

## See also

* [HV_STATS_OBJECT_TYPE](hv_stats_object_type.md)
* [HV_PARTITION_ID](hv_partition_id.md)
* [HV_VP_INDEX](hv_vp_index.md)
