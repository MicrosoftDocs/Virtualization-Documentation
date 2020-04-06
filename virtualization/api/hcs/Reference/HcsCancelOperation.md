# HcsCancelOperation

## Description
Cancel the operation, optionally waiting for any in-progress callbacks to complete.

## Syntax

```cpp
HRESULT WINAPI
HcsCancelOperation (
    _In_ HCS_OPERATION operation,
    _In_ BOOL          waitForCallback
    );

```

## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`operation`| Handle to an active operation|
|`waitForCallback`| If TRUE, cancelation will wait for any in-progress callback to complete.|
|    |    | 


## Return Values
|Return Value | Description|
|---|---|
|`S_OK`| If the operation succeeded|
|`HRESULT`| Returns code indicating the result of the operation.|
|     |     |