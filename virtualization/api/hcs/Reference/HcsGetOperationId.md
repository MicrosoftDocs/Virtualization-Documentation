---
title: HcsGetOperationId
description: HcsGetOperationId
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsGetOperationId
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsGetOperationId

## Description

Returns the Id that uniquely identifies an operation.

## Syntax

```cpp
UINT64 WINAPI
HcsGetOperationId(
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`operation`

The handle to an active operation.

## Return Values

If the function succeeds, the return value is the operation's Id.

If the operation is invalid, the return value is `HCS_INVALID_OPERATION_ID`.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
