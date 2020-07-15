# HcsSubmitWerReport

## Description

This function submits a WER report for a bugcheck of a VM, see [sample code](./ServiceSample.md#SubmitReport) 

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