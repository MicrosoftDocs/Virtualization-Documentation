---
title: HDV_PCI_DEVICE_INITIALIZE
description: HDV_PCI_DEVICE_INITIALIZE
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HDV_PCI_DEVICE_INITIALIZE
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HDV_PCI_DEVICE_INITIALIZE

## Description

Function invoked to initialize the emulated device. It is called as the VM is powered on.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_INITIALIZE)(
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
