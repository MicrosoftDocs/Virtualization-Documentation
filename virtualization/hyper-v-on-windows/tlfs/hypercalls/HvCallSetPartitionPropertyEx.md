---
title: HvCallSetPartitionPropertyEx
description: HvCallSetPartitionPropertyEx hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HvCallSetPartitionPropertyEx

HvCallSetPartitionPropertyEx sets the value of a partition property whose payload size exceeds the fixed-size value supported by [HvCallSetPartitionProperty](HvCallSetPartitionProperty.md). It accepts a variable-size property value buffer.

## Interface
```c
HV_STATUS
HvCallSetPartitionPropertyEx(
    _In_ HV_PARTITION_ID             PartitionId,
    _In_ HV_PARTITION_PROPERTY_CODE  PropertyCode,
    _In_ UINT64                      PropertyArgument,
    _In_reads_bytes_(VariableHeaderSize) const VOID* PropertyValue,
);
```
## Call Code
`0x010A` (Variable, simple input)

## Input Parameters
| Name         | Offset | Size      | Information Provided |
|--------------|--------|-----------|----------------------|
| PartitionId  | 0      | 8         | Target partition |
| PropertyCode | 8      | 4         | Property selector |
| Padding      | 12      | 4        | Padding for alignment (must be zero) |
| PropertyArgument | 16      | 4         | Property Argument |
| PropertyValue| 24     | VariableHeaderSize | Value bytes |

## See also
* [HvCallGetPartitionProperty](HvCallGetPartitionProperty.md)
* [HvCallSetPartitionProperty](HvCallSetPartitionProperty.md)
* [HV_PARTITION_PROPERTY_CODE](../datatypes/hv_partition_property_code.md)
