---
title: WHvGetPartitionCounters
description:  Description on partition counters and its properties, including a code sample for syntax and specific parameters and return value. 
description: Description on WHvGetPartitionCounters and understanding its parameters, syntax, and return value. 
author: jstarks
ms.author: jostarks
ms.date: 06/06/2019

---

# WHvGetPartitionCounters

## Syntax

```
typedef enum WHV_PARTITION_COUNTER_SET
{
    WHvPartitionCounterSetMemory,
} WHV_PARTITION_COUNTER_SET;

typedef struct WHV_PARTITION_MEMORY_COUNTERS
{
    UINT64 Mapped4KPageCount;
    UINT64 Mapped2MPageCount;
    UINT64 Mapped1GPageCount;
} WHV_PARTITION_MEMORY_COUNTERS;

HRESULT
WINAPI
WHvGetPartitionCounters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_COUNTER_SET CounterSet,
    _Out_writes_bytes_to_(BufferSizeInBytes, *BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_opt_ UINT32* BytesWritten
    );
```

### Parameters

`Partition`

Specifies the partition to query.

`CounterSet`

Specifies the counter set to query.

`Buffer`

Specifies the buffer to write the counters into.

`BufferSizeInBytes`

Specifies `Buffer`'s size in bytes.

`BytesWritten`

If non-NULL, specifies a pointer that will be updated with the size of the counter set in bytes.

### Return Value

If the operation completed successfully, the return value is `S_OK`.

If an unrecognized value was passed for `CounterSet`, the return value is `WHV_E_UNKNOWN_PROPERTY`.
