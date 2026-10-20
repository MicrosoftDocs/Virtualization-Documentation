---
title: HV_X64_MEMORY_ACCESS_INFO
description: Validity and state flags for an x64 memory intercept
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_X64_MEMORY_ACCESS_INFO

`HV_X64_MEMORY_ACCESS_INFO` specifies address validity, the cause of an x64 memory intercept, and the associated translation state.
The union occupies one byte.

Architecture: x64 only.

## Syntax

```c
typedef union
{
    UINT8 AsUINT8;
    struct
    {
        UINT8 GvaValid:1;
        UINT8 GvaGpaValid:1;
        UINT8 HypercallOutputPending:1;
        UINT8 TlbLocked:1;
        UINT8 SupervisorShadowStack:1;
        UINT8 VerifyPagingWrite:1;
        UINT8 Reserved1:2;
    };
} HV_X64_MEMORY_ACCESS_INFO;
```

## Bit definitions

| Bit | Field | Description |
|-----|-------|-------------|
| 0 | `GvaValid` | If set, `GuestVirtualAddress` contains the GVA associated with the intercepted access. If clear, software must ignore `GuestVirtualAddress`. |
| 1 | `GvaGpaValid` | If set, `GuestVirtualAddress` and `GuestPhysicalAddress` form a valid translation pair for the intercepted access. `GvaValid` alone does not establish the validity of this pair. |
| 2 | `HypercallOutputPending` | If set, a pending hypercall-output memory write caused the intercept, rather than an ordinary instruction memory operand. |
| 3 | `TlbLocked` | If set, the virtual processor's TLB is locked for intercept processing. This bit does not establish translation validity or indicate whether an overlay page is involved. |
| 4 | `SupervisorShadowStack` | If set, the intercepted access is a supervisor shadow-stack access. |
| 5 | `VerifyPagingWrite` | If set, the access was attempted to a page marked Verify Paging Write. |
| 7:6 | `Reserved1` | Reserved. Software must ignore these bits. |

If `GvaGpaValid` is clear, software must not assume that the address fields form a valid translation pair, even if `GvaValid` is set.

`GuestPhysicalAddress` identifies the intercepted physical access independently of `GvaGpaValid`. A clear `GvaGpaValid` does not invalidate
the GPA. `TlbLocked` may be set while `GvaGpaValid` is clear; TLB locking and translation-pair validity are separate conditions.

## See also

* [HV_X64_MEMORY_INTERCEPT_MESSAGE](hv_x64_memory_intercept_message.md)
