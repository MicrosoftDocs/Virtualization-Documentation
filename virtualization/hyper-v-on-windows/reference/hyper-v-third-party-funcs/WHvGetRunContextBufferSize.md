# WHvGetRunContextBufferSize

## Syntax

```C
UINT32 
WHvGetRunContextBufferSize(); 
```

## Return Value
Returns the minimum size required for the buffer that receives the exit context of the [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) function call. The value returned by this function is constant for a respective version of the DLL implementation.
  

