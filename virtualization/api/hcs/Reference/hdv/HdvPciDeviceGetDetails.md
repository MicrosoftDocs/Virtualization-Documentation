# HDV_PCI_DEVICE_GET_DETAILS function

Function invoked to query the PCI description of the emulated device. This information is used when presenting the device to the guest partition.

## Syntax

```C++
typedef HRESULT (CALLBACK *HDV_PCI_DEVICE_GET_DETAILS)(
    _In_opt_ void*           DeviceContext,
    _Out_    PHDV_PCI_PNP_ID PnpId,
    _Out_    UINT32          ProbedBars[HDV_PCI_BAR_COUNT]
    );
```

## Parameters

`DeviceContext` 

Context pointer that was supplied to HdvCreateDeviceInstance

`PnpId` 

Receives the vendor / device ID / ... information about the device

`ProbedBars` 

Receives the results for probing the MMIO BARs.

## Return Value

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