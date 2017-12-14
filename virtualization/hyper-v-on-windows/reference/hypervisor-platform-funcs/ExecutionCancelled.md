# Execution Canceled
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

## Syntax
```C
//
// Context data for an exit caused by a cancellation from the host (WHvRunVpExitReasonCanceled)
//
typedef enum WHV_RUN_VP_CANCEL_REASON
{
    WhvRunVpCancelReasonUser = 0 // Execution canceled by HvCancelRunVirtualProcessor
} WHV_RUN_VP_CANCEL_REASON;

typedef struct WHV_RUN_VP_CANCELED_CONTEXT
{
    WHV_RUN_VP_CANCEL_REASON CancelReason;
} WHV_RUN_VP_CANCELED_CONTEXT;

```

## Return Value
Information about an exit caused by host system is provided in the `WHV_RUN_VP_CANCELLED_CONTEXT` structure.   
