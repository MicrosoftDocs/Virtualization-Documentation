# WHvSetupPartition
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

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

Handle to the partition object that is set up.
  

## Remarks

Setting up the partition causes the actual partition to be created in the hypervisor.

A partition needs to be set up prior to performing any other operation on the partition after it was created by [`WHvCreatePartition`](WHvCreatePartition.md), with exception of calling [`WHvSetPartitionProperty`](WHvSetPartitionProperty.md) to configure the initial properties of the partition.

