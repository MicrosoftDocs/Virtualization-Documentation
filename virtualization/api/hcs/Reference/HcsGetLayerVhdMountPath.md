# HcsGetLayerVhdMountPath

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`virtualDiskHandle`| Handle to a VHD mounted on the host|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`mountPath`| Receives the volume path for the layer. It is the caller's responsibility to release the returned string buffer using `LocalFree`.|
|    |    | 
The function returns `S_OK` on success. `HRESULT` error code for failures to lookup the volume path.

## Remarks
This function returns the volume path for a layer VHD mounted on the host.