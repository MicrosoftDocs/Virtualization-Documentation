---
title: HV_VP_STATE_PAGE_TYPE
description: HV_VP_STATE_PAGE_TYPE data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/01/2025
ms.topic: reference
---

# HV_VP_STATE_PAGE_TYPE

## Overview
Enumeration that specifies the type of virtual processor state page to map or unmap. State pages provide access to different categories of VP-specific information and resources.

## Syntax

```c
typedef enum _HV_VP_STATE_PAGE_TYPE
{
    HvVpStatePageRegisters = 0,
    HvVpStatePageInterceptMessage = 1,
    HvVpVtlStatePageGhcb = 2
} HV_VP_STATE_PAGE_TYPE;
```

## Values

| Value | Name | Description |
|-------|------|-------------|
| 0 | HvVpStatePageRegisters | Register state page containing virtual processor register values |
| 1 | HvVpStatePageInterceptMessage | Intercept message page for handling VM exits and intercepts |
| 2 | HvVpVtlStatePageGhcb | Guest Hypervisor Communication Block (GHCB) page for SEV-SNP and VTL communication (x64 only - AMD SEV) |

## See Also

* [HvCallMapVpStatePage](../hypercalls/HvCallMapVpStatePage.md)
* [HvCallUnmapVpStatePage](../hypercalls/HvCallUnmapVpStatePage.md)
* [HV_VP_INDEX](hv_vp_index.md)
* [HV_INPUT_VTL](hv_input_vtl.md)
* [HV_PARTITION_ID](hv_partition_id.md)
