# HcsTerminateProcess

## Description

Terminates a process in a compute system

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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`process`| Handle to the process to terminate|
|`operation`| Handle to the operation tracking the terminate operation|
|`options`|Optional JSON document specifying terminate options|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to terminate the process|
|    |    |
