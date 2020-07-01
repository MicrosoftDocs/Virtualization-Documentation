# HcsGetComputeSystemProperties

## Description

Returns properties of a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsGetComputeSystemProperties(
    _In_  HCS_SYSTEM computeSystem,
    _In_  HCS_OPERATION operation,
    _In_opt_ PCWSTR propertyQuery
    );
```

## Parameters

`computeSystem`

The handle to the compute system to query

`operation`

The handle to the operation that tracks the query operation

`propertyQuery`

Optional JSON document of [System_PropertyQuery](./../SchemaReference.md#System_PropertyQuery) specifying the properties to query

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
