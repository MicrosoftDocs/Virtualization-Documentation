---
title: HvCallSetVpRegisters
description: HvCallSetVpRegisters hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallSetVpRegisters

The HvCallSetVpRegisters hypercall writes the state of a virtual processor.

## Interface

 ```c
HV_STATUS
HvCallSetVpRegisters(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_INPUT_VTL InputVtl,
    _Inout_ UINT32* RegisterCount,
    _In_reads_(*RegisterCount) const HV_REGISTER_NAME* RegisterNameList,
    _In_reads_(*RegisterCount) const HV_REGISTER_VALUE* RegisterValueList
    );
 ```

The state is written as a series of register values, each corresponding to a register name provided as input.

Minimal error checking is performed when a register value is modified. In particular, the hypervisor will validate that reserved bits of a register are set to zero, bits that are architecturally defined as always containing a zero or a one are set appropriately, and specified bits beyond the architectural size of the register are zeroed.

This call cannot be used to modify the value of a read-only register.

Side-effects of modifying a register are not performed. This includes generation of exceptions, pipeline synchronizations, TLB flushes, and so on.

### Restrictions

- The caller must either be the parent of the partition specified by PartitionId, or the partition specified must be “self” and the partition must have the AccessVpRegisters privilege.

## Call Code

`0x0051` (Rep)

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
| `RegisterName`          | 0          | 4        | Specifies the name of a register to be modified. |
| RsvdZ                   | 4          | 12       |                                           |
| `RegisterValue`         | 16         | 16       | Specifies the new value for the specified register. |

## Early Register List (ARM64)

On ARM64, certain registers can be set using this hypercall before the Guest OS ID register (`HvRegisterGuestOsId`) is set to a non-zero value. This allows early initialization of critical system registers during the boot process.

The following registers are permitted to be set before Guest OS identification:

| Register Name | Description |
|---------------|-------------|
| `HvRegisterGuestOsId` | Guest operating system identification register |
| `HvArm64RegisterSyntheticVbarEl1` | Synthetic Vector Base Address Register for EL1 |
| `HvRegisterGuestCrashCtl` | Guest crash control register |
| `HvRegisterGuestCrashP0` | Guest crash parameter 0 |
| `HvRegisterGuestCrashP1` | Guest crash parameter 1 |
| `HvRegisterGuestCrashP2` | Guest crash parameter 2 |
| `HvRegisterGuestCrashP3` | Guest crash parameter 3 |
| `HvRegisterGuestCrashP4` | Guest crash parameter 4 |

All other registers require the Guest OS ID to be established (non-zero) before they can be modified through this hypercall.

**Note:** Setting `HvRegisterGuestOsId` to a non-zero value is typically the first step in the hypervisor initialization sequence, as it identifies the guest operating system to the hypervisor and enables access to the full register set.

## See also

[HV_REGISTER_NAME](../datatypes/hv_register_name.md)

[HV_REGISTER_VALUE](../datatypes/hv_register_value.md)
