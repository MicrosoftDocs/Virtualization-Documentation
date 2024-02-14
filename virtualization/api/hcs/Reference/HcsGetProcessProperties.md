---
title: HcsGetProcessProperties
description: HcsGetProcessProperties
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetProcessProperties
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetProcessProperties

## Description

Returns the properties of a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessProperties(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR propertyQuery
    );
```

## Parameters

`process`

The handle to the process to query.

`operation`

The handle to the operation that tracks the process.

`propertyQuery`

Optional JSON document of [ProcessStatus](./../SchemaReference.md#ProcessStatus) specifying the properties to query.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md).

## Operation Results

The return value of [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The process properties queried successfully, the result document returned by the hcs operation is a JSON document representing a process's [ProcessStatus](./../SchemaReference.md#ProcessStatus) |


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
