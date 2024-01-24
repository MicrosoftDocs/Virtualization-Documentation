---
title: HdvUnregisterDoorbell function
description: HdvUnregisterDoorbell function
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HdvUnregisterDoorbell
api_location:
- vmdevicehost.dll
api_type:
- DllExport
topic_type: 
- apiref
---

# HdvUnregisterDoorbell function

Unregisters a doorbell notification.


## Syntax

```C++
HRESULT
WINAPI
HdvUnregisterDoorbell(
    HDV_DEVICE Requestor,
    HDV_PCI_BAR_SELECTOR BarIndex,
    UINT64 BarOffset,
    UINT64 TriggerValue,
    UINT64 Flags
    );
```

## Parameters

`Requestor`

A void pointer representing a handle to the device requesting to unregister the doorbell.

`BarIndex`

A [HDV_PCI_BAR_SELECTOR](HdvPciBarSelector.md) specifying index of the BAR containing the address to unregister.

`BarOffset`

The address offset within the BAR.

`TriggerValue`

The value that when written will trigger the doorbell.

`Flags`

Specifies doorbell behaviors.


## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | vmdevicehost.lib |
| **Dll** | vmdevicehost.dll |

