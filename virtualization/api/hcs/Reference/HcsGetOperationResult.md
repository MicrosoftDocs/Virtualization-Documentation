---
title: HcsGetOperationResult
description: HcsGetOperationResult
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetOperationResult
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetOperationResult

## Description

Gets the result of the operation used to track an HCS function; optionally returns a JSON document associated to such tracked operation.

## Syntax

```cpp
HRESULT WINAPI
HcsGetOperationResult(
    _In_ HCS_OPERATION operation,
    _Outptr_opt_ PWSTR* resultDocument
    );
```

## Parameters

`operation`

The handle to an active operation.

`resultDocument`

If the operation finished, regardless of success or failure, receives the result document of the operation. The returned result document's JSON document is dependent on the HCS function that was being tracked by this operation. Not all functions that are tracked with operations return a result document. Refer to the remarks on the documentation for the HCS functions that use hcs operations for asynchronous tracking.


On failure, it can optionally receive an error JSON document represented by a [ResultError](./../SchemaReference.md#ResultError); it's not guaranteed to be always returned and depends on the function call the operation was tracking.


The caller is responsible for releasing the returned string using [`LocalFree`](/windows/win32/api/winbase/nf-winbase-localfree).

## Return Values

|Value|Description|
|---|---|
|`S_OK`|The operation has completed successfully.|
|`HCS_E_OPERATION_NOT_STARTED`|The operation has not been started. This is expected when the operation has not been used yet in an HCS function that expects an `HCS_OPERATION` handle.|
|`HCS_E_OPERATION_PENDING`|The operation is still in progress and hasn't been completed, regardless of success or failure.|
|Any other failure [`HRESULT`](./HCSHResult.md) value|The operation completed with failures. The returned `HRESULT` is dependent on the HCS function thas was being tracked.|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
