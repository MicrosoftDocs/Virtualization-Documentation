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

Provides additional data for the event.

`Operation`

Handle to a completed operation, if `Type` is `HcsEventOperationCallback` as [`HCS_EVENT_TYPE`](./HCS_EVENT_TYPE.md).


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
