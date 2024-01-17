---
title: HvCallVtlCall
description: HvCallVtlCall hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallVtlCall

HvCallVtlCall initiates a "[VTL call](../vsm.md#vtl-call)" and switches into the next highest VTL enabled on the VP.

## Interface

 ```c
HV_STATUS
HvCallVtlCall(
    VOID
    );
 ```

## Call Code

`0x0011` (Simple)