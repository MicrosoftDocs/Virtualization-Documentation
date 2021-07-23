---
title: HvExtCallQueryCapabilities
description: HvExtCallQueryCapabilities hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvExtCallQueryCapabilities

This hypercall reports the availability of extended hypercalls.

The availability of this hypercall must be queried using the EnableExtendedHypercalls partition privilege flag.

## Interface

 ```c
HV_STATUS
HvExtCallQueryCapabilities(
    _Out_ UINT64 Capabilities
    );
 ```

## Call Code

`0x8001` (Simple)

## Output Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `Capabilities`          | 0          | 8        | Bitmask of supported extended hypercalls                          |

The bitmask of supported extended hypercalls has the following format:

| Bit     | Extended Hypercall                                          |
|---------|-------------------------------------------------------------|
| 0       | HvExtCallGetBootZeroedMemory                                |
| 1       | HvExtCallMemoryHeatHint                                     |
| 2       | HvExtCallEpfSetup                                           |
| 3       | HvExtCallSchedulerAssistSetup                               |
| 4       | HvExtCallMemoryHeatHintAsync                                |
| 63-5    | Reserved                                                    |
