# WHvDeletePartition
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

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
