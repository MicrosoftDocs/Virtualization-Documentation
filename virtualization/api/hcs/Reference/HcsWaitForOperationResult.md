# HcsWaitForOperationResult

## Description

Similar to HcsGetOperationResult, this will wait for the given number of milliseconds for the operation to complete. It is intended to be used when synchronous behavior is desired.

## Syntax

```cpp

HRESULT WINAPI
HcsWaitForOperationResult(
    _In_ HCS_OPERATION operation,
    _In_ DWORD timeoutMs,
    _Outptr_opt_ PWSTR* resultDocument
    );
```

## Parameters

`operation`

The handle to an active operation

`timeoutMs`

Time to wait for the operation to complete

`resultDocument`

If the operation succeeded, receives the result document of the operation. On failure, receives an error document. The caller is responsible for releasing the returned string using LocalFree()

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

