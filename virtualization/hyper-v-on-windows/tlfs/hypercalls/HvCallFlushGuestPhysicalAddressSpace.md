---
title: HvCallFlushGuestPhysicalAddressSpace
description: HvCallFlushGuestPhysicalAddressSpace hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallFlushGuestPhysicalAddressSpace

The HvCallFlushGuestPhysicalAddressSpace hypercall invalidates cached L2 GPA to GPA mappings within a second level address space.

## Interface

 ```c
HV_STATUS
HvCallFlushGuestPhysicalAddressSpace(
    _In_ HV_SPA AddressSpace,
    _In_ UINT64 Flags
    );
 ```

This hypercall can only be used with nested virtualization is active. The virtual TLB invalidation operation acts on all processors.

On Intel platforms, the HvCallFlushGuestPhysicalAddressSpace hypercall is like the execution of an INVEPT instruction with type “single-context” on all processors.

This call guarantees that by the time control returns to the caller, the observable effects of all flushes have occurred.
If the TLB is currently “locked”, the caller’s virtual processor is suspended.

## Call Code

`0x00AF` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (EPT PML4 table pointer). |
| `Flags`                 | 8          | 8        | RsvdZ                                     |