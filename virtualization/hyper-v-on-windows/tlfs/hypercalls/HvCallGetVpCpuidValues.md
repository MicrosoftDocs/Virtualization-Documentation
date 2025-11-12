---
title: HvCallGetVpCpuidValues
description: HvCallGetVpCpuidValues hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallGetVpCpuidValues

HvCallGetVpCpuidValues retrieves the CPUID values that are exposed to a specific virtual processor. This hypercall allows querying the virtualized CPUID information that the hypervisor presents to the guest, which may differ from the physical processor's CPUID values due to virtualization features and compatibility requirements.

## Interface

```c
HV_STATUS
HvCallGetVpCpuidValues(
    _In_ HV_PARTITION_ID        PartitionId,
    _In_ HV_VP_INDEX            VpIndex,
    _In_ HV_GET_VP_CPUID_VALUES_FLAGS Flags,
    _In_ UINT32 ReservedZ,
    _In_ const HV_CPUID_LEAF_INFO* CpuidLeafInfo, // Reads RepCount elements
    _Out_ HV_CPUID_RESULT*   CpuidResult // Writes RepCount elements
);
```

## Call Code

`0x00F4` (Rep)

## Restrictions

Architecture: x64 only.


## Input Parameters (per repetition element)

| Name          | Offset | Size | Information Provided |
|---------------|--------|------|----------------------|
| PartitionId   | 0      | 8    | Target partition |
| VpIndex       | 8      | 4    | VP index |
| Flags         | 12     | 4    | Flags  |
| ReservedZ     | 16     | 4    | Reserved (Must be zero) |
| CpuidLeafInfo | 24     | 8    | Leaf/Subleaf descriptor |

## Output Parameters (per repetition element)

| Name        | Offset | Size | Information Provided |
|-------------|--------|------|----------------------|
| CpuidResult | 0      | 16   | EAX/EBX/ECX/EDX synthesized result |

## See Also

- [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
- [HV_VP_INDEX](../datatypes/hv_vp_index.md)
- [HV_GET_VP_CPUID_VALUES_FLAGS](../datatypes/hv_get_vp_cpuid_values_flags.md)
- [HV_CPUID_RESULT](../datatypes/hv_cpuid_result.md)
