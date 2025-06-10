---
title: CPUID access call
description: Learn about context data for an exit caused by CPUID call.
author: sethmanheim
ms.author: roharwoo
ms.date: 04/20/2022
---

# CPUID Access


## Syntax
```C
//
// Context data for an exit caused by a CPUID call (WHvRunVpExitReasonX64CPUID)
//
typedef struct WHV_X64_CPUID_ACCESS_CONTEXT
{
    // CPUID access info
    UINT64 Rax;
    UINT64 Rcx;
    UINT64 Rdx;
    UINT64 Rbx;
    UINT64 DefaultResultRax;
    UINT64 DefaultResultRcx;
    UINT64 DefaultResultRdx;
    UINT64 DefaultResultRbx;
} WHV_X64_CPUID_ACCESS_CONTEXT;
```

## Return Value
Information about exits caused by the virtual processor executing the `CPUID` instruction is provided in the `WHV_X64_CPUID_ACCESS_CONTEXT` structure. The `DefaultResultRax-Rbx` members of the structure provide the values of the requested `CPUID` values that the hypervisor would return based on the partition properties and the capabilities of the host.  

Exits for `CPUID` accesses are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS.CpuidExit` property for the partition. 
