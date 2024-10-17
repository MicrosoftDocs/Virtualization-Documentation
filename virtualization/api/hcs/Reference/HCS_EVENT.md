---
title: HCS_EVENT
description: HCS_EVENT
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HCS_EVENT
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCS_EVENT

## Description

The struct provides information about an event that occurred on a compute system or process.

## Syntax

```cpp
typedef struct HCS_EVENT
{
    HCS_EVENT_TYPE Type;
    PCWSTR EventData;
    HCS_OPERATION Operation;
} HCS_EVENT;
```

## Members


`Type`

Type of event [`HCS_EVENT_TYPE`](./HCS_EVENT_TYPE.md)

`EventData`

Optionally provides additional data for the event as a JSON document. The following table shows expected documents for specific event types.

|Event Type|JSON Document|
|---|---|
|`HcsEventSystemExited`|[`SystemExitStatus`](../SchemaReference.md#SystemExitStatus)|
|`HcsEventSystemCrashInitiated`|[`CrashReport`](../SchemaReference.md#CrashReport)|
|`HcsEventSystemCrashReport`|[`CrashReport`](../SchemaReference.md#CrashReport)|
|`HcsEventProcessExited`|[`ProcessStatus`](../SchemaReference.md#ProcessStatus)|

`Operation`

Handle to a completed operation, if `Type` is `HcsEventOperationCallback`. This is only possible when [`HcsSetComputeSystemCallback`](./HcsSetComputeSystemCallback.md) has specified event option `HcsEventOptionEnableOperationCallbacks`.


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
