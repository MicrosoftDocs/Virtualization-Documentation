---
title: HvCallGetPartitionProperty
description: HvCallGetPartitionProperty hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HvCallGetPartitionProperty

HvCallGetPartitionProperty retrieves the value of a specific property for a partition.

## Interface

```c
HV_STATUS
HvCallGetPartitionProperty(
    _In_ HV_PARTITION_ID             PartitionId,
    _In_ HV_PARTITION_PROPERTY_CODE  PropertyCode,
    _Out_ UINT64*                    PropertyValue
);
```

## Call Code

`0x0044` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Specifies the ID of the partition whose property is being queried. |
| `PropertyCode`          | 8          | 4        | Specifies which partition property to retrieve. |
| RsvdZ                   | 12         | 4        |                                           |

## Output Parameters

| Name          | Offset | Size | Information Provided |
|---------------|--------|------|----------------------|
| PropertyValue | 0      | 8    | Returned property value |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HV_PARTITION_PROPERTY_CODE](../datatypes/hv_partition_property_code.md)
- [HvCallSetPartitionProperty](HvCallSetPartitionProperty.md)
- [HvCallSetPartitionPropertyEx](HvCallSetPartitionPropertyEx.md)
