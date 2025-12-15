---
title: HV_VP_VTL_CONTROL
description: HV_VP_VTL_CONTROL
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_VP_VTL_CONTROL

The hypervisor uses part of the VP assist page to facilitate communication with code running in a VTL higher than VTL0. Each VTL has its own control structure (except VTL0).

The following information is communicated using the control page:

1. The VTL entry reason.
2. A flag indicating that VINA is being asserted.
3. The values for registers to load upon a VTL return.

## Syntax

```c
typedef enum
{
    // This reason is reserved and is not used.
    HvVtlEntryReserved = 0,

    // Indicates entry due to a VTL call from a lower VTL.
    HvVtlEntryVtlCall = 1,

    // Indicates entry due to an interrupt targeted to the VTL.
    HvVtlEntryInterrupt = 2,

    // Indicates an entry due to an intercept delivered via the intercept page.
    HvVtlEntryIntercept = 3,
} HV_VTL_ENTRY_REASON;

typedef struct
{
    // The hypervisor updates the entry reason with an indication as to why
    // the VTL was entered on the virtual processor.
    HV_VTL_ENTRY_REASON EntryReason;

    // This flag determines whether the VINA interrupt line is asserted.
    union
    {
        UINT8 AsUINT8;
        struct
        {
            UINT8 VinaAsserted :1;
            UINT8 VinaReservedZ :7;
        };
    } VinaStatus;

    UINT8 ReservedZ00;
    UINT16 ReservedZ01;

#if defined(_AMD64_)
    // A guest updates the VtlReturn* fields to provide the register values
    // to restore on VTL return. The specific register values that are
    // restored will vary based on whether the VTL is 32-bit or 64-bit.
    union
    {
        struct
        {
            UINT64 VtlReturnX64Rax;
            UINT64 VtlReturnX64Rcx;
        };

        struct
        {
            UINT32 VtlReturnX86Eax;
            UINT32 VtlReturnX86Ecx;
            UINT32 VtlReturnX86Edx;
            UINT32 ReservedZ1;
        };
    };
#else
    // Return control registers not needed on ARM64.
    UINT64 ReservedZ2;
    UINT64 ReservedZ3;
#endif
} HV_VP_VTL_CONTROL;
 ```

### x64 Architecture

On x64, the VtlReturn fields allow the guest to specify register values to restore on VTL return. The 64-bit variant uses `VtlReturnX64Rax` and `VtlReturnX64Rcx`, while the 32-bit variant uses `VtlReturnX86Eax`, `VtlReturnX86Ecx`, and `VtlReturnX86Edx`.

### ARM64 Architecture

On ARM64, the return control registers are not needed. The corresponding space is reserved.

## See also

[HV_VP_ASSIST_PAGE](HV_VP_ASSIST_PAGE.md)
