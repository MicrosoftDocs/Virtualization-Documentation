# Partition Property Data Types
**Note: These APIs are not yet publically available and will be included in a future Windows release.**

## Syntax
```C
typedef enum { 
    WHvPartitionPropertyCodeExtendedVmExits        = 0x00000001, 
     
    WHvPartitionPropertyCodeProcessorVendor        = 0x00001000, 
    WHvPartitionPropertyCodeProcessorFeatures      = 0x00001001, 
    WHVPartitionPropertyCodeProcessorClFlushSize   = 0x00001002, 
     
    WHvPartitionPropertyCodeProcessorCount         = 0x00001fff 
} WHV_PARTITION_PROPERTY_CODE; 
 
typedef struct { 
    WHV_PARTITION_PROPERTY_CODE PropertyCode; 
     
    union { 
        WHV_EXTENDED_VM_EXITS ExtendedVmExits; // See VID_WHV_IOCTL_GET_CAPABILITY 
        WHV_PROCESSOR_VENDOR ProcessorVendor; // HV_PROCESSOR_VENDOR 
        WHV_PROCESSOR_FEATURES ProcessorFeatures; // HV_PARTITION_PROCESSOR_FEATURES 
        UINT8 ProcessorClFlushSize; 
    }; 
} WHV_GET_PARTITION_PROPERTY_OUTPUT; 
```


## Remarks

The `WHvPartitionExtendedVmExits` property controls the set of additional operations by a virtual processor that should cause the execution of the processor to exit and to return to the caller of the [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) function.

The `WHvPartitionProcessorXXX` properties control the processor features that are made available to the virtual processor of the partition. These properties can only be configured during the initial creation of the partition, prior to calling `WHvInitializePartition`.