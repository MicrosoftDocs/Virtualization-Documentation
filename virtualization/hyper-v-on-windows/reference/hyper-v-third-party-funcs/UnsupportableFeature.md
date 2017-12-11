# Unsupported Feature
## Syntax
```C
// Context data for an exit caused by the use of an unsupported feature 
typedef struct { 
    WHV_X64_UNSUPPORTED_FEATURE_CODE FeatureCode; // HV_X64_UNSUPPORTED_FEATURE_CODE 
    UINT64 FeatureParameter;  
} WHV_X64_UNSUPPORTED_FEATURE_CONTEXT; 
```

## Return Value
An exit for an unsupported feature is caused by the virtual processor accesses a feature of the architecture that is not properly virtualized by the hypervisor. 
