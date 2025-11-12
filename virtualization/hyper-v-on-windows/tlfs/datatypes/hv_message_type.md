---
title: HV_MESSAGE_TYPE
description: Synthetic message types delivered via the SynIC message mechanism
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 09/02/2025
ms.topic: reference

---

# HV_MESSAGE_TYPE

## Overview
SynIC messages encode the message type as a 32-bit number. Any message type that has the high bit set is reserved for use by the hypervisor. Guest-initiated messages cannot send messages with a hypervisor message type.

## Syntax
```c
#define HV_MESSAGE_TYPE_HYPERVISOR_MASK 0x80000000

typedef enum _HV_MESSAGE_TYPE {
    HvMessageTypeNone                               = 0x00000000,

    /* Memory access messages */
    HvMessageTypeUnmappedGpa                        = 0x80000000,
    HvMessageTypeGpaIntercept                       = 0x80000001,
    HvMessageTypeUnacceptedGpa                      = 0x80000003,
    HvMessageTypeGpaAttributeIntercept              = 0x80000004,

    /* Timer notification messages */
    HvMessageTimerExpired                           = 0x80000010,

    /* Error / fault messages */
    HvMessageTypeInvalidVpRegisterValue             = 0x80000020,
    HvMessageTypeUnrecoverableException             = 0x80000021,
    HvMessageTypeUnsupportedFeature                 = 0x80000022,

     /* Opaque intercept (details via intercept page) */
    HvMessageTypeOpaqueIntercept                    = 0x8000003F,

    /* Hypercall intercept */
    HvMessageTypeHypercallIntercept                 = 0x80000050,

    /* SynIC related */
    HvMessageTypeSynicEventIntercept                = 0x80000060,
    HvMessageTypeSynicSintIntercept                 = 0x80000061,
    HvMessageTypeSynicSintDeliverable               = 0x80000062,

    /* Async call completion */
    HvMessageTypeAsyncCallCompletion                = 0x80000070,
    HvMessageInsufficientMemory                     = 0x80000071,

    /* Scheduler (root / integrated) message id range */
    HvMessageTypeSchedulerVpSignalBitset            = 0x80000100,
    HvMessageTypeSchedulerVpSignalPair              = 0x80000101,

    /* Platform-specific processor intercept messages */
    HvMessageTypeX64IoPortIntercept                 = 0x80010000, /* x64 */
    HvMessageTypeMsrIntercept                       = 0x80010001, /* All */
    HvMessageTypeX64CpuidIntercept                  = 0x80010002, /* x64 */
    HvMessageTypeExceptionIntercept                 = 0x80010003, /* All */
    HvMessageTypeX64ApicEoi                         = 0x80010004, /* x64 */
    HvMessageTypeRegisterIntercept                  = 0x80010006, /* All */
    HvMessageTypeX64Halt                            = 0x80010007, /* x64 */
    HvMessageTypeX64InterruptionDeliverable         = 0x80010008, /* x64 */
    HvMessageTypeX64SipiIntercept                   = 0x80010009, /* x64 */
    HvMessageTypeX64RdtscIntercept                  = 0x8001000A, /* x64 */
    HvMessageTypeX64ApicSmiIntercept                = 0x8001000B, /* x64 */
    HvMessageTypeArm64ResetIntercept                = 0x8001000C, /* Arm64 */
    HvMessageTypeX64ApicInitSipiIntercept           = 0x8001000D, /* x64 */
    HvMessageTypeX64ApicWriteIntercept              = 0x8001000E, /* x64 */
    HvMessageTypeX64SnpGuestRequestIntercept        = 0x80010011, /* x64 */
    HvMessageTypeX64ExceptionTrapIntercept          = 0x80010012, /* x64 */
    HvMessageTypeX64SevVmgexitIntercept             = 0x80010013, /* x64 */
    HvMessageTypeX64MsrListIntercept                = 0x80010015, /* x64 */
} HV_MESSAGE_TYPE;
```