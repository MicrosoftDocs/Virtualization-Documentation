---
title: HCN_PORT_ACCESS
description: HCN_PORT_ACCESS
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HCN_PORT_ACCESS
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_PORT\_ACCESS

## Description

The type of access required for a port reservation.

## Syntax

```cpp
typedef enum tagHCN_PORT_ACCESS
{
    HCN_PORT_ACCESS_EXCLUSIVE = 0x01,
    HCN_PORT_ACCESS_SHARED = 0x02
} HCN_PORT_ACCESS;
```


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

