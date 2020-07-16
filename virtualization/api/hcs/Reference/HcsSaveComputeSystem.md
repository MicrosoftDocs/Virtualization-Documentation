# HcsSaveComputeSystem

## Description

Saves the state of a compute system, see [sample code](./ComputeSystemSample.md#SaveCloseCS).

## Syntax

```cpp
HRESULT WINAPI
HcsSaveComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to save.

`operation`

The handle to the operation that tracks the save operation.

`options`

Optional JSON document of [SaveOptions](./../SchemaReference.md#SaveOptions) specifying save options.

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Remarks

The compute system cannot be saved if it is still running and the return value of `HcsWaitForOperationResult` will be `HCS_E_INVALID_STATE`

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
