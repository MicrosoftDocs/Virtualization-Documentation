---
title: HdvTeardownDeviceHost
description: HdvTeardownDeviceHost
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HdvTeardownDeviceHost
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HdvTeardownDeviceHost

## Description

Tears down the device emulator host in the caller's process. All device instances associated to the device host become non-functional.

## Syntax

```C++
HRESULT WINAPI
HdvTeardownDeviceHost(
    _In_ HDV_HOST DeviceHost
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceHost` |Handle to the device host to tear down.|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | Returned if function succeeds.|
|`HRESULT` | An error code is returned if the function fails.
|     |     |

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |
