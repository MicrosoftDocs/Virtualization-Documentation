# HcsSubmitWerReport

## Description
This function submits a WER report for a bugcheck of a VM.

## Syntax

```cpp
HRESULT WINAPI
HcsSubmitWerReport(
    _In_ PCWSTR settings
    );
```


## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`settings`| JSON document with the bugcheck information|
|    |    | 

## Return Values
|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to submit the WER report.|
