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

`Requestor` 

Handle to the device requesting the interrupt.

`MsiAddress`

The guest address to which the interrupt message is written.

`MsiData`

The data to write at MsiAddress.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.
