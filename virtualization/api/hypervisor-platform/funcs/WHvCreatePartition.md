# WHvCreatePartition
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax

```C
typedef VOID* WHV_PARTITION_HANDLE;

HRESULT
WINAPI
WHvCreatePartition(
    _Out_ WHV_PARTITION_HANDLE* Partition
    );
```

### Parameters

`Partition`

Receives the handle to the newly created partition object. All operations on the partition are performed through this handle.

Closing this handle will tear down and cleanup the partition.
  

## Remarks

The `WHvCreatePartition` function creates a new partition object.

Creating the file object does not yet create the actual partition in the hypervisor. To create the hypervisor partition, the [`WHvSetupPartition`](WhvSetupPartition.md) function needs to be called. Additional properties of the partition can be configured prior to this call; these properties are stored in the partition object in the VID and are applied when creating the partition in the hypervisor.
