---
title: HV_GPA_MAPPING
description: HV_GPA_MAPPING data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_GPA_MAPPING

## Overview
Descriptor used by sparse GPA mapping hypercalls to associate a target GPA page with a source backing GPA page (in caller's partition) in a single repetition element.

## Syntax
```c
typedef struct {
    HV_GPA_PAGE_NUMBER TargetGpaPageNumber; // GPA in target partition (unmapped prior)
    HV_GPA_PAGE_NUMBER SourceGpaPageNumber; // GPA (backing) in caller / providing partition
} HV_GPA_MAPPING;
```

## Member Details
- `TargetGpaPageNumber` – Destination GPA to map; must be currently unmapped.
- `SourceGpaPageNumber` – Backing page; must reference valid committed page owned by the caller.

## See Also
* [HV_GPA_PAGE_NUMBER](hv_gpa_page_number.md)
* [HV_MAP_GPA_FLAGS](hv_map_gpa_flags.md)
* [HvCallMapSparseGpaPages](../hypercalls/HvCallMapSparseGpaPages.md)

