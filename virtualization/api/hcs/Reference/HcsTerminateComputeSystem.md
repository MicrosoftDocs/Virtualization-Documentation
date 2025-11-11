---
title: HcsTerminateComputeSystem
description: HcsTerminateComputeSystem
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsTerminateComputeSystem
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsTerminateComputeSystem

## Description

Forcefully terminates a compute system, see [sample code](./tutorial.md).

## Syntax

```cpp
HRESULT WINAPI
HcsTerminateComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to terminate.

`operation`

The handle to the operation that tracks the terminate operation.

`options`

Reserved for future use. Must be `NULL`.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md).


## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.


| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The compute system was terminated successfully |

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
