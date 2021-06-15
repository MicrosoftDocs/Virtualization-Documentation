---
title: HcsWaitForOperationResult
description: HcsWaitForOperationResult
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsWaitForOperationResult

## Description

Similar to [`HcsGetOperationResult`](./HcsGetOperationResult.md), but additionally waits for the operation to complete the specified number of milliseconds. It is intended to be used when synchronous behavior is desired.

## Syntax

```cpp
HRESULT WINAPI
HcsWaitForOperationResult(
    _In_ HCS_OPERATION operation,
    _In_ DWORD timeoutMs,
    _Outptr_opt_ PWSTR* resultDocument
    );
```

## Parameters

`operation`

The handle to an active operation.

`timeoutMs`

Time to wait in milliseconds for the operation to complete.

`resultDocument`

If the operation finished, regardless of success or failure, receives the result document of the operation. The returned result document's JSON document is dependent on the HCS function that was being tracked by this operation. Not all functions that are tracked with operations return a result document. Refer to the remarks on the documentation for the HCS functions that use hcs operations for asynchronous tracking.


On failure, it can optionally receive an error JSON document represented by a [ResultError](./../SchemaReference.md#ResultError); it's not guaranteed to be always returned and depends on the function call the operation was tracking.


The caller is responsible for releasing the returned string using [`LocalFree`](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree).

## Return Values

|Value|Description|
|---|---|
|`S_OK`|The operation has completed successfully.|
|`HCS_E_OPERATION_NOT_STARTED`|The operation has not been started. This is expected when the operation has not been used yet in an HCS function that expects an `HCS_OPERATION` handle.|
|`HCS_E_OPERATION_TIMEOUT`|The operation didn't complete within the specified wait time.|
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
