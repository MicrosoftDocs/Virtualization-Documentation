# HDV_PCI_WRITE_INTERCEPTED_MEMORY

Function called to execute an intercepted MMIO write for the emulated device.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_WRITE_INTERCEPTED_MEMORY)(
    _In_opt_           void*                DeviceContext,
    _In_               HDV_PCI_BAR_SELECTOR BarIndex,
    _In_               UINT64               Offset,
    _In_               UINT64               Length,
    _In_reads_(Length) const BYTE*          Value
    );
```

## Parameters

`DeviceContext` 

Context pointer that was supplied to HdvCreateDeviceInstance.

`BarIndex` 

Index to the BAR the write operation pertains to.

`Offset` 

Offset in bytes from the base of the BAR to write.

`Length` 

Length in bytes to write (1 / 2 / 4 / 8 bytes).

`Value` 

Value to write.

## Return Values

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.

## Requirements

|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    | 