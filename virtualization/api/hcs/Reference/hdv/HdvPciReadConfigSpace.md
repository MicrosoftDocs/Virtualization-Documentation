---
title: HDV_PCI_READ_CONFIG_SPACE
description: HDV_PCI_READ_CONFIG_SPACE
author: sethm
ms.authore: sethmanheim
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_READ_CONFIG_SPACE
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_READ_CONFIG_SPACE

## Description

Function called to execute a read into the emulated device's PCI config space.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_READ_CONFIG_SPACE)(
    _In_opt_ void*   DeviceContext,
    _In_     UINT32  Offset,
    _Out_    UINT32* Value
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance.|
|`Offset` |Offset in bytes from the base of the bar to read.|
|`Value` |Receives the read value.|
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
