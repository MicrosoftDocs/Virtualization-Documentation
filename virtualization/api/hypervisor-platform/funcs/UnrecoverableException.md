# Unrecoverable Exception
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax
```C
//
// Context data for an exit caused by an unrecoverable error, e.g. a triple fault
// (WHvRunVpExitReasonUnrecoverableException)
//
typedef struct WHV_UNRECOVERABLE_EXCEPTION_CONTEXT
{
    // Context of the virtual processor
    WHV_VP_EXIT_CONTEXT VpContext;
} WHV_UNRECOVERABLE_EXCEPTION_CONTEXT;
```

## Return Value
An exit for an unrecoverable error is caused by the virtual processor generating an exception that cannot be delivered (triple fault). 