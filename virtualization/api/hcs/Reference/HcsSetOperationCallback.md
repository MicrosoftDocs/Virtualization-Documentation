---
title: HcsSetOperationCallback
description: HcsSetOperationCallback
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HcsSetOperationCallback
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetOperationCallback

## Description

Sets a callback that is invoked on completion of an operation.

## Syntax

```cpp
HRESULT WINAPI
HcsSetOperationCallback(
    _In_ HCS_OPERATION operation,
    _In_opt_ const void* context,
    _In_ HCS_OPERATION_COMPLETION callback
    );
```

## Parameters

`operation`

The handle to an active operation.

`context`

Optional pointer to a context that is passed to the callback.

`callback`

The target [`HCS_OPERATION_COMPLETION`](./HCS_OPERATION_COMPLETION.md) callback that is invoked on completion of an operation.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |