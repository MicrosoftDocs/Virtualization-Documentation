# Unsupported Feature
**Note: A prerelease of this API is available starting in the Insiders Preview Build 17083**

## Syntax
```C
//
// Context data for an exit caused by the use of an unsupported processor feature
// (WHvRunVpExitReasonUnsupportedFeature)
//
typedef enum WHV_X64_UNSUPPORTED_FEATURE_CODE
{
    WHvUnsupportedFeatureIntercept     = 1,
    WHvUnsupportedFeatureTaskSwitchTss = 2
} WHV_X64_UNSUPPORTED_FEATURE_CODE;

typedef struct WHV_X64_UNSUPPORTED_FEATURE_CONTEXT
{
    WHV_X64_UNSUPPORTED_FEATURE_CODE FeatureCode;
    UINT64 FeatureParameter;
} WHV_X64_UNSUPPORTED_FEATURE_CONTEXT;
```

## Return Value
An exit for an unsupported feature is caused by the virtual processor accesses a feature of the architecture that is not properly virtualized by the hypervisor. 
