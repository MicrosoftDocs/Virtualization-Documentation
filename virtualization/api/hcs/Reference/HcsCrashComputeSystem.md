---
title: HcsCrashComputeSystem
description: HcsCrashComputeSystem
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsCrashComputeSystem
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsCrashComputeSystem

## Description

Requests to crash the guest through an architecture defined mechanism, by sending an NMI (Non Maskable Interrupt).

## Syntax

```cpp
HRESULT WINAPI
HcsCrashComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to crash.

`operation`

The handle to the operation that tracks the crash system operation.

`options`

Optional JSON document [CrashOptions](./../SchemaReference.md#CrashOptions) specifying terminate options.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md).



## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The guest compute system was crashed successfully |

If the operation's result is not `S_OK`, then it's possible the result document might contain the error message.


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
