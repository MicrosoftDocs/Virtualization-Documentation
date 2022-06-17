---
title: HcsCreateOperation
description: HcsCreateOperation
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HcsCreateOperation
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsCreateOperation

## Description

Creates a new operation.

## Syntax

```cpp
HCS_OPERATION WINAPI
HcsCreateOperation(
    _In_opt_ HCS_OPERATION_COMPLETION callback
    _In_opt_ void*                    context
    );
```

## Parameters

`callback`

Optional pointer to an [`HCS_OPERATION_COMPLETION`](./HCS_OPERATION_COMPLETION.md) callback to be invoked when the operation completes.

`context`

Optional pointer to a context that is passed to the callback.

## Return Values

Returns the `HCS_OPERATION` handle to the newly created operation on success, `NULL` if resources required for the operation couldn't be allocated. It is the responsibility of the caller to release the operation using [`HcsCloseOperation`](./HcsCloseOperation.md) once it is no longer used.

## Remarks

Refer to the async model sample code for details on how to use HCS operations.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |