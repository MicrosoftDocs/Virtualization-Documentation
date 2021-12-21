---
title: HDV_PCI_DEVICE_GET_DETAILS
description: HDV_PCI_DEVICE_GET_DETAILS
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_DEVICE_GET_DETAILS
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_DEVICE_GET_DETAILS

## Description

Function invoked to query the PCI description of the emulated device. This information is used when presenting the device to the guest partition.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_GET_DETAILS)(
    _In_opt_ void*           DeviceContext,
    _Out_    PHDV_PCI_PNP_ID PnpId,
    _Out_    UINT32          ProbedBars[HDV_PCI_BAR_COUNT]
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`DeviceContext` |Context pointer that was supplied to HdvCreateDeviceInstance|
|`PnpId` |Receives the vendor / device ID / ... information about the device|
|`BarCount`|Specifies the size of the output buffer provided in probedBars. It should be large enough to receive `HDV_MAX_PCI_BAR_COUNT` elements.|
|`ProbedBars` |Receives the results for probing the MMIO BARs.|
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
