# HvCallModifyVtlProtectionMask

The HvCallModifyVtlProtectionMask hypercall modifies the VTL protections applied to an existing set of GPA pages.

## Interface

 ```c
HV_STATUS
HvModifyVtlProtectionMask(
    _In_ HV_PARTITION_ID TargetPartitionId,
    _In_ HV_MAP_GPA_FLAGS MapFlags,
    _In_ HV_INPUT_VTL TargetVtl,
    _In_reads(PageCount) HV_GPA_PAGE_NUMBER GpaPageList
    );
 ```

A VTL can only place protections on a lower VTL.

Any attempt to apply VTL protections on non-RAM ranges will fail with HV_STATUS_INVALID_PARAMETER.

## Call Code

`0x000C` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `TargetPartitionId`     | 0          | 8        | Supplies the partition ID of the partition this request is for. |
| `MapFlags`              | 8          | 4        | Specifies the new mapping flags to apply. |
| `TargetVtl`             | 12         | 1        | Specified the target VTL. |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `GpaPageList`           | 0          | 8        | Supplies the pages to be protected.       |