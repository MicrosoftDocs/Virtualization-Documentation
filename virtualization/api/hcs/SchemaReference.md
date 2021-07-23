---
title: JSON Schema Reference
description: JSON Schema Reference
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: JSON Schema Reference
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# JSON Schema Reference

# Agenda
- [Enums](#enums)
- [Structs](#structs)
- [JSON type table](#JSON-type)
- [Version Map](#Schema-Version-Map)
---
<a name = "enums"></a>
# Enums
Note: all variants listed should be used as string
<a name = "ApplySecureBootTemplateType"></a>
## ApplySecureBootTemplateType
Referenced by: [Uefi](#Uefi)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Skip"`<br>|[2.3](#Schema-Version-Map)||
|`"Apply"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "AttachmentType"></a>
## AttachmentType
Referenced by: [Attachment](#Attachment)



|Variants|NewInVersion|Description|
|---|---|---|
|`"VirtualDisk"`<br>|[2.0](#Schema-Version-Map)||
|`"Iso"`<br>|[2.0](#Schema-Version-Map)||
|`"PassThru"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "CacheMode"></a>
## CacheMode
Referenced by: [Layer](#Layer)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Unspecified"`<br>|[2.0](#Schema-Version-Map)|Use the default caching scheme (typically Enabled).|
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)|Disable caching entirely.|
|`"Enabled"`<br>|[2.0](#Schema-Version-Map)|Enable caching in the system memory partition.|
|`"Private"`<br>|[2.0](#Schema-Version-Map)|Enable caching in the private memory partition.|
|`"PrivateAllowSharing"`<br>|[2.0](#Schema-Version-Map)|Enable caching in the private memory partition, but allow access by other partitions.|

---

<a name = "CachingMode"></a>
## CachingMode
Referenced by: [Attachment](#Attachment)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Uncached"`<br>|[2.1](#Schema-Version-Map)|Use uncached IO to read and write VHD files (default).|
|`"Cached"`<br>|[2.1](#Schema-Version-Map)|Use cached IO for all files.|
|`"ReadOnlyCached"`<br>|[2.1](#Schema-Version-Map)|Use cached IO for all read-only files in the VHD chain, and uncached IO for writable files.|

---

<a name = "ContainerCredentialGuardModifyOperation"></a>
## ContainerCredentialGuardModifyOperation
Referenced by: [ContainerCredentialGuardOperationRequest](#ContainerCredentialGuardOperationRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"AddInstance"`<br>|[2.1](#Schema-Version-Map)|Determines that a Container Credential Guard request operation is trying to add a new Container Credential Guard Instance.|
|`"RemoveInstance"`<br>|[2.1](#Schema-Version-Map)|Determines that a Container Credential Guard request operation is trying to remove an existing running Container Credential Guard Instance.|

---

<a name = "ContainerCredentialGuardTransport"></a>
## ContainerCredentialGuardTransport
Referenced by: [ContainerCredentialGuardAddInstanceRequest](#ContainerCredentialGuardAddInstanceRequest); [ContainerCredentialGuardState](#ContainerCredentialGuardState)



|Variants|NewInVersion|Description|
|---|---|---|
|`"LRPC"`<br>|[2.1](#Schema-Version-Map)|Specifies that the Container Credential Guard transport is configured using Local Remote Procedure calls.|
|`"HvSocket"`<br>|[2.1](#Schema-Version-Map)|Specifies that the Container Credential Guard transport is configured using Remote Procedure calls over HvSocket.|

---

<a name = "CrashType"></a>
## CrashType
Referenced by: [CrashOptions](#CrashOptions)



|Variants|NewInVersion|Description|
|---|---|---|
|`"CrashGuest"`<br>|[2.3](#Schema-Version-Map)|Crash the guest through an architectured defined mechanism|

---

<a name = "DeviceType"></a>
## DeviceType
Referenced by: [Device](#Device)



|Variants|NewInVersion|Description|
|---|---|---|
|`"ClassGuid"`<br>|[2.2](#Schema-Version-Map)||
|`"DeviceInstance"`<br>|[2.2](#Schema-Version-Map)||
|`"GpuMirror"`<br>|[2.2](#Schema-Version-Map)|Make all GPUs on the host visible to the container.|

---

<a name = "EventDataType"></a>
## EventDataType
Referenced by: [EventData](#EventData)

Data types for event data elements, based on EVT_VARIANT_TYPE

|Variants|NewInVersion|Description|
|---|---|---|
|`"Empty"`<br>|[2.1](#Schema-Version-Map)||
|`"String"`<br>|[2.1](#Schema-Version-Map)||
|`"AnsiString"`<br>|[2.1](#Schema-Version-Map)||
|`"SByte"`<br>|[2.1](#Schema-Version-Map)||
|`"Byte"`<br>|[2.1](#Schema-Version-Map)||
|`"Int16"`<br>|[2.1](#Schema-Version-Map)||
|`"UInt16"`<br>|[2.1](#Schema-Version-Map)||
|`"Int32"`<br>|[2.1](#Schema-Version-Map)||
|`"UInt32"`<br>|[2.1](#Schema-Version-Map)||
|`"Int64"`<br>|[2.1](#Schema-Version-Map)||
|`"UInt64"`<br>|[2.1](#Schema-Version-Map)||
|`"Single"`<br>|[2.1](#Schema-Version-Map)||
|`"Double"`<br>|[2.1](#Schema-Version-Map)||
|`"Boolean"`<br>|[2.1](#Schema-Version-Map)||
|`"Binary"`<br>|[2.1](#Schema-Version-Map)||
|`"Guid"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "FilesystemIsolationMode"></a>
## FilesystemIsolationMode
Referenced by: [FilesystemNamespace](#FilesystemNamespace)



|Variants|NewInVersion|Description|
|---|---|---|
|`"hard"`<br>|[2.3](#Schema-Version-Map)||
|`"soft"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "FilesystemNestingMode"></a>
## FilesystemNestingMode
Referenced by: [FilesystemNamespace](#FilesystemNamespace)



|Variants|NewInVersion|Description|
|---|---|---|
|`"inner"`<br>|[2.3](#Schema-Version-Map)||
|`"outer"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "FlexibleIoDeviceHostingModel"></a>
## FlexibleIoDeviceHostingModel
Referenced by: [FlexibleIoDevice](#FlexibleIoDevice)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Internal"`<br>|[2.1](#Schema-Version-Map)||
|`"External"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "GetPropertyType"></a>
## GetPropertyType
Referenced by: [Service_PropertyQuery](#Service_PropertyQuery)

Service property type queried by HcsGetServiceProperties

|Variants|NewInVersion|Description|
|---|---|---|
|`"Basic"`<br>|[2.1](#Schema-Version-Map)|Supported schema versions|
|`"CpuGroup"`<br>|[2.1](#Schema-Version-Map)|Cpu group information|
|`"ProcessorTopology"`<br>|[2.1](#Schema-Version-Map)|Logical processors details|
|`"ContainerCredentialGuard"`<br>|[2.1](#Schema-Version-Map)|Container credential guard Information|
|`"QoSCapabilities"`<br>|[2.1](#Schema-Version-Map)|Query of service capabilities|

---

<a name = "GpuAssignmentMode"></a>
## GpuAssignmentMode
Referenced by: [GpuConfiguration](#GpuConfiguration)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)|Do not assign GPU to the guest.|
|`"Default"`<br>|[2.0](#Schema-Version-Map)|Assign the single default GPU to guest, which currently is POST GPU.|
|`"List"`<br>|[2.0](#Schema-Version-Map)|Assign the GPU(s)/partition(s) specified in AssignmentRequest to guest. If AssignmentRequest is empty, do not assign GPU to the guest.|
|`"Mirror"`<br>|[2.0](#Schema-Version-Map)|Assign all current and future GPUs to guest.|

---

<a name = "InterfaceClassType"></a>
## InterfaceClassType
Referenced by: [InterfaceClass](#InterfaceClass)

Enum used to specify how the interface class should be treated when applying a device extension/creating container symlinks. This enum is ordering-sensitive; if two interface classes with the same identifier are merged, the type of the resulting interface class is given by the larger enum value (e.g., DeviceInstance + ClassGuid = ClassGuid).

|Variants|NewInVersion|Description|
|---|---|---|
|`"Inherit"`<br>|[2.3](#Schema-Version-Map)|Used only in the namespace portion of a device extension (i.e., an interface class that is added to the container definition when a given interface class is specified). This placeholder value will be replaced with the same type as the interface class that caused the device extension to be merged in.|
|`"DeviceInstance"`<br>|[2.3](#Schema-Version-Map)|Represents a single device instance.|
|`"ClassGuid"`<br>|[2.3](#Schema-Version-Map)|Represents all device interfaces of this class GUID on the system.|

---

<a name = "JobTerminationPolicy"></a>
## JobTerminationPolicy
Referenced by: [JobNamespace](#JobNamespace)



|Variants|NewInVersion|Description|
|---|---|---|
|`"PermanentQuiescent"`<br>|[2.3](#Schema-Version-Map)||
|`"KillOnHandleClose"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "MappedPipePathType"></a>
## MappedPipePathType
Referenced by: [MappedPipe](#MappedPipe)



|Variants|NewInVersion|Description|
|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)|The path associated to this path type is an absolute path. The path is passed as-is to Windows APIs.|
|`"VirtualSmbPipeName"`<br>|[2.1](#Schema-Version-Map)|The path associated to this path type is a virtual SMB pipe name. The path is translated to a file system path, relative to the virtual SMB object namespace path, before passed to Windows APIs.|

---

<a name = "MemoryBackingPageSize"></a>
## MemoryBackingPageSize
Referenced by: [VirtualMachine_Memory](#VirtualMachine_Memory)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Small"`<br>|[2.2](#Schema-Version-Map)|Small (4KB) page size unit|
|`"Large"`<br>|[2.2](#Schema-Version-Map)|Large (2MB) page size unit|

---

<a name = "ModifyOperation"></a>
## ModifyOperation
Referenced by: [ProcessModifyRequest](#ProcessModifyRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"ConsoleSize"`<br>|[2.0](#Schema-Version-Map)|Update the console size|
|`"CloseHandle"`<br>|[2.0](#Schema-Version-Map)|Close one or all of the std handles|

---

<a name = "ModifyPropertyType"></a>
## ModifyPropertyType
Referenced by: [ModificationRequest](#ModificationRequest)

Service property type modified by HcsModifyServiceSettings

|Variants|NewInVersion|Description|
|---|---|---|
|`"CpuGroup"`<br>|[2.1](#Schema-Version-Map)|Cpu group information|
|`"ContainerCredentialGuard"`<br>|[2.1](#Schema-Version-Map)|Container credential guard Information|

---

<a name = "ModifyRequestType"></a>
## ModifyRequestType
Referenced by: [GuestModifySettingRequest](#GuestModifySettingRequest); [ModifySettingRequest](#ModifySettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Add"`<br>|[2.0](#Schema-Version-Map)||
|`"Remove"`<br>|[2.0](#Schema-Version-Map)||
|`"Update"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyResourceType"></a>
## ModifyResourceType
Referenced by: [GuestModifySettingRequest](#GuestModifySettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Memory"`<br>|[2.0](#Schema-Version-Map)||
|`"MappedDirectory"`<br>|[2.0](#Schema-Version-Map)||
|`"MappedPipe"`<br>|[2.0](#Schema-Version-Map)||
|`"MappedVirtualDisk"`<br>|[2.0](#Schema-Version-Map)||
|`"CombinedLayers"`<br>|[2.0](#Schema-Version-Map)||
|`"NetworkNamespace"`<br>|[2.1](#Schema-Version-Map)||
|`"CimMount"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "ModifyServiceOperation"></a>
## ModifyServiceOperation
Referenced by: [HostProcessorModificationRequest](#HostProcessorModificationRequest)

Enumeration of different supported service processor modification requests

|Variants|NewInVersion|Description|
|---|---|---|
|`"CreateGroup"`<br>|[2.1](#Schema-Version-Map)||
|`"DeleteGroup"`<br>|[2.1](#Schema-Version-Map)||
|`"SetProperty"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "NotificationType"></a>
## NotificationType
Referenced by: [Properties](#Properties); [SystemExitStatus](#SystemExitStatus)

Exit type of a compute system.

|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.1](#Schema-Version-Map)||
|`"GracefulExit"`<br>|[2.1](#Schema-Version-Map)|The compute system exited cracefully, either by a system initiated shutdown or HcsShutdownComputeSystem.|
|`"ForcedExit"`<br>|[2.1](#Schema-Version-Map)|The compute system was forcefully terminated with HcsTerminateComputeSystem.|
|`"UnexpectedExit"`<br>|[2.1](#Schema-Version-Map)|The compute system exited unexpectedly.|
|`"Unknown"`<br>|[2.1](#Schema-Version-Map)|The compute system exit type could not be determined.|

---

<a name = "ObjectDirectoryShadow"></a>
## ObjectDirectoryShadow
Referenced by: [ObjectDirectory](#ObjectDirectory); [ObjectNamespace](#ObjectNamespace)



|Variants|NewInVersion|Description|
|---|---|---|
|`"false"`<br>|[2.3](#Schema-Version-Map)||
|`"true"`<br>|[2.3](#Schema-Version-Map)||
|`"ifexists"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "ObjectSymlinkScope"></a>
## ObjectSymlinkScope
Referenced by: [ObjectSymlink](#ObjectSymlink)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Local"`<br>|[2.3](#Schema-Version-Map)||
|`"Global"`<br>|[2.3](#Schema-Version-Map)||
|`"GlobalDropSilo"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "OsLayerType"></a>
## OsLayerType
Referenced by: [OsLayerOptions](#OsLayerOptions)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Container"`<br>|[2.1](#Schema-Version-Map)||
|`"Vm"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "OsType"></a>
## OsType
Referenced by: [Properties](#Properties)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Unknown"`<br>|[2.1](#Schema-Version-Map)||
|`"Windows"`<br>|[2.1](#Schema-Version-Map)||
|`"Linux"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "PathType"></a>
## PathType
Referenced by: [Layer](#Layer); [MappedDirectory](#MappedDirectory)



|Variants|NewInVersion|Description|
|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)|The path associated to this path type is an absolute path. The path is passed as-is to windows APIs.|
|`"VirtualSmbShareName"`<br>|[2.1](#Schema-Version-Map)|The path associated to this path type is a virtual SMB share name. The path is translated to a file system path, relative to the virtual SMB object namespace path, before passed to windows APIs.|

---

<a name = "PauseReason"></a>
## PauseReason
Referenced by: [PauseNotification](#PauseNotification)

Pause reason that is indicated to components running in the Virtual Machine.

|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.1](#Schema-Version-Map)||
|`"Save"`<br>|[2.1](#Schema-Version-Map)||
|`"Template"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "PauseSuspensionLevel"></a>
## PauseSuspensionLevel
Referenced by: [PauseOptions](#PauseOptions)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Suspend"`<br>|[2.0](#Schema-Version-Map)||
|`"MemoryLow"`<br>|[2.0](#Schema-Version-Map)||
|`"MemoryMedium"`<br>|[2.0](#Schema-Version-Map)||
|`"MemoryHigh"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "ProcessSignal"></a>
## ProcessSignal
Referenced by: [SignalProcessOptions](#SignalProcessOptions)



|Variants|NewInVersion|Description|
|---|---|---|
|`"CtrlC"`<br>|[2.1](#Schema-Version-Map)||
|`"CtrlBreak"`<br>|[2.1](#Schema-Version-Map)||
|`"CtrlClose"`<br>|[2.1](#Schema-Version-Map)||
|`"CtrlLogOff"`<br>|[2.1](#Schema-Version-Map)||
|`"CtrlShutdown"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "RegistryHive"></a>
## RegistryHive
Referenced by: [RegistryKey](#RegistryKey)



|Variants|NewInVersion|Description|
|---|---|---|
|`"System"`<br>|[2.0](#Schema-Version-Map)||
|`"Software"`<br>|[2.0](#Schema-Version-Map)||
|`"Security"`<br>|[2.0](#Schema-Version-Map)||
|`"Sam"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "RegistryValueType"></a>
## RegistryValueType
Referenced by: [RegistryValue](#RegistryValue)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"String"`<br>|[2.0](#Schema-Version-Map)||
|`"ExpandedString"`<br>|[2.0](#Schema-Version-Map)||
|`"MultiString"`<br>|[2.0](#Schema-Version-Map)||
|`"Binary"`<br>|[2.0](#Schema-Version-Map)||
|`"DWord"`<br>|[2.0](#Schema-Version-Map)||
|`"QWord"`<br>|[2.0](#Schema-Version-Map)||
|`"CustomType"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "SaveType"></a>
## SaveType
Referenced by: [SaveOptions](#SaveOptions)



|Variants|NewInVersion|Description|
|---|---|---|
|`"ToFile"`<br>|[2.1](#Schema-Version-Map)|The system's memory and device states are saved to the runtime state file.|
|`"AsTemplate"`<br>|[2.1](#Schema-Version-Map)|The system's device state is saved to the runtime state file. The system is then placed in a state such that other systems can be cloned from it.|

---

<a name = "SerialConsole"></a>
## SerialConsole
Referenced by: [Uefi](#Uefi)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Default"`<br>|[2.0](#Schema-Version-Map)||
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)||
|`"ComPort1"`<br>|[2.0](#Schema-Version-Map)||
|`"ComPort2"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "State"></a>
## State
Referenced by: [Properties](#Properties)

Compute system state which is exposed to external clients

|Variants|NewInVersion|Description|
|---|---|---|
|`"Created"`<br>|[2.1](#Schema-Version-Map)||
|`"Running"`<br>|[2.1](#Schema-Version-Map)||
|`"Paused"`<br>|[2.1](#Schema-Version-Map)||
|`"Stopped"`<br>|[2.1](#Schema-Version-Map)||
|`"SavedAsTemplate"`<br>|[2.1](#Schema-Version-Map)||
|`"Unknown"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "StdHandle"></a>
## StdHandle
Referenced by: [CloseHandle](#CloseHandle)



|Variants|NewInVersion|Description|
|---|---|---|
|`"StdIn"`<br>|[2.0](#Schema-Version-Map)||
|`"StdOut"`<br>|[2.0](#Schema-Version-Map)||
|`"StdErr"`<br>|[2.0](#Schema-Version-Map)||
|`"All"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "System_PropertyType"></a>
## System_PropertyType
Referenced by: [System_PropertyQuery](#System_PropertyQuery)

Compute system property types. The properties will be returned as a Schema.Responses.System.Properties instance.

|Variants|NewInVersion|Description|
|---|---|---|
|`"Memory"`<br>|[2.1](#Schema-Version-Map)||
|`"Statistics"`<br>|[2.1](#Schema-Version-Map)||
|`"ProcessList"`<br>|[2.1](#Schema-Version-Map)||
|`"TerminateOnLastHandleClosed"`<br>|[2.1](#Schema-Version-Map)||
|`"SharedMemoryRegion"`<br>|[2.1](#Schema-Version-Map)||
|`"GuestConnection"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "SystemType"></a>
## SystemType
Referenced by: [Properties](#Properties); [SystemQuery](#SystemQuery)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Container"`<br>|[2.1](#Schema-Version-Map)||
|`"VirtualMachine"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "UefiBootDevice"></a>
## UefiBootDevice
Referenced by: [UefiBootEntry](#UefiBootEntry)



|Variants|NewInVersion|Description|
|---|---|---|
|`"ScsiDrive"`<br>|[2.0](#Schema-Version-Map)||
|`"VmbFs"`<br>|[2.0](#Schema-Version-Map)||
|`"Network"`<br>|[2.0](#Schema-Version-Map)||
|`"File"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualPMemBackingType"></a>
## VirtualPMemBackingType
Referenced by: [VirtualPMemController](#VirtualPMemController)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Virtual"`<br>|[2.1](#Schema-Version-Map)||
|`"Physical"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualPMemImageFormat"></a>
## VirtualPMemImageFormat
Referenced by: [VirtualPMemDevice](#VirtualPMemDevice); [VirtualPMemMapping](#VirtualPMemMapping)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Vhdx"`<br>|[2.0](#Schema-Version-Map)||
|`"Vhd1"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "WindowsCrashPhase"></a>
## WindowsCrashPhase
Referenced by: [WindowsCrashReport](#WindowsCrashReport)

Indicated the progress of a Windows memory dump in a WindowsCrashReport.

|Variants|NewInVersion|Description|
|---|---|---|
|`"Inactive"`<br>|[2.1](#Schema-Version-Map)|A memory dump was not active.|
|`"CrashValues"`<br>|[2.1](#Schema-Version-Map)|Crash values have been reported through CrashParameters.|
|`"Starting"`<br>|[2.1](#Schema-Version-Map)|A memory dump is in the process of starting.|
|`"Started"`<br>|[2.1](#Schema-Version-Map)|A memory dump has been initialized.|
|`"Writing"`<br>|[2.1](#Schema-Version-Map)|Memory dump data is being written.|
|`"Complete"`<br>|[2.1](#Schema-Version-Map)|Memory dump was successfully written.|

---

<a name = "structs"></a>
# Structs
<a name = "Attachment"></a>
## Attachment
Referenced by: [Scsi](#Scsi)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[AttachmentType](#AttachmentType)|[2.0](#Schema-Version-Map)||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CachingMode**<br>|[CachingMode](#CachingMode)|[2.1](#Schema-Version-Map)||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SupportCompressedVolumes**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "AttributionRecord"></a>
## AttributionRecord



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "BasicInformation"></a>
## BasicInformation
Basic information

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|[2.1](#Schema-Version-Map)|The supported schema versions will be returned as an array. Array element A.X implies all versions with major version A and minor version from 0 to X are also supported.|

---

<a name = "Battery"></a>
## Battery
Referenced by: [Devices](#Devices)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "Chipset"></a>
## Chipset
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Uefi**<br>|[Uefi](#Uefi)|[2.0](#Schema-Version-Map)||
|**IsNumLockDisabled**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**BaseBoardSerialNumber**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ChassisSerialNumber**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ChassisAssetTag**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**UseUtc**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**LinuxKernelDirect**<br>|[LinuxKernelDirect](#LinuxKernelDirect)|[2.2](#Schema-Version-Map)||

---

<a name = "CimMount"></a>
## CimMount


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ImagePath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**FileSystemName**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**VolumeGuid**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "CloseHandle"></a>
## CloseHandle
Referenced by: [ProcessModifyRequest](#ProcessModifyRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Handle**<br>|[StdHandle](#StdHandle)|[2.0](#Schema-Version-Map)||

---

<a name = "CombinedLayers"></a>
## CombinedLayers
Object used by a modify request to add or remove a combined layers structure in the guest. For Windows, the GCS applies a filter in ContainerRootPath using the specified layers as the parent content. Ignores property ScratchPath since the container path is already the scratch path. For linux, the GCS unions the specified layers and ScratchPath together, placing the resulting union filesystem at ContainerRootPath.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)|Layer hierarchy to be combined.|
|**ScratchPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ContainerRootPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ComPort"></a>
## ComPort
Referenced by: [Devices](#Devices)

ComPort specifies the named pipe that will be used for the port, with empty string indicating a disconnected port.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NamedPipe**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**OptimizeForDebugger**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ComputeSystem"></a>
## ComputeSystem
Describes the configuration of a compute system to create with all of the necessary resources it requires for a successful boot.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|A string identifying the owning client for this system.|
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|A version structure for this schema. Properties nested within this object may identify their own schema versions.|
|**HostingSystemId**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|The identifier of the compute system that will host the system described by HostedSystem. The hosting system must already have been created.|
|**HostedSystem**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)|The JSON describing the compute system that will be launched inside of the system identified by HostingSystemId. This property is mutually exclusive with the Container and VirtualMachine properties.|
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)|The set of properties defining a container. This property is mutualy exclusive with the HostedSystem and VirtualMachine properties.|
|**VirtualMachine**<br>|[VirtualMachine](#VirtualMachine)|[2.0](#Schema-Version-Map)|The set of properties defining a virtual machine. This property is mutually exclusive with the HostedSystem and Container properties.|
|**ShouldTerminateOnLastHandleClosed**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|If true, this system will be forcibly terminated when the last HCS_SYSTEM handle corresponding to it is closed.|

---

<a name = "ConsoleSize"></a>
## ConsoleSize
Referenced by: [ProcessModifyRequest](#ProcessModifyRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Height**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Width**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Container"></a>
## Container
Referenced by: [ComputeSystem](#ComputeSystem); [HostedSystem](#HostedSystem)

Configuration of a Windows Server Container, used during its creation to set up and/or use resources.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GuestOs**<br>|[GuestOs](#GuestOs)|[2.0](#Schema-Version-Map)|Properties specific to the guest operating system that runs on the container.|
|**Storage**<br>|[Storage](#Storage)|[2.0](#Schema-Version-Map)|Storage configuration of a container.|
|**MappedDirectories**<br>|<[MappedDirectory](#MappedDirectory)> array|[2.0](#Schema-Version-Map)|Optional list of directories in the container host that will be mapped to the container guest on creation.|
|**MappedPipes**<br>|<[MappedPipe](#MappedPipe)> array|[2.0](#Schema-Version-Map)|Optional list of named pipes in the container host that will be mapped to the container guest on creation.|
|**Memory**<br>|[Container_Memory](#Container_Memory)|[2.0](#Schema-Version-Map)|Optional memory configuration of a container.|
|**Processor**<br>|[Container_Processor](#Container_Processor)|[2.0](#Schema-Version-Map)|Optional processor configuration of a container.|
|**Networking**<br>|[Networking](#Networking)|[2.0](#Schema-Version-Map)|Network configuration of a container.|
|**HvSocket**<br>|[Container_HvSocket](#Container_HvSocket)|[2.0](#Schema-Version-Map)|HvSocket configuration of a container. Used to configure ACLs to control what host process can connect\bind to the container. Hosted container ACLs are inherited from the hosting system.|
|**ContainerCredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)|Optional configuration and description of credentials forwarded to the container guest from the container host.|
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)|List of Windows registry key/value changes applied on the container on creation.|
|**AssignedDevices**<br>|<[Device](#Device)> array|[2.1](#Schema-Version-Map)|Optional list of direct device assignment configurations.|

---

<a name = "Container_HvSocket"></a>
## Container_HvSocket
Referenced by: [Container](#Container)

Describes the HvSocket configuration and options for a container.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Config**<br>|[HvSocketSystemConfig](#HvSocketSystemConfig)|[2.0](#Schema-Version-Map)|Optional detailed HvSocket configuration.|
|**EnablePowerShellDirect**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|When true, enables Powershell Direct service in the guest to allow it to use the HvSocket transport.|

---

<a name = "Container_Memory"></a>
## Container_Memory
Referenced by: [Container](#Container)

Describes memory configuration for a container.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SizeInMB**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)|Specifies the memory size in megabytes.|

---

<a name = "Container_Processor"></a>
## Container_Processor
Referenced by: [Container](#Container)

Specifies CPU limits for a container. Count, Maximum and Weight are all mutually exclusive.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Count**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|Optional property that represents the fraction of the configured processor count in a container in relation to the processors available in the host. The fraction ultimately determines the portion of processor cycles that the threads in a container can use during each scheduling interval, as the number of cycles per 10,000 cycles.|
|**Weight**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)|Optional property that limits the share of processor time given to the container relative to other workloads on the processor. The processor weight is a value between 0 and 10000.|
|**Maximum**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)|Optional property that determines the portion of processor cycles that the threads in a container can use during each scheduling interval, as the number of cycles per 10,000 cycles. Set processor maximum to a percentage times 100.|

---

<a name = "ContainerCredentialGuardAddInstanceRequest"></a>
## ContainerCredentialGuardAddInstanceRequest
Object describing a request to add a Container Credential Guard Instance.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Globally unique identifier to use for the Container Credential Guard Instance.|
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|JSON document as a string that describes the Container Credential Guard Instance's credential specification to use.|
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)|Specifies the transport the Container Credential Guard Instance will use at runtime.|

---

<a name = "ContainerCredentialGuardHvSocketServiceConfig"></a>
## ContainerCredentialGuardHvSocketServiceConfig
Referenced by: [ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)

Specifies the HvSocket configurations required for a Container Credential Guard instance that is meant to be used with HvSocket transport.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ServiceId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|Identifier of the service that needs to be configured over HvSocket.|
|**ServiceConfig**<br>|[HvSocketServiceConfig](#HvSocketServiceConfig)|[2.1](#Schema-Version-Map)|Necessary HvSocket settings that allow a Container Credential Guard instance to configure a transport using Remote Procedure Calls over HvSocket.|

---

<a name = "ContainerCredentialGuardInstance"></a>
## ContainerCredentialGuardInstance
Referenced by: [ContainerCredentialGuardSystemInfo](#ContainerCredentialGuardSystemInfo)

Describes the configuration of a running Container Credential Guard Instance.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Identifier of a Container Credential Guard Instance, globally unique.|
|**CredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)|Object that describes the state of a running Container Credential Guard Instance.|
|**HvSocketConfig**<br>|[ContainerCredentialGuardHvSocketServiceConfig](#ContainerCredentialGuardHvSocketServiceConfig)|[2.1](#Schema-Version-Map)|Optional HvSocket configuration to allow a Container Credential Guard Instance to communicate over an HvSocket transport.|

---

<a name = "ContainerCredentialGuardOperationRequest"></a>
## ContainerCredentialGuardOperationRequest
Object describing a Container Credential Guard system request.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Operation**<br>|[ContainerCredentialGuardModifyOperation](#ContainerCredentialGuardModifyOperation)|[2.1](#Schema-Version-Map)|Determines the type of Container Credential Guard request.|
|**OperationDetails**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)|Object describing the input properties used by the specified operation type.|

---

<a name = "ContainerCredentialGuardRemoveInstanceRequest"></a>
## ContainerCredentialGuardRemoveInstanceRequest
Object describing a request to remove a running Container Credential Guard Instance.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Globally unique identifier of a running Container Credential Guard Instance.|

---

<a name = "ContainerCredentialGuardState"></a>
## ContainerCredentialGuardState
Referenced by: [Container](#Container); [ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Cookie**<br>|[string_binary](#JSON-type)|[2.1](#Schema-Version-Map)|Authentication cookie for calls to a Container Credential Guard instance.|
|**RpcEndpoint**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Name of the RPC endpoint of the Container Credential Guard instance.|
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)|Transport used for the configured Container Credential Guard instance.|
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Credential spec used for the configured Container Credential Guard instance.|

---

<a name = "ContainerCredentialGuardSystemInfo"></a>
## ContainerCredentialGuardSystemInfo
Object listing the system's running Container Credential Guard Instances.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Instances**<br>|<[ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)> array|[2.1](#Schema-Version-Map)|Array of running Container Credential Guard Instances.|

---

<a name = "ContainersDef_BatchedBinding"></a>
## ContainersDef_BatchedBinding
Referenced by: [FilesystemNamespace](#FilesystemNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**filepath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**bindingroots**<br>|<[string](#JSON-type)> array|[2.3](#Schema-Version-Map)||

---

<a name = "ContainersDef_Container"></a>
## ContainersDef_Container


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**namespace**<br>|[Namespace](#Namespace)|[2.3](#Schema-Version-Map)||

---

<a name = "ContainersDef_Device"></a>
## ContainersDef_Device


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**device_extension**<br>|<[DeviceExtension](#DeviceExtension)> array|[2.3](#Schema-Version-Map)||

---

<a name = "CpuGroup"></a>
## CpuGroup
CPU groups allow Hyper-V administrators to better manage and allocate the host's CPU resources across guest virtual machines

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "CpuGroupAffinity"></a>
## CpuGroupAffinity
Referenced by: [CpuGroupConfig](#CpuGroupConfig)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LogicalProcessorCount**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**LogicalProcessors**<br>|<[uint32](#JSON-type)> array|[2.1](#Schema-Version-Map)||

---

<a name = "CpuGroupConfig"></a>
## CpuGroupConfig
Referenced by: [CpuGroupConfigurations](#CpuGroupConfigurations)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GroupId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Affinity**<br>|[CpuGroupAffinity](#CpuGroupAffinity)|[2.1](#Schema-Version-Map)||
|**GroupProperties**<br>|<[CpuGroupProperty](#CpuGroupProperty)> array|[2.1](#Schema-Version-Map)||

---

<a name = "CpuGroupConfigurations"></a>
## CpuGroupConfigurations
Structure used to return cpu groups for a Service property query

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**CpuGroups**<br>|<[CpuGroupConfig](#CpuGroupConfig)> array|[2.1](#Schema-Version-Map)||

---

<a name = "CpuGroupProperty"></a>
## CpuGroupProperty
Referenced by: [CpuGroupConfig](#CpuGroupConfig)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyCode**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**PropertyValue**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "CrashOptions"></a>
## CrashOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[CrashType](#CrashType)|[2.3](#Schema-Version-Map)||

---

<a name = "CrashReport"></a>
## CrashReport
Crash information reported through HcsEventSystemCrashInitiated and HcsEventSystemCrashReport notifications. This object is also used as the input to HcsSubmitWerReport.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SystemId**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Compute system id the CrashReport is for.|
|**ActivityId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|Trace correlation activity Id.|
|**WindowsCrashInfo**<br>|[WindowsCrashReport](#WindowsCrashReport)|[2.1](#Schema-Version-Map)|Additional Windows specific crash report information. This information is only present in HcsEventSystemCrashReport and only if the GuestCrashReporting device has been configured in the Devices as well as the Windows guest OS.|
|**CrashParameters**<br>|<[uint64](#JSON-type)> array|[2.3](#Schema-Version-Map)|Crash parameters as reported by the guest OS. For Windows these correspond to the bug check code followed by 4 bug check code specific values. The CrashParameters are available in both HcsEventSystemCrashInitiated and HcsEventSystemCrashReport events.|
|**CrashLog**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)|An optional string provided by the guest OS. Currently only used by Linux guest OSes with Hyper-V Linux Integration Services configured.|

---

<a name = "CreateGroupOperation"></a>
## CreateGroupOperation
Create group operation settings

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GroupId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**LogicalProcessorCount**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**LogicalProcessors**<br>|<[uint32](#JSON-type)> array|[2.1](#Schema-Version-Map)||

---

<a name = "DeleteGroupOperation"></a>
## DeleteGroupOperation
Delete group operation settings

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GroupId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "Device"></a>
## Device
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[DeviceType](#DeviceType)|[2.2](#Schema-Version-Map)|The type of device to assign to the container.|
|**InterfaceClassGuid**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|The interface class guid of the device interfaces to assign to the container. Only used when Type is ClassGuid.|
|**LocationPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|The location path of the device to assign to the container. Only used when Type is DeviceInstance.|

---

<a name = "DeviceCategory"></a>
## DeviceCategory
Referenced by: [DeviceExtension](#DeviceExtension); [DeviceNamespace](#DeviceNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**interface_class**<br>|<[InterfaceClass](#InterfaceClass)> array|[2.3](#Schema-Version-Map)||

---

<a name = "DeviceExtension"></a>
## DeviceExtension
Referenced by: [ContainersDef_Device](#ContainersDef_Device)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**device_category**<br>|[DeviceCategory](#DeviceCategory)|[2.3](#Schema-Version-Map)||
|**namespace**<br>|[Namespace](#Namespace)|[2.3](#Schema-Version-Map)||

---

<a name = "DeviceInstance"></a>
## DeviceInstance
Referenced by: [DeviceNamespace](#DeviceNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**id**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**location_path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**port_name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**interface_class**<br>|<[InterfaceClass](#InterfaceClass)> array|[2.3](#Schema-Version-Map)||

---

<a name = "DeviceNamespace"></a>
## DeviceNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**requires_driverstore**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**device_category**<br>|<[DeviceCategory](#DeviceCategory)> array|[2.3](#Schema-Version-Map)||
|**device_instance**<br>|<[DeviceInstance](#DeviceInstance)> array|[2.3](#Schema-Version-Map)||

---

<a name = "Devices"></a>
## Devices
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ComPorts**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [ComPort](#ComPort)>|[2.1](#Schema-Version-Map)|An optional object that maps COM Port objects for any ports configured on the virtual machine. The key in the map is the integer, starting from zero, that will identify the COM port into the guest.|
|**VirtioSerial**<br>|[VirtioSerial](#VirtioSerial)|[2.2](#Schema-Version-Map)||
|**Scsi**<br>|[Map](#JSON-type)<[string](#JSON-type), [Scsi](#Scsi)>|[2.0](#Schema-Version-Map)|An optional object that maps SCSI controllers, identified by friendly name. The provided name is hashed to create the controller's channel instance identifier. If the name is already a GUID, that GUID will be used as the channel instance identifier as-is.|
|**VirtualPMem**<br>|[VirtualPMemController](#VirtualPMemController)|[2.0](#Schema-Version-Map)|An optional object defining the settings for virtual persistent memory.|
|**NetworkAdapters**<br>|[Map](#JSON-type)<[string](#JSON-type), [NetworkAdapter](#NetworkAdapter)>|[2.0](#Schema-Version-Map)|An optional object that maps network adapters, identified by friendly name. The provided name is hashed to create the adapter's instance identifier. If the name is already a GUID, that GUID will be used as the identifier as-is.|
|**VideoMonitor**<br>|[VideoMonitor](#VideoMonitor)|[2.0](#Schema-Version-Map)|An optional object describing the video monitor device.|
|**Keyboard**<br>|[Keyboard](#Keyboard)|[2.0](#Schema-Version-Map)|An optional object describing the keyboard device.|
|**Mouse**<br>|[Mouse](#Mouse)|[2.0](#Schema-Version-Map)|An optional object describing the mouse device.|
|**HvSocket**<br>|[VirtualMachine_HvSocket](#VirtualMachine_HvSocket)|[2.1](#Schema-Version-Map)|An optional object describing socket services exposed to the virtual machine.|
|**EnhancedModeVideo**<br>|[EnhancedModeVideo](#EnhancedModeVideo)|[2.1](#Schema-Version-Map)|An optional object describing the configuration of enhanced-mode video, including connection configuration.|
|**GuestCrashReporting**<br>|[GuestCrashReporting](#GuestCrashReporting)|[2.0](#Schema-Version-Map)|An optional object defining settings for how guest crashes should be captured for later analysis.|
|**VirtualSmb**<br>|[VirtualSmb](#VirtualSmb)|[2.0](#Schema-Version-Map)|An optional object describing any virtual SMB shares to be exposed to the guest OS.|
|**Plan9**<br>|[Plan9](#Plan9)|[2.0](#Schema-Version-Map)|An optional object describing any Plan9 shares to be exposed to the guest OS.|
|**Battery**<br>|[Battery](#Battery)|[2.0](#Schema-Version-Map)|An optional battery device that will forward host battery state to the guest OS.|
|**FlexibleIov**<br>|[Map](#JSON-type)<[string](#JSON-type), [FlexibleIoDevice](#FlexibleIoDevice)>|[2.1](#Schema-Version-Map)|An optional object that maps flexible IoV devices, identified by friendly name. The provided name is hashed to create the device's instance identifier. If the name is already a GUID, that GUID will be used as the identifier as-is.|
|**SharedMemory**<br>|[SharedMemoryConfiguration](#SharedMemoryConfiguration)|[2.1](#Schema-Version-Map)|An optional object describing any shared memory settings for the virtual machine.|
|**VirtualPci**<br>|[Map](#JSON-type)<[string](#JSON-type), [VirtualPciDevice](#VirtualPciDevice)>|[2.3](#Schema-Version-Map)||

---

<a name = "DownlevelFixups"></a>
## DownlevelFixups
Referenced by: [DownlevelSku](#DownlevelSku)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**build_number**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||
|**lcu**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||
|**file**<br>|<[string](#JSON-type)> array|[2.3](#Schema-Version-Map)||

---

<a name = "DownlevelNamespace"></a>
## DownlevelNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**base_image_path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**sandbox_path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**sku**<br>|<[DownlevelSku](#DownlevelSku)> array|[2.3](#Schema-Version-Map)||

---

<a name = "DownlevelSku"></a>
## DownlevelSku
Referenced by: [DownlevelNamespace](#DownlevelNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**fixups**<br>|<[DownlevelFixups](#DownlevelFixups)> array|[2.3](#Schema-Version-Map)||

---

<a name = "EnhancedModeVideo"></a>
## EnhancedModeVideo
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ConnectionOptions**<br>|[RdpConnectionOptions](#RdpConnectionOptions)|[2.1](#Schema-Version-Map)||

---

<a name = "ErrorEvent"></a>
## ErrorEvent
Error descriptor that provides the info of an error object

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Message**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Fully formated error message|
|**StackTrace**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Stack trace in string form|
|**Provider**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|Event definition|
|**EventId**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)|Event Id|
|**Flags**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Flags|
|**Source**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Source|
|**Data**<br>|<[EventData](#EventData)> array|[2.1](#Schema-Version-Map)|Event data|

---

<a name = "EventData"></a>
## EventData
Referenced by: [ErrorEvent](#ErrorEvent)

Event data element

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[EventDataType](#EventDataType)|[2.1](#Schema-Version-Map)|Event data type|
|**Value**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Event value|

---

<a name = "ExportLayerOptions"></a>
## ExportLayerOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IsWritableLayer**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "FilesystemLayer"></a>
## FilesystemLayer
Referenced by: [FilesystemNamespace](#FilesystemNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**identifier**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)||
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "FilesystemNamespace"></a>
## FilesystemNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**isolation**<br>|[FilesystemIsolationMode](#FilesystemIsolationMode)|[2.3](#Schema-Version-Map)||
|**nesting**<br>|[FilesystemNestingMode](#FilesystemNestingMode)|[2.3](#Schema-Version-Map)||
|**layer**<br>|<[FilesystemLayer](#FilesystemLayer)> array|[2.3](#Schema-Version-Map)||
|**bindings**<br>|<[ContainersDef_BatchedBinding](#ContainersDef_BatchedBinding)> array|[2.3](#Schema-Version-Map)||

---

<a name = "FlexibleIoDevice"></a>
## FlexibleIoDevice
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EmulatorId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**HostingModel**<br>|[FlexibleIoDeviceHostingModel](#FlexibleIoDeviceHostingModel)|[2.1](#Schema-Version-Map)||
|**Configuration**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)||

---

<a name = "GpuConfiguration"></a>
## GpuConfiguration


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**AssignmentMode**<br>|[GpuAssignmentMode](#GpuAssignmentMode)|[2.0](#Schema-Version-Map)|The mode used to assign GPUs to the guest.|
|**AssignmentRequest**<br>|[Map](#JSON-type)<[string](#JSON-type), [uint16](#JSON-type)>|[2.0](#Schema-Version-Map)|This only applies to List mode, and is ignored in other modes. In GPU-P, string is GPU device interface, and unit16 is partition id. HCS simply assigns the partition with the input id. In GPU-PV, string is GPU device interface, and unit16 is 0xffff. HCS needs to find an available partition to assign.|
|**AllowVendorExtension**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|Whether we allow vendor extension.|

---

<a name = "GuestConnection"></a>
## GuestConnection
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**UseVsock**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|When true, use Vsock rather than Hyper-V sockets to communicate with the guest service.|
|**UseConnectedSuspend**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|When true, don't disconnect the guest connection when pausing the virtual machine.|

---

<a name = "GuestConnectionInfo"></a>
## GuestConnectionInfo
Referenced by: [Properties](#Properties)

Information about the guest.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|[2.1](#Schema-Version-Map)|Each schema version x.y stands for the range of versions a.b where a==x and b<=y. This list comes from the SupportedSchemaVersions field in GcsCapabilities.|
|**ProtocolVersion**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**GuestDefinedCapabilities**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "GuestCrash"></a>
## GuestCrash



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "GuestCrashReporting"></a>
## GuestCrashReporting
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**WindowsCrashSettings**<br>|[WindowsCrashReporting](#WindowsCrashReporting)|[2.0](#Schema-Version-Map)||

---

<a name = "GuestModifySettingRequest"></a>
## GuestModifySettingRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceType**<br>|[ModifyResourceType](#ModifyResourceType)|[2.1](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.1](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "GuestOs"></a>
## GuestOs
Referenced by: [Container](#Container)

Properties of the guest operating system that boots on a Windows Server Container.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|HostName assigned to a container guest operating system.|

---

<a name = "GuestState"></a>
## GuestState
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GuestStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|The path to an existing file uses for persistent guest state storage. An empty string indicates the system should initialize new transient, in-memory guest state.|
|**RuntimeStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|The path to an existing file for persistent runtime state storage. An empty string indicates the system should initialize new transient, in-memory runtime state.|
|**ForceTransientState**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|If true, the guest state and runtime state files will be used as templates to populate transient, in-memory state instead of using the files as persistent backing store.|

---

<a name = "Heartbeat"></a>
## Heartbeat



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "HostedSystem"></a>
## HostedSystem
Describes the configuration of a container compute system hosted by another compute system. This can have its own schema version since the hosted system could support different versions compared to the host machine.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|A version structure for this schema. Properties nested within this object may identify their own schema versions.|
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)|The set of properties defining a container.|

---

<a name = "HostFiles"></a>
## HostFiles
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**base_image_path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**sandbox_path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**file**<br>|<[string](#JSON-type)> array|[2.3](#Schema-Version-Map)||
|**optionalfile**<br>|<[string](#JSON-type)> array|[2.3](#Schema-Version-Map)||

---

<a name = "HostProcessorModificationRequest"></a>
## HostProcessorModificationRequest
Structure used to request a service processor modification

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Operation**<br>|[ModifyServiceOperation](#ModifyServiceOperation)|[2.1](#Schema-Version-Map)||
|**OperationDetails**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "HvSocketAddress"></a>
## HvSocketAddress
This class defines address settings applied to a VM by the GCS every time a VM starts or restores.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LocalAddress**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ParentAddress**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "HvSocketServiceConfig"></a>
## HvSocketServiceConfig
Referenced by: [ContainerCredentialGuardHvSocketServiceConfig](#ContainerCredentialGuardHvSocketServiceConfig); [HvSocketSystemConfig](#HvSocketSystemConfig)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**BindSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|SDDL string that HvSocket will check before allowing a host process to bind to this specific service. If not specified, defaults to the system DefaultBindSecurityDescriptor, defined in HvSocketSystemWpConfig in V1.|
|**ConnectSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|SDDL string that HvSocket will check before allowing a host process to connect to this specific service. If not specified, defaults to the system DefaultConnectSecurityDescriptor, defined in HvSocketSystemWpConfig in V1.|
|**AllowWildcardBinds**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|If true, HvSocket will process wildcard binds for this service/system combination. Wildcard binds are secured in the registry at SOFTWARE/Microsoft/Windows NT/CurrentVersion/Virtualization/HvSocket/WildcardDescriptors|

---

<a name = "HvSocketSystemConfig"></a>
## HvSocketSystemConfig
Referenced by: [Container_HvSocket](#Container_HvSocket); [VirtualMachine_HvSocket](#VirtualMachine_HvSocket)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DefaultBindSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|SDDL string that HvSocket will check before allowing a host process to bind to an unlisted service for this specific container/VM (not wildcard binds).|
|**DefaultConnectSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|SDDL string that HvSocket will check before allowing a host process to connect to an unlisted service in the VM/container.|
|**ServiceTable**<br>|[Map](#JSON-type)<Guid, [HvSocketServiceConfig](#HvSocketServiceConfig)>|[2.0](#Schema-Version-Map)||

---

<a name = "IdleProcessorsRequest"></a>
## IdleProcessorsRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IdleProcessorCount**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "InjectNonMaskableInterrupt"></a>
## InjectNonMaskableInterrupt
A non-maskable interrupt (NMI) was inject by the host management client or other tool.


**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "IntegrationComponentStatus"></a>
## IntegrationComponentStatus



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "InterfaceClass"></a>
## InterfaceClass
Referenced by: [DeviceCategory](#DeviceCategory); [DeviceInstance](#DeviceInstance)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**type**<br>|[InterfaceClassType](#InterfaceClassType)|[2.3](#Schema-Version-Map)||
|**identifier**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)||
|**recurse**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "IovSettings"></a>
## IovSettings



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "JobCpu"></a>
## JobCpu
Referenced by: [JobNamespace](#JobNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**rate**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||
|**weight**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "JobMemory"></a>
## JobMemory
Referenced by: [JobNamespace](#JobNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**limit**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "JobNamespace"></a>
## JobNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**cpu**<br>|[JobCpu](#JobCpu)|[2.3](#Schema-Version-Map)||
|**memory**<br>|[JobMemory](#JobMemory)|[2.3](#Schema-Version-Map)||
|**systemroot**<br>|[JobSystemRoot](#JobSystemRoot)|[2.3](#Schema-Version-Map)||
|**terminationpolicy**<br>|[JobTerminationPolicy](#JobTerminationPolicy)|[2.3](#Schema-Version-Map)||
|**threadimpersonation**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "JobSystemRoot"></a>
## JobSystemRoot
Referenced by: [JobNamespace](#JobNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "Keyboard"></a>
## Keyboard
Referenced by: [Devices](#Devices)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "Layer"></a>
## Layer
Referenced by: [CombinedLayers](#CombinedLayers); [LayerData](#LayerData); [Storage](#Storage)

Describe the parent hierarchy for a container's storage

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)|Identifier for a layer.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Root path of the layer.|
|**PathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)|Defines how to interpret the layer's path.|
|**Cache**<br>|[CacheMode](#CacheMode)|[2.0](#Schema-Version-Map)|Unspecified defaults to Enabled|

---

<a name = "LayerData"></a>
## LayerData


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.1](#Schema-Version-Map)||
|**Layers**<br>|<[Layer](#Layer)> array|[2.1](#Schema-Version-Map)||

---

<a name = "LinuxKernelDirect"></a>
## LinuxKernelDirect
Referenced by: [Chipset](#Chipset)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**KernelFilePath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||
|**InitRdPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||
|**KernelCmdLine**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||

---

<a name = "LogicalProcessor"></a>
## LogicalProcessor
Referenced by: [ProcessorTopology](#ProcessorTopology)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LpIndex**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**NodeNumber**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)||
|**PackageId**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**CoreId**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RootVpIndex**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "MappedDirectory"></a>
## MappedDirectory
Referenced by: [Container](#Container)

Object that describes a directory in the host that is requested to be mapped into a compute system's guest.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Path in the host that is going to be mapped into the compute system.|
|**HostPathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)|Defines how to interpret the host path.|
|**ContainerPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Path relative to the compute system's guest. This is the resulting path from mapping the host path.|
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|When set to true, the mapped directory in the compute system's guest will be read-only.|
|**SupportCloudFiles**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)|When set to true, the mapped directory in the compute system's guest will support cloud files.|

---

<a name = "MappedPipe"></a>
## MappedPipe
Referenced by: [Container](#Container)

Object that describes a named pipe that is requested to be mapped into a compute system's guest.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ContainerPipeName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|The resulting named pipe that will be accessible in the compute system's guest.|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|The named pipe path in the host that will be mapped into a compute system's guest.|
|**HostPathType**<br>|[MappedPipePathType](#MappedPipePathType)|[2.1](#Schema-Version-Map)|Defines how to interpret the host path.|

---

<a name = "MappedVirtualDisk"></a>
## MappedVirtualDisk


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ContainerPath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Lun**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "MemoryInformationForVm"></a>
## MemoryInformationForVm
Referenced by: [Properties](#Properties)

The response of memory information for virtual machine when query memory propery of compute system

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**VirtualNodeCount**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)||
|**VirtualMachineMemory**<br>|[VmMemory](#VmMemory)|[2.1](#Schema-Version-Map)||
|**VirtualNodes**<br>|<[VirtualNodeInfo](#VirtualNodeInfo)> array|[2.1](#Schema-Version-Map)||

---

<a name = "MemoryStats"></a>
## MemoryStats
Referenced by: [Statistics](#Statistics)

Memory runtime statistics

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MemoryUsageCommitBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryUsageCommitPeakBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryUsagePrivateWorkingSetBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ModificationRequest"></a>
## ModificationRequest
Structure used for service level modification request. Right now, we support modification of a single property type in a call.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyType**<br>|[ModifyPropertyType](#ModifyPropertyType)|[2.1](#Schema-Version-Map)|Specifies the property to be modified|
|**Settings**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)|Settings to the modification request|

---

<a name = "ModifySettingRequest"></a>
## ModifySettingRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourcePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**GuestRequest**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "MountManagerMountPoint"></a>
## MountManagerMountPoint
Referenced by: [MountManagerNamespace](#MountManagerNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "MountManagerNamespace"></a>
## MountManagerNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**mount_point**<br>|<[MountManagerMountPoint](#MountManagerMountPoint)> array|[2.3](#Schema-Version-Map)||

---

<a name = "Mouse"></a>
## Mouse
Referenced by: [Devices](#Devices)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "NamedPipeNamespace"></a>
## NamedPipeNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**symlink**<br>|<[NamedPipeSymlink](#NamedPipeSymlink)> array|[2.3](#Schema-Version-Map)||

---

<a name = "NamedPipeSymlink"></a>
## NamedPipeSymlink
Referenced by: [NamedPipeNamespace](#NamedPipeNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "Namespace"></a>
## Namespace
Referenced by: [ContainersDef_Container](#ContainersDef_Container); [DeviceExtension](#DeviceExtension)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**job**<br>|[JobNamespace](#JobNamespace)|[2.3](#Schema-Version-Map)||
|**filesystem**<br>|[FilesystemNamespace](#FilesystemNamespace)|[2.3](#Schema-Version-Map)||
|**mountmgr**<br>|[MountManagerNamespace](#MountManagerNamespace)|[2.3](#Schema-Version-Map)||
|**namedpipe**<br>|[NamedPipeNamespace](#NamedPipeNamespace)|[2.3](#Schema-Version-Map)||
|**ob**<br>|[ObjectNamespace](#ObjectNamespace)|[2.3](#Schema-Version-Map)||
|**registry**<br>|[RegistryNamespace](#RegistryNamespace)|[2.3](#Schema-Version-Map)||
|**network**<br>|[NetworkNamespace](#NetworkNamespace)|[2.3](#Schema-Version-Map)||
|**device**<br>|[DeviceNamespace](#DeviceNamespace)|[2.3](#Schema-Version-Map)||
|**downlevel**<br>|[DownlevelNamespace](#DownlevelNamespace)|[2.3](#Schema-Version-Map)||
|**hostfiles**<br>|[HostFiles](#HostFiles)|[2.3](#Schema-Version-Map)||

---

<a name = "NetworkAdapter"></a>
## NetworkAdapter
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EndpointId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**MacAddress**<br>|[MacAddress](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Networking"></a>
## Networking
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**AllowUnqualifiedDnsQuery**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DnsSearchList**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NetworkSharedContainerName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Namespace**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Guid in windows; string in linux|
|**NetworkAdapters**<br>|<[Guid](#JSON-type)> array|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkNamespace"></a>
## NetworkNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**compartment**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "ObjectDirectory"></a>
## ObjectDirectory
Referenced by: [ObjectDirectory](#ObjectDirectory); [ObjectNamespace](#ObjectNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**clonesd**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**shadow**<br>|[ObjectDirectoryShadow](#ObjectDirectoryShadow)|[2.3](#Schema-Version-Map)||
|**symlink**<br>|<[ObjectSymlink](#ObjectSymlink)> array|[2.3](#Schema-Version-Map)||
|**objdir**<br>|<[ObjectDirectory](#ObjectDirectory)> array|[2.3](#Schema-Version-Map)||

---

<a name = "ObjectNamespace"></a>
## ObjectNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**shadow**<br>|[ObjectDirectoryShadow](#ObjectDirectoryShadow)|[2.3](#Schema-Version-Map)||
|**symlink**<br>|<[ObjectSymlink](#ObjectSymlink)> array|[2.3](#Schema-Version-Map)||
|**objdir**<br>|<[ObjectDirectory](#ObjectDirectory)> array|[2.3](#Schema-Version-Map)||

---

<a name = "ObjectSymlink"></a>
## ObjectSymlink
Referenced by: [ObjectDirectory](#ObjectDirectory); [ObjectNamespace](#ObjectNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**path**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**scope**<br>|[ObjectSymlinkScope](#ObjectSymlinkScope)|[2.3](#Schema-Version-Map)||
|**pathtoclone**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**access_mask**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "OperationFailure"></a>
## OperationFailure



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "OsLayerOptions"></a>
## OsLayerOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[OsLayerType](#OsLayerType)|[2.1](#Schema-Version-Map)||
|**DisableCiCacheOptimization**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "PauseNotification"></a>
## PauseNotification
Referenced by: [PauseOptions](#PauseOptions)

Notification data that is indicated to components running in the Virtual Machine.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Reason**<br>|[PauseReason](#PauseReason)|[2.1](#Schema-Version-Map)||

---

<a name = "PauseOptions"></a>
## PauseOptions
Options for HcsPauseComputeSystem

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SuspensionLevel**<br>|[PauseSuspensionLevel](#PauseSuspensionLevel)|[2.0](#Schema-Version-Map)||
|**HostedNotification**<br>|[PauseNotification](#PauseNotification)|[2.1](#Schema-Version-Map)||

---

<a name = "Plan9"></a>
## Plan9
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Shares**<br>|<[Plan9Share](#Plan9Share)> array|[2.1](#Schema-Version-Map)||

---

<a name = "Plan9Share"></a>
## Plan9Share
Referenced by: [Plan9](#Plan9)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AccessName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|The name by which the guest operation system can access this share, via the aname parameter in the Plan9 protocol.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Port**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AllowedFiles**<br>|<[string](#JSON-type)> array|[2.2](#Schema-Version-Map)||

---

<a name = "ProcessDetails"></a>
## ProcessDetails
Referenced by: [Properties](#Properties)

Information about a process running in a container

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProcessId**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ImageName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**CreateTimestamp**<br>|[DateTime](#JSON-type)|[2.1](#Schema-Version-Map)||
|**UserTime100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**KernelTime100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryCommitBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryWorkingSetPrivateBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryWorkingSetSharedBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ProcessModifyRequest"></a>
## ProcessModifyRequest
Passed to HcsRpc_ModifyProcess

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Operation**<br>|[ModifyOperation](#ModifyOperation)|[2.0](#Schema-Version-Map)||
|**ConsoleSize**<br>|[ConsoleSize](#ConsoleSize)|[2.0](#Schema-Version-Map)||
|**CloseHandle**<br>|[CloseHandle](#CloseHandle)|[2.0](#Schema-Version-Map)||

---

<a name = "ProcessorLimits"></a>
## ProcessorLimits
Used when modifying processor scheduling limits of a virtual machine.


**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "ProcessorStats"></a>
## ProcessorStats
Referenced by: [Statistics](#Statistics)

CPU runtime statistics

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**TotalRuntime100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RuntimeUser100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RuntimeKernel100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ProcessorTopology"></a>
## ProcessorTopology
Structure used to return processor topology for a Service property query

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LogicalProcessorCount**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**LogicalProcessors**<br>|<[LogicalProcessor](#LogicalProcessor)> array|[2.1](#Schema-Version-Map)||

---

<a name = "ProcessParameters"></a>
## ProcessParameters


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ApplicationName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CommandLine**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CommandArgs**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)|optional alternative to CommandLine, currently only supported by Linux GCS|
|**User**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**WorkingDirectory**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Environment**<br>|[Map](#JSON-type)<[string](#JSON-type), [string](#JSON-type)>|[2.0](#Schema-Version-Map)||
|**RestrictedToken**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|if set, will run as low-privilege process|
|**EmulateConsole**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|if set, ignore StdErrPipe|
|**CreateStdInPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CreateStdOutPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CreateStdErrPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ConsoleSize**<br>|<[uint16](#JSON-type), 2> array|[2.0](#Schema-Version-Map)|height then width|
|**UseExistingLogin**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|if set, find an existing session for the user and create the process in it|
|**UseLegacyConsole**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|if set, use the legacy console instead of conhost|

---

<a name = "ProcessStatus"></a>
## ProcessStatus
Provided in the EventData parameter of an HcsEventProcessExited HCS_EVENT.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProcessId**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|The process id (PID) of the process.|
|**Exited**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|True if the process has exited, false if it has not exited yet.|
|**ExitCode**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Exit code of the process. The ExitCode is valid only if LastWaitResult is S_OK and Exited is true.|
|**LastWaitResult**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)|Status of waiting for process exit. S_OK indicates success. Other HRESULT values on error.|

---

<a name = "Properties"></a>
## Properties


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**SystemType**<br>|[SystemType](#SystemType)|[2.1](#Schema-Version-Map)||
|**RuntimeOsType**<br>|[OsType](#OsType)|[2.1](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RuntimeId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**RuntimeTemplateId**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**State**<br>|[State](#State)|[2.1](#Schema-Version-Map)||
|**Stopped**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ExitType**<br>|[NotificationType](#NotificationType)|[2.1](#Schema-Version-Map)||
|**Memory**<br>|[MemoryInformationForVm](#MemoryInformationForVm)|[2.1](#Schema-Version-Map)||
|**Statistics**<br>|[Statistics](#Statistics)|[2.1](#Schema-Version-Map)||
|**ProcessList**<br>|<[ProcessDetails](#ProcessDetails)> array|[2.1](#Schema-Version-Map)||
|**TerminateOnLastHandleClosed**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**HostingSystemId**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**SharedMemoryRegionInfo**<br>|<[SharedMemoryRegionInfo](#SharedMemoryRegionInfo)> array|[2.1](#Schema-Version-Map)||
|**GuestConnectionInfo**<br>|[GuestConnectionInfo](#GuestConnectionInfo)|[2.1](#Schema-Version-Map)||

---

<a name = "QoSCapabilities"></a>
## QoSCapabilities
Quality of Service (QoS) capabilities

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProcessorQoSSupported**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Whether or not processor QoS is supported|

---

<a name = "RdpConnectionOptions"></a>
## RdpConnectionOptions
Referenced by: [EnhancedModeVideo](#EnhancedModeVideo); [VideoMonitor](#VideoMonitor)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**AccessSids**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)||
|**NamedPipe**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "RegistryChanges"></a>
## RegistryChanges
Referenced by: [Container](#Container); [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**AddValues**<br>|<[RegistryValue](#RegistryValue)> array|[2.0](#Schema-Version-Map)||
|**DeleteKeys**<br>|<[RegistryKey](#RegistryKey)> array|[2.0](#Schema-Version-Map)||

---

<a name = "RegistryDeleteKey"></a>
## RegistryDeleteKey
Referenced by: [RegistryHiveStack](#RegistryHiveStack)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryFlushState"></a>
## RegistryFlushState
Represents the flush state of the registry hive for a Windows container's job object.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Enabled**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Determines whether the flush state of the registry hive is enabled or not. When not enabled, flushes are ignored and changes to the registry are not preserved.|

---

<a name = "RegistryHiveStack"></a>
## RegistryHiveStack
Referenced by: [RegistryNamespace](#RegistryNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**hive**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**layer**<br>|<[RegistryLayer](#RegistryLayer)> array|[2.3](#Schema-Version-Map)||
|**mkkey**<br>|<[RegistryMakeKey](#RegistryMakeKey)> array|[2.3](#Schema-Version-Map)||
|**delkey**<br>|<[RegistryDeleteKey](#RegistryDeleteKey)> array|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryKey"></a>
## RegistryKey
Referenced by: [RegistryChanges](#RegistryChanges); [RegistryValue](#RegistryValue)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Hive**<br>|[RegistryHive](#RegistryHive)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Volatile**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "RegistryLayer"></a>
## RegistryLayer
Referenced by: [RegistryHiveStack](#RegistryHiveStack)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**hosthive**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**filepath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**identifier**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)||
|**readonly**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**immutable**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**inherittrustclass**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**writethrough**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**fileaccesstoken**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)|The FileAccessToken field should only be used in-memory and not serialized/deserialized, since it refers to a token handle.|

---

<a name = "RegistryMakeKey"></a>
## RegistryMakeKey
Referenced by: [RegistryHiveStack](#RegistryHiveStack); [RegistryMakeKey](#RegistryMakeKey)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**clonesd**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**mkkey**<br>|<[RegistryMakeKey](#RegistryMakeKey)> array|[2.3](#Schema-Version-Map)||
|**mkvalue**<br>|<[RegistryMakeValue](#RegistryMakeValue)> array|[2.3](#Schema-Version-Map)||
|**volatile**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryMakeValue"></a>
## RegistryMakeValue
Referenced by: [RegistryMakeKey](#RegistryMakeKey)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**name**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**data_multistring**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**data_dword**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||
|**data_string**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**data_binary**<br>|[NullableByteArray](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryNamespace"></a>
## RegistryNamespace
Referenced by: [Namespace](#Namespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**symlink**<br>|<[RegistrySymlink](#RegistrySymlink)> array|[2.3](#Schema-Version-Map)||
|**redirectionnode**<br>|<[RegistryRedirectionNode](#RegistryRedirectionNode)> array|[2.3](#Schema-Version-Map)||
|**hivestack**<br>|<[RegistryHiveStack](#RegistryHiveStack)> array|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryRedirectionNode"></a>
## RegistryRedirectionNode
Referenced by: [RegistryNamespace](#RegistryNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**containerpath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**hostpath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**hivestack**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**access_mask**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)||
|**trustedhive**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||
|**exitnode**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "RegistrySymlink"></a>
## RegistrySymlink
Referenced by: [RegistryNamespace](#RegistryNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**key**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**target**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "RegistryValue"></a>
## RegistryValue
Referenced by: [RegistryChanges](#RegistryChanges)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Key**<br>|[RegistryKey](#RegistryKey)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Type**<br>|[RegistryValueType](#RegistryValueType)|[2.0](#Schema-Version-Map)||
|**StringValue**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|One and only one value type must be set.|
|**BinaryValue**<br>|[ByteArray](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DWordValue**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**QWordValue**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CustomType**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|Only used if RegistryValueType is CustomType The data is in BinaryValue|

---

<a name = "RestoreState"></a>
## RestoreState
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SaveStateFilePath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|The path to the save state file to restore the system from.|
|**TemplateSystemId**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|The ID of the template system to clone this new system off of. An empty string indicates the system should not be cloned from a template.|

---

<a name = "ResultError"></a>
## ResultError
Extended error information returned by the HCS

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Error**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)|HRESULT error code|
|**ErrorMessage**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Error message|

---

<a name = "SaveOptions"></a>
## SaveOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SaveType**<br>|[SaveType](#SaveType)|[2.1](#Schema-Version-Map)|The type of save operation to be performed.|
|**SaveStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|The path to the file that will container the saved state.|

---

<a name = "Scsi"></a>
## Scsi
Referenced by: [Devices](#Devices)

Object describing a SCSI controller.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Attachments**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [Attachment](#Attachment)>|[2.0](#Schema-Version-Map)|Map of attachments, where the key is the integer LUN number on the controller.|

---

<a name = "Service_PropertyQuery"></a>
## Service_PropertyQuery
Structure used to perform property query

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyTypes**<br>|<[GetPropertyType](#GetPropertyType)> array|[2.1](#Schema-Version-Map)|Specifies the property array to query|

---

<a name = "ServiceProperties"></a>
## ServiceProperties
Properties of the host

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Properties**<br>|<[Any](#JSON-type)> array|[2.1](#Schema-Version-Map)|The service properties will be returned as an array corresponding to the requested property types.|

---

<a name = "Services"></a>
## Services



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "SetPropertyOperation"></a>
## SetPropertyOperation
Set properties operation settings

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GroupId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**PropertyCode**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**PropertyValue**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "SharedMemoryConfiguration"></a>
## SharedMemoryConfiguration
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Regions**<br>|<[SharedMemoryRegion](#SharedMemoryRegion)> array|[2.1](#Schema-Version-Map)||

---

<a name = "SharedMemoryRegion"></a>
## SharedMemoryRegion
Referenced by: [SharedMemoryConfiguration](#SharedMemoryConfiguration)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SectionName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**StartOffset**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Length**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AllowGuestWrite**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HiddenFromGuest**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "SharedMemoryRegionInfo"></a>
## SharedMemoryRegionInfo
Referenced by: [Properties](#Properties)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SectionName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**GuestPhysicalAddress**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "SignalProcessOptions"></a>
## SignalProcessOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Signal**<br>|[ProcessSignal](#ProcessSignal)|[2.1](#Schema-Version-Map)||

---

<a name = "Statistics"></a>
## Statistics
Referenced by: [Properties](#Properties)

Runtime statistics for a container

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Timestamp**<br>|[DateTime](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ContainerStartTime**<br>|[DateTime](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Uptime100ns**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Processor**<br>|[ProcessorStats](#ProcessorStats)|[2.1](#Schema-Version-Map)||
|**Memory**<br>|[MemoryStats](#MemoryStats)|[2.1](#Schema-Version-Map)||
|**Storage**<br>|[StorageStats](#StorageStats)|[2.1](#Schema-Version-Map)||

---

<a name = "Storage"></a>
## Storage
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)|List of layers that describe the parent hierarchy for a container's storage. These layers combined together, presented as a disposable and/or committable working storage, are used by the container to record all changes done to the parent layers.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Path that points to the scratch space of a container, where parent layers are combined together to present a new disposable and/or committable layer with the changes done during its runtime.|
|**QoS**<br>|[StorageQoS](#StorageQoS)|[2.0](#Schema-Version-Map)|Optional quality of service configurations for a container's storage.|

---

<a name = "StorageQoS"></a>
## StorageQoS
Referenced by: [Storage](#Storage); [VirtualMachine](#VirtualMachine)

Describes storage quality of service settings, relative to a storage volume.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IopsMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|Defines the maximum allowed Input/Output operations per second in a volume.|
|**BandwidthMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|Defines the maximum bandwidth (bytes per second) allowed in a volume.|

---

<a name = "StorageStats"></a>
## StorageStats
Referenced by: [Statistics](#Statistics)

Storage runtime statistics

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ReadCountNormalized**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ReadSizeBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**WriteCountNormalized**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**WriteSizeBytes**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "System_PropertyQuery"></a>
## System_PropertyQuery
By default the basic properties will be returned. This query provides a way to request specific properties.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyTypes**<br>|<[System_PropertyType](#System_PropertyType)> array|[2.1](#Schema-Version-Map)||

---

<a name = "SystemExit"></a>
## SystemExit



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "SystemExitStatus"></a>
## SystemExitStatus
Document provided in the EventData parameter of an HcsEventSystemExited HCS_EVENT.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Status**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)|Exit status (HRESULT) for the system.|
|**ExitType**<br>|[NotificationType](#NotificationType)|[2.2](#Schema-Version-Map)|Exit type for the system.|

---

<a name = "SystemProcessorModificationRequest"></a>
## SystemProcessorModificationRequest
Structure used to request a system processor modification

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GroupId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "SystemQuery"></a>
## SystemQuery


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Ids**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)||
|**Names**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)||
|**Types**<br>|<[SystemType](#SystemType)> array|[2.1](#Schema-Version-Map)||
|**Owners**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)||

---

<a name = "SystemTime"></a>
## SystemTime
Referenced by: [TimeZoneInformation](#TimeZoneInformation)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Year**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Month**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**DayOfWeek**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Day**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Hour**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Minute**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Second**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Milliseconds**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "TimeZoneInformation"></a>
## TimeZoneInformation


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Bias**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**StandardName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**StandardDate**<br>|[SystemTime](#SystemTime)|[2.1](#Schema-Version-Map)||
|**StandardBias**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**DaylightName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**DaylightDate**<br>|[SystemTime](#SystemTime)|[2.1](#Schema-Version-Map)||
|**DaylightBias**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "Topology"></a>
## Topology
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Memory**<br>|[VirtualMachine_Memory](#VirtualMachine_Memory)|[2.0](#Schema-Version-Map)||
|**Processor**<br>|[VirtualMachine_Processor](#VirtualMachine_Processor)|[2.0](#Schema-Version-Map)||

---

<a name = "TripleFault"></a>
## TripleFault



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "Uefi"></a>
## Uefi
Referenced by: [Chipset](#Chipset)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EnableDebugger**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SecureBootTemplateId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ApplySecureBootTemplate**<br>|[ApplySecureBootTemplateType](#ApplySecureBootTemplateType)|[2.3](#Schema-Version-Map)||
|**BootThis**<br>|[UefiBootEntry](#UefiBootEntry)|[2.0](#Schema-Version-Map)||
|**Console**<br>|[SerialConsole](#SerialConsole)|[2.0](#Schema-Version-Map)||
|**StopOnBootFailure**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||

---

<a name = "UefiBootEntry"></a>
## UefiBootEntry
Referenced by: [Uefi](#Uefi)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DeviceType**<br>|[UefiBootDevice](#UefiBootDevice)|[2.1](#Schema-Version-Map)||
|**DevicePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**DiskNumber**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**OptionalData**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**VmbFsRootPath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "Version"></a>
## Version
Referenced by: [BasicInformation](#BasicInformation); [ComputeSystem](#ComputeSystem); [GuestConnectionInfo](#GuestConnectionInfo); [HostedSystem](#HostedSystem); [LayerData](#LayerData)

Object that describes a version with a Major.Minor format.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Major**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|The major version value. Individual major versions are not compatible with one another.|
|**Minor**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|The minor version value. A lower minor version is considered a compatible subset of a higher minor version.|

---

<a name = "VideoMonitor"></a>
## VideoMonitor
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HorizontalResolution**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**VerticalResolution**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ConnectionOptions**<br>|[RdpConnectionOptions](#RdpConnectionOptions)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtioSerial"></a>
## VirtioSerial
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Ports**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [VirtioSerialPort](#VirtioSerialPort)>|[2.2](#Schema-Version-Map)||

---

<a name = "VirtioSerialPort"></a>
## VirtioSerialPort
Referenced by: [VirtioSerial](#VirtioSerial)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NamedPipe**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||

---

<a name = "VirtualDeviceFailure"></a>
## VirtualDeviceFailure
Provides information on failures originated by a virtual device.


**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "VirtualMachine"></a>
## VirtualMachine
Referenced by: [ComputeSystem](#ComputeSystem)

Configuration of a virtual machine, used during its creation to set up and/or use resources.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**StopOnReset**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|When set to true, the virtual machine will treat a reset as a stop, releasing resources and cleaning up state.|
|**Chipset**<br>|[Chipset](#Chipset)|[2.0](#Schema-Version-Map)|An object describing the chipset settings, including boot settings.|
|**ComputeTopology**<br>|[Topology](#Topology)|[2.0](#Schema-Version-Map)|An object describing the processor and memory configuration of a virtual machine.|
|**Devices**<br>|[Devices](#Devices)|[2.0](#Schema-Version-Map)|Nested objects describing the set of devices attached to the virtual machine.|
|**GuestState**<br>|[GuestState](#GuestState)|[2.1](#Schema-Version-Map)|An optional object describing files used to back guest state. When omitted, guest state is transient and kept purely in memory.|
|**RestoreState**<br>|[RestoreState](#RestoreState)|[2.0](#Schema-Version-Map)|An optional object describing the state the virtual machine should restore from as part of start.|
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)|A set of changes applied to a Windows guest's registry at boot time.|
|**StorageQoS**<br>|[StorageQoS](#StorageQoS)|[2.1](#Schema-Version-Map)|An optional set of quality of service restrictions on the virtual machine's storage.|
|**GuestConnection**<br>|[GuestConnection](#GuestConnection)|[2.1](#Schema-Version-Map)|An optional object describing settings for a conection to the guest OS. If GuestConnection is not specified, the virtual machine will be considered started once the chipset is fully powered on. If specified, the virtual machine start will wait until a guest connection is established.|

---

<a name = "VirtualMachine_HvSocket"></a>
## VirtualMachine_HvSocket
Referenced by: [Devices](#Devices)

HvSocket configuration for a VM

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HvSocketConfig**<br>|[HvSocketSystemConfig](#HvSocketSystemConfig)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualMachine_Memory"></a>
## VirtualMachine_Memory
Referenced by: [Topology](#Topology)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SizeInMB**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**AllowOvercommit**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|If enabled, then the VM's memory is backed by the Windows pagefile rather than physically backed, statically allocated memory.|
|**BackingPageSize**<br>|[MemoryBackingPageSize](#MemoryBackingPageSize)|[2.2](#Schema-Version-Map)|The preferred page size unit (chunk size) used when allocating backing pages for the VM.|
|**PinBackingPages**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|If enabled, then each backing page is physically pinned on first access.|
|**ForbidSmallBackingPages**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|If enabled, then backing page chunks smaller than the backing page size are never used unless the system is under extreme memory pressure. If the backing page size is Small, then it is forced to Large when this option is enabled.|
|**EnableHotHint**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|If enabled, then the memory hot hint feature is exposed to the VM, allowing it to prefetch pages into its working set. (if supported by the guest operating system).|
|**EnableColdHint**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|If enabled, then the memory cold hint feature is exposed to the VM, allowing it to trim zeroed pages from its working set (if supported by the guest operating system).|
|**EnableColdDiscardHint**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|If enabled, then the memory cold discard hint feature is exposed to the VM, allowing it to trim non-zeroed pages from the working set (if supported by the guest operating system).|
|**EnableDeferredCommit**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|If enabled, then commit is not charged for each backing page until first access.|
|**LowMmioGapInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)|Low MMIO region allocated below 4GB|
|**HighMmioBaseInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)|High MMIO region allocated above 4GB (base and size)|
|**HighMmioGapInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "VirtualMachine_Processor"></a>
## VirtualMachine_Processor
Referenced by: [Topology](#Topology)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Count**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Limit**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Weight**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ExposeVirtualizationExtensions**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**EnablePerfmonPmu**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||
|**EnablePerfmonPebs**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||
|**EnablePerfmonLbr**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||
|**EnablePerfmonIpt**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||

---

<a name = "VirtualNodeInfo"></a>
## VirtualNodeInfo
Referenced by: [MemoryInformationForVm](#MemoryInformationForVm)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**VirtualNodeIndex**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)||
|**PhysicalNodeNumber**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)||
|**VirtualProcessorCount**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**MemoryUsageInPages**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualPciDevice"></a>
## VirtualPciDevice
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Functions**<br>|<[VirtualPciFunction](#VirtualPciFunction)> array|[2.3](#Schema-Version-Map)||

---

<a name = "VirtualPciFunction"></a>
## VirtualPciFunction
Referenced by: [VirtualPciDevice](#VirtualPciDevice)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DeviceInstancePath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**VirtualFunction**<br>|[uint16](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "VirtualPMemController"></a>
## VirtualPMemController
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Devices**<br>|[Map](#JSON-type)<[uint8](#JSON-type), [VirtualPMemDevice](#VirtualPMemDevice)>|[2.0](#Schema-Version-Map)||
|**MaximumCount**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)|This field indicates how many empty devices to add to the controller. If non-zero, additional VirtualPMemDevice objects with no HostPath and no Mappings will be added to the Devices map to get up to the MaximumCount. These devices will be configured with either the MaximumSizeBytes field if non-zero, or with the default maximum, 512 Mb.|
|**MaximumSizeBytes**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Backing**<br>|[VirtualPMemBackingType](#VirtualPMemBackingType)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualPMemDevice"></a>
## VirtualPMemDevice
Referenced by: [VirtualPMemController](#VirtualPMemController)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ImageFormat**<br>|[VirtualPMemImageFormat](#VirtualPMemImageFormat)|[2.0](#Schema-Version-Map)||
|**SizeBytes**<br>|[uint64](#JSON-type)|[2.2](#Schema-Version-Map)||
|**Mappings**<br>|[Map](#JSON-type)<[uint64](#JSON-type), [VirtualPMemMapping](#VirtualPMemMapping)>|[2.2](#Schema-Version-Map)||

---

<a name = "VirtualPMemMapping"></a>
## VirtualPMemMapping
Referenced by: [VirtualPMemDevice](#VirtualPMemDevice)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||
|**ImageFormat**<br>|[VirtualPMemImageFormat](#VirtualPMemImageFormat)|[2.2](#Schema-Version-Map)||

---

<a name = "VirtualSmb"></a>
## VirtualSmb
Referenced by: [Devices](#Devices)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Shares**<br>|<[VirtualSmbShare](#VirtualSmbShare)> array|[2.1](#Schema-Version-Map)||
|**DirectFileMappingInMB**<br>|[int64](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualSmbShare"></a>
## VirtualSmbShare
Referenced by: [VirtualSmb](#VirtualSmb)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AllowedFiles**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Options**<br>|[VirtualSmbShareOptions](#VirtualSmbShareOptions)|[2.1](#Schema-Version-Map)||

---

<a name = "VirtualSmbShareOptions"></a>
## VirtualSmbShareOptions
Referenced by: [VirtualSmbShare](#VirtualSmbShare)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ReadOnly**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ShareRead**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|convert exclusive access to shared read access|
|**CacheIo**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|all opens will use cached I/O|
|**NoOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|disable oplock support|
|**TakeBackupPrivilege**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Acquire the backup privilege when attempting to open|
|**UseShareRootIdentity**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Use the identity of the share root when opening|
|**NoDirectmap**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|disable Direct Mapping|
|**NoLocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|disable Byterange locks|
|**NoDirnotify**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|disable Directory CHange Notifications|
|**VmSharedMemory**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|share is use for VM shared memory|
|**RestrictFileAccess**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|allow access only to the files specified in AllowedFiles|
|**ForceLevelIIOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|disable all oplocks except Level II|
|**ReparseBaseLayer**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Allow the host to reparse this base layer|
|**PseudoOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Enable pseudo-oplocks|
|**NonCacheIo**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|All opens will use non-cached IO|
|**PseudoDirnotify**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Enable pseudo directory change notifications|
|**SingleFileMapping**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Block directory enumeration, renames, and deletes.|
|**SupportCloudFiles**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)|Support Cloud Files functionality|

---

<a name = "VmMemory"></a>
## VmMemory
Referenced by: [MemoryInformationForVm](#MemoryInformationForVm)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**AvailableMemory**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**AvailableMemoryBuffer**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ReservedMemory**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**AssignedMemory**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||
|**SlpActive**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**BalancingEnabled**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||
|**DmOperationInProgress**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "WindowsCrashReport"></a>
## WindowsCrashReport
Referenced by: [CrashReport](#CrashReport)

Windows specific crash information

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DumpFile**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Path to a Windows memory dump file. This will contain the same path as the configured in the GuestCrashReporting device. This field is not valid unless the FinalPhase is Complete.|
|**OsMajorVersion**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Major version as reported by the guest OS.|
|**OsMinorVersion**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Minor version as reported by the guest OS.|
|**OsBuildNumber**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Build number as reported by the guest OS.|
|**OsServicePackMajorVersion**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Service pack major version as reported by the guest OS.|
|**OsServicePackMinorVersion**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Service pack minor version as reported by the guest OS.|
|**OsSuiteMask**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Suite mask as reported by the guest OS.|
|**OsProductType**<br>|[uint32](#JSON-type)|[2.1](#Schema-Version-Map)|Product type as reported by the guest OS.|
|**Status**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)|Status of the crash dump. S_OK indicates success, other HRESULT values on error.|
|**FinalPhase**<br>|[WindowsCrashPhase](#WindowsCrashPhase)|[2.1](#Schema-Version-Map)|Indicates progress of a Windows memory dump when the crash report was sent.|

---

<a name = "WindowsCrashReporting"></a>
## WindowsCrashReporting
Referenced by: [GuestCrashReporting](#GuestCrashReporting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DumpFileName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**MaxDumpSize**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "WorkerExit"></a>
## WorkerExit



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "JSON-type"></a>
## JSON type

The table shows the mapping from type name for field of classes to JSON type, its format and pattern. See details in [Swagger IO spec](https://swagger.io/specification/#data-types)

|Name|JSON Type|Format|Pattern|
|---|---|---|---|
|Any|object|||
|bool|boolean|||
|ByteArray|string|byte||
|DateTime|string|date-time||
|Guid|string||^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$|
|int32|integer|int32||
|int64|integer|int64||
|MacAddress|string|mac-address||
|Map|object|||
|NullableByteArray|string|binary||
|string|string|||
|string_binary|string|binary||
|uint16|integer|uint16||
|uint32|integer|uint32||
|uint64|integer|uint64||
|uint8|integer|uint8||

---
<a name = "Schema-Version-Map"></a>
## Schema Version Map

|Schema Version|Release Version|
|---|---|
|2.0|Windows 10 SDK, version 1809 (10.0.17763.0)|
|2.1|Windows 10 SDK, version 1809 (10.0.17763.0)|
|2.2|Windows 10 SDK, version 1903 (10.0.18362.1)|
|2.3|Windows 10 SDK, version 2004 (10.0.19041.0)|

---
