# HcsModifyComputeSystem

## Description

Modifies settings of a compute system, see [sample code](./tutorial.md) for simple example.

## Syntax

```cpp
HRESULT WINAPI
HcsModifyComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_ PCWSTR configuration,
    _In_opt_ HANDLE identity
    );
```

## Parameters

`computeSystem`

Handle the compute system to modify.

`operation`

Handle to the operation that tracks the modify operation.

`configuration`

JSON document of [ModifySettingRequest](./../SchemaReference.md#ModifySettingRequest) specifying the settings to modify.

`identity`

Optional handle to an access token that is used when applying the settings.

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
