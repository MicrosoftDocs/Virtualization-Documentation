# HcsCancelOperation

## Description

Cancel the operation, optionally waiting for any in-progress callbacks to complete.

## Syntax

```cpp
HRESULT WINAPI
HcsCancelOperation (
    _In_ HCS_OPERATION operation
    );

```

## Parameters

|Parameter     |Description|
|---|---|
|`operation`| Handle to an active operation|
|    |    |

## Return Values
|Return Value | Description|
|---|---|
|`S_OK`| If the operation succeeded|
|`HRESULT`| Returns code indicating the result of the operation.|
|     |     |
