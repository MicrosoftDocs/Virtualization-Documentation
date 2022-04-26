---
title: HV_NESTED_ENLIGHTENMENTS_CONTROL
description: HV_NESTED_ENLIGHTENMENTS_CONTROL
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_NESTED_ENLIGHTENMENTS_CONTROL

Control structure that allows a hypervisor to indicate to its parent hypervisor which nested enlightenment privileges are to be granted to the current nested guest context.

## Syntax

```c
typedef struct
{
    union {
        UINT32 AsUINT32;
        struct
        {
            UINT32 DirectHypercall:1;
            UINT32 VirtualizationException:1;
            UINT32 Reserved:30;
        };
    } Features;

    union
    {
        UINT32 AsUINT32;
        struct
        {
            UINT32 InterPartitionCommunication:1;
            UINT32 Reserved:31;
        };
     } HypercallControls;
} HV_NESTED_ENLIGHTENMENTS_CONTROL, *PHV_NESTED_ENLIGHTENMENTS_CONTROL;
 ```

## See also

[HV_VP_ASSIST_PAGE](HV_VP_ASSIST_PAGE.md)