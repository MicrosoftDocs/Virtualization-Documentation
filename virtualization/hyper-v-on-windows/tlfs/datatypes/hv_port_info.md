---
title: HV_PORT_INFO
description: HV_PORT_INFO data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_PORT_INFO

## Overview
Type-specific configuration used with `HvCallCreatePort` to define a new port object. Only the active union member is consumed based on `PortType`; other union members are zero. Structure size is 24 bytes.

## Syntax

```c
typedef struct
{
    HV_PORT_TYPE PortType;
    UINT32       Padding;

    union
    {
        struct
        {
            HV_SYNIC_SINT_INDEX TargetSint;
            HV_VP_INDEX         TargetVp;
            UINT64              RsvdZ;
        } DoorbellPortInfo;
    };
} HV_PORT_INFO;
```

### Field Summary
| Field | Offset | Size | Description |
|-------|--------|------|-------------|
| DoorbellPortInfo.TargetSint | 8 | 1 | SINT (1..N-1). |
| DoorbellPortInfo.TargetVp | 9 | 4 | Target VP / ANY. |
| DoorbellPortInfo.RsvdZ | 13 | 11 | Zero (reserved; ignored). |

## See Also
* [HvCallCreatePort](../hypercalls/HvCallCreatePort.md)
* [HvCallConnectPort](../hypercalls/HvCallConnectPort.md)
* [HV_CONNECTION_INFO](hv_connection_info.md)
