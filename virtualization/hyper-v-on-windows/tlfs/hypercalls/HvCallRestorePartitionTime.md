---
title: HvCallRestorePartitionTime
description: HvCallRestorePartitionTime hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/05/2026
ms.topic: reference
---

# HvCallRestorePartitionTime

The HvCallRestorePartitionTime hypercall sets a partition's reference time and TSC to values that the partition saved earlier. A partition uses it when it resumes from hibernation, so that its time does not go backward.

Architecture: x64 only.

The following checks should be used to infer the availability of this hypercall:

- RestoreTimeOnResume must be indicated via [CPUID leaf 0x40000004](../feature-discovery.md#implementation-recommendations---0x40000004).

## Interface

```c
HV_STATUS
HvCallRestorePartitionTime(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ UINT32 TscSequence,
    _In_ UINT64 ReferenceTime,
    _In_ UINT64 Tsc
    );
```

Before hibernating, the partition saves its reference time, the `TscSequence` value from the same read of its reference TSC page, and a TSC value. On resume, it passes these values to HvCallRestorePartitionTime once, before other code reads time. To keep time from going backward, `Tsc` should be no lower than any TSC value that a virtual processor has read, and `ReferenceTime` should be no lower than any reference time that the partition has read.

The hypervisor sets the TSC of every virtual processor, in every VTL, to `Tsc`, and sets the partition reference counter so that it reads `ReferenceTime` when the TSC reads `Tsc`. The hypervisor also changes the IA32_TSC_ADJUST value of each virtual processor to reflect the TSC change.

If the reference TSC page is valid, the hypervisor writes `TscSequence` to the page, then updates the page so that reference time continues from `ReferenceTime`. The resulting `TscSequence` may differ from the value that was passed in. If `TscSequence` is 0, the page is not valid after the call. In both cases, the partition must follow the [reference TSC page protocol](../timers.md#partition-reference-tsc-mechanism).

## Call Code

`0x0103` (Simple)

## Restrictions

- The partition must possess the AccessPartitionReferenceCounter and AccessPartitionReferenceTsc privileges.
- The partition cannot be the root partition or a hardware-isolated partition.
- The caller must run in the highest VTL enabled for its partition.

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Specifies the partition whose time is restored. A partition restores its own time by specifying HV_PARTITION_ID_SELF. |
| `TscSequence`           | 8          | 4        | Specifies the `TscSequence` value from the reference TSC page read that produced `ReferenceTime`, or 0 if the page was unavailable or not valid. |
| RsvdZ                   | 12         | 4        |                                           |
| `ReferenceTime`         | 16         | 8        | Specifies the partition reference time to restore, in 100-nanosecond units. |
| `Tsc`                   | 24         | 8        | Specifies the TSC value that corresponds to `ReferenceTime`. |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | The caller is not permitted to access the specified partition. |
|                                     | The partition does not support time restoration. |
|                                     | The partition does not possess the AccessPartitionReferenceCounter or AccessPartitionReferenceTsc privilege. |
|                                     | The partition is the root partition or a hardware-isolated partition. |
|                                     | The caller is not running in the highest VTL enabled for its partition. |
| `HV_STATUS_INVALID_PARTITION_ID`    | The specified partition ID is invalid.                |
| `HV_STATUS_INVALID_PARTITION_STATE` | The specified partition is not in the “active” state. |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_PARTITION_PRIVILEGE_MASK](../datatypes/hv_partition_privilege_mask.md)
* [Partition Reference Time Enlightenment](../timers.md#partition-reference-time-enlightenment)
