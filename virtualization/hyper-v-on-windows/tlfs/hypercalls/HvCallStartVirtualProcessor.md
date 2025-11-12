---
title: HvCallStartVirtualProcessor
description: HvCallStartVirtualProcessor hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HvCallStartVirtualProcessor

HvCallStartVirtualProcessor is an enlightened method for starting a virtual processor. It is functionally equivalent to traditional INIT-based methods, except that the VP can start with a desired register state.

This is the only method for starting a VP in a non-zero VTL.

## Interface

 ```c
HV_STATUS
HvCallStartVirtualProcessor(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_VTL TargetVtl,
    _In_ HV_INITIAL_VP_CONTEXT VpContext
    );
 ```

## Call Code

`0x0099` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Partition                                 |
| `VpIndex`               | 8          | 4        | VP Index to start. To get the VP index from an APIC ID, use HvCallGetVpIndexFromApicId. |
| `TargetVtl`             | 12         | 1        | Target VTL                                |
| `VpContext`             | 16         | 224      | Specifies the initial context in which the VP should start. |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | Access denied                                         |
| `HV_STATUS_INVALID_PARTITION_ID`    | The specified partition ID is invalid.                |
| `HV_STATUS_INVALID_VP_INDEX`        | The virtual processor specified by HV_VP_INDEX is invalid. |
| `HV_STATUS_INVALID_REGISTER_VALUE`  | The supplied register value is invalid.               |
| `HV_STATUS_INVALID_VP_STATE`        | A virtual processor is not in the correct state for the performance of the indicated operation. |
| `HV_STATUS_INVALID_PARTITION_STATE` | The specified partition is not in the “active” state. |
| `HV_STATUS_INVALID_VTL_STATE`       | The VTL state conflicts with the requested operation. |

## See also

[HV_INITIAL_VP_CONTEXT](../datatypes/HV_INITIAL_VP_CONTEXT.md)