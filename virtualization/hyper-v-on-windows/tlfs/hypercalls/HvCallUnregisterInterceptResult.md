---
title: HvCallUnregisterInterceptResult
description: HvCallUnregisterInterceptResult hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallUnregisterInterceptResult

The HvCallUnregisterInterceptResult hypercall unregisters a previously registered intercept result for a specific intercept type within a partition.

## Interface

```c
HV_STATUS
HvCallUnregisterInterceptResult(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_INTERCEPT_TYPE InterceptType,
    _In_ HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS Parameters
);
```

## Call Code

`0x0092` (Simple)

## Restrictions

- Architecture: x64 only.

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| PartitionId             | 0          | 8        | Specifies the partition for which to unregister the intercept result |
| VpIndex                 | 8          | 4        | Specifies the VP index for the intercept |
| InterceptType           | 12         | 4        | Specifies the type of intercept for which to unregister the result |
| Parameters              | 16         | Variable | [HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS](../datatypes/hv_unregister_intercept_result_parameters.md) union selecting CPUID or MSR unregister parameters |

## See Also

* [HvCallRegisterInterceptResult](HvCallRegisterInterceptResult.md)
* [HV_INTERCEPT_TYPE](../datatypes/hv_intercept_type.md)
* [HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS](../datatypes/hv_unregister_intercept_result_parameters.md)
