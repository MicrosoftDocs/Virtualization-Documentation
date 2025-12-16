---
title: HV_MSI_ENTRY
description: HV_MSI_ENTRY
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_MSI_ENTRY

## Syntax

 ```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT32 Address;
        UINT32 Data;
    };
} HV_MSI_ENTRY;
 ```