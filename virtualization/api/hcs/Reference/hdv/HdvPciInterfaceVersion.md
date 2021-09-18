---
title: HDV_PCI_INTERFACE_VERSION Enumeration
description: HDV_PCI_INTERFACE_VERSION Enumeration
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HDV_PCI_INTERFACE_VERSION Enumeration
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HDV_PCI_INTERFACE_VERSION Enumeration

Discriminator for the PCI device version.

## Syntax

```C++
typedef enum
{
    HdvPciDeviceInterfaceVersionInvalid = 0,
    HdvPciDeviceInterfaceVersion1 = 1

} HDV_PCI_INTERFACE_VERSION;
```

## Constants

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| HdvPciDeviceInterfaceVersionInvalid | null |
| HdvPciDeviceInterfaceVersion1 | null |
|    |    |

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |