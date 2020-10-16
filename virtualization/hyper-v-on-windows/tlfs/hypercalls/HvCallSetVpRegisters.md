---
title: HvCallSetVpRegisters
description: HvCallSetVpRegisters hypercall
keywords: hyper-v
author: alexgrest
ms.author: alegre
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
    _Inout_ PUINT32 RegisterCount,
    _In_reads(RegisterCount) PCHV_REGISTER_NAME RegisterNameList,
    _In_reads(RegisterCount) PCHV_REGISTER_VALUE RegisterValueList
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

## See also

[HV_REGISTER_NAME](../datatypes/HV_REGISTER_NAME.md)

[HV_REGISTER_VALUE](../datatypes/HV_REGISTER_VALUE.md)
