---
title: HDV_PCI_PNP_ID structure
description: HDV_PCI_PNP_ID structure
author: sethm
ms.author: sethmanheim
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_PNP_ID structure
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_PNP_ID structure

PnP ID definition for a virtual device.

## Syntax

```C++
typedef struct HDV_PCI_PNP_ID
{
    UINT16 VendorID;
    UINT16 DeviceID;
    UINT8  RevisionID;
    UINT8  ProgIf;
    UINT8  SubClass;
    UINT8  BaseClass;
    UINT16 SubVendorID;
    UINT16 SubSystemID;

} HDV_PCI_PNP_ID, *PHDV_PCI_PNP_ID;
```

## Members

`VendorID`

Vendor ID (lowest two types of config space).

`DeviceID`

Device ID (offset 0x4 of config space).

`RevisionID`

Device Revision ID (offset 0x8 of config space).

`ProgIf`

Programable interface ID (offset 0x9 of config space).

`SubClass`

Sub-class code of device (offset 0xA of config space).

`BaseClass`

Base class code of device (offset 0xB of config space).

`SubVendorID`

Subsystem vendor ID of device (offset 0x2C of config space).

`SubSystemID`

Subsystem ID of device (offset 0x2E of config space).

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |