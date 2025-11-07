---
title: HV_INTERCEPT_PARAMETERS
description: HV_INTERCEPT_PARAMETERS
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_INTERCEPT_PARAMETERS

## Overview
Per-type parameter union for basic intercept installation (`HvCallInstallIntercept`).

Architecture:
- x64: All members listed below may be applicable subject to feature availability.
- ARM64: Only exception vector is valid.

## Syntax

```c
typedef union
{
    UINT64 AsUINT64;

#if defined(_AMD64_)

    HV_X64_IO_PORT IoPort;
    UINT32 CpuidIndex;
    UINT32 ApicWriteMask;
    UINT32 MsrIndex;

    struct
    {
        HV_X64_IO_PORT Base;
        HV_X64_IO_PORT End;
    } IoPortRange;

#endif

    UINT16 ExceptionVector;

} HV_INTERCEPT_PARAMETERS;
```

## Fields

| Field | Description |
|-------|-------------|
| IoPort | (x64) Single port (HvInterceptTypeX64IoPort) |
| CpuidIndex | (x64) CPUID leaf (HvInterceptTypeX64Cpuid) |
| ApicWriteMask | (x64) APIC write mask (HvInterceptTypeX64ApicWrite) |
| MsrIndex | (x64) MSR index (HvInterceptTypeX64Msr) |
| IoPortRange.Base/End | (x64) Inclusive port range (HvInterceptTypeX64IoPortRange) |
| ExceptionVector | Exception vector number (HvInterceptTypeException) |

## See also

* [HV_INTERCEPT_PARAMETERS_EX](hv_intercept_parameters_ex.md)
* [HV_INTERCEPT_TYPE](hv_intercept_type.md)
* [HV_INTERCEPT_ACCESS_TYPE_MASK](hv_intercept_access_type_mask.md)
