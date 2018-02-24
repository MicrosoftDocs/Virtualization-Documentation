# Memory Access
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

## Syntax
```C
//
// Context data for a VM exit caused by a memory access (WHvRunVpExitReasonMemoryAccess)
//
typedef enum WHV_MEMORY_ACCESS_TYPE
{
    WHvMemoryAccessRead    = 0,
    WHvMemoryAccessWrite   = 1,
    WHvMemoryAccessExecute = 2
} WHV_MEMORY_ACCESS_TYPE;

typedef union WHV_MEMORY_ACCESS_INFO
{
    struct {
        UINT32 AccessType  : 2;  // WHV_MEMORY_ACCESS_TYPE
        UINT32 GpaUnmapped : 1;
        UINT32 GvaValid    : 1;
        UINT32 Reserved    : 28;
    };

    UINT32 AsUINT32;
} WHV_MEMORY_ACCESS_INFO;

typedef struct WHV_MEMORY_ACCESS_CONTEXT
{
    // Context of the virtual processor
    UINT8 InstructionByteCount;
    UINT8 InstructionBytes[16];

    // Memory access info
    WHV_MEMORY_ACCESS_INFO AccessInfo;
    WHV_GUEST_PHYSICAL_ADDRESS Gpa;
    WHV_GUEST_VIRTUAL_ADDRESS Gva;
} WHV_MEMORY_ACCESS_CONTEXT;
```

## Return Value

Information about exits caused by the virtual processor accessing a memory location that is not mapped or not accessible is provided by the `WHV_MEMORY_ACCESS_CONTEXT` structure.   

A common use case for memory access exits is the emulation of MMIO device operations, where unmapped regions of the partition’s GPA space are used for the MMIO space of an emulated device and accesses to this region are forwarded to the device emulation logic in the virtualization stack. 
