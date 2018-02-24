# Partition Property Data Types
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

## Syntax
```C
typedef enum { 
    WHvPartitionPropertyCodeExtendedVmExits        = 0x00000001, 

    WHvPartitionPropertyCodeProcessorFeatures      = 0x00001001, 
    WHVPartitionPropertyCodeProcessorClFlushSize   = 0x00001002, 
     
    WHvPartitionPropertyCodeProcessorCount         = 0x00001fff 
} WHV_PARTITION_PROPERTY_CODE; 

//
// WHvPartitionPropertyCodeCpuidResultList input buffer list element.
//
typedef struct WHV_X64_CPUID_RESULT
{
    UINT32 Function;
    UINT32 Reserved[3];
    UINT32 Eax;
    UINT32 Ebx;
    UINT32 Ecx;
    UINT32 Edx;
} WHV_X64_CPUID_RESULT;
 
//
// WHvGetPartitionProperty output buffer / WHvSetPartitionProperty input buffer
//
typedef union WHV_PARTITION_PROPERTY
{
    WHV_EXTENDED_VM_EXITS ExtendedVmExits;
    WHV_PROCESSOR_FEATURES ProcessorFeatures;
    UINT8 ProcessorClFlushSize;
    UINT32 ProcessorCount;
    UINT32 CpuidExitList[1];
    WHV_X64_CPUID_RESULT CpuidResultList[1];
} WHV_PARTITION_PROPERTY;
```


## Remarks

The `WHvPartitionPropertyCodeExtendedVmExits` property controls the set of additional operations by a virtual processor that should cause the execution of the processor to exit and to return to the caller of the [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) function.

The `WHvPartitionPropertyCodeProcessorXXX` properties control the processor features that are made available to the virtual processor of the partition. These properties can only be configured during the initial creation of the partition, prior to calling [`WHvSetupPartition`](WHvSetupPartition.md).