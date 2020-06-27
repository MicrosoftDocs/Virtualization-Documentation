# HcsGetOperationId

## Description

Get the id of the operation Id uniquely identify the operation, for example there can be multiple modify settings calls in progress.

## Syntax

```cpp
UINT64 WINAPI
HcsGetOperationId(
    _In_ HCS_OPERATION operation
    );


```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`operation`| Handle to an active operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`Id`| Id of operation|
|`HCS_INVALID_OPERATION_ID` |Returns if the operation is invalid|
|     |     |
