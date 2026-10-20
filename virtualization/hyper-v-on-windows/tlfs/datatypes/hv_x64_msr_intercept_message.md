---
title: HV_X64_MSR_INTERCEPT_MESSAGE
description: Payload for an x64 model-specific register intercept
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_X64_MSR_INTERCEPT_MESSAGE

`HV_X64_MSR_INTERCEPT_MESSAGE` defines the x64 payload for `HvMessageTypeMsrIntercept` (`0x80010001`). It identifies the MSR accessed
by an intercepted `RDMSR` or `WRMSR` instruction and contains the values of RAX and RDX at interception.

Architecture: x64 only.

## Syntax

```c
typedef struct
{
    HV_X64_INTERCEPT_MESSAGE_HEADER Header;
    UINT32 MsrNumber;
    UINT32 Reserved;
    UINT64 Rdx;
    UINT64 Rax;
} HV_X64_MSR_INTERCEPT_MESSAGE;
```

## Layout

| Offset | Size | Field | Description |
|--------|------|-------|-------------|
| 0 | 40 | `Header` | Common x64 intercept context. `Header.InterceptAccessType` distinguishes an MSR read from an MSR write. Hardware-isolated partitions do not disclose the full architectural state in this header. |
| 40 | 4 | `MsrNumber` | Architectural MSR index (RCX[31:0] for `RDMSR`/`WRMSR`), not an `HV_REGISTER_NAME`. |
| 44 | 4 | `Reserved` | Reserved. Software must ignore this field. |
| 48 | 8 | `Rdx` | RDX value at the intercept. |
| 56 | 8 | `Rax` | RAX value at the intercept. |

The structure is 64 bytes.

## Access semantics

| `Header.InterceptAccessType` | Instruction | Operand interpretation |
|------------------------------|-------------|------------------------|
| `HV_INTERCEPT_ACCESS_READ` | `RDMSR` | `Rax` and `Rdx` contain the register values before completion of the instruction, not the result of the MSR read. |
| `HV_INTERCEPT_ACCESS_WRITE` | `WRMSR` | `Rax[31:0]` specifies bits 31:0 of the value to be written; `Rdx[31:0]` specifies bits 63:32. Bits 63:32 of each field are not part of the operand. |

When available, the architectural register context in the common header describes the state before completion of the intercepted
instruction. Software emulating `RDMSR` must update the virtual processor state with the result of the read. Successful emulation writes
result bits 31:0 to EAX and bits 63:32 to EDX and clears bits 63:32 of RAX and RDX. The message contains RAX and RDX at interception;
it does not contain the result of the emulated read.

The execute access type is not used for this message. MSR-list instructions use the separate `HvMessageTypeX64MsrListIntercept` payload.

## See also

* [HV_INTERCEPT_PARAMETERS](hv_intercept_parameters.md)
* [HvCallInstallIntercept](../hypercalls/HvCallInstallIntercept.md)
* [HV_MESSAGE_TYPE](hv_message_type.md)
