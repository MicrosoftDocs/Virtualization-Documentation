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

|Parameter     |Description|
|---|---|
|`idNamespace`| Unique Id namespace identifying the compute system|
|`query`|Optional JSON document specifying a query for specific compute systems|
|`operation`| Handle to the operation that tracks the enumerate operation|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`|Returned on success|
|`HRESULT`|Error code for failures to enumerate the compute system|
|     |     |
