# HcsGetOperationResultAndProcessInfo

## Description

Returns the result of an operation, including the process information for HcsCreateProcess and HcsGetProcessInfo.

## Syntax

```cpp
HRESULT WINAPI
HcsGetOperationResultAndProcessInfo(
    _In_ HCS_OPERATION operation,
    _Out_opt_ HCS_PROCESS_INFORMATION* processInformation,
    _Outptr_opt_ PWSTR* resultDocument
    );

```

## Parameters

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|`processInformation`| Pointer to the process information|
|`resultDocument`| If the operation succeeded, receives the result document of the operation.|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_PROCESS_INFORMATION` |Returns process information|
|`HRESULT`| Returns code indicating the result of the operation.|
|     |     |
