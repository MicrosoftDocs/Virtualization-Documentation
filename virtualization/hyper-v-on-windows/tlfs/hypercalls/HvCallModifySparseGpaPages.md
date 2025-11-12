---
title: HvCallModifySparseGpaPages
description: HvCallModifySparseGpaPages hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallModifySparseGpaPages

The HvCallModifySparseGpaPages hypercall updates access / caching attributes for already-mapped (sparse) GPA pages.

## Interface

```c
HV_STATUS
HvCallModifySparseGpaPages(
    _In_ HV_PARTITION_ID        TargetPartitionId,
    _In_ HV_MAP_GPA_FLAGS       MapFlags,
    _In_ UINT32                 Rsvdz,
    _In_ const HV_GPA_PAGE_NUMBER GpaPageList[] // Reads RepCount elements
);
```

## Call Code

`0x0090` (Rep)

## Input Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TargetPartitionId | 0      | 8    | Target partition |
| MapFlags          | 8      | 4    | New attribute flags (subset mutable) |
| Rsvdz             | 12     | 4    | Must be zero |

## Input List Element

| Name          | Offset | Size | Information Provided |
|---------------|--------|------|----------------------|
| GpaPageNumber | 0      | 8    | GPA page to re-attribute |

## See also

[HV_PARTITION_ID](../datatypes/hv_partition_id.md)
[HV_MAP_GPA_FLAGS](../datatypes/hv_map_gpa_flags.md)
[HV_GPA_PAGE_NUMBER](../datatypes/hv_gpa_page_number.md)
