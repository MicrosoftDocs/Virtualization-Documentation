# HcsPauseComputeSystem

## Description

Pauses the execution of a compute system, see [sample code](./ComputeSystemSample.md#PauseResumeCS)

## Syntax

```cpp

HRESULT WINAPI
HcsPauseComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to pause

`operation`

The handle to the operation that tracks the pause operation

`options`

Optional JSON document of [PauseOptions](./../SchemaReference.md#PauseOptions) specifying pause options

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

