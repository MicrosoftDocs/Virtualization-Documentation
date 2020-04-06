# HcsModifyProcess

## Description
Modifies the parameters of a process in a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsModifyProcess(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_ PCWSTR settings
    );
```

## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to modify|
|`operation`| Handle to the operation that tracks the process|
|`settings`| Receives the new settings of the process|
|    |    | 



## Return Values
|Return Value | Description|
|---|---|
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to modify the process|
|    |    | 