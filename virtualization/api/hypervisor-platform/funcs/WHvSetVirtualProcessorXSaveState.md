# WHvSetVirtualProcessorXsaveState

## Syntax

```
HRESULT
WINAPI
WHvSetVirtualProcessorXsaveState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_bytes_(BufferSizeInBytes) const VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes
    );
```

### Parameters

`Partition`

Specifies the partition of the virtual processor.

`VpIndex`

Specifies the index of the virtual processor whose XSAVE state should be set.

`Buffer`

Specifies the buffer containing the XSAVE state.

`BufferSizeInBytes`

Specifies the size of the buffer, in bytes.

## Return Value

If the function succeeds, the return value is `S_OK`.
