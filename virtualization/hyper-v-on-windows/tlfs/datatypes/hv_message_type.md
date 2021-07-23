---
title: HV_MESSAGE_TYPE
description: HV_MESSAGE_TYPE
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_MESSAGE_TYPE

SynIC messages encode the message type as a 32-bit number. Any message type that has the high bit set is reserved for use by the hypervisor. Guest-initiated messages cannot send messages with a hypervisor message type.

## Syntax

 ```c
#define HV_MESSAGE_TYPE_HYPERVISOR_MASK 0x80000000

typedef enum
{
    HvMessageTypeNone = 0x00000000,

    // Memory access messages
    HvMessageTypeUnmappedGpa = 0x80000000,
    HvMessageTypeGpaIntercept = 0x80000001,

    // Timer notifications
    HvMessageTimerExpired = 0x80000010,

    // Error messages
    HvMessageTypeInvalidVpRegisterValue = 0x80000020,
    HvMessageTypeUnrecoverableException = 0x80000021,
    HvMessageTypeUnsupportedFeature = 0x80000022,
    HvMessageTypeTlbPageSizeMismatch = 0x80000023,

    // Hypercall intercept
    HvMessageTypeHypercallIntercept = 0x80000050,

    // Platform-specific processor intercept messages
    HvMessageTypeX64IoPortIntercept = 0x80010000,
    HvMessageTypeMsrIntercept = 0x80010001,
    HvMessageTypeX64CpuidIntercept = 0x80010002,
    HvMessageTypeExceptionIntercept = 0x80010003,
    HvMessageTypeX64ApicEoi = 0x80010004,
    HvMessageTypeX64LegacyFpError = 0x80010005,
    HvMessageTypeRegisterIntercept = 0x80010006,
} HV_MESSAGE_TYPE;
 ```
