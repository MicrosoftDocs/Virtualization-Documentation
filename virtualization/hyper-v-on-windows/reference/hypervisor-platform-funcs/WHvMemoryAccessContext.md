# WHV_Memory_Access_Context
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

## Syntax
```C
// Context data for an exit caused by a memory access 
typedef struct { 
    UINT32 AccessType : 2; // HV_INTERCEPT_ACCESS_TYPE 
    UINT32 GpaUnmapped : 1; // Unmapped GPA or GPA access violation 
    UINT32 GvaValid : 1; 
    UINT32 Reserved : 28; 
} WHV_MEMORY_ACCESS_INFO; 

typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    WHV_MEMORY_ACCESS_INFO AccessInfo; 
    WHV_GUEST_ADDRESS Gpa; 
    WHV_GUEST_ADDRESS Gva; 
} WHV_MEMORY_ACCESS_CONTEXT; 
```

## Remarks

Information about exits caused by the virtual processor accessing a memory location that is not mapped or not accessible is provided by the `WHV_MEMORY_ACCESS_CONTEXT` structure. 

A common use case for memory access exits is the emulation of MMIO device operations, where unmapped regions of the partition’s GPA space are used for the MMIO space of an emulated device and accesses to this region are forwarded to the device emulation logic in the virtualization stack
