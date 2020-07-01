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

`settings`

JSON document  of [ModificationRequest](./../SchemaReference.md#ModificationRequest) specifying the new settings

`result`

Optional, receives an error document on failures to apply the settings

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

