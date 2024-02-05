---
title: HdvProxyDeviceHost function
description: HdvProxyDeviceHost function
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.date: 06/09/2021
api_name:
- HdvProxyDeviceHost
api_location:
- vmdevicehost.dll
api_type:
- DllExport
topic_type: 
- apiref
---

# HdvProxyDeviceHost function

Register a device host from another process with the compute system.


## Syntax

```C++
HRESULT
WINAPI
HdvProxyDeviceHost(
    HCS_SYSTEM ComputeSystem,
    _In_ PVOID DeviceHost_IUnknown,
    DWORD TargetProcessId,
    _Out_ UINT64* IpcSectionHandle
    );
```

## Parameters

`ComputeSystem`

Handle to the compute system to which the device host will be associated.

`DeviceHost_IUnknown`

A [HDV_PCI_BAR_SELECTOR](HdvPciBarSelector.md) specifying index of the BAR containing the address to register.

`TargetProcessId`

The ID of the process containing the device host.

`IpcSectionHandle`

Receives the IPC handle to return to remote process.


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
