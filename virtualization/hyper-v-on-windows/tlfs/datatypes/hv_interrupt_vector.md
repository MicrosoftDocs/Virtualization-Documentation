---
title: HV_INTERRUPT_VECTOR
description: HV_INTERRUPT_VECTOR data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_INTERRUPT_VECTOR

## Overview
Numeric identifier for an interrupt to inject / reserve / target. Semantics differ by architecture & controller.

## Syntax

```c
typedef UINT32 HV_INTERRUPT_VECTOR;
```

The interrupt vector is a 32-bit unsigned integer that specifies the vector number for interrupt delivery. The valid range and meaning of interrupt vectors depend on the processor architecture and interrupt controller configuration.

## See also

[HV_INTERRUPT_CONTROL](hv_interrupt_control.md)
[HV_INTERRUPT_TYPE](hv_interrupt_type.md)
[HvCallAssertVirtualInterrupt](../hypercalls/HvCallAssertVirtualInterrupt.md)
[HvCallSetVirtualInterruptTarget](../hypercalls/HvCallSetVirtualInterruptTarget.md)