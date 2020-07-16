# HCS_PROCESS_INFORMATION

## Description

Struct containing information about a process created by  [HcsCreateProcess](./HcsCreateProcess.md).

## Syntax

```cpp
typedef struct
{
    DWORD ProcessId;
    DWORD Reserved;
    HANDLE StdInput;
    HANDLE StdOutput;
    HANDLE StdError;
} HCS_PROCESS_INFORMATION;
```

## Members

`ProcessId`

Identifier of the created process.

`Reserved`

`StdInput`

If created, standard input handle of the process.

`StdOutput`

If created, standard output handle of the process.

`StdError`

If created, standard error handle of the process.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
