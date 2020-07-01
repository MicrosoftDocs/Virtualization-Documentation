# HcsGetOperationId

## Description

Get the id of the operation Id uniquely identify the operation, for example there can be multiple modify settings calls in progress.

## Syntax

```cpp
UINT64 WINAPI
HcsGetOperationId(
    _In_ HCS_OPERATION operation
    );


```

## Parameters

`operation`

The handle to an active operation

## Return Values

If the function succeeds, the return value is Id of operation.

If the operation is invalid, the return value is `HCS_INVALID_OPERATION_ID`


## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |

