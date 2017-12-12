# Unrecoverable Exception
## Syntax
```C
// Context data for an exit caused by an unrecoverable error (tripple fault) 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
} WHV_UNRECOVERABLE_EXCEPTION_CONTEXT; 
```

## Return Value
An exit for an unrecoverable error is caused by the virtual processor generating an exception that cannot be delivered (triple fault). 