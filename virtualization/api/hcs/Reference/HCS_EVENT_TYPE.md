---
title: HCS_EVENT_TYPE
description: HCS_EVENT_TYPE
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HCS_EVENT_TYPE
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCS_EVENT_TYPE

## Description

Events indicated to callbacks registered by [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) or [HcsSetProcessCallback](./HcsSetProcessCallback.md).

## Syntax

```cpp
typedef enum HCS_EVENT_TYPE
{
    HcsEventInvalid = 0x00000000,
    HcsEventSystemExited = 0x00000001,
    HcsEventSystemCrashInitiated = 0x00000002,
    HcsEventSystemCrashReport = 0x00000003,
    HcsEventSystemRdpEnhancedModeStateChanged = 0x00000004,
    HcsEventSystemSiloJobCreated = 0x00000005,
    HcsEventSystemGuestConnectionClosed = 0x00000006,
    HcsEventProcessExited = 0x00010000,
    HcsEventOperationCallback = 0x01000000,
    HcsEventServiceDisconnect = 0x02000000
} HCS_EVENT_TYPE;
```

## Constants

|Name|Description|
|---|---|
|`HcsEventInvalid`|The event is invalid.|
|`HcsEventSystemExited`|The notification of `HCS_SYSTEM` handle for system exited.|
|`HcsEventSystemCrashInitiated`|The notification of `HCS_SYSTEM` handle for crash initiated.|
|`HcsEventSystemCrashReport`|The notification of `HCS_SYSTEM` handle for crash report.|
|`HcsEventSystemRdpEnhancedModeStateChanged`|The notification of `HCS_SYSTEM` handle for Rdp enhanced mode state changed.|
|`HcsEventSystemSiloJobCreated`|Reserved For Future Use.|
|`HcsEventSystemGuestConnectionClosed`|The notification of `HCS_SYSTEM` handle for guest connection closed.|
|`HcsEventProcessExited`|The notification of `HCS_PROCESS` handle for process exited.|
|`HcsEventOperationCallback`|The notification of call-back operation.|
|`HcsEventServiceDisconnect`|The notification of service disconnect.|

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
