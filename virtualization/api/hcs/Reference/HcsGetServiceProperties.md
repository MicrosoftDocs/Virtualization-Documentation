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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`propertyQuery`| Optional JSON document specifying the properties to query|
|`properties` | Receives a JSON document with the requested properties.|
|`result` | Optional, receives an error document on failures to query the properties.
|    |    |

## Return Values

|Return Value     |Description|
|---|---|---|---|---|---|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to query the properties.|
|    |    |
