---
title: WHvEmulatorDestoryEmulator method
description: Learn about the WHvEmulatorDestoryEmulator method. 
author: sethmanheim
ms.author: roharwoo
ms.date: 04/19/2022
---

# WHvEmulatorDestoryEmulator


## Syntax

```c
HRESULT
WINAPI
WHvEmulatorDestoryEmulator(
    _In_ WHV_EMULATOR_HANDLE Emulator
    );
```
### Parameters

`Partition`

Handle to the emulator instance that is destroyed.

## Remarks
Destroy an instance of the instruction emulator created by [`WHvEmulatorCreateEmulator`](WHvEmulatorCreateEmulator.md)
