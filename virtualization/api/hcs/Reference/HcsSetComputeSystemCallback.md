# HcsSetOperationContext

## Description

Registers a callback to receive notifications for the compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsSetComputeSystemCallback(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_EVENT_OPTIONS callbackOptions,
    _In_opt_ const void* context,
    _In_ HCS_EVENT_CALLBACK callback
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`computeSystem`| Handle to the compute system|
|`callbackOptions`| JSON document specifying callback options|
|`context`| Optional pointer to a context that is passed to the callback|
|`callback`| The target callback for HCS event|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HRESULT`|Returns code indicating the result of the operation.|
|     |     |
