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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`idNamespace`| Unique Id namespace identifying the compute system|
|`id`| Unique Id identifying the compute system|
|`requestedAccess`| Specifies the required access to the compute system|
|`computeSystem`| Receives a handle to the compute system. It is the responsibility of the caller to release the handle using `HcsCloseComputeSystem` once it is no longer in use.|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`|Returned on success|
|`HCS_E_SYSTEM_NOT_FOUND`|Returns if a compute system with the specified Id does not exist|
|`HRESULT`|Error code for failures to open the compute system|
|     |     |
