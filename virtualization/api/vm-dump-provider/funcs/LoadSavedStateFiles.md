# LoadSavedStateFiles
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
LoadSavedStateFiles( 
    _In_    LPCWSTR                         BinFile, 
    _In_    LPCWSTR                         VsvFile, 
    _Out_   VM_SAVED_STATE_DUMP_HANDLE*     VmSavedStateDumpHandle 
    ); 
```
### Parameters

`BinFile`

Supplies the path to the BIN file to load.

`VsvFile`

Supplies the path to the VSV file to load.

`VmSavedStateDumpHandle`

Returns the ID for the dump provider instance created.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Loads the given saved state files and creates an instance of VmSavedStateDump. This instance can be referenced on the other methods with the returned UINT64 Id. 