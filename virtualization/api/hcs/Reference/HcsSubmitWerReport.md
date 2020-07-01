# HcsSubmitWerReport

## Description

This function submits a WER report for a bugcheck of a VM.

## Syntax

```cpp
HRESULT WINAPI
HcsSubmitWerReport(
    _In_ PCWSTR settings
    );
```

## Parameters

`settings`

JSON document of [CrashReport](./../SchemaReference.md#CrashReport) with the bugcheck information

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