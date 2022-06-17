---
title: HCS_EVENT_CALLBACK
description: HCS_EVENT_CALLBACK
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HCS_EVENT_CALLBACK
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCS_EVENT_CALLBACK

## Description

Function type for compute system event callbacks.

## Syntax

```cpp
typedef void (CALLBACK *HCS_EVENT_CALLBACK)(
    _In_ HCS_EVENT* event,
    _In_opt_ void* context
    );
```

## Parameters

`event`

Handle to the pointer of [`HCS_EVENT`](./HCS_EVENT.md).

`context`

Handle for context of callback.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
