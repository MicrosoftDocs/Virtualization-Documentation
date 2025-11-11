---
title: HvCallMapSparseGpaPages
description: HvCallMapSparseGpaPages hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallMapSparseGpaPages

`HvCallMapSparseGpaPages` maps non-contiguous guest physical pages using an array of mapping descriptors.

## Interface

```c
HV_STATUS
HvCallMapSparseGpaPages(
    _In_ HV_PARTITION_ID      TargetPartitionId,
    _In_ HV_MAP_GPA_FLAGS     MapFlags,
    _In_ const HV_GPA_MAPPING PageList[] // Reads RepCount elements
);
```

## Call Code

`0x006E` (Rep)

## Input Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TargetPartitionId | 0      | 8    | Target partition |
| MapFlags          | 8      | 8    | Shared attributes applied to each mapping unless per-entry overrides exist (implementation-defined) |
| PageList          | 16     | var  | Array of mapping tuples. |

## See Also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_MAP_GPA_FLAGS](../datatypes/hv_map_gpa_flags.md)
* [HV_GPA_MAPPING](../datatypes/hv_gpa_mapping.md)
* [HV_STATUS](../datatypes/hv_status.md)
* [HvCallMapGpaPages](HvCallMapGpaPages.md)
* [HvCallUnmapGpaPages](HvCallUnmapGpaPages.md)
