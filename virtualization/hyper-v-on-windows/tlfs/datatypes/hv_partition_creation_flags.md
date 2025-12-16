---
title: HV_PARTITION_CREATION_FLAGS
description: HV_PARTITION_CREATION_FLAGS data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference
---

# HV_PARTITION_CREATION_FLAGS

HV_PARTITION_CREATION_FLAGS is a bitmask (UINT64) controlling behavior and initial capabilities of a newly created partition. A flag being present authorizes or requests the corresponding feature; absence leaves it disabled or at the platform default.

## Syntax

```c
#define HV_PARTITION_CREATION_FLAG_SMT_ENABLED_GUEST                    (1ULL << 0)
#define HV_PARTITION_CREATION_FLAG_NESTED_VIRTUALIZATION_CAPABLE        (1ULL << 1)
#define HV_PARTITION_CREATION_FLAG_GPA_SUPER_PAGES_ENABLED              (1ULL << 4)
#define HV_PARTITION_CREATION_FLAG_EXO_PARTITION                        (1ULL << 8)
#define HV_PARTITION_CREATION_FLAG_VTL1_OVERRIDE                        (1ULL << 9)
#define HV_PARTITION_CREATION_FLAG_VTL2_OVERRIDE                        (1ULL << 10)
#define HV_PARTITION_CREATION_FLAG_LAPIC_ENABLED                        (1ULL << 13)
#define HV_PARTITION_CREATION_FLAG_ENABLE_PERFMON_PMU                   (1ULL << 15)
#define HV_PARTITION_CREATION_FLAG_ENABLE_PERFMON_LBR                   (1ULL << 16)
#define HV_PARTITION_CREATION_FLAG_INTERCEPT_MESSAGE_PAGE_ENABLED       (1ULL << 19)
#define HV_PARTITION_CREATION_FLAG_HYPERCALL_DOORBELL_PAGE_ENABLED      (1ULL << 20)
#define HV_PARTITION_CREATION_FLAG_X2APIC_CAPABLE                       (1ULL << 22)

```

## Architecture Notes

The following flags are x64-specific and are ignored on ARM64:
- `HV_PARTITION_CREATION_FLAG_LAPIC_ENABLED` - Local APIC is x64-specific
- `HV_PARTITION_CREATION_FLAG_X2APIC_CAPABLE` - x2APIC is x64-specific

See Also:
- [`HvCallCreatePartition`](../hypercalls/HvCallCreatePartition.md)
- [`HV_PARTITION_CREATION_PROPERTIES`](hv_partition_creation_properties.md)
