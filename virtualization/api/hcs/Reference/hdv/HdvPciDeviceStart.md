---
title: HDV_PCI_DEVICE_START
description: HDV_PCI_DEVICE_START
author: sethm
ms.author: sethmanheim
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_DEVICE_START
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_DEVICE_START

## Description

Function called to notify the emulated device that the virtual processors of the VM are about to start.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_START)(
    _In_opt_ void* DeviceContext
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance|
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
