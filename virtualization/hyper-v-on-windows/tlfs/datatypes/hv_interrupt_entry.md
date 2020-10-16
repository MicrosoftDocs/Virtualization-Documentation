---
title: HV_INTERRUPT_ENTRY
description: HV_INTERRUPT_ENTRY
keywords: hyper-v
author: alexgrest
ms.author: alegre
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_INTERRUPT_ENTRY

## Syntax

 ```c
typedef enum
{
    HvInterruptSourceMsi = 1,
} HV_INTERRUPT_SOURCE;

typedef struct
{
    HV_INTERRUPT_SOURCE InterruptSource;
    UINT32 Reserved;

    union
    {
        HV_MSI_ENTRY MsiEntry;
        UINT64 Data;
    };
} HV_INTERRUPT_ENTRY;
 ```

## See also

[HV_MSI_ENTRY](HV_MSI_ENTRY.md)