---
title: HvCallSetPartitionProperty
description: HvCallSetPartitionProperty hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HvCallSetPartitionProperty

HvCallSetPartitionProperty sets the value of a fixed-size property for a partition. 

## Interface

```c
HV_STATUS
HvCallSetPartitionProperty(
    _In_ HV_PARTITION_ID             PartitionId,
    _In_ HV_PARTITION_PROPERTY_CODE  PropertyCode,
    _In_ UINT64                      PropertyValue
);
```

## Call Code
`0x0045` (Simple)

## See also
* [HvCallGetPartitionProperty](HvCallGetPartitionProperty.md)
* [HvCallSetPartitionPropertyEx](HvCallSetPartitionPropertyEx.md)
* [HV_PARTITION_PROPERTY_CODE](../datatypes/hv_partition_property_code.md)
* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
