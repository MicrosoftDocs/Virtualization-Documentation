# HcsCloseOperation

## Description

Close the operation, freeing any tracking resources associated with the operation.

## Syntax

```cpp
void WINAPI
HcsCloseOperation(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`operation`| Handle to an operation|
|    |    |

## Return Values

If the operation is in progress it will be cancelled.  An operation can be closed from within a callback.
