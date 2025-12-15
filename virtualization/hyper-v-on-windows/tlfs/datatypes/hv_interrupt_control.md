---
title: HV_INTERRUPT_CONTROL
description: HV_INTERRUPT_CONTROL data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_INTERRUPT_CONTROL

## Overview
Structure for controlling virtual interrupt routing & semantics.

## Syntax

```c
#if defined(_AMD64_)

typedef union
{
    UINT64 AsUINT64;
    struct
    {
        HV_INTERRUPT_TYPE InterruptType;
        UINT32 LevelTriggered           : 1;
        UINT32 LogicalDestinationMode   : 1;
        UINT32 Reserved                 : 30;
    };
} HV_X64_INTERRUPT_CONTROL;

#define HV_INTERRUPT_CONTROL  HV_X64_INTERRUPT_CONTROL

#else

typedef union
{
    UINT64 AsUINT64;
    struct
    {
        HV_INTERRUPT_TYPE InterruptType;
        UINT32 Reserved1                : 2;
        UINT32 Asserted                 : 1;
        UINT32 Reserved2                : 29;
    };
} HV_ARM64_INTERRUPT_CONTROL;

#define HV_INTERRUPT_CONTROL  HV_ARM64_INTERRUPT_CONTROL

#endif // _ARCH_
```

The interrupt control structure provides architecture-specific control over interrupt delivery behavior.

**x64 Architecture Fields:**
- **InterruptType**: Specifies the type of interrupt to deliver (see [HV_INTERRUPT_TYPE](hv_interrupt_type.md))
- **LevelTriggered**: When set, indicates level-triggered interrupt; when clear, indicates edge-triggered
- **LogicalDestinationMode**: When set, uses logical destination mode for interrupt routing, where the target specifies a logical APIC ID which describes a set of target virtual processors; when clear, uses physical destination mode where the target specifies a local APIC ID.

**ARM64 Architecture Fields:**
- **InterruptType**: Specifies the type of interrupt to deliver (see [HV_INTERRUPT_TYPE](hv_interrupt_type.md))
- **Asserted**: When set, indicates the interrupt should be asserted; when clear, indicates deassertion

## Usage Notes
- On ARM64, whether the interrupt is edge or level triggered is controlled by the Guest GIC configuration, rather than the HV_INTERRUPT_CONTROL structure.

## See also

[HV_INTERRUPT_TYPE](hv_interrupt_type.md)
[HV_INTERRUPT_VECTOR](hv_interrupt_vector.md)
[HvCallAssertVirtualInterrupt](../hypercalls/HvCallAssertVirtualInterrupt.md)
