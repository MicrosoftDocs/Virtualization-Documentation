# HdvWriteGuestMemory

Writes the contents of the supplied buffer to guest primary memory (RAM).

## Syntax

```C++
HRESULT WINAPI
HdvWriteGuestMemory(
    _In_                        HDV_DEVICE Requestor,
    _In_                        UINT64     GuestPhysicalAddress,
    _In_                        UINT32     ByteCount,
    _In_reads_(ByteCount) const BYTE*      Buffer
    );
```

## Parameters

`Requestor` 

Handle to the device requesting memory access.

`GuestPhysicalAddress` 

Guest physical address at which the write operation starts.

`ByteCount` 

Number of bytes to write.

`Buffer` 

Source buffer for the write operation.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.
