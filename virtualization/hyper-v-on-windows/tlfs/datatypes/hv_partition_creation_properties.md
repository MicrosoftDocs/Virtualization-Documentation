---
title: HV_PARTITION_CREATION_PROPERTIES
description: HV_PARTITION_CREATION_PROPERTIES data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference

---

# HV_PARTITION_CREATION_PROPERTIES

HV_PARTITION_CREATION_PROPERTIES supplies optional processor feature disable masks at partition creation time.

## Syntax

```c
// AMD64
typedef struct {
    HV_PARTITION_PROCESSOR_FEATURES DisabledProcessorFeatures;
    HV_PARTITION_PROCESSOR_XSAVE_FEATURES DisabledProcessorXsaveFeatures;
} HV_PARTITION_CREATION_PROPERTIES_AMD64; 

// ARM64
typedef struct {
    HV_PARTITION_PROCESSOR_FEATURES  DisabledProcessorFeatures; 
} HV_PARTITION_CREATION_PROPERTIES_ARM64;
```

Field Notes:
- DisabledProcessorFeatures: Each set bit masks (disables) the corresponding reported processor processor feature for guest VPs. Unset bits leave the feature enabled if globally available.
- DisabledProcessorXsaveFeatures (AMD64 only): Masks XSAVE-managed extended state components; bits correspond to architectural XSTATE components. Disabling a component removes exposure via CPUID/XSTATE size enumeration.

See Also:
- [`HvCallCreatePartition`](../hypercalls/HvCallCreatePartition.md)
- [`HV_PARTITION_CREATION_FLAGS`](hv_partition_creation_flags.md)
- ['HV_PARTITION_PROCESSOR_FEATURES'](hv_partition_processor_features.md)