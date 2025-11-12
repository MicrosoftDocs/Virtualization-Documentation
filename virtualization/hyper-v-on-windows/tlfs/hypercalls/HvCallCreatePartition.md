---
title: HvCallCreatePartition
description: HvCallCreatePartition hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HvCallCreatePartition

HvCallCreatePartition creates a new child partition. 

## Interface

```c
HV_STATUS
HvCallCreatePartition(
    _In_ UINT64                            Flags,
    _In_ HV_PROXIMITY_DOMAIN_INFO          ProximityDomainInfo,
    _In_ HV_COMPATIBILITY_VERSION          CompatibilityVersion,
    _In_ HV_PARTITION_CREATION_PROPERTIES  Properties,
    _In_ UINT64                            ReservedZ0,
    _Out_ HV_PARTITION_ID*                 NewPartitionId
);
```

## Call Code

`0x0040` (Simple)

### AMD64 Layout (total size 56 bytes)
| Name                                       | Offset | Size | Information Provided |
|--------------------------------------------|--------|------|----------------------|
| Flags                                      | 0      | 8    | Partition creation flags bitmask. |
| ProximityDomainInfo                        | 8      | 8    | Initial NUMA locality hint. |
| CompatibilityVersion                       | 16     | 4    | Requested compatibility version. |
| Padding (should be zero)          | 20     | 4    | Alignment to 8-byte boundary. |
| Properties.DisabledProcessorFeatures       | 24     | 16   | Banked processor feature disable mask(s). |
| Properties.DisabledProcessorXsaveFeatures  | 40     | 8    | XSAVE state component disable mask. |
| ReservedZ0                                 | 48     | 8    | Must be 0. |

### ARM64 Layout (total size 48 bytes)
| Name                                  | Offset | Size | Information Provided |
|---------------------------------------|--------|------|----------------------|
| Flags                                 | 0      | 8    | Partition creation flags bitmask. |
| ProximityDomainInfo                   | 8      | 8    | Initial NUMA locality hint. |
| CompatibilityVersion                  | 16     | 4    | Requested compatibility version. |
| Padding (should be zero)     | 20     | 4    | Alignment to 8-byte boundary. |
| Properties.DisabledProcessorFeatures  | 24     | 16   | Banked processor feature disable mask(s). |
| ReservedZ0                            | 40     | 8    | Must be 0. |

## Output Parameters

| Name           | Offset | Size | Information Provided |
|----------------|--------|------|----------------------|
| NewPartitionId | 0      | 8    | Assigned partition identifier. |

## See Also

- [HV_PARTITION_CREATION_PROPERTIES](../datatypes/hv_partition_creation_properties.md)
- [HV_PARTITION_CREATION_FLAGS](../datatypes/hv_partition_creation_flags.md)
- [HvCallInitializePartition](HvCallInitializePartition.md)
- [HvCallFinalizePartition](HvCallFinalizePartition.md)
