# HcsCreateEmptyRuntimetStateFile

## Description

This function creates an empty runtime-state file (.vmrs) for a VM. This file is used to save a running VM. It is specified in the options document of the [`HcsSaveComputeSystem`](./HcsSaveComputeSystem.md) function.

## Syntax

```cpp
HRESULT WINAPI
HcsCreateEmptyRuntimeStateFile(
    _In_ PCWSTR runtimeStateFilePath
    );
```

## Parameters

`runtimeStateFilePath`

Full path to the runtime-state file to create

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