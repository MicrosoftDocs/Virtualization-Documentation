---
title: HcsSaveComputeSystem
description: HcsSaveComputeSystem
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsSaveComputeSystem
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsSaveComputeSystem

## Description

Saves the state of a compute system, see [sample code](./ComputeSystemSample.md#SaveCloseCS).

## Syntax

```cpp
HRESULT WINAPI
HcsSaveComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to save.

`operation`

The handle to the operation that tracks the save operation.

`options`

Optional JSON document of [SaveOptions](./../SchemaReference.md#SaveOptions) specifying save options.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md).


## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The compute system was saved successfully |
| `HCS_E_INVALID_STATE` | The compute system cannot be saved as it is still running |

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
