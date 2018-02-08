# ApplyPendingSavedStateFileReplayLog
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

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