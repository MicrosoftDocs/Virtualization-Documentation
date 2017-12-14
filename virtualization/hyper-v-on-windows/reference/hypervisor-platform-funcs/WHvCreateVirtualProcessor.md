# WHvCreateVirtualProcessor
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

## Syntax

```C
HRESULT
WINAPI
WHvCreateVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ UINT32 Flags
    );
```

### Parameters

`Partition` 

Handle to the partition object 

`VpIndex`

 Specifies the index of the new virtual processor

`Flags` 

Unused, must be zero
  

## Remarks

The `WHvCreateVirtualProcessor` function creates a new virtual processor in a partition. The index of the virtual processor is used to set the APIC ID of the processor. 
