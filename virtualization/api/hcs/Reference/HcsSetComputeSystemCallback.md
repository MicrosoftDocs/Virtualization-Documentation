---
title: HcsSetComputeSystemCallback
description: HcsSetComputeSystemCallback
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsSetComputeSystemCallback
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetComputeSystemCallback

## Description

Registers a callback to receive notifications for the compute system, see [sample code](./AsyncModelSample.md#).

## Syntax

```cpp
HRESULT WINAPI
HcsSetComputeSystemCallback(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_EVENT_OPTIONS callbackOptions,
    _In_opt_ const void* context,
    _In_ HCS_EVENT_CALLBACK callback
    );
```

## Parameters

`computeSystem`

The handle to the compute system.

`callbackOptions`

The option for callback, using one from [HCS_EVENT_OPTIONS](./HCS_EVENT_OPTIONS.md).

`context`

Optional pointer to a context that is passed to the callback.

`callback`

The target [`HCS_EVENT_CALLBACK`](./HCS_EVENT_CALLBACK.md) for compute system events.

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