# HcsGetProcessProperties

## Description
Returns the properties of a process in a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessProperties(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR propertyQuery
    );
```

## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to query|
|`operation`| Handle to the operation that tracks the process|
|`propertyQuery`| Optional JSON document specifying the properties to query|
|    |    | 



## Return Values
|Return Value | Description|
|---|---|
|`S_OK`| Returned  on success|
|`HRESULT`| Error code for failures to query the process |
|    |    | 