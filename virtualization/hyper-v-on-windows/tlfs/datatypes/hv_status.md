---
title: HV_STATUS
description: HV_STATUS
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/03/2026
ms.topic: reference
ai-usage: ai-assisted
---

# HV_STATUS

Status codes for hypervisor operations.

## Syntax

```c
typedef UINT16 HV_STATUS;
```

## HV_STATUS status code values

The following table lists the `HV_STATUS` values that this specification defines:

| HV_STATUS constant | Hexadecimal value | Operation result |
|------|-------|---------|
| `HV_STATUS_SUCCESS` | `0x0000` | The operation succeeded. |
| `HV_STATUS_INVALID_HYPERCALL_CODE` | `0x0002` | The hypercall code is not recognized or supported. |
| `HV_STATUS_INVALID_HYPERCALL_INPUT` | `0x0003` | The hypercall input value has an invalid encoding. |
| `HV_STATUS_INVALID_ALIGNMENT` | `0x0004` | An input or output parameter has an invalid alignment. |
| `HV_STATUS_INVALID_PARAMETER` | `0x0005` | A parameter is invalid. |
| `HV_STATUS_ACCESS_DENIED` | `0x0006` | Access to the requested operation or object is denied. |
| `HV_STATUS_INVALID_PARTITION_STATE` | `0x0007` | The partition is in a state that does not permit the operation. |
| `HV_STATUS_INVALID_PARTITION_ID` | `0x000D` | The partition identifier is invalid. |
| `HV_STATUS_INVALID_VP_INDEX` | `0x000E` | The virtual processor index is invalid. |
| `HV_STATUS_INVALID_PORT_ID` | `0x0011` | The port identifier is invalid. |
| `HV_STATUS_INVALID_CONNECTION_ID` | `0x0012` | The connection identifier is invalid. |
| `HV_STATUS_INSUFFICIENT_BUFFERS` | `0x0013` | There are insufficient buffers for the operation. |
| `HV_STATUS_INVALID_VP_STATE` | `0x0015` | The virtual processor is in a state that does not permit the operation. |
| `HV_STATUS_INVALID_SYNIC_STATE` | `0x0018` | The synthetic interrupt controller is in a state that does not permit the operation. |
| `HV_STATUS_INVALID_REGISTER_VALUE` | `0x0050` | A register value is invalid. |
| `HV_STATUS_INVALID_VTL_STATE` | `0x0051` | A virtual trust level is in a state that does not permit the operation. |

Other status values may be returned. Software must not assume that this table is exhaustive.

## Related content

* [Hypercall Status Codes](../hypercall-interface.md#hypercall-status-codes)
