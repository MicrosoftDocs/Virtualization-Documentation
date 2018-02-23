# Interrupt Window

**Note: A prerelease of this API is available starting in the Insiders Preview Build 17083**

## Syntax
```C
//
// Context data for an exit caused by an interrupt delivery window cancellation from the host
// (WHvRunVpExitReasonX64InterruptWindow)
//
typedef enum WHV_X64_PENDING_INTERRUPTION_TYPE
{
    WHvX64PendingInterrupt           = 0,
    WHvX64PendingNmi                 = 2,
    WHvX64PendingException           = 3
} WHV_X64_PENDING_INTERRUPTION_TYPE, *PWHV_X64_PENDING_INTERRUPTION_TYPE;

typedef struct WHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT
{
    WHV_X64_PENDING_INTERRUPTION_TYPE DeliverableType;
} WHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT, *PWHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT;
```

## Return Value

Information about exits caused by the virtual processor accessing a memory location that is not mapped or not accessible is provided by the `WHV_MEMORY_ACCESS_CONTEXT` structure.  