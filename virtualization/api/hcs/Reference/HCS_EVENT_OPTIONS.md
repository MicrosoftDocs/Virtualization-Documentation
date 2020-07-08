# HCS_EVENT_OPTIONS

## Description

Defines the options for an event callback registration, used in [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) and [HcsSetProcessCallback](./HcsSetProcessCallback.md).

## Syntax

```cpp
typedef enum HCS_EVENT_OPTIONS
{
    HcsEventOptionNone = 0x00000000,
    HcsEventOptionEnableOperationCallbacks = 0x00000001
} HCS_EVENT_OPTIONS;
```

## Constants

|||
|---|---|
|HcsEventOptionNone|No callback|
|HcsEventOptionEnableOperationCallbacks|Enable operation call back|


## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
