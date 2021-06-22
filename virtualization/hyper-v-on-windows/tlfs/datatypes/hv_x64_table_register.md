---
title: HV_X64_TABLE_REGISTER
description: HV_X64_TABLE_REGISTER
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_X64_TABLE_REGISTER

Table registers are similar to segment registers, but they have no selector or attributes, and the limit is restricted to 16 bits.

## Syntax

```c
typedef struct
{
    UINT16 Pad[3];
    UINT16 Limit;
    UINT64 Base;
} HV_X64_TABLE_REGISTER;
 ```
