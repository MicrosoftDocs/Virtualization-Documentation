# HcsEnumerateComputeSystems

## Description

Enumerates existing compute systems

## Syntax

```cpp
HRESULT WINAPI
HcsEnumerateComputeSystems(
    _In_opt_ PCWSTR        query,
    _In_     HCS_OPERATION operation
    );

```

## Parameters

|Parameter     |Description|
|---|---|
|`query`|Optional JSON document specifying a query for specific compute systems|
|`operation`| Handle to the operation that tracks the enumerate operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`|Returned on success|
|`HRESULT`|Error code for failures to enumerate the compute system|
|     |     |
