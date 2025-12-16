---
title: HV_GET_VP_CPUID_VALUES_FLAGS
description: HV_GET_VP_CPUID_VALUES_FLAGS data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/08/2025
ms.topic: reference
---

# HV_GET_VP_CPUID_VALUES_FLAGS

## Overview

Control flags for `HvCallGetVpCpuidValues` hypercall that specify how CPUID values should be retrieved and processed for the target virtual processor.

Architecture: x64 only.

## Syntax

```c
typedef union {
    UINT32 AsUINT32;
    struct {
        UINT32 UseVpXfemXss : 1;
        UINT32 ApplyRegisteredValues : 1;
        UINT32 Reserved : 30;
    };
} HV_GET_VP_CPUID_VALUES_FLAGS;
```

### Members

| Member | Description |
|--------|-------------|
| UseVpXfemXss | If set, use the VP's current XFEM/XSS values when synthesizing CPUID results |
| ApplyRegisteredValues | If set, apply any registered CPUID value overrides to the results |
| Reserved | Must be zero |

## See Also

- [HvCallGetVpCpuidValues](../hypercalls/HvCallGetVpCpuidValues.md)
- [HV_CPUID_RESULT](hv_cpuid_result.md)