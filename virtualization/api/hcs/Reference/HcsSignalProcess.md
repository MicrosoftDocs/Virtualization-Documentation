# HcsSignalProcess

## Description

Sends a signal to a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsSignalProcess(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`process`

The handle to the process to send the signal to.

`operation`

The handle to the operation that tracks the signal.

`options`

Optional JSON document of [SignalProcessOptions](./../SchemaReference.md#SignalProcessOptions) specifying the detailed signal.

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