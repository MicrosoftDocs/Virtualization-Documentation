# HcsEnumerateComputeSystems

## Description

Enumerates existing compute systems in a given namespace.

## Syntax

```cpp
HRESULT WINAPI
HcsEnumerateComputeSystemsInNamespace(
    _In_ PCWSTR idNamespace,
    _In_opt_ PCWSTR query,
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`idNamespace`

Unique Id namespace identifying the compute system

`query`

Optional JSON document [Properties](./../SchemaReference.md#Properties) specifying a query for specific compute systems

`operation`

The handle to the operation that tracks the enumerate operation

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
