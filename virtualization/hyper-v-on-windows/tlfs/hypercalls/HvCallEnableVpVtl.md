# HvCallEnableVpVtl

HvCallEnableVpVtl enables a VTL to run on a VP. This hypercall should be used in conjunction with HvCallEnablePartitionVtl to enable and use a VTL. To enable a VTL on a VP, it must first be enabled for the partition. This call does not change the active VTL.

## Interface

 ```c

HV_STATUS
HvEnableVpVtl(
    _In_ HV_PARTITION_ID TargetPartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_VTL TargetVtl,
    _In_ HV_INITIAL_VP_CONTEXT VpVtlContext
    );
 ```

### Restrictions

In general, a VTL can only be enabled by a higher VTL. There is one exception to this rule: the highest VTL enabled for a partition can enable a higher target VTL.

Once the target VTL is enabled on a VP, all other calls to enable the VTL must come from equal or greater VTLs.
This hypercall will fail if called to enable a VTL that is already enabled for a VP.

## Call Code
`0x000F` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `TargetPartitionId`     | 0          | 8        | Supplies the partition ID of the partition this request is for. |
| `VpIndex`               | 8          | 4        | Specifies the index of the virtual processor on which to enable the VTL. |
| `TargetVtl`             | 12         | 1        | Specifies the VTL to be enabled by this hypercall. |
| RsvdZ                   | 13         | 3        |                                           |
| `VpVtlContext`          | 16         | 224      | Specifies the initial context in which the VP should start upon the first entry to the target VTL. |

## See also

[HV_INITIAL_VP_CONTEXT](../datatypes/HV_INITIAL_VP_CONTEXT.md)