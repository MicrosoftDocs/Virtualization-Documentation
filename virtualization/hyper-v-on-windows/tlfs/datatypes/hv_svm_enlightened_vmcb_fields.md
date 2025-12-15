---
title: HV_SVM_ENLIGHTENED_VMCB_FIELDS
description: HV_SVM_ENLIGHTENED_VMCB_FIELDS
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_SVM_ENLIGHTENED_VMCB_FIELDS

Enlightened fields in the VMCB (on AMD platforms). The enlightened fields are in the control section, offset 0x3E0-3FF, of the VMCB.

## Syntax

```c
typedef struct
{
    struct
    {
        // Direct virtual flush.
        UINT32 NestedFlushVirtualHypercall : 1;

        // Enlightened MSR bitmap.
        UINT32 MsrBitmap : 1;

        // Enlightened TLB: ASID flushes do not affect TLB entries derived from the NPT.
        // Hypercalls must be used to invalidate NPT TLB entries.
        UINT32 EnlightenedNptTlb : 1;

        UINT32 Reserved : 29;
    } EnlightenmentsControl;

    UINT32 VpId;
    UINT64 VmId;
    UINT64 PartitionAssistPage;
    UINT64 Reserved;

} HV_SVM_ENLIGHTENED_VMCB_FIELDS;
 ```
