# WHvCreatePartition

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

Receives the partition handle to the newly created partition object. All operations on the partition are performed through this handle.

To delete a partition created by `WHvCreatePartition`, use the [`WHvDeletePartition`](WhvDeletePartition.md) function.
  

## Remarks

The `WHvCreatePartition` function creates a new partition object.

`WHvCreatePartition` does not yet create the actual partition in the hypervisor. To create the hypervisor partition, the [`WHvSetupPartition`](WhvSetupPartition.md) function needs to be called. Additional properties of the partition can be configured prior to this call; these properties are stored in the partition object in the VID and are applied when creating the partition in the hypervisor.
