# WHvSetPartitionProperty


## Syntax
```C
HRESULT
WINAPI
WHvSetPartitionProperty(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_PROPERTY_CODE PropertyCode,
    _In_reads_bytes_(PropertyBufferSizeInBytes) const VOID* PropertyBuffer,
    _In_ UINT32 PropertyBufferSizeInBytes
    );
```
### Parameters

`Partition`

Handle to the partition object. 

`PropertyCode`

Specifies the property that is being set.

`PropertyBuffer`

Specifies the input buffer that provides the property value. 

`PropertyBufferSizeInBytes`

Specifies the size of the input buffer, in bytes. 

## Return Value

If the operation completed successfully, the return value is `S_OK`. 

The function returns `WHV_E_UNKNOWN_PROPERTY` for attempts to configure a property that is not available on the current system. 

The function returns `E_INVALIDARG` if the property cannot be modified in the current state of the partition, particularly for attempts to set a property prior to the [`WHvSetupPartition`](WhvSetupPartition.md) function. Starting in Insider Preview Builds (19H2), the following properties can be modified after the [`WHvSetupPartition`](WhvSetupPartition.md) function:
`WHvPartitionPropertyCodeExtendedVmExits`
`WHvPartitionPropertyCodeExceptionExitBitmap`
`WHvPartitionPropertyCodeX64MsrExitBitmap`
`WHvPartitionPropertyCodeCpuidExitList`

