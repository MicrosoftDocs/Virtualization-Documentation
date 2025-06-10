---
title: Exit caused by an interrupt delivery window cancellation from the host
description: Learn about context data for an exit caused by an interrupt delivery window cancellation from the host.
author: sethmanheim
ms.author: roharwoo
ms.date: 04/20/2022
---

# Interrupt Window


## Syntax
```C
//
// Context data for an exit caused by an interrupt delivery window cancellation from the host
// (WHvRunVpExitReasonX64InterruptWindow)
//
typedef enum WHV_X64_PENDING_INTERRUPTION_TYPE
{
    WHvX64PendingInterrupt           = 0,
    WHvX64PendingNmi                 = 2,
    WHvX64PendingException           = 3
} WHV_X64_PENDING_INTERRUPTION_TYPE, *PWHV_X64_PENDING_INTERRUPTION_TYPE;

typedef struct WHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT
{
    WHV_X64_PENDING_INTERRUPTION_TYPE DeliverableType;
} WHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT, *PWHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT;
```

## Return Value

Information about exits caused by the virtual processor when the interruptibility state of the processor would allow delivery of a given interrupt.
