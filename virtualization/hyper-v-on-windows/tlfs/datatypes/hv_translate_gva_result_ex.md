---
title: HV_TRANSLATE_GVA_RESULT_EX
description: HV_TRANSLATE_GVA_RESULT_EX data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_TRANSLATE_GVA_RESULT_EX

## Overview
Extended translation result for `HvCallTranslateVirtualAddressEx`.

## Syntax

```c
typedef struct
{
    HV_TRANSLATE_GVA_RESULT_CODE ResultCode;
    UINT32 CacheType : 8;
    UINT32 OverlayPage : 1;
    UINT32 Reserved : 23;

#if !defined(_ARM64_)
    HV_X64_PENDING_EVENT EventInfo;
#endif
} HV_TRANSLATE_GVA_RESULT_EX;
```

### Members

| Member | Description |
|--------|-------------|
| ResultCode | See result code table (same values as basic result) |
| CacheType | Cache type enumeration, see Cache Types table below |
| OverlayPage | Overlay indicator |
| Reserved | Must be zero; ignore on read |
| EventInfo (x64) | Pending event / intercept metadata |

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

### Architecture Differences

On x64 platforms, this structure includes additional event information that can be used to understand the context of translation failures or intercepts. On ARM64 platforms, only the basic result information is provided.

## See Also

[HvCallTranslateVirtualAddressEx](../hypercalls/HvCallTranslateVirtualAddressEx.md)
[HV_TRANSLATE_GVA_CONTROL_FLAGS](hv_translate_gva_control_flags.md)
[HV_TRANSLATE_GVA_RESULT](hv_translate_gva_result.md)
