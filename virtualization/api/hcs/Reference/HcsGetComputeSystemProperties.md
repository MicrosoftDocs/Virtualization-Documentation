---
title: HcsGetComputeSystemProperties
description: HcsGetComputeSystemProperties
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetComputeSystemProperties
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetComputeSystemProperties

## Description

Returns properties of a compute system, see [sample code](./tutorial.md) for simple example.

## Syntax

```cpp
HRESULT WINAPI
HcsGetComputeSystemProperties(
    _In_  HCS_SYSTEM computeSystem,
    _In_  HCS_OPERATION operation,
    _In_opt_ PCWSTR propertyQuery
    );
```

## Parameters

`computeSystem`

The handle to the compute system to query.

`operation`

The handle to the operation that tracks the query operation.

`propertyQuery`

Optional JSON document of [System_PropertyQuery](./../SchemaReference.md#System_PropertyQuery) specifying the properties to query.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md)

## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The operation was finished successfully, the result document returned by the hcs operation is a JSON document representing a compute system's [Properties](./../SchemaReference.md#Properties). Compute system Id and [SystemType](./../SchemaReference.md#SystemType) will always be returned.|

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
