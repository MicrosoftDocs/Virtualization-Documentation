---
title: HV_REGISTER_VALUE
description: Encoding of a virtual processor register value
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_REGISTER_VALUE

Virtual processor register values are all 128 bits in size. Values that do not consume the full 128 bits are zero-extended to fill out the entire 128 bits.

## Syntax

### Architecture-Neutral Members

```c
typedef union
{
    UINT128 Reg128;
    UINT64 Reg64;
    UINT32 Reg32;
    UINT16 Reg16;
    UINT8 Reg8;

    HV_EXPLICIT_SUSPEND_REGISTER ExplicitSuspend;
    HV_INTERCEPT_SUSPEND_REGISTER InterceptSuspend;
    HV_DISPATCH_SUSPEND_REGISTER DispatchSuspend;
} HV_REGISTER_VALUE;
 ```

### x64-Specific Members

On x64 platforms, the union additionally includes:

```c
typedef union
{
    // ... architecture-neutral members ...
    HV_X64_FP_REGISTER Fp;
    HV_X64_FP_CONTROL_STATUS_REGISTER FpControlStatus;
    HV_X64_XMM_CONTROL_STATUS_REGISTER XmmControlStatus;
    HV_X64_SEGMENT_REGISTER Segment;
    HV_X64_TABLE_REGISTER Table;
    HV_X64_INTERRUPT_STATE_REGISTER InterruptState;
    HV_X64_PENDING_INTERRUPTION_REGISTER PendingInterruption;
    HV_X64_MSR_NPIEP_CONFIG_CONTENTS NpiepConfig;
    HV_X64_PENDING_EXCEPTION_EVENT PendingExceptionEvent;
    HV_X64_PENDING_VIRTUALIZATION_FAULT_EVENT PendingVirtualizationFaultEvent;
    HV_X64_INTEL_INVEPT_REG InvEptReg;
    HV_X64_INTEL_INVVPID_REG InvVpidReg;
} HV_REGISTER_VALUE;
```

## Member selection

The `HV_REGISTER_NAME` associated with a register access determines the interpretation of the value.

| Member | Use |
|--------|-----|
| `Reg8`, `Reg16`, `Reg32`, `Reg64` | Scalar registers of the corresponding width. The remaining high-order bits are zero. |
| `Reg128` | Registers defined as an opaque or integer 128-bit value. |
| `ExplicitSuspend`, `InterceptSuspend`, `DispatchSuspend` | Structured virtual processor suspension state. |
| `Fp` | x64 80-bit x87 register value in a 128-bit representation. |
| `FpControlStatus`, `XmmControlStatus` | x64 floating-point and SIMD control/status state. |
| `Segment`, `Table` | x64 segment or descriptor-table register state. |
| `InterruptState`, `PendingInterruption` | x64 interrupt state. |
| `NpiepConfig` | x64 Non-Privileged Instruction Execution Prevention (NPIEP) configuration for SGDT, SIDT, SLDT, and STR. |
| `PendingExceptionEvent` | x64 pending exception state. |
| `PendingVirtualizationFaultEvent` | x64 pending virtualization-fault state. |
| `InvEptReg`, `InvVpidReg` | Information for emulated Intel INVEPT and INVVPID instructions. |

## Usage requirements

- The union occupies 16 bytes and has 16-byte alignment, including when a scalar member is selected.
- Reserved bits are subject to the requirements of the selected member's type. Software supplying a value to the hypervisor must clear
  fields defined as reserved-zero.
- A successful register read returns the encoding specified by the requested register name. The numerical value does not determine the
  encoding.
- Register availability and access permissions, including read-only and write-only restrictions, are defined by `HV_REGISTER_NAME`.

## See also

* [HV_REGISTER_NAME](hv_register_name.md)
* [HV_X64_MSR_NPIEP_CONFIG_CONTENTS](hv_x64_msr_npiep_config_contents.md)
* [HvCallGetVpRegisters](../hypercalls/HvCallGetVpRegisters.md)
* [HvCallSetVpRegisters](../hypercalls/HvCallSetVpRegisters.md)
* [HV_X64_REGISTER_ACCESS_INFO](hv_x64_register_access_info.md)