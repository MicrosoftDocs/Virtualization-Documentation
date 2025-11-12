---
title: HvCallInstallIntercept
description: HvCallInstallIntercept hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallInstallIntercept

HvCallInstallIntercept installs an intercept handler for specific virtualization events on a virtual processor.

## Interface

```c
HV_STATUS
HvCallInstallIntercept(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_INTERCEPT_ACCESS_TYPE_MASK AccessType,
    _In_ HV_INTERCEPT_TYPE InterceptType,
    _In_ HV_INTERCEPT_PARAMETERS InterceptParameter
    );
```

## Call Code

`0x004d` (Simple)

## Input Parameters

| Name | Offset | Size | Information Provided |
|---|---|---|---|
| `PartitionId` | 0 | 8 | Specifies the ID of the partition for which to install the intercept. |
| `AccessType` | 8 | 4 | Specifies the access type mask for the intercept. |
| `InterceptType` | 12 | 4 | Specifies the type of operation to intercept. |
| `InterceptParameter` | 16 | 8 | Specifies additional parameters for the intercept configuration. |

## See also

* [`HV_PARTITION_ID`](../datatypes/hv_partition_id.md)
* [`HV_INTERCEPT_TYPE`](../datatypes/hv_intercept_type.md)
* [`HV_INTERCEPT_PARAMETERS`](../datatypes/hv_intercept_parameters.md)
* [`HvCallInstallInterceptEx`](HvCallInstallInterceptEx.md)
