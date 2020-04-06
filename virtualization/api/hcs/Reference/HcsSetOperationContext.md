# HcsSetOperationContext

## Description
Sets the context pointer on an operation


## Syntax

```cpp
void WINAPI
HcsSetOperationContext(
    _In_     HCS_OPERATION operation
    _In_opt_ void         context
    );


```


## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`operation`| Handle to an active operation|
|`context`| Optional pointer to a context that is passed to the callback|
|    |    | 


## Return Values
None.
