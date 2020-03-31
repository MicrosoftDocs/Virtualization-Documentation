# HDV_PCI_DEVICE_SET_CONFIGURATION

Function invoked to set the configuration of the emulated device.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_SET_CONFIGURATION)(
    _In_opt_ void*         DeviceContext,
    _In_     UINT32        ConfigurationValueCount,
    _In_     const PCWSTR* ConfigurationValues
    );
```

## Parameters

`DeviceContext` 

Context pointer that was supplied to HdvCreateDeviceInstance

`ConfigurationValueCount` 

Number of elements in the ConfigurationValues array

`ConfigurationValues` 

Array with strings representing the configurations values. These strings are provided in the VM’s configuration.

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