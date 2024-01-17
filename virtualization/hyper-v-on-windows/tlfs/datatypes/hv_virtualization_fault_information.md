---
title: HV_VIRTUALIZATION_FAULT_INFORMATION
description: HV_VIRTUALIZATION_FAULT_INFORMATION
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_VIRTUALIZATION_FAULT_INFORMATION

The virtualization fault information area contains the current fault code and fault parameters for the VP. It is 16 byte aligned.

## Syntax

```c
typedef union
{
    struct
    {
        UINT16 Parameter0;
        UINT16 Reserved0;
        UINT32 Code;
        UINT64 Parameter1;
    };
} HV_VIRTUALIZATION_FAULT_INFORMATION, *PHV_VIRTUALIZATION_FAULT_INFORMATION;
 ```

## See also

 [HV_VP_ASSIST_PAGE](HV_VP_ASSIST_PAGE.md)