# HcsGetOperationResult

## Description

Gets the result of the operation and optionally a result document.

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

The handle to an active operation.

`resultDocument`

If the operation succeeded, receives the result document of the operation. The result document is dependent on the operation that was running. Not all functions that are tracked with operations return a result document on success. Refer to the remarks on the documentation for the HCS functions that use hcs operations for asynchronous tracking.


On failure, it can optionally receive an error JSON document represented by a [ResultError](./../SchemaReference.md#ResultError); it's not guaranteed to be always returned and depends on the function call the operation was tracking.


The caller is responsible for releasing the returned string using [`LocalFree`](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree).


Refer to [async model documentation](./../AsyncModel.md) for more details.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Remarks

When the operation doesn't have a callback set, this function can be used to poll for the result. As long as the operation is valid, running and not completed this will return `HCS_E_OPERATION_PENDING`.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
