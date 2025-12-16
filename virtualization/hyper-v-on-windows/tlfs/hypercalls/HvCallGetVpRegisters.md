---
title: HvCallGetVpRegisters
description: HvCallGetVpRegisters hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HvCallGetVpRegisters

The HvCallGetVpRegisters hypercall reads the state of a virtual processor.

## Interface

 ```c
HV_STATUS
HvCallGetVpRegisters(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_INPUT_VTL InputVtl,
    _Inout_ UINT32* RegisterCount,
    _In_reads_(*RegisterCount) const HV_REGISTER_NAME* RegisterNameList,
    _Out_writes_(*RegisterCount) HV_REGISTER_VALUE* RegisterValueList
    );
 ```

The state is returned as a series of register values, each corresponding to a register name provided as input.

### Restrictions

- The caller must either be the parent of the partition specified by PartitionId, or the partition specified must be “self” and the partition must have the AccessVpRegisters privilege.

## Call Code

`0x0050` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Specifies the partition Id.               |
| `VpIndex`               | 8          | 4        | Specifies the index of the virtual processor. |
| `TargetVtl`             | 12         | 1        | specifies the target VTL.                 |
| RsvdZ                   | 13         | 3        |                                           |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `RegisterName`          | 0          | 4        | Specifies the name of a register to be read. |

## Output List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `RegisterValue`         | 0          | 16       | Returns the value of the specified register. |

## Early Register List (ARM64)

On ARM64, certain registers can be read using this hypercall before the Guest OS ID register (`HvRegisterGuestOsId`) is set to a non-zero value. This allows early access to hypervisor information and critical system registers during the boot process.

The following registers are permitted to be read before Guest OS identification:

| Register Name | Description |
|---------------|-------------|
| `HvRegisterGuestOsId` | Guest operating system identification register |
| `HvRegisterHypervisorVersion` | Hypervisor version information |
| `HvRegisterPrivilegesAndFeaturesInfo` | Partition privileges and feature information |
| `HvRegisterFeaturesInfo` | Hypervisor feature information |
| `HvRegisterImplementationLimitsInfo` | Implementation-specific limits |
| `HvRegisterHardwareFeaturesInfo` | Hardware feature information |
| `HvRegisterTimeRefCount` | Time reference counter |
| `HvArm64RegisterSyntheticVbarEl1` | Synthetic Vector Base Address Register for EL1 |
| `HvArm64RegisterSyntheticEsrEl1` | Synthetic Exception Syndrome Register for EL1 |
| `HvRegisterGuestCrashCtl` | Guest crash control register |
| `HvRegisterGuestCrashP0` | Guest crash parameter 0 |
| `HvRegisterGuestCrashP1` | Guest crash parameter 1 |
| `HvRegisterGuestCrashP2` | Guest crash parameter 2 |
| `HvRegisterGuestCrashP3` | Guest crash parameter 3 |
| `HvRegisterGuestCrashP4` | Guest crash parameter 4 |

All other registers require the Guest OS ID to be established (non-zero) before they can be read through this hypercall.

**Note:** These early-accessible registers primarily provide hypervisor capability information and crash reporting functionality, enabling guests to discover hypervisor features and establish basic functionality before full Guest OS identification.

## See also

[HV_REGISTER_NAME](../datatypes/hv_register_name.md)

[HV_REGISTER_VALUE](../datatypes/hv_register_value.md)
