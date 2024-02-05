---
title: HcsModifyProcess
description: HcsModifyProcess
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsModifyProcess
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsModifyProcess

## Description

Modifies the parameters of a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsModifyProcess(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_ PCWSTR settings
    );
```

## Parameters

`process`

Handle to the process to modify.

`operation`

Handle to the operation that tracks the process.

`settings`

JSON document of [ProcessModifyRequest](./../SchemaReference.md#ProcessModifyRequest) specifying the settings of process to modify.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md).


## Operation Results

The return value of [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The process parameters changed successfully |

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
