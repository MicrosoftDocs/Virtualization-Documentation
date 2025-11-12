---
title: HvCallTranslateVirtualAddress
description: HvCallTranslateVirtualAddress hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallTranslateVirtualAddress

The HvCallTranslateVirtualAddress hypercall translates a guest virtual address to a guest physical address using the context of the specified VP.

## Interface

```c
HV_STATUS
HvCallTranslateVirtualAddress(
    _In_ HV_PARTITION_ID                  PartitionId,
    _In_ HV_VP_INDEX                      VpIndex,
    _In_ HV_TRANSLATE_GVA_CONTROL_FLAGS   ControlFlags,
    _In_ HV_GVA_PAGE_NUMBER               GvaPage,
    _Out_ HV_TRANSLATE_GVA_RESULT*        TranslationResult,
    _Out_ HV_GPA_PAGE_NUMBER*             GpaPage
);
```

## Call Code

`0x0052` (Simple)

## Input Parameters

| Name         | Offset | Size | Information Provided |
|--------------|--------|------|----------------------|
| PartitionId  | 0      | 8    | Target partition |
| VpIndex      | 8      | 4    | VP performing translation context |
| ControlFlags | 16     | 8    | Control / privilege / walk modifiers |
| GvaPage      | 24     | 8    | Guest virtual page |

## Output Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TranslationResult | 0      | 8    | Result code / attributes |
| GpaPage           | 8      | 8    | Translated GPA page (valid if success) |

## See Also

[HV_TRANSLATE_GVA_CONTROL_FLAGS](../datatypes/hv_translate_gva_control_flags.md)
[HV_TRANSLATE_GVA_RESULT](../datatypes/hv_translate_gva_result.md)
