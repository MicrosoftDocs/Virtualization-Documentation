# HcsGetServiceProperties

## Description

This function returns properties of the Host Compute System, see [sample code](./ServiceSample.md#GetServiceProperties).

## Syntax

```cpp
HRESULT WINAPI
HcsGetServiceProperties(
    _In_opt_ PCWSTR propertyQuery,
    _Outptr_ PWSTR* result
    );
```

## Parameters

`propertyQuery`

Optional JSON document of [Service_PropertyQuery](./../SchemaReference.md#Service_PropertyQuery) specifying the properties to query.

`result`

On success, receives a JSON document of [ServiceProperties](./../SchemaReference.md#ServiceProperties) with the requested properties.

On failure, it can optionally receive an error JSON document represented by a [ResultError](./../SchemaReference.md#ResultError).


## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Remarks

On success, the result as [ServiceProperties](./../SchemaReference.md#ServiceProperties) JSON document is an array of `"Properties"` of type `Any`. In JSON, `Any` means an arbitrary object with no restrictions. Refer to the following table to know what JSON type HCS expects for each [PropertyType](./../SchemaReference.md#Service_PropertyType).

|`PropertyType`|Property type for `result`|
|---|---|
|`"Basic"`|[BasicInformation](./../SchemaReference.md#BasicInformation)|
|`"Memory"`|HostMemoryQueryRequest(V1 schema), Filter supported|
|`"CpuGroup"`|CpuGroupConfigurations(V1 schema), Filter supported|
|`"ProcessorTopology"`|processorTopology(V1 schema), Filter supported|
|`"CacheAllocation"`|CacheAllocationSystemInfo(V1 schema)|
|`"CacheMonitoring"`|CacheMonitoringSystemInfo(V1 schema)|
|`"ContainerCredentialGuard"`|[ContainerCredentialGuardSystemInfo](./../SchemaReference.md#ContainerCredentialGuardSystemInfo)|
|`"QoSCapabilities"`|[QoSCapabilities](./../SchemaReference.md#QoSCapabilities)|
|`"MemoryBwAllocation"`|MemoryBwAllocationSystemInfo(V1 schema)|

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |