---
title: HV_X64_REGISTER_INTERCEPT_MESSAGE
description: Payload for an x64 virtual processor register intercept
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_X64_REGISTER_INTERCEPT_MESSAGE

`HV_X64_REGISTER_INTERCEPT_MESSAGE` defines the x64 payload for `HvMessageTypeRegisterIntercept` (`0x80010006`). The payload identifies the
virtual processor register and specifies the associated operand information. Register intercepts may be delivered to the parent partition
or a higher VTL.

Architecture: x64 only.

## Syntax

```c
typedef struct
{
    HV_X64_INTERCEPT_MESSAGE_HEADER Header;
    struct
    {
        UINT8 IsMemoryOp:1;
        UINT8 Reserved:7;
    };
    UINT8 Reserved8;
    UINT16 Reserved16;
    HV_REGISTER_NAME RegisterName;
    HV_X64_REGISTER_ACCESS_INFO AccessInfo;
} HV_X64_REGISTER_INTERCEPT_MESSAGE;
```

## Layout

| Offset | Size | Field | Description |
|--------|------|-------|-------------|
| 0 | 40 | `Header` | Common x64 intercept context, including the access direction. Hardware-isolated partitions do not disclose the full architectural state in this header. |
| 40 | 1 | `IsMemoryOp`, `Reserved` | If `IsMemoryOp` is set, the operand is a memory operand. If clear, the operand is a value or register. The remaining bits are reserved; software must ignore them. |
| 41 | 1 | `Reserved8` | Reserved. Software must ignore this field. |
| 42 | 2 | `Reserved16` | Reserved. Software must ignore this field. |
| 44 | 4 | `RegisterName` | Virtual processor register being accessed. |
| 48 | 16 | `AccessInfo` | Direction-dependent source or destination information. |

The structure is 64 bytes and has 16-byte alignment.

## Operand interpretation

`Header.InterceptAccessType` and `IsMemoryOp` jointly select the valid `AccessInfo` member:

| Access type | `IsMemoryOp` | Valid member |
|-------------|--------------|--------------|
| `HV_INTERCEPT_ACCESS_WRITE` | 0 | `AccessInfo.SourceValue` |
| `HV_INTERCEPT_ACCESS_WRITE` | 1 | `AccessInfo.SourceAddress` (not currently supplied) |
| `HV_INTERCEPT_ACCESS_READ` | 0 | `AccessInfo.DestinationRegister` |
| `HV_INTERCEPT_ACCESS_READ` | 1 | `AccessInfo.DestinationAddress` (not currently supplied) |

For a write intercept, `RegisterName` specifies the destination register. For a read intercept, it specifies the source register.
The field contains an `HV_REGISTER_NAME`, not an architectural MSR index.

A value of zero in `AccessInfo.DestinationRegister` indicates that no read destination is specified. In this field, zero must not be
interpreted as a register name.

## Delivery semantics

An explicitly configured register intercept normally has fault semantics: the intercepted access has not completed. Guest crash register
notifications on isolated x64 partitions have trap semantics and do not require an explicitly installed parent-partition intercept.
A register-intercept message does not, by itself, indicate that the intercepted instruction remains to be emulated.

## See also

* [HV_X64_REGISTER_ACCESS_INFO](hv_x64_register_access_info.md)
* [HV_REGISTER_NAME](hv_register_name.md)
* [HV_REGISTER_VALUE](hv_register_value.md)
* [HV_MESSAGE_TYPE](hv_message_type.md)
