---
title: HV_GPA_PAGE_NUMBER
description: HV_GPA_PAGE_NUMBER data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_GPA_PAGE_NUMBER

The HV_GVA_PAGE_NUMBER type represents a guest physical address page number used in hypervisor operations for physical address memory management.

## Syntax

```c
typedef UINT64 HV_GPA_PAGE_NUMBER;
```

## Description

HV_GPA_PAGE_NUMBER is a 64-bit unsigned integer that represents the page number portion of a guest physical address. This value is obtained by right-shifting a guest pysical address by the page size (typically 12 bits for 4KB pages), effectively removing the page offset and leaving only the page number.

## Usage

When converting between a guest physical address and its page number:
- **To get page number from address**: `GpaPageNumber = GuestPhysicalAddress >> PAGE_SHIFT`
- **To get address from page number**: `GuestPhysicalAddress = GpaPageNumber << PAGE_SHIFT`

Where `PAGE_SHIFT` is 12 for 4KB pages.

## See also

* [HvCallDepositMemory](../hypercalls/HvCallDepositMemory.md)
* [HvCallWithdrawMemory](../hypercalls/HvCallWithdrawMemory.md)
* [HvCallMapGpaPages](../hypercalls/HvCallMapGpaPages.md)
* [HvCallUnmapGpaPages](../hypercalls/HvCallUnmapGpaPages.md)
* [HV_PARTITION_ID](hv_partition_id.md)
