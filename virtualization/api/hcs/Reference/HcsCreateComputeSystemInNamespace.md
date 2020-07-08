# HcsCreateComputeSystem

## Description

Creates a new compute system in a given namespace.

## Syntax

```cpp
HRESULT WINAPI
HcsCreateComputeSystemInNamespace(
    _In_ PCWSTR idNamespace,
    _In_ PCWSTR id,
    _In_ PCWSTR configuration,
    _In_ HCS_OPERATION operation,
    _In_opt_ const HCS_CREATE_OPTIONS* options,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

`idNamespace`

Unique Id namespace identifying the compute system

`id`

Unique Id identifying the compute system

`configuration`

JSON document specifying the settings of the [compute system](./../SchemaReference.md#ComputeSystem)

`operation`

The handle to the operation that tracks the create operation

`options`

Reserved for future use. Must be `NULL`.

`computeSystem`

Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.

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
