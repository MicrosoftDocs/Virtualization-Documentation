# HcsGetOperationContext

## Description

Gets the context pointer of an operation.

## Syntax

```cpp
void* WINAPI
HcsGetOperationContext(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

`operation`

The handle to an operation

## Return Values

`void*`

Returns context pointer stored in the operation

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
