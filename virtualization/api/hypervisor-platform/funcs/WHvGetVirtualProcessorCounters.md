---
title: WHvGetVirtualProcessorCounters
description: Description on parameters and return value for the WHvGetVirtualProcessorCounters, which includes a code snippet for syntax reference. 
authors: jstarks
ms.authors: jostarks
date: 06/06/2019
---

# WHvGetVirtualProcessorCounters

## Syntax

```
HRESULT
WINAPI
WHvGetVirtualProcessorCounters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ WHV_PROCESSOR_COUNTER_SET CounterSet,
    _Out_writes_bytes_to_(BufferSizeInBytes, *BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_opt_ UINT32* BytesWritten
    );

typedef enum WHV_PROCESSOR_COUNTER_SET
{
    WHvProcessorCounterSetRuntime,
    WHvProcessorCounterSetIntercepts,
    WHvProcessorCounterSetEvents,
    WHvProcessorCounterSetApic,
} WHV_PROCESSOR_COUNTER_SET;

typedef struct WHV_PROCESSOR_RUNTIME_COUNTERS
{
    UINT64 TotalRuntime100ns;
    UINT64 HypervisorRuntime100ns;
} WHV_PROCESSOR_RUNTIME_COUNTERS;

typedef struct WHV_PROCESSOR_INTERCEPT_COUNTER
{
    UINT64 Count;
    UINT64 Time100ns;
} WHV_PROCESSOR_INTERCEPT_COUNTER;

typedef struct WHV_PROCESSOR_INTERCEPT_COUNTERS
{
    WHV_PROCESSOR_INTERCEPT_COUNTER PageInvalidations;
    WHV_PROCESSOR_INTERCEPT_COUNTER ControlRegisterAccesses;
    WHV_PROCESSOR_INTERCEPT_COUNTER IoInstructions;
    WHV_PROCESSOR_INTERCEPT_COUNTER HaltInstructions;
    WHV_PROCESSOR_INTERCEPT_COUNTER CpuidInstructions;
    WHV_PROCESSOR_INTERCEPT_COUNTER MsrAccesses;
    WHV_PROCESSOR_INTERCEPT_COUNTER OtherIntercepts;
    WHV_PROCESSOR_INTERCEPT_COUNTER PendingInterrupts;
    WHV_PROCESSOR_INTERCEPT_COUNTER EmulatedInstructions;
    WHV_PROCESSOR_INTERCEPT_COUNTER DebugRegisterAccesses;
    WHV_PROCESSOR_INTERCEPT_COUNTER PageFaultIntercepts;
} WHV_PROCESSOR_ACTIVITY_COUNTERS;

typedef struct WHV_PROCESSOR_EVENT_COUNTERS
{
    UINT64 PageFaultCount;
    UINT64 ExceptionCount;
    UINT64 InterruptCount;
} WHV_PROCESSOR_GUEST_EVENT_COUNTERS;

typedef struct WHV_PROCESSOR_APIC_COUNTERS
{
    UINT64 MmioAccessCount;
    UINT64 EoiAccessCount;
    UINT64 TprAccessCount;
    UINT64 SentIpiCount;
    UINT64 SelfIpiCount;
} WHV_PROCESSOR_APIC_COUNTERS;

```

### Parameters

`Partition`

Specifies the partition to query.

`VpIndex`

Specifies the virtual processor index of the processor to query.

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
