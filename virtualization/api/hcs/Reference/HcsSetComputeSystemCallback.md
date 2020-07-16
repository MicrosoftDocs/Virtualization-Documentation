# HcsSetComputeSystemCallback

## Description

Registers a callback to receive notifications for the compute system, see [sample code](./ComputeSystemSample.md#SetCSCallback)

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

`computeSystem`

The handle to the compute system

`callbackOptions`

The option for callback, using [HCS_EVENT_OPTIONS](./HCS_EVENT_OPTIONS.md)

`context`

Optional pointer to a context that is passed to the callback

`callback`

The target callback for HCS event.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |