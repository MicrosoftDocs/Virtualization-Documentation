---
title: Delete a partition and release the resources that the partition was using
description: Learn about the WHvDeletePartition function that lets you delete a partition, remove the partition object, and release the resources that the partition was using.
author: sethmanheim
ms.author: sethm
ms.date: 04/20/2022
---

# WHvDeletePartition


## Syntax
```C
HRESULT
WINAPI
WHvDeletePartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```
### Parameters

`Partition`

Handle to the partition object that is deleted.
  

## Remarks

Deleting a partition tears down the partition object and releases all resource that the partition was using.
