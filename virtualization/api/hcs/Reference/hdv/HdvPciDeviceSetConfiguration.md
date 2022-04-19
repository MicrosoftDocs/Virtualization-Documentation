---
title: HDV_PCI_DEVICE_SET_CONFIGURATION
description: HDV_PCI_DEVICE_SET_CONFIGURATION
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_DEVICE_SET_CONFIGURATION
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_DEVICE_SET_CONFIGURATION

## Description

Function invoked to set the configuration of the emulated device.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_SET_CONFIGURATION)(
    _In_opt_ void*         DeviceContext,
    _In_     UINT32        ConfigurationValueCount,
    _In_     const PCWSTR* ConfigurationValues
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance|
|`ConfigurationValueCount` |Number of elements in the ConfigurationValues array|
|`ConfigurationValues` |Array with strings representing the configurations values. These strings are provided in the VM's configuration.|
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
