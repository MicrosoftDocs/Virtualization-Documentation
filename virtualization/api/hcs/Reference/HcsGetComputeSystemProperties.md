# HcsGetComputeSystemProperties

## Description

Returns properties of a compute system, see [sample code](./tutorial.md) for simple example.

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

The handle to the compute system to query.

`operation`

The handle to the operation that tracks the query operation.

`propertyQuery`

Optional JSON document of [System_PropertyQuery](./../SchemaReference.md#System_PropertyQuery) specifying the properties to query.

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Remarks

On success, the result document returned by the hcs operation is a JSON document representing a compute system' [Properties](./../SchemaReference.md#Properties).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
