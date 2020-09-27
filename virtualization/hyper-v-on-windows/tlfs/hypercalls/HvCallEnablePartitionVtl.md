# HvCallEnablePartitionVtl

The HvCallEnablePartitionVtl hypercall enables a virtual trust level for a specified partition. It should be used in conjunction with HvCallEnableVpVtl to initiate and use a new VTL.

## Interface

 ```c

typedef union
{
    UINT8 AsUINT8;
    struct {
        UINT8 EnableMbec:1;
        UINT8 Reserved:7;
    };
} HV_ENABLE_PARTITION_VTL_FLAGS;

HV_STATUS
HvCallEnablePartitionVtl(
    _In_ HV_PARTITION_ID TargetPartitionId,
    _In_ HV_VTL TargetVtl,
    _In_ HV_ENABLE_PARTITION_VTL_FLAGS Flags
    );
 ```

### Restrictions

- A launching VTL can always enable a target VTL if the target VTL is lower than the launching VTL.
- A launching VTL can enable a higher target VTL if the launching VTL is the highest VTL enabled for the partition that is lower than the target VTL.

## Call Code
`0x000D` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `TargetPartitionId`     | 0          | 8        | Supplies the partition ID of the partition this request is for. |
| `TargetVtl`             | 8          | 1        | Specifies the VTL to be enabled by this hypercall. |
| `Flags`                 | 9          | 1        | Specifies a mask to enable VSM related features.|
| RsvdZ                   | 10         | 6        |                                           |