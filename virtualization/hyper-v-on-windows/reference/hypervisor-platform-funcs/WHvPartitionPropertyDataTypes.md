# Partition Property Data Types
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax
```C
typedef enum { 
    WHvPartitionPropertyCodeExtendedVmExits        = 0x00000001, 
     
    WHvPartitionPropertyCodeProcessorVendor        = 0x00001000, 
    WHvPartitionPropertyCodeProcessorFeatures      = 0x00001001, 
    WHVPartitionPropertyCodeProcessorClFlushSize   = 0x00001002, 
     
    WHvPartitionPropertyCodeProcessorCount         = 0x00001fff 
} WHV_PARTITION_PROPERTY_CODE; 
 
//
// WHvGetPartitionProperty output buffer / WHvSetPartitionProperty input buffer
//
typedef struct WHV_PARTITION_PROPERTY
{
    WHV_PARTITION_PROPERTY_CODE PropertyCode;

    union
    {
         WHV_EXTENDED_VM_EXITS ExtendedVmExits;
         WHV_PROCESSOR_VENDOR ProcessorVendor;
         WHV_PROCESSOR_FEATURES ProcessorFeatures;
         UINT8 ProcessorClFlushSize;
         UINT32 ProcessorCount;
    };
} WHV_PARTITION_PROPERTY;
```


## Remarks

The `WHvPartitionPropertyCodeExtendedVmExits` property controls the set of additional operations by a virtual processor that should cause the execution of the processor to exit and to return to the caller of the [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) function.

The `WHvPartitionPropertyCodeProcessorXXX` properties control the processor features that are made available to the virtual processor of the partition. These properties can only be configured during the initial creation of the partition, prior to calling [`WHvSetupPartition`](WHvSetupPartition.md).