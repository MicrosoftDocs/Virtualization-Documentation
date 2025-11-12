---
title: HvCallGetMemoryBalance
description: HvCallGetMemoryBalance hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallGetMemoryBalance

HvCallGetMemoryBalance retrieves the current memory allocation information for a partition. This hypercall provides details about the partition's memory usage in the hypervisor.

## Interface

```c
HV_STATUS
HvCallGetMemoryBalance(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_PROXIMITY_DOMAIN_INFO ProximityDomainInfo,
    _Out_ UINT64* PagesAvailable;
    _Out_ UINT64* PagesInUse;
);
```

## Call Code

`0x004A` (Simple)

## Input Parameters

| Name                | Offset | Size | Information Provided |
|---------------------|--------|------|----------------------|
| PartitionId         | 0      | 8    | Target partition identifier. |
| ProximityDomainInfo | 8      | 8    | NUMA domain hint; supply zeroed structure if domain not used. |

## Output Parameters

| Name          | Offset | Size | Information Provided |
|---------------|--------|------|----------------------|
| PagesAvailable | 0      | 8   | Number of pages available for allocation |
| PagesInUse | 0      | 8   | Number of pages in use by the hypervisor |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_PROXIMITY_DOMAIN_INFO](../datatypes/hv_proximity_domain_info.md)
* [HvCallDepositMemory](HvCallDepositMemory.md)
* [HvCallWithdrawMemory](HvCallWithdrawMemory.md)
