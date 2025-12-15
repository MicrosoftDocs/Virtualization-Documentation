---
title: HvCallVtlReturn
description: HvCallVtlReturn hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallVtlReturn

HvCallVtlReturn initiates a "[VTL Return](../vsm.md#vtl-return)" and switches into the next lowest VTL enabled on the VP.

## Interface

 ```c
HV_STATUS
HvCallVtlReturn(
    VOID
    );
 ```

## Call Code

`0x0012` (Simple)