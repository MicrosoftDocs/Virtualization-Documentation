---
title: HcsEnumerateComputeSystemsInNamespace
description: HcsEnumerateComputeSystemsInNamespace
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsEnumerateComputeSystemsInNamespace
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsEnumerateComputeSystemsInNamespace

## Description

Enumerates existing compute systems in a given namespace.

## Syntax

```cpp
HRESULT WINAPI
HcsEnumerateComputeSystemsInNamespace(
    _In_ PCWSTR idNamespace,
    _In_opt_ PCWSTR query,
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`idNamespace`

The string contains the queried namespace.

`query`

Optional JSON document of [SystemQuery](./../SchemaReference.md#SystemQuery) specifying a query for specific compute systems.

`operation`

The handle to the operation that tracks the enumerate operation.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md)


## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The operation was finished successfully, the result document returned by the hcs operation is a JSON document representing an array of compute system [Properties](./../SchemaReference.md#Properties) |


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 2004 |
| **Minimum supported server** | Windows Server, version 2004 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
