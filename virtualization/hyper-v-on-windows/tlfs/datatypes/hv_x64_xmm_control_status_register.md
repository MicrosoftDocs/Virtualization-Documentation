---
title: HV_X64_XMM_CONTROL_STATUS_REGISTER
description: HV_X64_XMM_CONTROL_STATUS_REGISTER
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_X64_XMM_CONTROL_STATUS_REGISTER

Architecture: x64 only.

## Syntax

```c
typedef struct
{
    union
    {
        UINT64 LastFpRdp;
        struct
        {
            UINT32 LastFpDp;
            UINT16 LastFpDs;
        };
    };

    UINT32 XmmStatusControl;
    UINT32 XmmStatusControlMask;
} HV_X64_XMM_CONTROL_STATUS_REGISTER;
 ```
