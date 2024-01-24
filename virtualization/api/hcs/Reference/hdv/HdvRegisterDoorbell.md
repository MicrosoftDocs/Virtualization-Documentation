---
title: HdvRegisterDoorbell function
description: HdvRegisterDoorbell function
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HdvRegisterDoorbell
api_location:
- vmdevicehost.dll
api_type:
- DllExport
topic_type: 
- apiref
---

# HdvRegisterDoorbell function

Registers a guest address to trigger an event on writes. The value of the write will be discarded.


## Syntax

```C++
HRESULT
WINAPI
HdvRegisterDoorbell(
    HDV_DEVICE Requestor,
    HDV_PCI_BAR_SELECTOR BarIndex,
    UINT64 BarOffset,
    UINT64 TriggerValue,
    UINT64 Flags,
    HANDLE DoorbellEvent
    );
```

## Parameters

`Requestor`

A void pointer representing a handle to the device requesting the doorbell.

`BarIndex`

A [HDV_PCI_BAR_SELECTOR](HdvPciBarSelector.md) specifying index of the BAR containing the address to register.

`BarOffset`

The address offset within the BAR.

`TriggerValue`

The value that when written will trigger the doorbell.

`Flags`

Specifies doorbell behaviors.

`DoorbellEvent`

Handle to the event to signal.


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