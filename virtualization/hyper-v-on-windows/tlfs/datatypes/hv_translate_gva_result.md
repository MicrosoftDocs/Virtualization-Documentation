---
title: HV_TRANSLATE_GVA_RESULT
description: HV_TRANSLATE_GVA_RESULT data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
---

# HV_TRANSLATE_GVA_RESULT

## Overview
Translation result for `HvCallTranslateVirtualAddress`.

## Syntax

```c
typedef union
{
    UINT64 AsUINT64;

    struct
    {
        HV_TRANSLATE_GVA_RESULT_CODE ResultCode;
        UINT32 CacheType : 8;
        UINT32 OverlayPage : 1;
        UINT32 Reserved : 23;
    };
} HV_TRANSLATE_GVA_RESULT;
```

### Members

| Member | Description |
|--------|-------------|
| AsUINT64 | Entire 64-bit packed representation |
| ResultCode | Outcome (success / fault classification) |
| CacheType | Host cache type enumeration for mapping |
| OverlayPage | 1 if backing page is overlay |
| Reserved | Must be zero; ignore on read |

### Cache Types

The `CacheType` field indicates the caching behavior for the translated memory region. The following values are supported:

| Value | Name | Description |
|-------|------|-------------|
| 0 | HvCacheTypeUncached | Memory is not cached; all accesses go directly to memory |
| 1 | HvCacheTypeWriteCombining | Writes can be buffered and combined before being sent to memory |
| 4 | HvCacheTypeWriteThrough | Writes are cached and immediately written to memory |
| 5 | HvCacheTypeWriteProtected | Write-protected caching (x64 only) |
| 6 | HvCacheTypeWriteBack | Writes are cached and written to memory later |

### Result Codes

The `ResultCode` field can contain one of the following values:

| Value | Name | Description |
|-------|------|-------------|
| 0 | HvTranslateGvaSuccess | Translation completed successfully |
| 1 | HvTranslateGvaPageNotPresent | The page is not present in memory |
| 2 | HvTranslateGvaPrivilegeViolation | Access violates privilege requirements |
| 3 | HvTranslateGvaInvalidPageTableFlags | Invalid page table flags encountered |
| 4 | HvTranslateGvaGpaUnmapped | The guest physical address is unmapped |
| 5 | HvTranslateGvaGpaNoReadAccess | No read access to the guest physical address |
| 6 | HvTranslateGvaGpaNoWriteAccess | No write access to the guest physical address |
| 7 | HvTranslateGvaGpaIllegalOverlayAccess | Illegal access to overlay memory |
| 8 | HvTranslateGvaIntercept | Memory access was intercepted |
| 9 | HvTranslateGvaGpaUnaccepted | The guest physical address is unaccepted |

## See Also

[HvCallTranslateVirtualAddress](../hypercalls/HvCallTranslateVirtualAddress.md)
[HV_TRANSLATE_GVA_CONTROL_FLAGS](hv_translate_gva_control_flags.md)
[HV_TRANSLATE_GVA_RESULT_EX](hv_translate_gva_result_ex.md)
