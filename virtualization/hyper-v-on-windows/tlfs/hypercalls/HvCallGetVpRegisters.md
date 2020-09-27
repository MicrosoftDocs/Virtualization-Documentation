# HvCallGetVpRegisters

The HvCallGetVpRegisters hypercall reads the state of a virtual processor.

## Interface

 ```c
HV_STATUS
HvCallGetVpRegisters(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_INPUT_VTL InputVtl,
    _Inout_ PUINT32 RegisterCount,
    _In_reads(RegisterCount) PCHV_REGISTER_NAME RegisterNameList,
    _In_writes(RegisterCount) PHV_REGISTER_VALUE RegisterValueList
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

## See also

[HV_REGISTER_NAME](../datatypes/HV_REGISTER_NAME.md)

[HV_REGISTER_VALUE](../datatypes/HV_REGISTER_VALUE.md)
