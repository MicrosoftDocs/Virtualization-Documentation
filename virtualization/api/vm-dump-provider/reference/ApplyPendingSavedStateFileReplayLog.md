---
title: The ApplyPendingSavedStateFileReplayLog function
description: The ApplyPendingSavedStateFileReplayLog function opens the given saved state file in read-write exclusive mode so that it applies any pending replay logs to the contents. This method doesn't loads the saved state file into the library and can't be used to get content data; function LoadSavedStateFile must be used instead.
ms.date: 04/18/2022
author: mattbriggs
ms.author: mabrigg
---
# ApplyPendingSavedStateFileReplayLog function

Opens the given saved state file in read-write exclusive mode so that it applies any pending replay logs to the contents. This method doesn't loads the saved state file into the library and can't be used to get content data; function LoadSavedStateFile must be used instead.

## Syntax

```C
HRESULT
WINAPI
ApplyPendingSavedStateFileReplayLog(
    _In_    LPCWSTR                         VmrsFile
    );
```

## Parameters

`VmrsFile`

Supplies the path to the VMRS file whose any pending replay log will be applied.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |