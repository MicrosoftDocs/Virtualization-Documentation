---
title: HV_X64_VP_EXECUTION_STATE union in Hyper-V
description: HV_X64_VP_EXECUTION_STATE defines the 16-bit x64 virtual processor execution state in a Hyper-V intercept message. Review its fields and bit layout.
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/03/2026
ms.topic: reference
ai-usage: ai-assisted
---

# HV_X64_VP_EXECUTION_STATE

`HV_X64_VP_EXECUTION_STATE` records selected execution-state attributes for an x64 virtual processor in an intercept message header. Understanding this value helps you interpret the processor's privilege, mode, interruption, and virtual trust level (VTL) state when an intercept occurs.

This reference explains the union layout and the meaning of each state bit.

Architecture: x64 only.

## Syntax

```c
typedef union
{
    UINT16 AsUINT16;
    struct
    {
        UINT16 Cpl : 2;
        UINT16 Cr0Pe : 1;
        UINT16 Cr0Am : 1;
        UINT16 EferLma : 1;
        UINT16 DebugActive : 1;
        UINT16 InterruptionPending : 1;
        UINT16 Vtl : 4;
        UINT16 Reserved0 : 1;
        UINT16 InterruptShadow : 1;
        UINT16 Reserved1 : 3;
    };
} HV_X64_VP_EXECUTION_STATE;
```

## Bit definitions

The following table defines the bit fields in `HV_X64_VP_EXECUTION_STATE`.

| Bits | Field | Meaning |
|------|-------|---------|
| 1:0 | `Cpl` | Current privilege level. |
| 2 | `Cr0Pe` | CR0.PE, the protected-mode enable bit. |
| 3 | `Cr0Am` | CR0.AM, the alignment-mask bit. |
| 4 | `EferLma` | EFER.LMA, the long-mode active bit. |
| 5 | `DebugActive` | Debugging is active for the virtual processor. |
| 6 | `InterruptionPending` | An event is pending, or the intercept occurred during event delivery. |
| 10:7 | `Vtl` | Virtual trust level (VTL) of the intercepted virtual processor state. |
| 11 | `Reserved0` | Reserved; ignore on read. |
| 12 | `InterruptShadow` | The virtual processor is in an interrupt shadow. |
| 15:13 | `Reserved1` | Reserved; ignore on read. |

The value is 16 bits. Reserved bits can be nonzero and must be ignored.
For a hardware-isolated partition, unavailable execution-state fields contain zero. These zero
values don't represent processor state.

## See also

* [HV_X64_INTERCEPT_MESSAGE_HEADER](hv-x64-intercept-message-header.md)
* [Virtual Trust Level](../vsm.md#virtual-trust-level-vtl)
