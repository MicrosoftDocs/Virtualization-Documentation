---
title: HcsSetProcessCallback
description: HcsSetProcessCallback
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsSetProcessCallback
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetProcessCallback

## Description

Registers a callback function to receive notifications for a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsSetProcessCallback(
    _In_ HCS_PROCESS process,
    _In_ HCS_EVENT_OPTIONS callbackOptions,
    _In_ void* context,
    _In_ HCS_EVENT_CALLBACK callback
    );
```

## Parameters

`process`

The handle to the process for that the callback is registered.

`callbackOptions`

The option for callback, using [HCS_EVENT_OPTIONS](./HCS_EVENT_OPTIONS.md).

`context`

Optional pointer to a context that is passed to the callback.

`callback`

Callback function that is invoked for events on the process.

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
