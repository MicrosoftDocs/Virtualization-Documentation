# HdvCreateGuestMemoryAperture

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

`Requestor` 

Handle to the device requesting memory access.

`GuestPhysicalAddress`

Base physical address at which the aperture starts.

`ByteCount`

Size of the aperture in bytes.

`WriteProtected`

If TRUE, the process is only granted read access to the mapped memory.

`MappedAddress`

Receives the virtual address (in the calling process) at which the requested guest memory region has been mapped. 

## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.
