# WHvDeletePartition
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

## Syntax
```C
HRESULT
WINAPI
WHvDeletePartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```
### Parameters

`Partition`

Handle to the partition object that is deleted.
  

## Remarks

Deleting a partition tears down the partition object and releases all resource that the partition was using.
