---
title: HV_PORT_ID
description: HV_PORT_ID data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_PORT_ID

## Overview
Uniquely identifies a communication port within a partition’s port namespace.

## Syntax

```c
typedef union
{
    UINT32 AsUINT32;

    struct
    {
        UINT32 Id:24;
        UINT32 Reserved:8;
    };

} HV_PORT_ID;
```

### Fields
| Field | Bits | Description |
|-------|------|-------------|
| Id | 23:0 | Port identifier (caller supplies on create; uniqueness enforced per partition). |

## See Also
* [HvCallCreatePort](../hypercalls/HvCallCreatePort.md)
* [HvCallDeletePort](../hypercalls/HvCallDeletePort.md)
