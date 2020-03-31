# HcsSubmitWerReport

## Description
This function submits a WER report for a bugcheck of a VM.

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`settings`| JSON document with the bugcheck information|
|    |    | 

### Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to submit the WER report.
