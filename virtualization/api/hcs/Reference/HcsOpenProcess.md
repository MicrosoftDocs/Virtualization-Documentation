# HcsOpenProcess

## Description

Opens an existing process in a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsOpenProcess(
    _In_ HCS_SYSTEM computeSystem,
    _In_ DWORD processId,
    _In_ DWORD requestedAccess,
    _Out_ HCS_PROCESS* process
    );

```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system in which to start the process|
|`processId`| Specifies the Id of the process to open|
|`requestedAccess`| Specifies the required access to the compute system|
|`process`| Receives the handle to the process|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to open the process|
|    |    |
