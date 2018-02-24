# WHvDeleteVirtualProcessor
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**
## Syntax

```C
HRESULT
WINAPI
WHvDeleteVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex
    );
```

### Parameters

`Partition`

Handle to the partition object

`VpIndex`

 Specifies the index of the virtual processor that is deleted
  

## Remarks

The `WHvDeleteVirtualProcessor` function deletes a virtual processor in a partition. 
