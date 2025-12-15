---
title: HV_GVA
description: HV_GVA data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_GVA

## Overview
`HV_GVA` represents a guest virtual address within a partition's address space (Stage-1). 

## Syntax
```c
typedef UINT64 HV_GVA;
```

An `HV_GVA` is a 64-bit unsigned integer large enough to hold any architecture-supported guest virtual address. 

## See Also
- [HV_GVA_PAGE_NUMBER](hv_gva_page_number.md)
- [HvCallFlushVirtualAddressList](../hypercalls/HvCallFlushVirtualAddressList.md)
- [HvCallFlushVirtualAddressListEx](../hypercalls/HvCallFlushVirtualAddressListEx.md)
- [HvCallTranslateVirtualAddress](../hypercalls/HvCallTranslateVirtualAddress.md)
- [HvCallTranslateVirtualAddressEx](../hypercalls/HvCallTranslateVirtualAddressEx.md)
