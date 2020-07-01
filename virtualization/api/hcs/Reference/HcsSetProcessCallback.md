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

`process`

The handle to the process for that the callback is registered

`callbackOptions`

The option for callback, using HCS_EVENT_OPTIONS
|Parameter|Value|Description|
|---|---|---|
|HcsEventOptionNone|0|No callback|
|HcsEventOptionEnableOperationCallbacks|1|Enable operation call back|

`context`

Optional pointer to a context that is passed to the callback

`callback`

Callback function that is invoked for events on the process

## Return Values

The function returns [HRESULT](https://docs.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values)

If the operation completes successfully, the return value is `S_OK`.

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
