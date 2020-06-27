# HcsSignalProcess

## Description

Sends a signal to a process in a compute system

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

|Parameter     |Description|
|---|---|
|`process`| Handle to the process to send the signal to|
|`operation`| Handle to the operation that tracks the signal|
|`options`| Optional JSON document specifying the detailed signal|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`|Returned on success|
|`HRESULT`|Error code for failures to send the signal to the process|
|    |    |
