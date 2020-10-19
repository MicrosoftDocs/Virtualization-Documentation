---
title: HV_DEVICE_INTERRUPT_TARGET
description: HV_DEVICE_INTERRUPT_TARGET
keywords: hyper-v
author: alexgrest
ms.author: alegre
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_DEVICE_INTERRUPT_TARGET

## Syntax

 ```c

#define HV_DEVICE_INTERRUPT_TARGET_MULTICAST 1
#define HV_DEVICE_INTERRUPT_TARGET_PROCESSOR_SET 2

typedef struct
{
    HV_INTERRUPT_VECTOR Vector;
    UINT32 Flags;
    union
    {
        UINT64 ProcessorMask;
        UINT64 ProcessorSet[];
    };
} HV_DEVICE_INTERRUPT_TARGET;
 ```

“Flags” supplies optional flags for the interrupt target. “Multicast” indicates that the interrupt is sent to all processors in the target set. By default, the interrupt is sent to an arbitrary single processor in the target set.
