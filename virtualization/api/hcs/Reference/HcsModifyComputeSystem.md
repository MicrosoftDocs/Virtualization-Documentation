---
title: HcsModifyComputeSystem
description: HcsModifyComputeSystem
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsModifyComputeSystem

## Description

Modifies settings of a compute system, see [sample code](./tutorial.md) for simple example.

## Syntax

```cpp
HRESULT WINAPI
HcsModifyComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_ PCWSTR configuration,
    _In_opt_ HANDLE identity
    );
```

## Parameters

`computeSystem`

Handle the compute system to modify.

`operation`

Handle to the operation that tracks the modify operation.

`configuration`

JSON document of [ModifySettingRequest](./../SchemaReference.md#ModifySettingRequest) specifying the settings to modify.

`identity`

Optional handle to an access token that is used when applying the settings.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md).

## Operation Results

The return value of [`HcsWaitForOperationResult`](./HcsWaitForOperationResult.md) or [`HcsGetOperationResult`](./HcsGetOperationResult.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The compute system was modified successfully |

## Remarks

The [ModifySettingRequest](./../SchemaReference.md#ModifySettingRequest) JSON document has a property called `"Settings"` of type `Any`. In JSON, `Any` means an arbitrary object with no restrictions. Refer to the following table to know what JSON type HCS expects for each `"ResourcePath"`.

|`"ResourcePath"`|`"Settings"` Type|Valid `"RequestType"` in [ModifyRequestType](./../SchemaReference.md#ModifyRequestType)|
|---|---|---|
|L"VirtualMachine/ComputeTopology/Processor/CpuGroup"|[CpuGroup](./../SchemaReference.md#CpuGroup)|No Limit|
|L"VirtualMachine/ComputeTopology/Processor/IdledProcessors"|[IdleProcessorsRequest](./../SchemaReference.md#CpuGroup)|Only "Update"|
|L"VirtualMachine/ComputeTopology/Processor/CpuFrequencyPowerCap"|ULONG|No Limit|
|L"VirtualMachine/Devices/FlexibleIov/`<Identifier>`"<br>`Identifier` is expected as uniq name to represent the flexible IOV device|[FlexibleIoDevice](./../SchemaReference.md#FlexibleIoDevice)|Only "Add"|
|L"VirtualMachine/ComputeTopology/Gpu"|[GpuConfiguration](./../SchemaReference.md#GpuConfiguration)|Only "Update"|
|L"VirtualMachine/Devices/MappedPipes/`<Identifier>`"<br>`Identifier` is expected as uniq name to represent the host named pipe to be mapped|`Settings` should be empty|"Add" or "Remove"|
|L"VirtualMachine/ComputeTopology/Memory/SizeInMB"|UINT64, meaning new memory size in MB|No Limit|
|L"VirtualMachine/Devices/NetworkAdapters/`<Identifier`>"<br>`Identifier` is expected as uniq name to represent the network adapter|[NetworkAdapter](./../SchemaReference.md#CpuGroup)|No Limit|
|L"VirtualMachine/Devices/Plan9/Shares"|[Plan9Share](./../SchemaReference.md#Plan9Share)|No Limit|
|L"VirtualMachine/Devices/Scsi/`<Identifier>`/Attachments/`<UnsignedInt>`"<br>`Identifier` is expected as uniq name to represent the scsi device; `UnsignedInt` is expected as the unsigned int value to represent the lun of the disk|[Attachment](./../SchemaReference.md#Attachment)|No Limit<br>`Settings` is ignored when type is "Remove"|
|L"VirtualMachine/Devices/ComPorts/`<UnsignedInt>`"<br>`UnsignedInt` is expected to represent the serial ID which is not larger than 1|[comPort](./../SchemaReference.md#comPort)|No Limit(check c_SerialResourceRegex???)|
|L"VirtualMachine/Devices/SharedMemory/Regions"|[SharedMemoryRegion](./../SchemaReference.md#SharedMemoryRegion)|No Limit|
|L"VirtualMachine/Devices/VirtualPMem/Devices/`<UnsignedInt>`"<br>`UnsignedInt` is expected to represent the number identifier of the VPMEM device|[VirtualPMemDevice](./../SchemaReference.md#VirtualPMemDevice)|"Add" or "Remove"<br>`Settings` is ignored when type is "Remove"|
|L"VirtualMachine/Devices/VirtualPMem/Devices/`<UnsignedInt>`/Mappings/`<UnsignedInt>`"<br>First `UnsignedInt` is expected to represent the number identifier of the VPMEM device; Second `UnsignedInt` is expected to represent the offset indicating which Mapping to modify|[VirtualPMemMapping](./../SchemaReference.md#VirtualPMemMapping)|"Add" or "Remove"<br>`Settings` is ignored when type is "Remove"|
|L"VirtualMachine/Devices/VirtualSmb/Shares"|[VirtualSmbShare](./../SchemaReference.md#VirtualSmbShare)|No Limit|
|L"VirtualMachine/Devices/VirtualPci/" + c_Identifier|[VirtualPciDevice](./../SchemaReference.md#VirtualSmbShare)|"Add" or "Remove"<br>`Settings` is ignored when type is "Remove"|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
