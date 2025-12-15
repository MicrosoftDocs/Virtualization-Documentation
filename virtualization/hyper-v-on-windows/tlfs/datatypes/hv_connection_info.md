---
title: HV_CONNECTION_INFO
description: HV_CONNECTION_INFO data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_CONNECTION_INFO

## Overview
Per-connection type descriptor used when establishing a connection (`HvCallConnectPort`). Only the union member matching `PortType` is interpreted; other members are zero.

## Syntax

```c
typedef enum
{
    HvPortTypeDoorbell  = 4,
} HV_PORT_TYPE;

typedef struct
{
    HV_PORT_TYPE PortType;
    UINT32 Padding;

    union
    {
        struct
        {
            HV_GPA GuestPhysicalAddress;
            UINT64 TriggerValue;
            UINT64 Flags;
        } DoorbellConnectionInfo;
    };
} HV_CONNECTION_INFO;
```

### Port Types

| Enum | Value | Meaning | Use Cases |
|------|-------|---------|-----------|
| HvPortTypeDoorbell | 4 | Lightweight guest doorbell (write / trigger semantics) | Low latency memory-mapped notifications. |

### Connection Type Details

#### Doorbell Connections (HvPortTypeDoorbell)
**Purpose**: Memory-mapped notification mechanism with configurable trigger semantics.
**Configuration**:
- `GuestPhysicalAddress`: Target memory location for write operations
- `TriggerValue`: Expected value to trigger the doorbell (when using specific value matching)
- `Flags`: Controls trigger behavior and access pattern

### Doorbell Flags Configuration

| Flag | Value | Description |
|------|-------|-------------|
| HV_DOORBELL_FLAG_TRIGGER_SIZE_ANY | 0x00000000 | Trigger on any write operation regardless of size |
| HV_DOORBELL_FLAG_TRIGGER_SIZE_BYTE | 0x00000001 | Trigger only on 1-byte writes |
| HV_DOORBELL_FLAG_TRIGGER_SIZE_WORD | 0x00000002 | Trigger only on 2-byte writes |
| HV_DOORBELL_FLAG_TRIGGER_SIZE_DWORD | 0x00000003 | Trigger only on 4-byte writes |
| HV_DOORBELL_FLAG_TRIGGER_SIZE_QWORD | 0x00000004 | Trigger only on 8-byte writes |
| HV_DOORBELL_FLAG_TRIGGER_ANY_VALUE | 0x80000000 | Trigger on any written value (ignore TriggerValue) |

**Flag Combinations**:
- **Size-specific + value-specific**: Triggers only when the exact size and value match
- **Size-specific + HV_DOORBELL_FLAG_TRIGGER_ANY_VALUE**: Triggers on any write of the specified size
- **HV_DOORBELL_FLAG_TRIGGER_SIZE_ANY + value-specific**: Triggers when any write matches the value
- **HV_DOORBELL_FLAG_TRIGGER_SIZE_ANY + HV_DOORBELL_FLAG_TRIGGER_ANY_VALUE**: Triggers on any write operation

### Restrictions and Limitations
* **Doorbell connections**:
  - Must not cross page boundaries
  - Target GPA must be valid and accessible

## See Also
* [HvCallConnectPort](../hypercalls/HvCallConnectPort.md)
* [HV_PORT_TYPE](hv_port_type.md)
