# HV_X64_XMM_CONTROL_STATUS_REGISTER

## Syntax

```c
typedef struct
{
    union
    {
        UINT64 LastFpRdp;
        struct
        {
            UINT32 LastFpDp;
            UINT16 LastFpDs;
        };
    };

    UINT32 XmmStatusControl;
    UINT32 XmmStatusControlMask;
} HV_X64_XMM_CONTROL_STATUS_REGISTER;
 ```