---
title: HvCallGetVpIndexFromApicId
description: HvCallGetVpIndexFromApicId hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallGetVpIndexFromApicId

The HvCallGetVpIndexFromApicId allows the caller to retrieve a VP index for the VP with the specified hardware processor ID (APIC ID on x64, MPIDR on ARM64).

## Interface

 ```c
HV_STATUS
HvCallGetVpIndexFromApicId(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VTL TargetVtl,
    _Inout_ UINT32* ApicIdCount,
    _In_reads_(ApicIdCount) HV_PROCESSOR_HW_ID* ApicIdList,
    _Out_writes(ApicIdCount) HV_VP_INDEX* VpIndexList
    );

 ```

## Call Code

`0x009A` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Partition                                 |
| `TargetVtl`             | 8          | 1        | Target VTL                                |
| Padding                 | 9          | 7        |                                           |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ProcessorHwId`         | 0          | 4 (x64) or 8 (ARM64) | Hardware processor ID: APIC ID (UINT32) on x64, MPIDR value (UINT64) on ARM64 |
| Padding                 | 4 or 8     | 4 or 0   |                                           |

## Output List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `VpIndex`               | 0          | 4        | Index of the VP with the specified hardware processor ID |
| Padding                 | 4          | 4        |                                           |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | Access denied                                         |
| `HV_STATUS_INVALID_PARAMETER`       | An invalid parameter was specified                    |
| `HV_STATUS_INVALID_PARTITION_ID`    | The specified partition ID is invalid.                |
| `HV_STATUS_INVALID_REGISTER_VALUE`  | The supplied register value is invalid.               |
| `HV_STATUS_INVALID_VP_STATE`        | A virtual processor is not in the correct state for the performance of the indicated operation. |
| `HV_STATUS_INVALID_PARTITION_STATE` | The specified partition is not in the “active” state. |
| `HV_STATUS_INVALID_VTL_STATE`       | The VTL state conflicts with the requested operation. |