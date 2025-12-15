---
title: HV_INTERRUPT_TYPE
description: HV_INTERRUPT_TYPE data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_INTERRUPT_TYPE

## Overview
Enumeration of interrupt delivery modes per architecture.

## Syntax

```c
typedef enum _HV_INTERRUPT_TYPE
{
#if defined(_ARM64_)
    HvArm64InterruptTypeFixed             = 0x0000,
#else
    HvX64InterruptTypeFixed             = 0x0000,
    HvX64InterruptTypeLowestPriority    = 0x0001,
    HvX64InterruptTypeSmi               = 0x0002,
    HvX64InterruptTypeRemoteRead        = 0x0003,
    HvX64InterruptTypeNmi               = 0x0004,
    HvX64InterruptTypeInit              = 0x0005,
    HvX64InterruptTypeSipi              = 0x0006,
    HvX64InterruptTypeExtInt            = 0x0007,
    HvX64InterruptTypeLocalInt0         = 0x0008,
    HvX64InterruptTypeLocalInt1         = 0x0009,
#endif
} HV_INTERRUPT_TYPE;
```

The interrupt types have different meanings depending on the processor architecture:

### ARM64 Values
- HvArm64InterruptTypeFixed – Standard fixed delivery.

### x64 Values
- HvX64InterruptTypeFixed – Fixed vector.
- HvX64InterruptTypeLowestPriority – Dynamic routing to lowest priority.
- HvX64InterruptTypeSmi – System Management Interrupt (restricted).
- HvX64InterruptTypeRemoteRead – Remote read IPI.
- HvX64InterruptTypeNmi – Non-maskable interrupt.
- HvX64InterruptTypeInit – INIT IPI.
- HvX64InterruptTypeSipi – SIPI (startup IPI).
- HvX64InterruptTypeExtInt – External interrupt signal.
- HvX64InterruptTypeLocalInt0 / LocalInt1 – Local APIC LINT pins.

## See Also
* [HV_INTERRUPT_CONTROL](hv_interrupt_control.md)
* [HV_INTERRUPT_VECTOR](hv_interrupt_vector.md)
* [HvCallAssertVirtualInterrupt](../hypercalls/HvCallAssertVirtualInterrupt.md)
* [HvCallSetVirtualInterruptTarget](../hypercalls/HvCallSetVirtualInterruptTarget.md)
