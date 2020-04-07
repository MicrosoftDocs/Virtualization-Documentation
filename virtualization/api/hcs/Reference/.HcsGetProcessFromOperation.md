# HcsGetProcessFromOperation

## Description

Returns the handle to the process associated with an operation

## Syntax

```cpp
HCS_PROCESS WINAPI
HcsGetProcessFromOperation(
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
|`HCS_PROCESS`|Returns NULL if no handle was found.|
|     |     |
