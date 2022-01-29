---
title: HcsWaitForProcessExit
description: HcsWaitForProcessExit
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 12/21/2021
api_name:
- HcsWaitForProcessExit
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsWaitForProcessExit

## Description

Waits for a process in a compute system to exit.

## Syntax

```cpp
HRESULT WINAPI
HcsWaitForProcessExit(
    _In_ HCS_PROCESS process,
    _In_ DWORD timeoutMs,
    _Outptr_opt_ PWSTR* result
    );
```

## Parameters

`process`

The handle to the process to exit.

`timeoutMs`

Time to wait in milliseconds for the process to exit.

`result`

JSON document of [ProcessStatus](./../SchemaReference.md#ProcessStatus).

The caller is responsible for releasing the returned string using [`LocalFree`](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree).

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 2104|
| **Minimum supported server** | Windows Server 2022 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
