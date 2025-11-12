---
title: HV_CRASH_CTL_REG_CONTENTS
description: HV_CRASH_CTL_REG_CONTENTS
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HV_CRASH_CTL_REG_CONTENTS

The following data structure is used to define the contents of the guest crash enlightenment control register (HV_X64_MSR_CRASH_CTL).

## Syntax

 ```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Reserved      : 58; // Reserved bits
        UINT64 PreOSId       : 3;  // Crash occurred in the preOS environment
        UINT64 NoCrashDump   : 1;  // Crash dump will not be captured
        UINT64 CrashMessage  : 1;  // P3 is the PA of the message, P4 is the length in bytes
        UINT64 CrashNotify   : 1;  // Log contents of crash parameter system registers
    };
} HV_CRASH_CTL_REG_CONTENTS;
 ```

## See also

 [Partition Crash Enlightenment](../partition-properties.md#partition-crash-enlightenment)