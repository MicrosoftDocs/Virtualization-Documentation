---
title: WHV_EMULATOR_MEMORY_CALLBACK method
description: Learn about the WHV_EMULATOR_MEMORY_CALLBACK method. 
author: sethmanheim
ms.author: roharwoo
ms.date: 04/19/2022
---

# WHV_EMULATOR_MEMORY_CALLBACK


## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_MEMORY_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_MEMORY_ACCESS_INFO* MemoryAccess
    );
```

## Remarks
Callback notifying the virtualization stack that the current instruction is attempting to accessing memory as specified in the `MemoryAccess` structure.

**NOTE:** As mentioned above, since in x86/AMD64 it is legal to do unaligned memory accesses, a memory access spanning a page boundary ie:

`movq [0xffe], rax`

This would cause two different memory callbacks to be invoked, one for two bytes, and one for 6 bytes.
