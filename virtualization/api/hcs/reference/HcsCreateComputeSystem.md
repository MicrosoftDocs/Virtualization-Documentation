# HcsCreateComputeSystem

## Description

Creates a new compute system, see [sample code](./ComputeSystemSample.md#CreateStartVM)

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

Unique Id identifying the compute system

`configuration`

JSON document specifying the settings of the [compute system](./../SchemaReference.md#ComputeSystem)

`operation`

The handle to the operation that tracks the create operation

`securityDescriptor`

Optional security descriptor specifying the permissions on the compute system. If not specified, only the caller of the function is granted permissions to perform operations on the compute system.

`computeSystem`

Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.


## Return Values

The function returns [HRESULT](./HCSHResult.md), refering details in [asnyc model](./../AsyncModel.md#HcsOperationResult)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |

