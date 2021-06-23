---
title: HdvInitializeDeviceHost function
description: HdvInitializeDeviceHost function
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
---

# HdvInitializeDeviceHost function

Initializes a device emulator host in the caller’s process and associates it with the specified compute system.


## Syntax

```C++
HRESULT WINAPI
HdvInitializeDeviceHost(
    _In_  HCS_SYSTEM ComputeSystem,
    _Out_ HDV_HOST*  DeviceHost
    );
```

## Parameters

`ComputeSystem`

Handle to the compute system of the VM in which the device is used. The VM’s configuration must indicate that an external device host for the VM will be present.

`DeviceHost`

Receives the handle to the device emulator host for the VM.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |