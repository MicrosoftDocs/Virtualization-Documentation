---
title: HV_X64_REGISTER_SEV_GPA_PAGE
description: HV_X64_REGISTER_SEV_GPA_PAGE
keywords: hyper-v
author: ericle
ms.author: hvdev
ms.date: 08/11/2025
ms.topic: reference
---

# HV_X64_REGISTER_SEV_GPA_PAGE

The following data structure is used to define the contents of the Secure AVIC control register (HvX64RegisterSevAvicGpa).

Architecture: x64 only (AMD SEV).

## Syntax

 ```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Enabled      : 1;
        UINT64 ReservedZ    : 11;
        UINT64 PageNumber   : 52;
    };

} HV_X64_REGISTER_SEV_GPA_PAGE;
 ```