---
title: HDV_DEVICE_TYPE Structure
description: HDV_DEVICE_TYPE Structure
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
---
# HDV_DEVICE_TYPE Structure

Device emulation callbacks for PCI devices, passed by the emulated device to HdvCreateDeviceInstance.

## Syntax

```C++
typedef struct HDV_PCI_DEVICE_INTERFACE
{
    HDV_PCI_INTERFACE_VERSION Version;
    HDV_PCI_DEVICE_INITIALIZE Initialize;
    HDV_PCI_DEVICE_TEARDOWN Teardown;
    HDV_PCI_DEVICE_SET_CONFIGURATION SetConfiguration;
    HDV_PCI_DEVICE_GET_DETAILS GetDetails;
    HDV_PCI_DEVICE_START Start;
    HDV_PCI_DEVICE_STOP Stop;
    HDV_PCI_READ_CONFIG_SPACE ReadConfigSpace;
    HDV_PCI_WRITE_CONFIG_SPACE WriteConfigSpace;
    HDV_PCI_READ_INTERCEPTED_MEMORY ReadInterceptedMemory;
    HDV_PCI_WRITE_INTERCEPTED_MEMORY WriteInterceptedMemory;
} HDV_PCI_DEVICE_INTERFACE, *PHDV_PCI_DEVICE_INTERFACE;
```

## Members

`Version`

Version.

`Initialize`

Version.

`Teardown`

Version.

`SetConfiguration`

Version.

`GetDetails`

Version.

`Start`

Version.

`Stop`

Version.

`ReadConfigSpace`

Version.

`WriteConfigSpace`

Version.

`ReadInterceptedMemory`

Version.

`WriteInterceptedMemory`

Version.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |