---
title: HvCallNotifyLongSpinWait
description: HvCallNotifyLongSpinWait hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallNotifyLongSpinWait

The HvCallNotifyLongSpinWait hypercall is used by a guest OS to notify the hypervisor that the calling virtual processor is attempting to acquire a resource that is potentially held by another virtual processor within the same partition. This scheduling hint improves the scalability of partitions with more than one virtual processor.

## Interface

 ```c
HV_STATUS
HvCallNotifyLongSpinWait(
    _In_ UINT64 SpinCount
    );
 ```

## Call Code

`0x0008` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `SpinCount`             | 0          | 4        | Specifies the accumulated count the guest was spinning. |
| RsvdZ                   | 4          | 4        |                                           |

## Return Values

There is no error status for this hypercall, only HV_STATUS_SUCCESS will be returned as this is an advisory hypercall.