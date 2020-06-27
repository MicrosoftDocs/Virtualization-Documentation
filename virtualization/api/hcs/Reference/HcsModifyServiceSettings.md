# HcsModifyServiceSettings

## Description

This function modifies the settings of the Host Compute System

## Syntax

```cpp
HRESULT WINAPI
HcsModifyServiceSettings(
    _In_ PCWSTR settings,
    _Outptr_opt_ PWSTR* result
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`settings`| JSON document specifying the new settings|
|`result` | Optional, receives an error document on failures to apply the settings.|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to modify the settings.|
|    |    |
