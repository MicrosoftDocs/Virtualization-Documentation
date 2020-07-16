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

`operation`

The handle to an active operation

`context`

Optional pointer to a context that is passed to the callback

`callback`

The target callback that is invoked on completion of an operation

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |