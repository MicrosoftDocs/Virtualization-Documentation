# WHvSetupPartition

## Syntax

```C
HRESULT
WINAPI
WHvSetupPartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```

### Parameters

`Partition`

Handle to the partition object
  

## Remarks

The `WHvSetupPartition` function sets up the parition which causes the actual partition to be created in the hypervisor.

Before setting up the partition with `WHvSetupPartition`, the partition object should be created with [`WHvCreatePartition`](WHvCreatePartition.md) and the initial properties of the partition object configured with [`WHvSetPartitionProperty`](WHvSetPartitionProperty.md). After setting up the partition, the partition object can be passed to the other Windows Hypervisor Platform APIs.
