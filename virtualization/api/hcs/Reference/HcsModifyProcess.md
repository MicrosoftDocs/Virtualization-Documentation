# HcsModifyProcess

## Description

Modifies the parameters of a process in a compute system, see [sample code](./ProcessSample.md#ModifyProcess)  

## Syntax

```cpp
HRESULT WINAPI
HcsModifyProcess(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation,
    _In_ PCWSTR settings
    );
```

## Parameters

`process`

Handle to the process to modify

`operation`

Handle to the operation that tracks the process

`settings`

Receives the new settings of the process

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
