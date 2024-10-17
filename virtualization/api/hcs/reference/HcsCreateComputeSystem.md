---
title: HcsCreateComputeSystem
description: HcsCreateComputeSystem
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsCreateComputeSystem
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsCreateComputeSystem

## Description

Creates a new compute system, see [sample code](./tutorial.md) for simple example.

## Syntax

```cpp
HRESULT WINAPI
HcsCreateComputeSystem(
    _In_ PCWSTR id,
    _In_ PCWSTR configuration,
    _In_ HCS_OPERATION operation,
    _In_opt_ const SECURITY_DESCRIPTOR* securityDescriptor,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

`id`

Unique Id identifying the compute system.

`configuration`

JSON document specifying the settings of the [compute system](./../SchemaReference.md#ComputeSystem). The compute system document is expected to have a `Container`, `VirtualMachine` or `HostedSystem` property set since they are mutually exclusive.

`operation`

The handle to the operation that tracks the create operation.

`securityDescriptor`

Reserved for future use, must be `NULL`.

`computeSystem`

Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.


## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md).


## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The compute system was created successfully |
| `HCS_E_OPERATION_PENDING` | The compute system has not been fully created yet |
| Other Windows `HRESULT` value | If something went wrong when creating the compute system, the return value here will give hints on what could have gone wrong |

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
