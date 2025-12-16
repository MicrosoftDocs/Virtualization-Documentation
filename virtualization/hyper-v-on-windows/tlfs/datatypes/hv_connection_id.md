---
title: HV_CONNECTION_ID
description: HV_CONNECTION_ID
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_CONNECTION_ID

## Overview
Connections are identified by 32-bit IDs. The high 8 bits are reserved and must be zero. All connection IDs are unique within a partition.

## Syntax

 ```c
typedef union
{
    UINT32 AsUInt32;
    struct
    {
        UINT32 Id:24;
        UINT32 Reserved:8;
    };
} HV_CONNECTION_ID;
 ```
