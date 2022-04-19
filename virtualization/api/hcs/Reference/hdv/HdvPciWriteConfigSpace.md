---
title: HDV_PCI_WRITE_CONFIG_SPACE
description: HDV_PCI_WRITE_CONFIG_SPACE
author: faymeng
ms.author: mabriggs
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_WRITE_CONFIG_SPACE
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_WRITE_CONFIG_SPACE

## Description

Function called to execute a write to the emulated device's PCI config space.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_WRITE_CONFIG_SPACE)(
    _In_opt_ void*  DeviceContext,
    _In_     UINT32 Offset,
    _In_     UINT32 Value
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance.|
|`Offset` |Offset in bytes from the base of the bar to write.|
|`Value` |Value to write.|
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
