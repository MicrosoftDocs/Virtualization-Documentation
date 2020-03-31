# HcsCreateEmptyRuntimetStateFile

## Description
This function creates an empty runtime-state file (.vmrs) for a VM. This file is used to save a running VM. It is specified in the options document of the [`HcsSaveComputeSystem`](./HcsSaveComputeSystem.md) function.

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`runtimeStateFilePath`| Full path to the runtime-state file to create|
|    |    | 



### Return Values
The function returns `S_OK` on success. `HRESULT` error code for failures to create the file.


