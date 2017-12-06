# WHvGetVirtualProcessorRegisters

## Syntax

```C
HRESULT 
WHvGetVirtualProcessorRegisters( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex, 
    _In_ WHV_REGISTER_NAME* RegisterNames, 
    _In_ UINT32 RegisterCount, 
    _Out_ WHV_REGISTER_VALUE* RegisterValues 
); 
```

### Parameters

`Partition` 

Handle to the partition object

`VpIndex`

Specifies the index of the virtual processor whose registers are queried

`RegisterNames` 

Array specifying the names of the registers that are queried

`RegisterCount` 

Specifies the number of elements in the RegisterNames array

`RegisterValues` 

Specifies the output buffer that receives the values of the request registers

