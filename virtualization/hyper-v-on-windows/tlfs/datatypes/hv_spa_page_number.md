---
title: HV_SPA_PAGE_NUMBER
description: HV_SPA_PAGE_NUMBER
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_SPA_PAGE_NUMBER

Represents a system physical address page number.

## Syntax

```c
typedef UINT64 HV_SPA_PAGE_NUMBER;
```

## Remarks

This type represents a 64-bit system physical address (SPA) page number. System physical addresses refer to the actual physical memory addresses in the host system, as opposed to guest physical addresses which are virtualized.

The page size is typically 4KB, so the actual physical address can be calculated by shifting the page number left by 12 bits.

## See also

* [HV_GPA_PAGE_NUMBER](hv_gpa_page_number.md)

