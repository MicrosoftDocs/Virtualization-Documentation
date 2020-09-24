# HvCallGetVpIndexFromApicId

The HvCallGetVpIndexFromApicId allows the caller to retrieve a VP index for the VP with the specified APID ID.

## Interface

 ```c
HV_STATUS
HvCallGetVpIndexFromApicId
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VTL TargetVtl,
    _Inout_ PUINT32 ApicIdCoount,
    _In_reads_(ApicIdCount) PHV_APIC_ID ApicIdList,
    _Out_writes(ApicIdCount) PHV_VP_INDEX VpIndexList
    );

 ```

## Call Code
`0x009A` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Partition                                 |
| `TargetVtl`             | 8          | 1        | Target VTL                                |
| Padding                 | 9          | 7        |                                           |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ApicId`                | 0          | 4        | APIC ID of the VP                         |
| Padding                 | 4          | 4        |                                           |

## Output List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `VpIndex`               | 0          | 4        | Index of the VP with the specified APIC ID|
| Padding                 | 4          | 4        |                                           |

# Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | Access denied                                         |
| `HV_STATUS_INVALID_PARAMETER`       | An invalid parameter was specified                    |
| `HV_STATUS_INVALID_PARTITION_ID`    | The specified partition ID is invalid.                |
| `HV_STATUS_INVALID_REGISTER_VALUE`  | The supplied register value is invalid.               |
| `HV_STATUS_INVALID_VP_STATE`        | A virtual processor is not in the correct state for the performance of the indicated operation. |
| `HV_STATUS_INVALID_PARTITION_STATE` | The specified partition is not in the “active” state. |
| `HV_STATUS_INVALID_VTL_STATE`       | The VTL state conflicts with the requested operation. |