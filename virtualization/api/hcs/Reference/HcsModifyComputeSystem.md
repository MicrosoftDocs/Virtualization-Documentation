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
|L"VirtualMachine/ComputeTopology/Processor/Limits"|[ProcessorLimits](./../SchemaReference.md#ProcessorLimits)(all new members NewIn 2.4???)|No Limit|
|L"VirtualMachine/ComputeTopology/Processor/CpuGroup"|[CpuGroup](./../SchemaReference.md#CpuGroup)|No Limit|
|L"VirtualMachine/ComputeTopology/Processor/IdledProcessors"||Only "Update"|
|L"VirtualMachine/ComputeTopology/Processor/CpuFrequencyPowerCap"|ULONG|No Limit|
|L"VirtualMachine/Devices/FlexibleIov/"(following is Regex???)|[FlexibleIoDevice](./../SchemaReference.md#FlexibleIoDevice)|Only "Add"|
|L"VirtualMachine/ComputeTopology/Gpu"|[GpuConfiguration](./../SchemaReference.md#GpuConfiguration)|Only "Update"|
|L"VirtualMachine/Devices/Licensing"|Licensing(class is referenced as private???)|Only "Update"|
|L"VirtualMachine/Devices/MappedPipes/"(following is Regex???)|NULL(`E_INVALIDARG` if `Settings` is not empty)|"Add" or "Remove"|
|L"VirtualMachine/ComputeTopology/Memory/SizeInMB"|UINT64, meaning new memory size in MB|No Limit|
|L"VirtualMachine/Devices/NetworkAdapters/"(following is Regex???)|[NetworkAdapter](./../SchemaReference.md#CpuGroup)|No Limit|
|L"VirtualMachine/Devices/Plan9/Shares"|[Plan9Share](./../SchemaReference.md#Plan9Share)|No Limit|
|L"VirtualMachine/Devices/Scsi/" + c_Identifier + L"/Attachments/" + c_UnsignedInt(c_UnsignedInt is Regex???)|[Attachment](./../SchemaReference.md#CpuGroup)|No Limit|
|L"VirtualMachine/Devices/ComPorts/" + c_UnsignedInt|[comPort](./../SchemaReference.md#comPort)|No Limit(check c_SerialResourceRegex???)|
|L"VirtualMachine/Devices/SharedMemory/Regions"||No Limit|
|L"VirtualMachine/Devices/VirtualPMem/Devices/" + c_UnsignedInt|[VirtualPMemDevice](./../SchemaReference.md#VirtualPMemDevice)|"Add" or "Remove"|
|L"VirtualMachine/Devices/VirtualPMem/Devices/" + c_UnsignedInt + L"/Mappings/" + c_UnsignedInt|[VirtualPMemMapping(]./../SchemaReference.md#VirtualPMemMapping)|"Add" or "Remove"|
|L"VirtualMachine/Devices/VirtualSmb/Shares"|[VirtualSmbShare](./../SchemaReference.md#VirtualSmbShare)|No Limit|
|L"VirtualMachine/Devices/VirtualPci/" + c_Identifier|[VirtualPciDevice](./../SchemaReference.md#VirtualSmbShare)|"Add" or "Remove"|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
