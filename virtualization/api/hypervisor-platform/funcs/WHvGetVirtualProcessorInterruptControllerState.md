---
title: WHvGetVirtualProcessorInterruptControllerState
description: Description for working with the WHvGetVirtualProcessorInterruptControllerState, including its parameters, syntax and return value.  
author: jstarks
ms.author: jostarks
ms.date: 06/06/2019
---

# WHvGetVirtualProcessorInterruptControllerState

## Syntax

```
HRESULT
WINAPI
WHvGetVirtualProcessorInterruptControllerState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_to_(StateSize, *WrittenSize) VOID* State,
    _In_ UINT32 StateSize,
    _Out_opt_ UINT32* WrittenSize
    );
```

### Parameters

`Partition`

Specifies the partition of the virtual processor.

`VpIndex`

Specifies the index of the virtual processor whose interrupt controller should be retrieved.

`State`

Specifies a buffer to write the interrupt controller state into.

`StateSize`

Specifies the size of the buffer, in bytes.

`WrittenSize`

If non-NULL, receives the number of bytes written to the buffer.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the buffer is too small to contain the interrupt controller state, the return value is `WHV_E_INSUFFICIENT_BUFFER`. In this case, `WrittenSize` receives the number of bytes necessary to fit the interrupt controller state.
