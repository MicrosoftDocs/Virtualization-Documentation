# HcsEnumerateComputeSystems

## Description

Enumerates existing compute systems, see [sample code](./ComputeSystemSample.md#EnumCS)

## Syntax

```cpp
HRESULT WINAPI
HcsEnumerateComputeSystems(
    _In_opt_ PCWSTR        query,
    _In_     HCS_OPERATION operation
    );

```

## Parameters

`query`

Optional JSON document of [Properties](./../SchemaReference.md#Properties) specifying a query for specific compute systems

`operation`

The handle to the operation that tracks the enumerate operation

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
