---
title: HV_TRANSLATE_GVA_CONTROL_FLAGS
description: HV_TRANSLATE_GVA_CONTROL_FLAGS
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_TRANSLATE_GVA_CONTROL_FLAGS

The HV_TRANSLATE_GVA_CONTROL_FLAGS type defines the control flags used to specify how guest virtual address translation should be performed.

## Syntax

```c
typedef UINT64 HV_TRANSLATE_GVA_CONTROL_FLAGS;
```

### Flag Values

The following flags can be combined using bitwise OR operations:

| Flag | Value | Description |
|------|-------|-------------|
| HV_TRANSLATE_GVA_VALIDATE_READ | 0x0001 | Request data read access validation |
| HV_TRANSLATE_GVA_VALIDATE_WRITE | 0x0002 | Request data write access validation |
| HV_TRANSLATE_GVA_VALIDATE_EXECUTE | 0x0004 | Request instruction fetch access validation |
| HV_TRANSLATE_GVA_PRIVILEGE_EXEMPT | 0x0008 | Don't enforce access mode checks (x64 only) |
| HV_TRANSLATE_GVA_SET_PAGE_TABLE_BITS | 0x0010 | Set page table bits during translation |
| HV_TRANSLATE_GVA_TLB_FLUSH_INHIBIT | 0x0020 | Inhibit TLB flush operations |
| HV_TRANSLATE_GVA_SUPERVISOR_ACCESS | 0x0040 | Treat as supervisor mode access |
| HV_TRANSLATE_GVA_USER_ACCESS | 0x0080 | Treat as user mode access |
| HV_TRANSLATE_GVA_ENFORCE_SMAP | 0x0100 | (x64) Enforce SMAP restriction |
| HV_TRANSLATE_GVA_OVERRIDE_SMAP | 0x0200 | (x64) Override SMAP restriction |
| HV_TRANSLATE_GVA_PAN_SET | 0x0100 | (ARM64) Translate with PSTATE.PAN = 1 |
| HV_TRANSLATE_GVA_PAN_CLEAR | 0x0200 | (ARM64) Translate with PSTATE.PAN = 0 |
| HV_TRANSLATE_GVA_SHADOW_STACK | 0x0400 | Treat as shadow stack access (x64 only) |
| HV_TRANSLATE_GVA_INPUT_VTL_MASK | 0xFF00000000000000 | Mask for input VTL specification |

## See Also

[HvCallTranslateVirtualAddress](../hypercalls/HvCallTranslateVirtualAddress.md)
[HvCallTranslateVirtualAddressEx](../hypercalls/HvCallTranslateVirtualAddressEx.md)
[HV_TRANSLATE_GVA_RESULT](hv_translate_gva_result.md)
[HV_TRANSLATE_GVA_RESULT_EX](hv_translate_gva_result_ex.md)
