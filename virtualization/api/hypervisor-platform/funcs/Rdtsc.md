# RDTSC(P)


## Syntax
```C
//
// Context data for an exit caused by a rdtsc(p) instruction
// (WHvRunVpExitReasonX64Rdtsc)
//
typedef union WHV_X64_RDTSC_INFO
{
    struct
    {
        UINT64 IsRdtscp:1;
        UINT64 Reserved:63;
    };

    UINT64 AsUINT64;
} WHV_X64_RDTSC_INFO;

typedef struct WHV_X64_RDTSC_CONTEXT
{
    UINT64 TscAux;
    UINT64 VirtualOffset;
    UINT64 Reserved[2];
    WHV_X64_RDTSC_INFO RdtscInfo;
} WHV_X64_RDTSC_CONTEXT;
```

## Return Value
Information about a rdtsc(p) instruction from the virtual processor is provided in the `WHV_VP_EXCEPTION_CONTEXT` structure. 

Exits for exceptions are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS.X64RdtscExit` property for the partition.

## Requirements

Minimum supported build:    Insider Preview Builds (19H2) Experimental