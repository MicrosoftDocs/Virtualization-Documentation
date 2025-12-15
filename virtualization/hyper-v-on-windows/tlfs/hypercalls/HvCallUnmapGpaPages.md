---
title: HvCallUnmapGpaPages
description: HvCallUnmapGpaPages hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HvCallUnmapGpaPages

The HvCallUnmapGpaPages hypercall unmaps a contiguous run of GPA pages from a target partition, releasing backing pages / references. 

## Interface

```c
HV_STATUS
HvCallUnmapGpaPages(
    _In_ HV_PARTITION_ID      TargetPartitionId,
    _In_ HV_GPA_PAGE_NUMBER   TargetGpaBase,
    _In_ HV_UNMAP_GPA_FLAGS   UnmapFlags
);
```

## Call Code

`0x004C` (Rep)

## Input Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TargetPartitionId | 0      | 8    | Target partition |
| TargetGpaBase     | 8      | 8    | First GPA page to unmap (up to RepCount) |
| UnmapFlags        | 16     | 4    | [HV_UNMAP_GPA_FLAGS](../datatypes/hv_unmap_gpa_flags.md) controlling precommit retention and large page handling |

## See Also

- [HV_UNMAP_GPA_FLAGS](../datatypes/hv_unmap_gpa_flags.md)
- [HvCallMapGpaPages](HvCallMapGpaPages.md)
