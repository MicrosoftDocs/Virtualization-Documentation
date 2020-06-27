# HcsGetOperationType

## Description

Get the type of the operation, this corresponds to the API call the operation was issued with.

## Syntax

```cpp
HCS_OPERATION_TYPE WINAPI
HcsGetOperationType(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_OPERATION_TYPE`|Returned on success|
|`HcsOperationNone` |Returned if the operation has not yet been used in a function call|
|     |     |
