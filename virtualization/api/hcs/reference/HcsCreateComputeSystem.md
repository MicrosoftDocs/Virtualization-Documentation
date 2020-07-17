# HcsCreateComputeSystem

## Description

Creates a new compute system, see [sample code](./tutorial.md) for simple example.

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

`id`

Unique Id identifying the compute system.

`configuration`

JSON document specifying the settings of the [compute system](./../SchemaReference.md#ComputeSystem). The compute system document is expected to have a `Container`, `VirtualMachine` or `HostedSystem` property set since they are mutually exclusive.

`operation`

The handle to the operation that tracks the create operation.

`securityDescriptor`

Reserved for future use, must be `NULL`.

`computeSystem`

Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.


## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation starts successfully. It needs 
to use [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) to show operation result.

If the return value is `HCS_E_OPERATION_PENDING`...



## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
