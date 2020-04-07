# HdvDeliverGuestInterrupt

Delivers a message signalled interrupt (MSI) to the guest partition.

## Syntax

```C++
HRESULT WINAPI
HdvDeliverGuestInterrupt(
    _In_ HDV_DEVICE Requestor,
    _In_ UINT64     MsiAddress,
    _In_ UINT32     MsiData
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`Requestor` |Handle to the device requesting the interrupt.|
|`MsiAddress` |The guest address to which the interrupt message is written.|
|`MsiData`|The data to write at MsiAddress.|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | Returned if function succeeds.|
|`HRESULT` | An error code is returned if the function fails.
|     |     |

## Requirements

|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    | 