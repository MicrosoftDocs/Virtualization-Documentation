---
title: HV_INITIAL_VP_CONTEXT
description: HV_INITIAL_VP_CONTEXT
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HV_INITIAL_VP_CONTEXT

## Syntax

 ```c
typedef struct
{
    UINT64 Rip;
    UINT64 Rsp;
    UINT64 Rflags;

    // Segment selector registers together with their hidden state.
    HV_X64_SEGMENT_REGISTER Cs;
    HV_X64_SEGMENT_REGISTER Ds;
    HV_X64_SEGMENT_REGISTER Es;
    HV_X64_SEGMENT_REGISTER Fs;
    HV_X64_SEGMENT_REGISTER Gs;
    HV_X64_SEGMENT_REGISTER Ss;
    HV_X64_SEGMENT_REGISTER Tr;
    HV_X64_SEGMENT_REGISTER Ldtr;

    // Global and Interrupt Descriptor tables
    HV_X64_TABLE_REGISTER Idtr;
    HV_X64_TABLE_REGISTER Gdtr;

    // Control registers and MSR's
    UINT64 Efer;
    UINT64 Cr0;
    UINT64 Cr3;
    UINT64 Cr4;
    UINT64 MsrCrPat;
} HV_INITIAL_VP_CONTEXT;
 ```

## See also

[HV_X64_SEGMENT_REGISTER](HV_X64_SEGMENT_REGISTER.md)

[HV_X64_TABLE_REGISTER](HV_X64_TABLE_REGISTER.md)
