---
title: HvCallMapGpaPages
description: HvCallMapGpaPages hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallMapGpaPages

`HvCallMapGpaPages` maps a list of physical pages owned by the caller to the target child partition's address space.

## Interface

```c
HV_STATUS
HvCallMapGpaPages(
    _In_ HV_PARTITION_ID      TargetPartitionId,
    _In_ HV_GPA_PAGE_NUMBER   TargetGpaBase,
    _In_ HV_MAP_GPA_FLAGS     MapFlags,
    _In_ const HV_GPA_PAGE_NUMBER SourceGpaPageList[] // Reads RepCount elements
);
```

## Call Code

`0x004B` (Rep)

## Input Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TargetPartitionId | 0      | 8    | Target partition |
| TargetGpaBase     | 8      | 8    | Starting GPA page (increments per repetition) |
| MapFlags          | 16     | 8    | Access / caching / semantics flags |
| SourceGpaPageList | 24     | var  | Array of source GPA pages (one per repetition) |

## See Also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_GPA_PAGE_NUMBER](../datatypes/hv_gpa_page_number.md)
* [HV_MAP_GPA_FLAGS](../datatypes/hv_map_gpa_flags.md)
* [HV_STATUS](../datatypes/hv_status.md)
* [HvCallUnmapGpaPages](HvCallUnmapGpaPages.md)
* [HvCallMapSparseGpaPages](HvCallMapSparseGpaPages.md)
