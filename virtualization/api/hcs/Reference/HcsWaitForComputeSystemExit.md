---
title: HcsWaitForComputeSystemExit
description: HcsWaitForComputeSystemExit
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 12/21/2021
api_name:
- HcsWaitForComputeSystemExit
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsWaitForComputeSystemExit

## Description

Waits for a compute system to exit.

## Syntax

```cpp
HRESULT WINAPI
HcsWaitForComputeSystemExit(
    _In_ HCS_SYSTEM computeSystem,
    _In_ DWORD timeoutMs,
    _Outptr_opt_ PWSTR* result
    );
```

## Parameters

`computeSystem`

The handle to the compute system to exit.

`timeoutMs`

Time to wait in milliseconds for the compute system to exit.

`result`

JSON document of [SystemExitStatus](./../SchemaReference.md#SystemExitStatus).

The caller is responsible for releasing the returned string using [`LocalFree`](/windows/win32/api/winbase/nf-winbase-localfree).

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
