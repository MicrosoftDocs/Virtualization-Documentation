---
title: HvCallWithdrawMemory
description: HvCallWithdrawMemory hypercall specification
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallWithdrawMemory

HvCallWithdrawMemory withdraws physical pages from a partition's memory pool returning their page numbers to the caller.

## Interface

```c
HV_STATUS
HvCallWithdrawMemory(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_PROXIMITY_DOMAIN_INFO ProximityDomainInfo,
    _Out_ HV_GPA_PAGE_NUMBER* GpaPageList // Writes RepCount elements
);
```

## Call Code

`0x0049` (Rep)

## Input Parameters

| Name                | Offset | Size | Information Provided |
|---------------------|--------|------|----------------------|
| PartitionId         | 0      | 8    | Target partition identifier. |
| ProximityDomainInfo | 8      | 8    | NUMA domain hint for withdrawal. |

## Output Parameters

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| GpaPageList | 0      | Var  | Output array of withdrawn page numbers (count = ElementsProcessed). |

## See Also

- [HvCallDepositMemory](HvCallDepositMemory.md)
- [HvCallGetMemoryBalance](HvCallGetMemoryBalance.md)
- [HV_PROXIMITY_DOMAIN_INFO](../datatypes/hv_proximity_domain_info.md)
