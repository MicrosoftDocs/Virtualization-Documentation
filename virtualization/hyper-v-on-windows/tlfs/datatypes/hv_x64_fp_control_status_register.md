---
title: HV_X64_FP_CONTROL_STATUS_REGISTER
description: HV_X64_FP_CONTROL_STATUS_REGISTER
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_X64_FP_CONTROL_STATUS_REGISTER

## Syntax

```c
typedef struct
{
    UINT16 FpControl;
    UINT16 FpStatus;
    UINT8 FpTag;
    UINT8 Reserved:8;
    UINT16 LastFpOp;
    union {
        UINT64 LastFpRip;
        struct {
            UINT32 LastFpEip;
            UINT16 LastFpCs;
        };
     };
 } HV_X64_FP_CONTROL_STATUS_REGISTER;
 ```
