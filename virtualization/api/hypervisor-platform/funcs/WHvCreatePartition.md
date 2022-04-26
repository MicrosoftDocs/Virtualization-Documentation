---
title: Create a new partition object
description: Learn about the WHvCreatePartition function that creates a new partition object.
author: mattbriggs
ms.author: mabrigg
ms.date: 04/20/2022
---

# WHvCreatePartition

## Syntax

```C
typedef VOID* WHV_PARTITION_HANDLE;

HRESULT
WINAPI
WHvCreatePartition(
    _Out_ WHV_PARTITION_HANDLE* Partition
    );
```

### Parameters

`Partition`

Receives the partition handle to the newly created partition object. All operations on the partition are performed through this handle.

To delete a partition created by `WHvCreatePartition`, use the [`WHvDeletePartition`](WhvDeletePartition.md) function.
  

## Remarks

The `WHvCreatePartition` function creates a new partition object.

`WHvCreatePartition` only creates the partition object and does not yet create the actual partition in the hypervisor. After creation of the partition object, the partition object should be configured using [`WHvSetPartitionProperty`](WHvSetPartitionProperty.md). After the partition object is configured, the [`WHvSetupPartition`](WhvSetupPartition.md) function should be called to create the hypervisor partition.
