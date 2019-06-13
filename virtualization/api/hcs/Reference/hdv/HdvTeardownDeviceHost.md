# HdvInitializeDeviceHost

Tears down the device emulator host in the caller's process. All device instances associated to the device host become non-functional.

## Syntax

```C++
HRESULT WINAPI
HdvTeardownDeviceHost(
    _In_ HDV_HOST DeviceHost
    );
```

## Parameters

`DeviceHost` 

Handle to the device host to tear down.

## Return Value

If the function succeeds, the return value is `S_OK`.

If the function fails, the return value is an  `HRESULT` error code.
