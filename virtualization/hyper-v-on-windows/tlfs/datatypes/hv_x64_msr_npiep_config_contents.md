---
title: HV_X64_MSR_NPIEP_CONFIG_CONTENTS
description: HV_X64_MSR_NPIEP_CONFIG_CONTENTS
keywords: hyper-v
author: alexgrest
ms.author: alegre
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_X64_MSR_NPIEP_CONFIG_CONTENTS

## Syntax

```c
union
{
    UINT64 AsUINT64;
    struct
    {
        // These bits enable instruction execution prevention for specific
        // instructions.

        UINT64 PreventSgdt:1;
        UINT64 PreventSidt:1;
        UINT64 PreventSldt:1;
        UINT64 PreventStr:1;
        UINT64 Reserved:60;
    };
} HV_X64_MSR_NPIEP_CONFIG_CONTENTS;
 ```
