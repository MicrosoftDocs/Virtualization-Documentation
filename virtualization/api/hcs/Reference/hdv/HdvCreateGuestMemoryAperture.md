# HdvCreateGuestMemoryAperture

## Description

Creates a guest RAM aperture into the address space of the calling process.

## Syntax

```C++
HRESULT WINAPI
HdvCreateGuestMemoryAperture(
    _In_  HDV_DEVICE Requestor,
    _In_  UINT64     GuestPhysicalAddress,
    _In_  UINT32     ByteCount,
    _In_  BOOL       WriteProtected,
    _Out_ void**     MappedAddress
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`Requestor` | Handle to the device requesting memory access.|
|`GuestPhysicalAddress` | Base physical address at which the aperture starts.|
|`ByteCount` | Size of the aperture in bytes.|
|`WriteProtected` | If TRUE, the process is only granted read access to the mapped memory.|
|`MappedAddress` | Receives the virtual address (in the calling process) at which the requested guest memory region has been mapped.|
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
