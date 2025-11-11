---
title: HvCallTranslateVirtualAddressEx
description: HvCallTranslateVirtualAddressEx hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallTranslateVirtualAddressEx

The HvCallTranslateVirtualAddressEx hypercall translates a guest virtual address to a guest physical address using the context of the specified VP, providing extended translation results.

## Interface

```c
HV_STATUS
HvCallTranslateVirtualAddressEx(
    _In_ HV_PARTITION_ID                    PartitionId,
    _In_ HV_VP_INDEX                        VpIndex,
    _In_ HV_TRANSLATE_GVA_CONTROL_FLAGS     ControlFlags,
    _In_ HV_GVA_PAGE_NUMBER                 GvaPage,
    _Out_ HV_TRANSLATE_GVA_RESULT_EX*       TranslationResult,
    _Out_ HV_GPA_PAGE_NUMBER*               GpaPage
);
```

## Call Code

`0x00AC` (Simple)

## Input Parameters

| Name         | Offset | Size | Information Provided |
|--------------|--------|------|----------------------|
| PartitionId  | 0      | 8    | Target partition |
| VpIndex      | 8      | 4    | VP context |
| Reserved     | 12     | 4    | Must be zero |
| ControlFlags | 16     | 8    | Control flags |
| GvaPage      | 24     | 8    | Guest virtual page |

## Output Parameters

| Name              | Offset | Size | Information Provided |
|-------------------|--------|------|----------------------|
| TranslationResult | 0      | 16   | Extended result (fault info, attributes) |
| GpaPage           | 16     | 8    | GPA page |

## See Also

[HV_TRANSLATE_GVA_CONTROL_FLAGS](../datatypes/hv_translate_gva_control_flags.md)
[HV_TRANSLATE_GVA_RESULT_EX](../datatypes/hv_translate_gva_result_ex.md)
