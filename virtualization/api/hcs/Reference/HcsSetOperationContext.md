# HcsSetOperationContext

## Description

Sets the context pointer on an operation

## Syntax

```cpp
HRESULT WINAPI
HcsSetOperationContext(
    _In_     HCS_OPERATION operation
    _In_opt_ void*         context
    );


```

## Parameters

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|`context`| Optional pointer to a context that is passed to the callback|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HRESULT`|Returns code indicating the result of the operation.|
|     |     |
