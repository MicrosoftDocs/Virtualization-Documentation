# ReleaseSavedStateFiles
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
ReleaseSavedStateFiles( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle 
    );  
```
### Parameters

`VmSavedStateDumpHandle`

Supplies the ID of the dump provider instance to release.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Releases the given VmSavedStateDump provider that matches the supplied ID. Releasing the provider releases the locks to the saved state files. This means that it won't be available for use on other methods. 