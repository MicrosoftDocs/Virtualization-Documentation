---
title: HCN_PORT_PROTOCOL
description: HCN_PORT_PROTOCOL
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HCN_PORT_PROTOCOL
api_location:
- computenetwork.dlll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_PORT\_PROTOCOL

## Description

The protocol for a reservation.

## Syntax

```cpp
typedef enum tagHCN_PORT_PROTOCOL
{
    HCN_PORT_PROTOCOL_TCP = 0x01,
    HCN_PORT_PROTOCOL_UDP = 0x02,
    HCN_PORT_PROTOCOL_BOTH = 0x03
} HCN_PORT_PROTOCOL;

```

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

