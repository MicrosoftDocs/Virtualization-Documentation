# GetVpCount function

Queries for the Virtual Processor count for a given VmSavedStateDump.

## Syntax

```C
HRESULT
WINAPI
GetVpCount(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _Out_   UINT32*                         VpCount
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpCount`

Returns the Virtual Processor count.

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