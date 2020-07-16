# HcsGrantVmAccess

## Description

This function adds a group of entries to a files ACL that grants access to the user account used to run the VM.

## Syntax

```cpp
HRESULT WINAPI
HcsGrantVmAccess(
    _In_ PCWSTR filePath
    );
```

## Parameters

`filePath`

Path to the file for which to update the ACL

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |