---
title: HvCallGetVpSetFromMda
description: HvCallGetVpSetFromMda hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HvCallGetVpSetFromMda

HvCallGetVpSetFromMda converts a Memory Descriptor Array (MDA) into a virtual processor set. This hypercall translates memory-based virtual processor specifications into the standard VP set format used by other hypervisor operations.

## Interface

```c
HV_STATUS
HvCallGetVpSetFromMda(
    _In_ HV_PARTITION_ID  TargetPartition,
    _In_ UINT64           DestinationAddress,
    _In_ HV_VTL           TargetVtl,
    _In_ BOOLEAN          LogicalDestinationMode,
    _In_ UINT16           ReservedZ0,
    _In_ UINT32           ReservedZ1,
    _Out_ HV_VP_SET*      TargetVpSet
);
```

## Call Code

`0x00E5` (Simple)

## Restrictions

Architecture: x64 only (not available on arm64). 

## Input Parameters

| Name                 | Offset | Size | Information Provided |
|----------------------|--------|------|----------------------|
| TargetPartition      | 0      | 8    | Partition whose MDA is interpreted |
| DestinationAddress   | 8      | 8    | APIC / GIC style destination bits |
| TargetVtl            | 16     | 1    | Target VTL |
| LogicalDestinationMode | 17   | 1    | Interpret destination logically when set |
| Reserved             | 18     | 6    | Must be zero |

## Output Parameters

| Name        | Offset | Size  | Information Provided |
|-------------|--------|-------|----------------------|
| TargetVpSet | 0      | 4104  | Result VP set bitmap |

## See also

* [`HV_PARTITION_ID`](../datatypes/hv_partition_id.md)
* [`HV_VP_SET`](../datatypes/hv_vp_set.md)
* [`HV_VTL`](../datatypes/hv_vtl.md)
