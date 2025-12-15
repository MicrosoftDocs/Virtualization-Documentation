---
title: HV_PORT_TYPE
description: HV_PORT_TYPE data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_PORT_TYPE

HV_PORT_TYPE specifies the type of communication port being created or used for inter-partition communication.

## Syntax

```c
typedef enum
{
    HvPortTypeDoorbell  = 4,
} HV_PORT_TYPE;
```

The port type determines the communication semantics and capabilities of the port.

**Port Type Descriptions:**
- **HvPortTypeDoorbell (4)**: Used for low latency notification mechanism.

## See Also
* [HvCallCreatePort](../hypercalls/HvCallCreatePort.md)
* [HvCallConnectPort](../hypercalls/HvCallConnectPort.md)
* [HV_CONNECTION_INFO](hv_connection_info.md)