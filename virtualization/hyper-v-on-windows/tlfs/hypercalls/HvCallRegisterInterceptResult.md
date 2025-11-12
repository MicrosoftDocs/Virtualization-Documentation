---
title: HvCallRegisterInterceptResult
description: HvCallRegisterInterceptResult hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallRegisterInterceptResult

The HvCallRegisterInterceptResult hypercall registers the result of handling an intercept, providing the hypervisor with information on how the intercept was processed.

## Interface

 ```c
HV_STATUS
HvCallRegisterInterceptResult(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_INTERCEPT_TYPE InterceptType,
    _In_ HV_REGISTER_INTERCEPT_RESULT_PARAMETERS Parameters
);
 ```

## Call Code

`0x0091` (Simple)

## Restrictions

- Architecture: x64 only.

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| PartitionId             | 0          | 8        | Partition ID where intercept occurred     |
| VpIndex                 | 8          | 4        | Virtual processor index                   |
| InterceptType           | 12         | 4        | Type of intercept that was handled       |
| Parameters              | 16         | Variable | Parameters specific to the intercept type|

## See also

[HV_PARTITION_ID](../datatypes/hv_partition_id.md)
[HV_VP_INDEX](../datatypes/hv_vp_index.md)
[HV_INTERCEPT_TYPE](../datatypes/hv_intercept_type.md)
[HV_REGISTER_INTERCEPT_RESULT_PARAMETERS](../datatypes/hv_register_intercept_result_parameters.md)
