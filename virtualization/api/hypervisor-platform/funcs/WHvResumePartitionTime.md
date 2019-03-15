# WHvResumePartitionTime

## Syntax

```C
HRESULT
WINAPI
WHvResumePartitionTime(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```

### Parameters

`Partition`

Handle to the partition object.

## Return Value

If the function succeeds, the return value is `S_OK`.  

## Remarks

Resumes time for a partition suspended by [`WHvSuspendPartitionTime`](WHvSuspendPartitionTime.md).

## Requirements

Minimum supported build:    Insider Preview Builds (19H1)