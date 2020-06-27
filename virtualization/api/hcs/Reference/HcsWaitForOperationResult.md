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

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation.|
|`timeoutMs`| Time to wait for the operation to complete.|
|`resultDocument`| If the operation succeeded, receives the result document of the operation. On failure, receives an error document. The caller is responsible for releasing the returned string using LocalFree().|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_TIMEOUT`|Returned if the operation does not complete within the specified timeout period.|
|`HRESULT`|Indicates the result of the operation.|
|
|     |     |
