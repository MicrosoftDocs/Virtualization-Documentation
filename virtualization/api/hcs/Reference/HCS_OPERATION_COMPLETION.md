# HCS_OPERATION_TYPE

## Description

Function type for the completion callback of an operation.

## Syntax

```cpp
typedef void (CALLBACK *HCS_OPERATION_COMPLETION)(
    _In_ HCS_OPERATION operation,
    _In_opt_ void* context
    );
```

## Parameters

`operation`

Handle to an operation on a compute system

`context`

Handle to the pointer of callback context

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
