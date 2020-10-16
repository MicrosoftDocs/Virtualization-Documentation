---
title: HvCallSendSyntheticClusterIpi
description: HvCallSendSyntheticClusterIpi hypercall
keywords: hyper-v
author: alexgrest
ms.author: alegre
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallSendSyntheticClusterIpi

This hypercall sends a virtual fixed interrupt to the specified virtual processor set. It does not support NMIs.

## Interface

 ```c
HV_STATUS
HvCallSendSyntheticClusterIpi(
    _In_ UINT32 Vector,
    _In_ HV_INPUT_VTL TargetVtl,
    _In_ UINT64 ProcessorMask
    );
 ```

## Call Code
`0x000b` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `Vector`                | 0          | 4        | Specified the vector asserted. Must be between >= 0x10 and <= 0xFF.  |
| `TargetVtl`             | 4          | 1        | Target VTL                                |
| Padding                 | 5          | 3        |                                           |
| `ProcessorMask`         | 8          | 1        | Specifies a mask representing VPs to target|
