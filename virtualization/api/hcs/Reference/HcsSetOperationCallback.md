# HcsSetOperationContext

## Description

Sets a callback that is invoked on completion of an operation.

## Syntax

```cpp
HRESULT WINAPI
HcsSetOperationCallback(
    _In_ HCS_OPERATION operation,
    _In_opt_ const void* context,
    _In_ HCS_OPERATION_COMPLETION callback
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|`context`| Optional pointer to a context that is passed to the callback|
|`callback`| The target callback that is invoked on completion of an operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HRESULT`|Returns code indicating the result of the operation.|
|     |     |
