---
title: WHV_EMULATOR_IO_PORT_CALLBACK method
description: Learn about the WHV_EMULATOR_IO_PORT_CALLBACK method. 
author: sethmanheim
ms.author: mabrigg
ms.date: 04/19/2022
---

# WHV_EMULATOR_IO_PORT_CALLBACK


## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_IO_PORT_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_IO_ACCESS_INFO* IoAccess
    );
```

## Return Value
The callback should return `S_OK` on success, and some error value on failure. Any error value returned here will terminate emulation and return from the corresponding emulation call.

## Remarks
Callback notifying the virtualization stack that the current instruction has
modified the IO Port specified in the IoAccess structure. Context is the value
specified in the emulation call which identifies this current instance of the emulation.

