# HcsOpenComputeSystem

## Description

Opens a handle to an existing compute system in a given namespace.

## Syntax

```cpp
HRESULT WINAPI
HcsOpenComputeSystemInNamespace(
    _In_ PCWSTR idNamespace,
    _In_ PCWSTR id,
    _In_ DWORD requestedAccess,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

`idNamespace`

Unique Id namespace identifying the compute system

`id`

Unique Id identifying the compute system

`requestedAccess`

Specifies the required access to the compute system

`computeSystem`

Receives a handle to the compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.

## Return Values

The function returns [HRESULT](https://docs.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values)

If the operation completes successfully, the return value is `S_OK`.

If a compute system with the specified Id does not exist, the return value is `HCS_E_SYSTEM_NOT_FOUND`.

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
