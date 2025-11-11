---
title: HcsSetOperationContext
description: HcsSetOperationContext
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsSetOperationContext
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetOperationContext

## Description

Sets the context pointer on an operation.

## Syntax

```cpp
HRESULT WINAPI
HcsSetOperationContext(
    _In_     HCS_OPERATION operation
    _In_opt_ void*         context
    );


```

## Parameters

`operation`

The handle to an active operation.

`context`

Optional pointer to a context that is passed to the callback.

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
