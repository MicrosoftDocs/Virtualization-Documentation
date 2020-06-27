# HcsGetComputeSystemFromOperation

## Description

Get the compute system associated with operation

## Syntax

```cpp
HCS_SYSTEM WINAPI
HcsGetComputeSystemFromOperation(
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
|`HCS_SYSTEM`|Returns NULL if the operation is not active.|
|     |     |
