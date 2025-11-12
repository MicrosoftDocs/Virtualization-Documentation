---
title: HvCallDepositMemory
description: HvCallDepositMemory hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallDepositMemory

HvCallDepositMemory adds physical memory pages to a partition's memory pool. This hypercall allows a parent partition to provide additional memory resources to the hypervisor, expanding its available memory for allocation on behalf of the partition.

## Usage Notes

- This is a REP hypercall: the `RepCount` specifies number of page elements in `GpaPageList`; `ElementsProcessed` (implicit output) indicates progress for retries.

## Interface

 ```c
HV_STATUS
HvCallDepositMemory(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ const HV_GPA_PAGE_NUMBER GpaPageList[] // Reads RepCount elements
    );
 ```

## Call Code

`0x0048` (Rep)

## Input Parameters

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| PartitionId | 0      | 8    | Target partition identifier. |
| GpaPageList | 8      | Var  | Array of page numbers; element count = `RepCount`. |

### Element List

Each element of `GpaPageList` is one `HV_GPA_PAGE_NUMBER` (8 bytes). The hypercall control's `RepCount` specifies how many elements to consume. The hypervisor deposits pages in order until all are processed or a failure/limit condition is encountered. `ElementsProcessed` (from the hypercall result control) reports how many entries from the caller's array were successfully deposited.

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HV_GPA_PAGE_NUMBER](../datatypes/hv_gpa_page_number.md)
- [HvCallWithdrawMemory](HvCallWithdrawMemory.md)
- [HvCallGetMemoryBalance](HvCallGetMemoryBalance.md)
