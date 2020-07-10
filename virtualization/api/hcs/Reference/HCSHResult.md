# HCS HRESULT

The following HRESULT values are the most common ones. More values are contained in the header file [Winerror.h](https://docs.microsoft.com/en-us/windows/win32/api/winerror/)

|Name|Description|Value|
|S_OK|Operation initialized successfully|0x00000000|
|HCS_E_SYSTEM_NOT_FOUND|A virtual machine or container with the specified identifier does not exist|0x8037010E|
|HCS_E_INVALID_STATE|The requested virtual machine or container operation is not valid in the current state|0x80370105|
|HCS_E_OPERATION_TIMEOUT|The operation did not complete in time|0x80370118|
