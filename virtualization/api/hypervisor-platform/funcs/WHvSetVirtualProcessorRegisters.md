---
title: WHvSetVirtualProcessorRegisters
description: Description for WHvSetVirtualProcessorRegisters and understaning how to work with its parameters and syntax. 
author: Juarezhm
ms.author: hajuaez
ms.date: 06/22/2018
---

# WHvSetVirtualProcessorRegisters

## Syntax

```C
HRESULT
WINAPI
WHvSetVirtualProcessorRegisters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _In_reads_(RegisterCount) const WHV_REGISTER_VALUE* RegisterValues
    );
```

### Parameters

`Partition`

Handle to the partition object

`VpIndex`

Specifies the index of the virtual processor whose registers are set

`RegisterNames`

Array specifying the names of the registers that are set

`RegisterCount`

Specifies the number of elements in the `RegisterNames` array

`RegisterValues`

Array specifying the values of the registers that are set

