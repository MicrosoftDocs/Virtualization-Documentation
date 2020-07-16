# HcsGetOperationResult

## Description

Get the result of the operation and optionally a result document.

## Syntax

```cpp
HRESULT WINAPI
HcsGetOperationResult(
    _In_ HCS_OPERATION operation,
    _Outptr_opt_ PWSTR* resultDocument
    );

```

## Parameters

`operation`

The handle to an active operation

`resultDocument`

If the operation succeeded, receives the result document of the operation. On failure, receives an error document. The caller is responsible for releasing the returned string using LocalFree()

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
