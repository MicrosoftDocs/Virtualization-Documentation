# HcsGetOperationType

## Description

Get the type of the operation, this corresponds to the API call the operation was issued with.

## Syntax

```cpp
HCS_OPERATION_TYPE WINAPI
HcsGetOperationType(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

`operation`
The handle to an active operation

## Return Values

If the function succeeds, the return value is [HCS_OPERATION_TYPE](./HCS_OPERATION_TYPE.md)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |