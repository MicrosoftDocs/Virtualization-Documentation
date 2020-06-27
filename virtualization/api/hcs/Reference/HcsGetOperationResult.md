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

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|`resultDocument`| If the operation succeeded, receives the result document of the operation. On failure, receives an error document. The caller is responsible for releasing the returned string using LocalFree().|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING` |Returns if the operation is still pending|
|`HRESULT`| Returns code indicating the result of the operation.|
|     |     |
