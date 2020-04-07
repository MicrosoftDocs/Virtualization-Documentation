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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system to query|
|`operation`| Handle to the operation that tracks the query operation|
|`propertyQuery`| Optional JSON document specifying the properties to query|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returns if querying the compute system was successfully initiated|
|`HRESULT`|Error code for failures to query the compute system|
|     |     |
