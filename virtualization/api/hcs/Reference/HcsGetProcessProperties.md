# HcsGetProcessProperties

## Description

Returns the properties of a process in a compute system, see [sample code](./ProcessSample.md#GetProcessProperty)

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessProperties(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR propertyQuery
    );
```

## Parameters

`process`

The handle to the process to query

`operation`

The handle to the operation that tracks the process

`propertyQuery`

Optional JSON document of [ProcessStatus](./../SchemaReference.md#ProcessStatus) specifying the properties to query

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
