---
title: HdvCreateDeviceInstance
description: HdvCreateDeviceInstance
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HdvCreateDeviceInstance
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HdvCreateDeviceInstance

## Description

Creates a device instance in the current host and associates it with a device emulation interface and context.

## Syntax

```C++
HRESULT WINAPI
HdvCreateDeviceInstance(
    _In_     HDV_HOST        DeviceHost,
    _In_     HDV_DEVICE_TYPE DeviceType,
    _In_     const GUID*     DeviceClassId,
    _In_     const GUID*     DeviceInstanceId,
    _In_     const VOID*     DeviceInterface,
    _In_opt_ void*           DeviceContext,
    _Out_    HDV_DEVICE*     DeviceHandle
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceHost` | Handle to the device host in which to create the new device.|
|`DeviceType` | Specifies the [HDV_DEVICE_TYPE](HdvDeviceType.md) type of the device instance to create.|
|`DeviceClassId` | Supplies the client-defined class ID of the device instance to create.|
|`DeviceInterface` | Supplies the client-defined instance ID of the device instance to create.|
|`DeviceInterface` | Supplies a function table representing the interface exposed by the device instance. The actual type of this parameter is implied by the DeviceType parameter.|
|`DeviceContext` | An optional opaque context pointer that will be supplied to the device instance callbacks.|
|`DeviceHandle` | Receives a handle to the created device instance.|
|     |     |

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
