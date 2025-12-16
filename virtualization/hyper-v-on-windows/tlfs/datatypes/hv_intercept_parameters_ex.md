---
title: HV_INTERCEPT_PARAMETERS_EX
description: HV_INTERCEPT_PARAMETERS_EX
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---
# HV_INTERCEPT_PARAMETERS_EX

## Overview
Extended intercept parameter union used with `HvCallInstallInterceptEx`.

Architecture:
- ARM64 only.

## Syntax

```c
typedef union {
    struct {
        HV_REGISTER_NAME RegisterName;
        HV_INTERCEPT_ACCESS_TYPE_MASK AccessTypeMask;
        UINT64 WriteInterceptMask;
        UINT64 Reserved[14];
    } RegisterInterceptParams;
} HV_INTERCEPT_PARAMETERS_EX;
```

## Fields

| Field | Description |
|-------|-------------|
| RegisterInterceptParams | Structure for register intercepts |

### RegisterInterceptParams

| Field | Description |
|-------|-------------|
| RegisterName | Target register identifier |
| AccessTypeMask | Combination of read/write bits to trap |
| WriteInterceptMask | Bitmask selecting subfields for write trapping (mapping defined by the register's documented bit layout) |
| Reserved | Must be zero |

## See also

* [HV_INTERCEPT_PARAMETERS](hv_intercept_parameters.md)
* [HV_INTERCEPT_ACCESS_TYPE_MASK](hv_intercept_access_type_mask.md)
* [HV_REGISTER_NAME](hv_register_name.md)
