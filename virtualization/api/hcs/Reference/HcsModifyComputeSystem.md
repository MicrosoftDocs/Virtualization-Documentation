# HcsModifyComputeSystem

## Description

Modifies settings of a compute system

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

|Parameter     |Description|
|---|---|
|`computeSystem`| Handle the compute system to modify|
|`operation`| Handle to the operation that tracks the modify operation|
|`configuration`| JSON document specifying the settings to modify|
|`identity`| Optional handle to an access token that is used when applying the settings|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returns if modifying the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returns if the compute system cannot be modified in it's current state|
|`HRESULT`|Error code for failures to modify the compute system.|
|     |     |
