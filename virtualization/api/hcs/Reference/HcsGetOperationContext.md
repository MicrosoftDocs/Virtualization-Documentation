# HcsGetOperationContext

## Description

Gets the context pointer of an operation.

## Syntax

```cpp
void* WINAPI
HcsGetOperationContext(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`operation`| Handle to an operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`void*`|Returns context pointer stored in the operation|
