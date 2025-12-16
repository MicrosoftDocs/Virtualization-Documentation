---
title: HV_GVA_PAGE_NUMBER
description: HV_GVA_PAGE_NUMBER data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_GVA_PAGE_NUMBER

The HV_GVA_PAGE_NUMBER type represents a guest virtual address page number used in hypervisor operations for virtual address translation and memory management.

## Syntax

```c
typedef UINT64 HV_GVA_PAGE_NUMBER;
```

## Description

HV_GVA_PAGE_NUMBER is a 64-bit unsigned integer that represents the page number portion of a guest virtual address. This value is obtained by right-shifting a guest virtual address by the page size (typically 12 bits for 4KB pages), effectively removing the page offset and leaving only the page number.

The page number is used in hypervisor operations that work with memory at page granularity, such as:
- Virtual address translation
- Memory mapping operations
- Page-level access control

## Usage

When converting between a guest virtual address and its page number:
- **To get page number from address**: `GvaPageNumber = GuestVirtualAddress >> PAGE_SHIFT`
- **To get address from page number**: `GuestVirtualAddress = GvaPageNumber << PAGE_SHIFT`

Where `PAGE_SHIFT` is typically 12 (for 4KB pages).

## See Also

[HvCallTranslateVirtualAddress](../hypercalls/HvCallTranslateVirtualAddress.md)
[HvCallTranslateVirtualAddressEx](../hypercalls/HvCallTranslateVirtualAddressEx.md)
[HV_TRANSLATE_GVA_CONTROL_FLAGS](hv_translate_gva_control_flags.md)
