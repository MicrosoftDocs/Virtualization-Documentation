---
title: HDV_PCI_READ_INTERCEPTED_MEMORY
description: HDV_PCI_READ_INTERCEPTED_MEMORY
author: sethm
ms.authore: sethmanheim
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_READ_INTERCEPTED_MEMORY
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_READ_INTERCEPTED_MEMORY

## Description

Function called to execute an intercepted MMIO read for the emulated device.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_READ_INTERCEPTED_MEMORY)(
    _In_opt_             void*                DeviceContext,
    _In_                 HDV_PCI_BAR_SELECTOR BarIndex,
    _In_                 UINT64               Offset,
    _In_                 UINT64               Length,
    _Out_writes_(Length) BYTE*                Value
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance.|
|`BarIndex` |Index to the BAR the read operation pertains to.|
|`Offset` |Offset in bytes from the base of the BAR to read.|
|`Length` |Length in bytes to read (1 / 2 / 4 / 8 bytes).|
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
