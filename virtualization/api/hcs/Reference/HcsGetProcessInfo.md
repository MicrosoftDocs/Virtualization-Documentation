# HcsGetProcessInfo

## Description

Returns the initial startup information of a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessInfo(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`process`

The handle to the process to query

`operation`

The handle to the operation that tracks the process

## Return Values

The function returns [HRESULT](./HCSHResult.md)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
