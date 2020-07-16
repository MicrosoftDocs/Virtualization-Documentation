# HcsTerminateProcess

## Description

Terminates a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsTerminateProcess(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`process`

The handle to the process to terminate.

`operation`

The handle to the operation tracking the terminate operation.

`options`

Reserved for future use. Must be `NULL`.

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