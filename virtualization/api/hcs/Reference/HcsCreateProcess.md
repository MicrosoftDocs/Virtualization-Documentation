# HcsCreateProcess

## Description

Starts a process in a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsCreateProcess(
    _In_ HCS_SYSTEM computeSystem,
    _In_ PCWSTR processParameters,
    _In_ HCS_OPERATION operation,
    _In_opt_ const SECURITY_DESCRIPTOR* securityDescriptor,
    _Out_ HCS_PROCESS* process
    );
```

## Parameters

`computeSystem`

The handle to the compute system in which to start the process

`processParameters`

JSON document of [ProcessParameters](./../SchemaReference.md#ProcessParameters) specifying the command line and environment for the process 

`operation`

Handle to the operation that tracks the process creation operation

`securityDescriptor`

Optional security descriptor specifying the permissions on the compute system process. If not specified, only the caller of the function is granted permissions to perform operations on the compute system process

`process`

Receives the handle to the newly created process

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