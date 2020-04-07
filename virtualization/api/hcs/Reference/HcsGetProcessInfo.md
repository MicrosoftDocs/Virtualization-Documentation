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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`process`| Handle to the process to query|
|`operation`| Handle to the operation that tracks the process|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`| Returned on success|
|`HRESULT`| Error code for failures to get the process information.|
|    |    |
