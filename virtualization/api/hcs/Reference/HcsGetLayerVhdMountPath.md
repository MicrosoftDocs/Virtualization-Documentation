# HcsGetLayerVhdMountPath

## Description
Returns the volume path for a virtual disk of a writable container layer

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`vhdHandle`| Handle to a VHD mounted on the host|
|`mountPath`| Receives the volume path for the layer. It is the caller's responsibility to release the returned string buffer using `LocalFree`.|
|    |    | 



### Return Values
The function returns `S_OK` on success. `HRESULT` error code for failures to lookup the volume path.

