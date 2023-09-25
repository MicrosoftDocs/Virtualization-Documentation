---
title: HdvInitializeDeviceHostForProxy function
description: HdvInitializeDeviceHostForProxy function
author: sethm
ms.author: sethmanheim
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HdvInitializeDeviceHostForProxy function
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---

# HdvInitializeDeviceHostForProxy function

Initializes the device emulator host in the caller's process and associates it with the specified proxy. The proxy is responsible for associating with the compute system. A successfull call to **HdvInitializeDeviceHostForProxy must** be balanced by a call to [HdvTeardownDeviceHost](HdvTeardownDeviceHost.md) on the same thread.


## Syntax

```C++
HRESULT WINAPI
HdvInitializeDeviceHostForProxy(
    _In_ const GUID* VmId,
    _In_ PVOID ProxyInterface_IUnknown,
    _Out_ HDV_HOST* DeviceHostHandle
    );
```

## Parameters

`VmId`

The unique identifier of the compute system.

`ProxyInterface_IUnknown`

The interface used to communicate with the proxy.

`DeviceHostHandle`

A void pointer that receives a handle to the created device host.

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