# HCS_EVENT

## Description

Provides information about an event that occurred on a compute system or process.

## Syntax

```cpp
typedef struct HCS_EVENT
{
    HCS_EVENT_TYPE Type;
    PCWSTR EventData;
    HCS_OPERATION Operation;
} HCS_EVENT;
```

## Members


`Type`

Type of event [`HCS_EVENT_TYPE`](./HCS_EVENT_TYPE.md)

`EventData`

Optionally provides additional data for the event as a JSON document. The following table shows expected documents for specific event types.

|Event Type|JSON Document|
|---|---|
|`HcsEventOperationCallback`|Dependent on the operation being tracked. This is equivalent to the result document you can obtain from [`HcsGetOperationResult`](./HcsGetOperationResult.md), [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md), [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) and [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md). |

`Operation`

Handle to a completed operation, if `Type` is `HcsEventOperationCallback`. This is only possible when [`HcsSetComputeSystemCallback`](./HcsSetComputeSystemCallback.md) has specified event option `HcsEventOptionEnableOperationCallbacks`.


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
