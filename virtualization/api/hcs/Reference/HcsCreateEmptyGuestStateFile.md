# HcsCreateEmptyGuestStateFile

## Description

This function creates an empty guest-state file (.vmgs) for a VM. This file is required in cases where the VM  is expected to be persisted and restarted multiple times. It is configured in the 'GuestState' property of the settings document for a VM.

## Syntax

```cpp
HRESULT WINAPI
HcsCreateEmptyGuestStateFile(
    _In_ PCWSTR guestStateFilePath
    );
```

### Parameters

`guestStateFilePath`

Full path to the guest-state file to create

### Return Values

The function returns [HRESULT](./HCSHResult.md)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |