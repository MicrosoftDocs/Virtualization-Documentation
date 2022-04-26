---
title: Delete a virtual processor in a partition
description: Learn about the WHvDeleteVirtualProcessor function that deletes a virtual processor in a partition.
author: mattbriggs
ms.author: mabrigg
ms.date: 04/20/2022
---

# WHvDeleteVirtualProcessor

## Syntax

```C
HRESULT
WINAPI
WHvDeleteVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex
    );
```

### Parameters

`Partition`

Handle to the partition object

`VpIndex`

 Specifies the index of the virtual processor that is deleted
  

## Remarks

The `WHvDeleteVirtualProcessor` function deletes a virtual processor in a partition. 
