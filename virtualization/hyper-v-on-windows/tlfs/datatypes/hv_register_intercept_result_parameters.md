---
title: HV_REGISTER_INTERCEPT_RESULT_PARAMETERS
description: HV_REGISTER_INTERCEPT_RESULT_PARAMETERS parameters for intercept result registration
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_REGISTER_INTERCEPT_RESULT_PARAMETERS

## Overview
Union of parameter blocks for intercept result registration (`HvCallRegisterInterceptResult`). Each member tailors result synthesis for a specific intercept class.

Architecture:
- x64 only: This union (and its CPUID/MSR substructures) applies only where the hypercall is available. On ARM64 the hypercall is not supported.

## Syntax

```c
typedef struct
{
    UINT32 Eax;
    UINT32 EaxMask;
    UINT32 Ebx;
    UINT32 EbxMask;
    UINT32 Ecx;
    UINT32 EcxMask;
    UINT32 Edx;
    UINT32 EdxMask;
} HV_REGISTER_X64_CPUID_RESULT_PARAMETERS;

typedef struct
{
    UINT32 MsrIndex;
    HV_INTERCEPT_ACCESS_TYPE_MASK AccessType;
    HV_UNIMPLEMENTED_MSR_ACTION Action;
} HV_REGISTER_X64_MSR_RESULT_PARAMETERS;

typedef union
{
    HV_REGISTER_X64_CPUID_RESULT_PARAMETERS Cpuid;
    HV_REGISTER_X64_MSR_RESULT_PARAMETERS Msr;
} HV_REGISTER_INTERCEPT_RESULT_PARAMETERS;
```

### Member Semantics
* `Cpuid` – Supplies masked expected register values; mask bits of zero indicate "don't care" for matching.
* `Msr` – Describes MSR index, access direction(s), and action policy when the MSR is unimplemented.

### Field Details (HV_REGISTER_X64_MSR_RESULT_PARAMETERS)
| Field | Description |
|-------|-------------|
| `MsrIndex` | Target MSR (full 32-bit index) for which a synthesized intercept result is registered. |
| `AccessType` | Combination of read / write direction bits. See [HV_INTERCEPT_ACCESS_TYPE_MASK](hv_intercept_access_type_mask.md). At least one bit must be set. |
| `Action` | Policy applied when the specified MSR is unimplemented. See table below. |

#### HV_UNIMPLEMENTED_MSR_ACTION
Enumeration controlling behavior for accesses to an unimplemented MSR when an intercept result is registered.

| Value | Name | Read Behavior | Write Behavior |
|-------|------|---------------|----------------|
| 0 | HvUnimplementedMsrActionFault | Intercept results in a fault (#GP equivalent) delivered to the guest. | Same (fault) |
| 1 | HvUnimplementedMsrActionIgnoreWriteReadZero | Read returns zero | Write is ignored (no state change). |

## See also
* [HvCallRegisterInterceptResult](../hypercalls/HvCallRegisterInterceptResult.md)
* [HvCallUnregisterInterceptResult](../hypercalls/HvCallUnregisterInterceptResult.md)
* [HV_INTERCEPT_TYPE](hv_intercept_type.md)
* [HV_INTERCEPT_ACCESS_TYPE_MASK](hv_intercept_access_type_mask.md)
* [HvPartitionPropertyUnimplementedMsrAction](hv_partition_property_code.md)
