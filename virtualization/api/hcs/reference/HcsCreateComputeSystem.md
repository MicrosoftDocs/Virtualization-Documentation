# HcsCreateComputeSystem

## Description

Creates a new compute system

## Syntax

```cpp
HRESULT WINAPI
HcsCreateComputeSystem(
    _In_ PCWSTR id,
    _In_ PCWSTR configuration,
    _In_ HCS_OPERATION operation,
    _In_opt_ const SECURITY_DESCRIPTOR* securityDescriptor,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`id`| Unique Id identifying the compute system|
|`configuration`| JSON document specifying the settings of the [compute system](./../SchemaReference.md#ComputeSystem)|
|`operation`| Handle to the operation that tracks the create operation|
|`securityDescriptor`| Optional security descriptor specifying the permissions on the compute system. If not specified, only the caller of the function is granted permissions to perform operations on the compute system.|
|`computeSystem`| Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using HcsCloseComputeSystem once it is no longer in use.|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returned if creating the compute system was successfully initiated|
|`HCS_E_SYSTEM_ALREADY_EXISTS`|Returned if a compute system with the specified unique Id already exists|
|`HCS_E_INVALID_JSON`|Returned if the specified settings document is invalid|
|`HRESULT`|Error code for failures to create the compute system|
|     |     |
