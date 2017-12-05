# WHvSetupPartition

## Syntax

```C
HRESULT
WHvSetupPartition(
    _In_ WHV_PARTITION_HANDLE Partition
);
```

### Parameters

`Partition`

Handle to the partition object that is set up.
  

## Remarks

Setting up the partition causes the actual partition to be created in the hypervisor.

A partition needs to be set up prior to performing any other operation on the partition after it was created by `WHvCreatePartition`, with exception of calling [`WHvSetPartitionProperty`](reference/hyper-v-third-party-funcs/WHvSetPartitionProperty.md) to configure the initial properties of the partition.

