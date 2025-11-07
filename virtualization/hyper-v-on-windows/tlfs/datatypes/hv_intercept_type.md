---
title: HV_INTERCEPT_TYPE
description: HV_INTERCEPT_TYPE
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_INTERCEPT_TYPE

## Overview
Enumerates guest operations / events that can generate a virtualization intercept delivered to a higher VTL / parent for emulation, policy, or diagnostics.

## Syntax

```c
typedef enum {
    HvInterceptTypeX64IoPort        = 0x00000000,
    HvInterceptTypeX64Msr           = 0x00000001,
    HvInterceptTypeX64Cpuid         = 0x00000002,
    HvInterceptTypeException        = 0x00000003,
    HvInterceptTypeX64GlobalCpuid   = 0x00000006,
    HvInterceptTypeX64ApicSmi       = 0x00000007,
    HvInterceptTypeHypercall        = 0x00000008,
    HvInterceptTypeX64ApicInitSipi  = 0x00000009,
    HvInterceptTypeX64ApicWrite     = 0x0000000B,
    HvInterceptTypeUnknownSynicConnection = 0x0000000D,
    HvInterceptTypeX64ApicEoi       = 0x0000000E,
    HvInterceptTypeRetargetInterruptWithUnknownDeviceId = 0x0000000F,
    HvInterceptTypeX64ExceptionTrap = 0x00000010,
    HvInterceptTypeX64IoPortRange   = 0x00000011,
    HvInterceptTypeRegister         = 0x00000012,
    HvInterceptTypeSystemResetExtended = 0x00000013,
} HV_INTERCEPT_TYPE;
```

### Values

- **HvInterceptTypeX64IoPort**: (x64 only) An intercept was triggered by an I/O port access.
- **HvInterceptTypeX64Msr**: (x64 only) An intercept was triggered by an MSR access.
- **HvInterceptTypeX64Cpuid**: (x64 only) An intercept was triggered by a CPUID instruction.
- **HvInterceptTypeException**: An intercept was triggered by an exception.
- **HvInterceptTypeX64GlobalCpuid**: (x64 only) An intercept was triggered by a CPUID instruction that is global to the partition.
- **HvInterceptTypeX64ApicSmi**: (x64 only) An intercept was triggered by an APIC SMI.
- **HvInterceptTypeHypercall**: An intercept was triggered by a hypercall.
- **HvInterceptTypeX64ApicInitSipi**: (x64 only) An intercept was triggered by an APIC INIT/SIPI.
- **HvInterceptTypeX64ApicWrite**: (x64 only) An intercept was triggered by a write to an APIC register.
- **HvInterceptTypeUnknownSynicConnection**: An intercept was triggered by an unknown SynIC connection.
- **HvInterceptTypeX64ApicEoi**: (x64 only) An intercept was triggered by an APIC EOI.
- **HvInterceptTypeRetargetInterruptWithUnknownDeviceId**: An intercept was triggered when retargeting an interrupt for an unknown device ID.
- **HvInterceptTypeX64ExceptionTrap**: (x64 only) An intercept was triggered by an exception trap.
- **HvInterceptTypeX64IoPortRange**: (x64 only) An intercept was triggered by an I/O port access within a registered range.
- **HvInterceptTypeRegister**: (ARM64 only) An intercept was triggered by a register access.
- **HvInterceptTypeSystemResetExtended**: (ARM64 only) An intercept was triggered by a PSCI System_Reset2 or System_Off2 call.

## See also
* [HvCallInstallIntercept](../hypercalls/HvCallInstallIntercept.md)
* [HvCallInstallInterceptEx](../hypercalls/HvCallInstallInterceptEx.md)
* [HvCallRegisterInterceptResult](../hypercalls/HvCallRegisterInterceptResult.md)
* [HvCallUnregisterInterceptResult](../hypercalls/HvCallUnregisterInterceptResult.md)
