---
title: WHvSuspendPartitionTime
description: Describes virtual processor SuspendPartitionTime and provides parameters, return value, remarks, and requirements.
author: nschonni
ms.author: roharwoo
ms.date: 06/03/2019
---

# WHvSuspendPartitionTime

## Syntax

```C
HRESULT
WINAPI
WHvSuspendPartitionTime(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```

### Parameters

`Partition`

Handle to the partition object.

## Return Value

If the function succeeds, the return value is `S_OK`.  

## Remarks

Suspends time for the partition.

No virtual processor may be running when this is called.  Time will resume when [`WHvResumePartitionTime`](WHvResumePartitionTime.md) or
[`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) is called.

## Requirements

Minimum supported build:    Insider Preview Builds (19H1)
