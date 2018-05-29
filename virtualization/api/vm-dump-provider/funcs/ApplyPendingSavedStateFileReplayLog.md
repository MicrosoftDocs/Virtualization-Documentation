# ApplyPendingSavedStateFileReplayLog
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
ApplyPendingSavedStateFileReplayLog( 
    _In_    LPCWSTR                         VmrsFile 
    ); 
```
### Parameters

`VmrsFile`

Supplies the path to the VMRS file whose any pending replay log will be applied. 

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Opens the given saved state file in read-write exclusive mode so that it applies any pending replay logs to the contents. This method doesn't loads the saved state file into the library and can't be used to get content data; function LoadSavedStateFile must be used instead. 