# WHvGetPartitionProperty


## Syntax
```C
HRESULT
WINAPI
WHvGetPartitionProperty(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_PROPERTY_CODE PropertyCode,
    _Out_writes_bytes_to_(PropertyBufferSizeInBytes, *WrittenSizeInBytes) VOID* PropertyBuffer,
    _In_ UINT32 PropertyBufferSizeInBytes,
    _Out_opt_ UINT32 *WrittenSizeInBytes
    );
```
### Parameters

`Partition`

Handle to the partition object.

`PropertyCode`

Specifies the property that is queried.

`PropertyBuffer`

Specifies the output buffer that receives the value of the requested property. 

`PropertyBufferSizeInBytes`

Specifies the size of the output buffer, in bytes. For the currently available set of properties, the buffer should be large enough to hold a 64-bit value.

`WrittenSizeInBytes`

Receives the written size in bytes of the `PropertyBuffer`.

## Return Value
If the operation completed successfully, the return value is `S_OK`.

The function returns `WHV_E_UNKNOWN_PROPERTY` if an unknown `PropertyCode` is requested.
