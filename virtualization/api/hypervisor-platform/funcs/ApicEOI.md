---
title: APIC EOI
description: Learn about context data for an exit caused by an APIC EOI of a level-triggered interrupt.
author: mattbriggs
ms.author: mabrigg
ms.date: 04/20/2022
---

# APIC EOI


## Syntax
```C
//
// Context data for an exit caused by an APIC EOI of a level-triggered
// interrupt (WHvRunVpExitReasonX64ApicEoi)
//
typedef struct WHV_X64_APIC_EOI_CONTEXT
{
    UINT32 InterruptVector;
} WHV_X64_APIC_EOI_CONTEXT;
```

## Return Value
