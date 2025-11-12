---
title: HV_VP_ASSIST_PAGE
description: HV_VP_ASSIST_PAGE
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HV_VP_ASSIST_PAGE

 This structure defines the format of the [Virtual Processor Assist Page](../vp-properties.md#virtual-processor-assist-page).

## Syntax

```c
typedef union
{
    struct
    {
        //
        // APIC assist for optimized EOI processing.
        //
        HV_VIRTUAL_APIC_ASSIST ApicAssist;
        UINT32 ReservedZ0;

        //
        // VP-VTL control information
        //
        HV_VP_VTL_CONTROL VtlControl;

        HV_NESTED_ENLIGHTENMENTS_CONTROL NestedEnlightenmentsControl;
        BOOLEAN EnlightenVmEntry;
        UINT8 ReservedZ1[7];
        HV_GPA CurrentNestedVmcs;

        BOOLEAN SyntheticTimeUnhaltedTimerExpired;
        UINT8 ReservedZ2[7];

        //
        // VirtualizationFaultInformation must be 16 byte aligned.
        //
        HV_VIRTUALIZATION_FAULT_INFORMATION VirtualizationFaultInformation;
    };

    UINT8 ReservedZBytePadding[HV_PAGE_SIZE];

} HV_VP_ASSIST_PAGE;
 ```

## See also

[HV_NESTED_ENLIGHTENMENTS_CONTROL](HV_NESTED_ENLIGHTENMENTS_CONTROL.md)

[HV_VIRTUALIZATION_FAULT_INFORMATION](HV_VIRTUALIZATION_FAULT_INFORMATION.md)

[HV_VP_VTL_CONTROL](HV_VP_VTL_CONTROL.md)