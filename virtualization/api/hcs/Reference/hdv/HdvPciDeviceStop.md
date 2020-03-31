# HDV_PCI_DEVICE_STOP

Function called to notify the emulated device that the virtual processors of the VM are about to be stopped.

## Syntax

```C++
typedef void (CALLBACK *HDV_PCI_DEVICE_STOP)(
    _In_opt_ void* DeviceContext
    );
```

## Parameters

`DeviceContext` 

Context pointer that was supplied to HdvCreateDeviceInstance

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