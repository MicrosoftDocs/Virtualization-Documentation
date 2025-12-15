---
title: HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS
description: HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS

## Overview
Parameter union selecting which previously registered intercept result entries to remove.

Architecture:
- x64 only: Applies only where intercept result registration is supported. Not present on ARM64.

## Syntax

```c
typedef union
{
    HV_UNREGISTER_X64_CPUID_RESULT_PARAMETERS Cpuid;
    HV_UNREGISTER_X64_MSR_RESULT_PARAMETERS Msr;
} HV_UNREGISTER_INTERCEPT_RESULT_PARAMETERS;
```

### Members

- **Cpuid**: An `HV_UNREGISTER_X64_CPUID_RESULT_PARAMETERS` structure containing parameters for unregistering CPUID instruction intercepts.
- **Msr**: An `HV_UNREGISTER_X64_MSR_RESULT_PARAMETERS` structure containing parameters for unregistering Model Specific Register (MSR) access intercepts.

## Description
- For CPUID unregistration supply the same masked pattern used during registration.
- For MSR unregistration supply the MSR index and access type combination.

## See Also
* [HvCallUnregisterInterceptResult](../hypercalls/HvCallUnregisterInterceptResult.md)
* [HvCallRegisterInterceptResult](../hypercalls/HvCallRegisterInterceptResult.md)
