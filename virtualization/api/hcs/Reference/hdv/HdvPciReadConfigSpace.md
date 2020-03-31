# HDV_PCI_READ_CONFIG_SPACE

Function called to execute a read into the emulated device’s PCI config space.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_READ_CONFIG_SPACE)(
    _In_opt_ void*   DeviceContext,
    _In_     UINT32  Offset,
    _Out_    UINT32* Value
    );
```

## Parameters

`DeviceContext` 

Context pointer that was supplied to HdvCreateDeviceInstance.

`Offset` 

Offset in bytes from the base of the bar to read.

`Value` 

Receives the read value.

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