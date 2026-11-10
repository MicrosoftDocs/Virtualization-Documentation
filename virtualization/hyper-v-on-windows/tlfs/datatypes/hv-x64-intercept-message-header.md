---
title: HV_X64_INTERCEPT_MESSAGE_HEADER in Hyper-V
description: HV_X64_INTERCEPT_MESSAGE_HEADER defines the common structure, field layout, execution context, and access types for Hyper-V x64 intercept messages.
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/03/2026
ms.topic: reference
ai-usage: ai-assisted
---

# HV_X64_INTERCEPT_MESSAGE_HEADER

`HV_X64_INTERCEPT_MESSAGE_HEADER` is the common prefix in x64 intercept message payloads. An intercept message reports a virtual processor operation that the hypervisor intercepted, and the header identifies that processor and the available execution context. Understanding this header helps you interpret context consistently across x64 intercept message types.

This reference explains the header layout, context-availability rules, and access-type values.

Architecture: x64 only.

## HV_X64_INTERCEPT_MESSAGE_HEADER syntax

```c
typedef UINT8 HV_INTERCEPT_ACCESS_TYPE;

typedef struct
{
    HV_VP_INDEX VpIndex;
    UINT8 InstructionLength : 4;
    UINT8 Reserved : 4;
    HV_INTERCEPT_ACCESS_TYPE InterceptAccessType;
    HV_X64_VP_EXECUTION_STATE ExecutionState;
    HV_X64_SEGMENT_REGISTER CsSegment;
    UINT64 Rip;
    UINT64 Rflags;
} HV_X64_INTERCEPT_MESSAGE_HEADER;
```

## HV_X64_INTERCEPT_MESSAGE_HEADER layout

| Offset (bytes) | Size (bytes) | Field | Description |
|--------|------|-------|-------------|
| 0 | 4 | `VpIndex` | Index of the intercepted virtual processor. |
| 4 | 1 | `InstructionLength`, `Reserved` | Bits 3:0 contain the instruction length in bytes, when supplied. Zero means the length is not supplied. Bits 7:4 are reserved. |
| 5 | 1 | `InterceptAccessType` | The intercepted access type, as defined below. |
| 6 | 2 | `ExecutionState` | [Virtual processor execution state](hv-x64-vp-execution-state.md). |
| 8 | 16 | `CsSegment` | [CS segment state](hv_x64_segment_register.md), when supplied. |
| 24 | 8 | `Rip` | Instruction pointer at the intercept, when supplied. |
| 32 | 8 | `Rflags` | RFLAGS at the intercept, when supplied. |

The structure is 40 bytes. Software must ignore reserved bits on read and must not assume that
they are zero.

The intercept message type and partition determine which context fields are available and how to interpret them.
For example, hardware-isolated partitions may not disclose the full processor state. A zero in a
field that is not supplied does not represent the corresponding architectural register state.

## HV_INTERCEPT_ACCESS_TYPE value definitions

`HV_INTERCEPT_ACCESS_TYPE` encodes one access type, not a mask:

| Value | Name | Meaning |
|-------|------|---------|
| 0 | `HV_INTERCEPT_ACCESS_READ` | Read |
| 1 | `HV_INTERCEPT_ACCESS_WRITE` | Write |
| 2 | `HV_INTERCEPT_ACCESS_EXECUTE` | Execute |

The applicable values depend on the intercept message type.

## Related content

* [HV_X64_VP_EXECUTION_STATE](hv-x64-vp-execution-state.md)
* [HV_X64_SEGMENT_REGISTER](hv_x64_segment_register.md)
* [HV_INTERCEPT_ACCESS_TYPE_MASK](hv_intercept_access_type_mask.md)
* [HV_X64_MEMORY_INTERCEPT_MESSAGE](hv_x64_memory_intercept_message.md)
* [HV_X64_MSR_INTERCEPT_MESSAGE](hv_x64_msr_intercept_message.md)
* [HV_X64_REGISTER_INTERCEPT_MESSAGE](hv_x64_register_intercept_message.md)
