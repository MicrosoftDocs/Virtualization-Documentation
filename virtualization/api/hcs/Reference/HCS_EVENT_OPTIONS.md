---
title: HCS_EVENT_OPTIONS
description: HCS_EVENT_OPTIONS
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HCS_EVENT_OPTIONS

## Description

Defines the options for an event callback registration, used in [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) and [HcsSetProcessCallback](./HcsSetProcessCallback.md).

## Syntax

```cpp
typedef enum HCS_EVENT_OPTIONS
{
    HcsEventOptionNone = 0x00000000,
    HcsEventOptionEnableOperationCallbacks = 0x00000001
} HCS_EVENT_OPTIONS;
```

## Constants

|||
|---|---|
|`HcsEventOptionNone`|No special event options.|
|`HcsEventOptionEnableOperationCallbacks`|Enables `HcsEventOperationCallback` [event type](./HCS_EVENT_TYPE.md) in the callback supplied in [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) and [HcsSetProcessCallback](./HcsSetProcessCallback.md). This allows for a compute system handle or compute process handle to get notified when the operation used to track the function call completes. When event operation completion callbacks are enabled, hcs operations with callbacks are not allowed when calling HCS functions that require an operation handle. Such function calls will fail with `HCS_E_OPERATION_SYSTEM_CALLBACK_ALREADY_SET`.|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
