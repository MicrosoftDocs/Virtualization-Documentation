---
title: The LocateSavedStateFiles function
description: Locates the saved state file(s) for a given VM and/or snapshot.
ms.date: 04/19/2022
author: sethmanheim
ms.author: roharwoo
---

# LocateSavedStateFiles function

Locates the saved state file(s) for a given VM and/or snapshot. This function uses WMI and the V1 or V2 virtualization namespace. So this is expected to fail if ran on a machine without Hyper-V installed.
- If the given VM has a VMRS file, parameters BinPath and VsvPath will be a single null terminator character.
- If the given VM has BIN and VSV files, parameter VmrsPath will be a single null terminator character.
- If no saved state files are found, all three returned string parameters will be single null terminator characters.

## Syntax
```C
HRESULT
WINAPI
LocateSavedStateFiles(
    _In_        LPCWSTR                     VmName,
    _In_opt_    LPCWSTR                     SnapshotName,
    _Out_       LPWSTR*                     BinPath,
    _Out_       LPWSTR*                     VsvPath,
    _Out_       LPWSTR*                     VmrsPath
    );
```
## Parameters

`VmName`

Supplies the VM name for which the saved state file will be located.

`SnapshotName`

Supplies an optional snapshot name to locate its saved state file on relation to the given VM name.

`BinPath`

Returns a pointer to a NULL-terminated string containing the full path name to the BIN file. The caller must call LocalFree on the returned pointer in order to release the memory occupied by the string.

`VsvPath`

Returns a pointer to a NULL-terminated string containing the full path name to the VSV file. The caller must call LocalFree on the returned pointer in order to release the memory occupied by the string.

`VmrsPath`

Returns a pointer to a NULL-terminated string containing the full path name to the VMRS file. The caller must call LocalFree on the returned pointer in order to release the memory occupied by the string.

## Return Value

If the operation completes successfully, the return value is `S_OK`. Otherwise, `E_OUTOFMEMORY` indicates there was insufficient memory to return the full path(s) or other `HRESULT` failure codes might be returned.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |
