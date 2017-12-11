# Execution Canceled
## Syntax
```C
// Context data for an exit caused by a cancellation from the host 
typedef enum { 
    WhvRunVpCancelReasonUser = 0 // Execution canceled by HvCancelRunVirtualProcessor 
} WHV_RUN_VP_CANCEL_REASON; 
 
typedef struct { 
    WHV_RUN_VP_CANCEL_REASON CancelReason; 
} WHV_RUN_VP_CANCELED_CONTEXT; 
```

## Return Value
Information about an exit caused by host system is provided in the `WHV_RUN_VP_CANCELLED_CONTEXT` structure.   
