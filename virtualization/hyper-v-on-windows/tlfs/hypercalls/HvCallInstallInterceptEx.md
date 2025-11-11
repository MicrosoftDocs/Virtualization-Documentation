---
title: HvCallInstallInterceptEx
description: HvCallInstallInterceptEx hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallInstallInterceptEx

HvCallInstallInterceptEx installs an extended intercept handler for specific virtualization events.

Architecture: ARM64 only.

## Interface

```c
HV_STATUS
HvCallInstallInterceptEx(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_INPUT_VTL InterceptingInputVtl,
    _In_ HV_INTERCEPT_TYPE InterceptType,
    _In_ UINT64 Reserved[4],
    _In_ HV_INTERCEPT_PARAMETERS_EX* InterceptParametersEx, // Reads RepCount elements
    );
```

## Call Code

`0x0110` (Rep)

## Input Parameters

| Name | Offset | Size | Information Provided |
|---|---|---|---|
| `PartitionId` | 0 | 8 | Specifies the ID of the partition containing the virtual processors. |
| `InterceptInputVtl` | 8 | 1 | Specifies the type of operation to intercept. |
| Padding | 9 | 2 | Padding (must be zero) |
| `InterceptType` | 12 | 4 | Specifies the type of operation to intercept. |
| Reserved[4] | 16 | 32 | Reserved (must be zero) |
| `InterceptParametersEx` | 48 | Variable | Specifies extended parameters for the intercept configuration. |

## See also

* [`HV_PARTITION_ID`](../datatypes/hv_partition_id.md)
* [`HV_VP_SET`](../datatypes/hv_vp_set.md)
* [`HV_INTERCEPT_TYPE`](../datatypes/hv_intercept_type.md)
* [`HV_INTERCEPT_PARAMETERS_EX`](../datatypes/hv_intercept_parameters_ex.md)
* [`HvCallInstallIntercept`](HvCallInstallIntercept.md)
