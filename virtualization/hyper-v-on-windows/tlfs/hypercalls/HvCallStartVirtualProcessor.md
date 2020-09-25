# HvCallStartVirtualProcessor

HvCallStartVirtualProcessor is an enlightened method for starting a virtual processor. It is functionally equivalent to traditional INIT-based methods, except that the VP can start with a desired register state.

This is the only method for starting a VP in a non-zero VTL.

## Interface

 ```c
HV_STATUS
HvCallStartVirtualProcessor(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_VTL TargetVtl,
    _In_ HV_INITIAL_VP_CONTEXT VpContext
    );

typedef struct
{
    UINT64 Rip;
    UINT64 Rsp;
    UINT64 Rflags;

    // Segment selector registers together with their hidden state.
    HV_X64_SEGMENT_REGISTER Cs;
    HV_X64_SEGMENT_REGISTER Ds;
    HV_X64_SEGMENT_REGISTER Es;
    HV_X64_SEGMENT_REGISTER Fs;
    HV_X64_SEGMENT_REGISTER Gs;
    HV_X64_SEGMENT_REGISTER Ss;
    HV_X64_SEGMENT_REGISTER Tr;
    HV_X64_SEGMENT_REGISTER Ldtr;

    // Global and Interrupt Descriptor tables
    HV_X64_TABLE_REGISTER Idtr;
    HV_X64_TABLE_REGISTER Gdtr;

    // Control registers and MSR's
    UINT64 Efer;
    UINT64 Cr0;
    UINT64 Cr3;
    UINT64 Cr4;
    UINT64 MsrCrPat;
} HV_INITIAL_VP_CONTEXT;
 ```

## Call Code
`0x0099` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Partition                                 |
| `VpIndex`               | 8          | 4        | VP Index to start. To get the VP index from an APIC ID, use HvGetVpIndexFromApicId. |
| `TargetVtl`             | 12         | 1        | Target VTL                                |
| `Rip`                   | 16         | 8        | Initial Instruction pointer               |
| `Rsp`                   | 24         | 8        | Initial stack pointer                     |
| `Rflags`                | 32         | 8        | Initial flags                             |
| `CS`                    | 40         | 16       | CS segment selector and hidden state      |
| `DS`                    | 56         | 16       | DS segment selector and hidden state      |
| `ES`                    | 72         | 16       | ES segment selector and hidden state      |
| `FS`                    | 88         | 16       | FS segment selector and hidden state      |
| `GS`                    | 104        | 16       | GS segment selector and hidden state      |
| `SS`                    | 120        | 16       | SS segment selector and hidden state      |
| `Tr`                    | 136        | 16       | Task segment selector and hidden state    |
| `Ldtr`                  | 152        | 16       | Local descriptor table                    |
| `Idtr`                  | 168        | 16       | Interrupt descriptor table                |
| `Gdtr`                  | 184        | 16       | Global descriptor table                   |
| `Efer`                  | 200        | 8        | Initial EFER                              |
| `Cr0`                   | 208        | 8        | Initial CR0                               |
| `Cr3`                   | 2016       | 8        | Initial CR3                               |
| `Cr4`                   | 224        | 8        | Initial CR4                               |
| `MsrCrPat`              | 232        | 8        | Initial value for the PAT MSR             |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | Access denied                                         |
| `HV_STATUS_INVALID_PARTITION_ID`    | The specified partition ID is invalid.                |
| `HV_STATUS_INVALID_VP_INDEX`        | The virtual processor specified by HV_VP_INDEX is invalid. |
| `HV_STATUS_INVALID_REGISTER_VALUE`  | The supplied register value is invalid.               |
| `HV_STATUS_INVALID_VP_STATE`        | A virtual processor is not in the correct state for the performance of the indicated operation. |
| `HV_STATUS_INVALID_PARTITION_STATE` | The specified partition is not in the “active” state. |
| `HV_STATUS_INVALID_VTL_STATE`       | The VTL state conflicts with the requested operation. |