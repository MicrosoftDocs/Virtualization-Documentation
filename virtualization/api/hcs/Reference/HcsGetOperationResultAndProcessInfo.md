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

`operation`

The handle to an active operation

`processInformation`

If the operation succeeded, receives the pointer to the process information, which type is [HCS_PROCESS_INFORMATION](./HCS_PROCESS_INFORMATION.md)

`resultDocument`

If the operation succeeded, receives the result document of the operation

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

