---
title: HvCallCreateVp
description: HvCallCreateVp hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallCreateVp

HvCallCreateVp creates a new virtual processor within a partition. Virtual processors are the execution contexts that run guest code within a partition, and each partition must have at least one virtual processor to execute code.

## Interface

 ```c
HV_STATUS
HvCallCreateVp(
    _In_ HV_PARTITION_ID             PartitionId,
    _In_ HV_VP_INDEX                 VpIndex,
    _In_ UINT8                       ReservedZ0[3],
    _In_ UINT8                       SubnodeType,
    _In_ UINT64                      SubnodeId,
    _In_ HV_PROXIMITY_DOMAIN_INFO    ProximityDomainInfo,
    _In_ UINT64                      Flags
    );
 ```

## Call Code

`0x004e` (Simple)

## Input Parameters

| Name                | Offset | Size | Information Provided |
|---------------------|--------|------|----------------------|
| PartitionId         | 0      | 8    | Target partition identifier. |
| VpIndex             | 8      | 4    | New VP index (0-based, unique within partition). |
| ReservedZ0          | 12     | 3    | Must be zero. |
| SubnodeType         | 15     | 1    | Subnode type (0 if not used). |
| SubnodeId           | 16     | 8    | Subnode identifier (0 if not used). |
| ProximityDomainInfo | 24     | 8    | NUMA / locality hint. |
| Flags               | 32     | 8    | Reserved – must be zero. |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HV_VP_INDEX](../datatypes/hv_vp_index.md)
- [HV_PROXIMITY_DOMAIN_INFO](../datatypes/hv_proximity_domain_info.md)
- [HvCallDeleteVp](HvCallDeleteVp.md)
- [HvCallStartVirtualProcessor](HvCallStartVirtualProcessor.md)
