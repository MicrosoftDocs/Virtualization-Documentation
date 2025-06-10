---
title: HcsCancelOperation
description: HcsCancelOperation
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsCancelOperation
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsCancelOperation

## Description

Cancel the operation, optionally waiting for any in-progress callbacks to complete.

## Syntax

```cpp
HRESULT WINAPI
HcsCancelOperation (
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`operation`

The handle to an active operation.


## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Remarks

This function is not currently implemented and will always return an `E_NOTIMPL` HRESULT value.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
