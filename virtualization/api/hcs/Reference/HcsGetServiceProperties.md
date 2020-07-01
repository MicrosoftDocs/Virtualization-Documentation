# HcsGetServiceProperties

## Description

This function returns properties of the Host Compute System

## Syntax

```cpp
HRESULT WINAPI
HcsGetServiceProperties(
    _In_opt_ PCWSTR propertyQuery,
    _Outptr_ PWSTR* result
    );
```

## Parameters

`propertyQuery`

Optional JSON document of [Service_PropertyQuery](./../SchemaReference.md#Service_PropertyQuery) specifying the properties to query

`result`

Receives a JSON document of [ServiceProperties](./../SchemaReference.md#ServiceProperties) with the requested properties

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