---
title: Cancel the run of a virtual processor
description: Learn about the WHvCancelRunVirtualProcessor function that cancels the call to run a virtual processor.
author: sethmanheim
ms.author: sethm
ms.date: 04/20/2022
---

# WHvCancelRunVirtualProcessor

## Syntax

```C
HRESULT
WINAPI
WHvCancelRunVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ UINT32 Flags
    );
```

### Parameters

`Partition`

Handle to the partition object

`VpIndex`

Specifies the index of the virtual processor for which the execution should be stopped

`Flags`

Unused, must be zero 

## Remarks

Canceling the execution of a virtual processor allows an application to abort the call to run the virtual processor ([`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md)) by another thread, and to return the control to that thread. The virtualization stack can use this function to return the control of a virtual processor back to the virtualization stack in case it needs to change the state of a VM or to inject an event into the processor. 
