# MSR Access


## Syntax
```C
//
// Context data for an exit caused by an MSR access (WHvRunVpExitReasonX64MSRAccess)
//
typedef union WHV_X64_MSR_ACCESS_INFO
{
    struct
    {
        UINT32 IsWrite : 1;
        UINT32 Reserved : 31;
    };

    UINT32 AsUINT32;
} WHV_X64_MSR_ACCESS_INFO;

typedef struct WHV_X64_MSR_ACCESS_CONTEXT
{
    // MSR access info
    WHV_X64_MSR_ACCESS_INFO AccessInfo;
    UINT32 MsrNumber;
    UINT64 Rax;
    UINT64 Rdx;
} WHV_X64_MSR_ACCESS_CONTEXT;
```

## Return Value

Information about exits caused by the virtual processor accessing a model specific register (MSR) using the RDMSR or WRMSR instructions is provided in the `WHV_X64_MSR_ACCESS_CONTEXT` structure. 

Exits for MSR accesses are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS.MsrExit` property for the partition. 