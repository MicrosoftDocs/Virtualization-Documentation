# HcsFormatWritableLayerVhd

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`virtualDiskHandle`| Handle to a VHD|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to initialize the VHD.

## Remarks
This function creates and formats a partition that is intended to be used as a writable layer for a container.