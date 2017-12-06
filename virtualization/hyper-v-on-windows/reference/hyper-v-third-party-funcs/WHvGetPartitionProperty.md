# WHvGetPartitionProperty

## Syntax
```C
HRESULT 
WHvGetPartitionProperty( 
    _In_  WHV_PARTITION_HANDLE Partition, 
    _In_  WHV_PARTITION_PROPERTY_CODE Property, 
    _Out_ VOID* PropertyBuffer, 
    _In_  UINT32 PropertyBufferSizeInBytes 
); 
```
### Parameters

`Partition`

Handle to the partition object

`Property`

Specifies the property that is queried

`PropertyBuffer` 

Specifies the output buffer that receives the value of the requested property. 

`PropertyBufferSizeInBytes` 

Specifies the size of the output buffer, in bytes. For the currently available set of properties, the buffer should be large enough to hold a 64-bit value.  