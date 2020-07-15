# HcsCreateOperation

## Description

Creates a new operation, see [sample code](./OperationSample.md#CreateOperation) 

## Syntax

```cpp
HCS_OPERATION WINAPI
HcsCreateOperation(
    _In_opt_ HCS_OPERATION_COMPLETION callback
    _In_opt_ void*                    context
    );

```

## Parameters

`callback`

Optional pointer to a HCS_OPERATION_COMPLETION callback to be invoked when the operation completes. If no callback is specified, the caller needs to use the HcsWaitForOperationResult function to wait for the completion of a function call in case HCS_E_OPERATION_PENDING is returned by the function.

`context`

Optional pointer to a context that is passed to the callback

## Return Values

`HCS_OPERATION`

Return the handle to the newly created operation on success, NULL if resources required for the operation couldn't be allocated. It is the responsibility of the caller to release the operation using HcsCloseOperation once it is no longer used

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |