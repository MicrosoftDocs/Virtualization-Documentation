---
title: HV_INITIAL_VP_CONTEXT
description: HV_INITIAL_VP_CONTEXT
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_INITIAL_VP_CONTEXT

## Syntax

### x64 Layout

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

### ARM64 Layout

 ```c
typedef struct
{
    UINT64 Pc;
    UINT64 Sp_ELh;
    UINT64 SCTLR_EL1;
    UINT64 MAIR_EL1;
    UINT64 TCR_EL1;
    UINT64 VBAR_EL1;
    UINT64 TTBR0_EL1;
    UINT64 TTBR1_EL1;
    UINT64 X18;
} HV_INITIAL_VP_CONTEXT;
 ```

#### ARM64 Field Descriptions

`Pc`: Program Counter - the initial instruction address.

`Sp_ELh`: Stack Pointer for the handler EL (EL1h mode).

`SCTLR_EL1`: System Control Register - controls architectural features including MMU enable, cache enable, and alignment checking.

`MAIR_EL1`: Memory Attribute Indirection Register - defines memory attribute encodings for the translation tables.

`TCR_EL1`: Translation Control Register - controls address translation parameters including translation table size and granule size.

`VBAR_EL1`: Vector Base Address Register - holds the exception vector table base address.

`TTBR0_EL1`: Translation Table Base Register 0 - holds the base address of the translation table for the lower virtual address range.

`TTBR1_EL1`: Translation Table Base Register 1 - holds the base address of the translation table for the upper virtual address range.

`X18`: General-purpose register X18, which is typically reserved as the platform register.

> **Note:** The ARM64 registers provided in HV_INITIAL_VP_CONTEXT are not sufficient to begin executing compiler-generated code. The guest must perform initial assembly setup to configure additional system registers as required by the compiled code, such as CPACR_EL1 (coprocessor access control) to enable floating-point and SIMD instructions.

## See also

[HvCallStartVirtualProcessor](../hypercalls/HvCallStartVirtualProcessor.md)
[HV_X64_SEGMENT_REGISTER](HV_X64_SEGMENT_REGISTER.md)
[HV_X64_TABLE_REGISTER](HV_X64_TABLE_REGISTER.md)
