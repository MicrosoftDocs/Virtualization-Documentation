# Exit Context Data Types


## Syntax

```C
//
// Reason for a VM exit
//
typedef enum WHV_RUN_VP_EXIT_REASON
{
    WHvRunVpExitReasonNone                   = 0x00000000,

    // Standard exits caused by operations of the virtual processor
    WHvRunVpExitReasonMemoryAccess           = 0x00000001,
    WHvRunVpExitReasonX64IoPortAccess        = 0x00000002,
    WHvRunVpExitReasonUnrecoverableException = 0x00000004,
    WHvRunVpExitReasonInvalidVpRegisterValue = 0x00000005,
    WHvRunVpExitReasonUnsupportedFeature     = 0x00000006,
    WHvRunVpExitReasonX64InterruptWindow     = 0x00000007,
    WHvRunVpExitReasonX64Halt                = 0x00000008,

    // Additional exits that can be configured through partition properties
    WHvRunVpExitReasonX64MsrAccess           = 0x00001000,
    WHvRunVpExitReasonX64Cpuid               = 0x00001001,
    WHvRunVpExitReasonException              = 0x00001002,
    WHvRunVpExitReasonX64Rdtsc               = 0x00001003,

    // Exits caused by the host
    WHvRunVpExitReasonCanceled               = 0x00002001
} WHV_RUN_VP_EXIT_REASON;

//
// Execution state of the virtual processor
//
typedef union WHV_X64_VP_EXECUTION_STATE
{
    struct
    {
        UINT16 Cpl : 2;
        UINT16 Cr0Pe : 1;
        UINT16 Cr0Am : 1;
        UINT16 EferLma : 1;
        UINT16 DebugActive : 1;
        UINT16 InterruptionPending : 1;
        UINT16 Reserved0 : 5;
        UINT16 InterruptShadow : 1;
        UINT16 Reserved1 : 3;
    };

    UINT16 AsUINT16;
} WHV_X64_VP_EXECUTION_STATE;
//
// Execution context of a virtual processor at the time of an exit
//
typedef struct WHV_VP_EXIT_CONTEXT
{
    WHV_X64_VP_EXECUTION_STATE ExecutionState;
    UINT8 InstructionLength : 4;
    UINT8 Cr8 : 4;
    UINT8 Reserved;
    UINT32 Reserved2;
    WHV_X64_SEGMENT_REGISTER Cs;
    UINT64 Rip;
    UINT64 Rflags;
} WHV_VP_EXIT_CONTEXT;
```
## Remarks

The context structures for several exit reasons share common definitions for the data that provides information about the processor instruction that caused the exit and the state of the virtual processor at the time of the exit. 

## Requirements

Minimum supported build:    Insider Preview Builds (19H2) Experimental:
`WHvRunVpExitReasonX64Rdtsc`