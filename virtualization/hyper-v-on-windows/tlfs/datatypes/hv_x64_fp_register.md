---
title: HV_X64_FP_REGISTER
description: HV_X64_FP_REGISTER
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_X64_FP_REGISTER

Floating point registers are encoded as 80-bit values.

Architecture: x64 only.

## Syntax

```c
typedef struct
{
    UINT64 Mantissa;
    UINT64 BiasedExponent:15;
    UINT64 Sign:1;
    UINT64 Reserved:48;
} HV_X64_FP_REGISTER;
 ```
