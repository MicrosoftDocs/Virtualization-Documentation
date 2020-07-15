# HcsCrashComputeSystem

## Description

Forcefully terminates a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsCrashComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to terminate

`operation`

The handle to the operation that tracks the terminate operation

`options`

Optional JSON document [CrashOptions](./../SchemaReference.md#CrashOptions) specifying terminate options

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
