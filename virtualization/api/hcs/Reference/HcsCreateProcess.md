# HcsCreateProcess

## Description

Starts a process in a compute system

## Syntax

```csharp
THROW_IF_FAILED(
        HcsCreateProcess(
            containerSystem.get(),  
            c_ProcessConfiguration,
            nullptr,
            &processInfo,
            &process,
            &result
        ));

```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system in which to start the process|
|`processParameters`| JSON document specifying the command line and environment for the process|
|`operation`| Handle to the operation that tracks the process creation operation|
|`securityDescriptor`| Optional security descriptor specifying the permissions on the compute system process. If not specified, only the caller of the function is granted permissions to perform operations on the compute system process|
|`process`| Receives the handle to the newly created process|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to create the process.|
|    |    |
