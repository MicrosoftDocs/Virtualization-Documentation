---
title: HvCallUnmapVpStatePage
description: HvCallUnmapVpStatePage hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallUnmapVpStatePage

The HvCallUnmapVpStatePage hypercall unmaps a previously mapped VP state page.

## Interface

```c
HV_STATUS
HvCallUnmapVpStatePage(
    _In_ HV_PARTITION_ID   PartitionId,
    _In_ HV_VP_INDEX       VpIndex,
    _In_ UINT16            Type,
    _In_ HV_INPUT_VTL      InputVtl,
    _In_ UINT8             Reserved0
);
```

## Call Code

`0x00E2` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| PartitionId             | 0          | 8        | Specifies the partition ID               |
| VpIndex                 | 8          | 4        | Specifies the VP index                   |
| Type                    | 12         | 2        | State page type ([HV_VP_STATE_PAGE_TYPE](../datatypes/hv_vp_state_page_type.md))        |
| InputVtl                | 14         | 1        | Specifies the input VTL                  |
| Reserved0               | 15         | 1        | Reserved                                 |

## See Also

[HV_PARTITION_ID](../datatypes/hv_partition_id.md)
[HV_VP_INDEX](../datatypes/hv_vp_index.md)
[HV_INPUT_VTL](../datatypes/hv_input_vtl.md)
[HV_VP_STATE_PAGE_TYPE](../datatypes/hv_vp_state_page_type.md)
[HvCallMapVpStatePage](HvCallMapVpStatePage.md)
