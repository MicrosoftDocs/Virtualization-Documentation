---
title: HV_INPUT_VTL
description: HV_INPUT_VTL
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_INPUT_VTL

Specifies a virtual trust level for input operations.

## Syntax

```c
typedef union
{
    UINT8 AsUINT8;
    struct
    {
        UINT8 TargetVtl    : 4;
        UINT8 UseTargetVtl : 1;
        UINT8 ReservedZ    : 3;
    };
} HV_INPUT_VTL;
```

## Fields

| Field | Description |
|-------|-------------|
| `AsUINT8` | Raw 8-bit value representation |
| `TargetVtl` | Target virtual trust level (0-15) |
| `UseTargetVtl` | Flag indicating whether to use the target VTL |
| `ReservedZ` | Reserved field, must be zero |

## Remarks

This union allows specifying a target virtual trust level for hypercall operations that operate across VTL boundaries. The `UseTargetVtl` flag determines whether the `TargetVtl` field should be honored. If not set, the target VTL is either the current caller's VTL, or all VTLs, depending on the Hypercall.

## See also

* [HV_VTL](hv_vtl.md)

