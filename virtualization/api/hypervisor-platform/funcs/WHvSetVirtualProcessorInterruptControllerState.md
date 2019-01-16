# WHvSetVirtualProcessorInterruptControllerState

## Syntax

```
HRESULT
WINAPI
WHvSetVirtualProcessorInterruptControllerState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_bytes_(StateSize) const VOID* State,
    _In_ UINT32 StateSize
    );
```

### Parameters

`Partition`

Specifies the partition of the virtual processor.

`VpIndex`

Specifies the index of the virtual processor whose interrupt controller should be set.

`State`

Specifies a buffer containing the interrupt controller state.

`StateSize`

Specifies the size of the buffer, in bytes.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the virtual processor is currently running, the return value is `WHV_E_INVALID_VP_STATE`.
