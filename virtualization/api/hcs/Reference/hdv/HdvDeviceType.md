---
title: HDV_DEVICE_TYPE
description: HDV_DEVICE_TYPE
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HDV_DEVICE_TYPE
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HDV_DEVICE_TYPE

## Description

Discriminator for the Emulated device type.

## Syntax

```C++
typedef enum HDV_DEVICE_TYPE
{
    HdvDeviceTypeUndefined = 0,
    HdvDeviceTypePCI
} HDV_DEVICE_TYPE;
```

## Constants

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| HdvDeviceTypeUndefined | null |
| HdvDeviceTypePCI | null |
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
