# WHvGetVirtualProcessorXsaveState

## Syntax

```
HRESULT
WINAPI
WHvGetVirtualProcessorXsaveState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_to_(BufferSizeInBytes, *BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_ UINT32* BytesWritten
    );
```

### Parameters

`Partition`

Specifies the partition of the virtual processor.

`VpIndex`

Specifies the index of the virtual processor whose XSAVE state should be queried.

`Buffer`

Specifies the buffer to receive the virtual processor's XSAVE state.

`BufferSizeInBytes`

Specifies the size of the buffer, in bytes.

`BytesWritten`

Receives the number of bytes written to the buffer.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the buffer is not large enough, the return value is `WHV_E_INSUFFICIENT_BUFFER`. In this case, `BytesWritten` receives the required buffer size.
