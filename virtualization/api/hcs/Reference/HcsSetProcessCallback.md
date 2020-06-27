# HcsSetOperationContext

## Description

Registers a callback function to receive notifications for a process in a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsSetProcessCallback(
    _In_ HCS_PROCESS process,
    _In_ HCS_EVENT_OPTIONS callbackOptions,
    _In_ void* context,
    _In_ HCS_EVENT_CALLBACK callback
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`process`| Handle to the process for that the callback is registered|
|`callbackOptions`| JSON document specifying callback options|
|`context`| Optional pointer to a context that is passed to the callback|
|`callback`| Callback function that is invoked for events on the process|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`| Returns on success|
|`HRESULT`| Returns error code for failures to register the callback|
|     |     |
