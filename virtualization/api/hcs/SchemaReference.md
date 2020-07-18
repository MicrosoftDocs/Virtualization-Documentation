# Agenda
- Enums
    - [AppContainerLaunchType](#AppContainerLaunchType)
    - [ApplySecureBootTemplateType](#ApplySecureBootTemplateType)
    - [AttachmentType](#AttachmentType)
    - [CacheMode](#CacheMode)
    - [CachingMode](#CachingMode)
    - [ContainerCredentialGuardModifyOperation](#ContainerCredentialGuardModifyOperation)
    - [ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)
    - [CrashType](#CrashType)
    - [DeviceType](#DeviceType)
    - [EventDataType](#EventDataType)
    - [FlexibleIoDeviceHostingModel](#FlexibleIoDeviceHostingModel)
    - [GpuAssignmentMode](#GpuAssignmentMode)
    - [IntegrationComponentOperatingStateReason](#IntegrationComponentOperatingStateReason)
    - [IntegrationComponentOperationalState](#IntegrationComponentOperationalState)
    - [MappedPipePathType](#MappedPipePathType)
    - [MemoryBackingPageSize](#MemoryBackingPageSize)
    - [ModifyOperation](#ModifyOperation)
    - [ModifyRequestType](#ModifyRequestType)
    - [ModifyResourceType](#ModifyResourceType)
    - [NetworkModifyRequestType](#NetworkModifyRequestType)
    - [NotificationType](#NotificationType)
    - [OsLayerType](#OsLayerType)
    - [OsType](#OsType)
    - [PathType](#PathType)
    - [PauseReason](#PauseReason)
    - [PauseSuspensionLevel](#PauseSuspensionLevel)
    - [ProcessDumpType](#ProcessDumpType)
    - [ProcessSignal](#ProcessSignal)
    - [RegistryHive](#RegistryHive)
    - [RegistryValueType](#RegistryValueType)
    - [SaveType](#SaveType)
    - [SerialConsole](#SerialConsole)
    - [Service_PropertyType](#Service_PropertyType)
    - [State](#State)
    - [StdHandle](#StdHandle)
    - [System_PropertyType](#System_PropertyType)
    - [SystemType](#SystemType)
    - [UefiBootDevice](#UefiBootDevice)
    - [VirtualPMemBackingType](#VirtualPMemBackingType)
    - [VirtualPMemImageFormat](#VirtualPMemImageFormat)
    - [WindowsCrashPhase](#WindowsCrashPhase)
- Structs
    - [Attachment](#Attachment)
    - [AttributionRecord](#AttributionRecord)
    - [BasicInformation](#BasicInformation)
    - [Battery](#Battery)
    - [Chipset](#Chipset)
    - [CimMount](#CimMount)
    - [CloseHandle](#CloseHandle)
    - [CombinedLayers](#CombinedLayers)
    - [ComPort](#ComPort)
    - [ComputeSystem](#ComputeSystem)
    - [ConsoleSize](#ConsoleSize)
    - [Container](#Container)
    - [Container_HvSocket](#Container_HvSocket)
    - [Container_Memory](#Container_Memory)
    - [Container_Processor](#Container_Processor)
    - [ContainerCredentialGuardAddInstanceRequest](#ContainerCredentialGuardAddInstanceRequest)
    - [ContainerCredentialGuardHvSocketServiceConfig](#ContainerCredentialGuardHvSocketServiceConfig)
    - [ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)
    - [ContainerCredentialGuardOperationRequest](#ContainerCredentialGuardOperationRequest)
    - [ContainerCredentialGuardRemoveInstanceRequest](#ContainerCredentialGuardRemoveInstanceRequest)
    - [ContainerCredentialGuardState](#ContainerCredentialGuardState)
    - [ContainerCredentialGuardSystemInfo](#ContainerCredentialGuardSystemInfo)
    - [CpuGroup](#CpuGroup)
    - [CrashOptions](#CrashOptions)
    - [CrashReport](#CrashReport)
    - [CrashReportProcessDump](#CrashReportProcessDump)
    - [Device](#Device)
    - [Devices](#Devices)
    - [EnhancedModeVideo](#EnhancedModeVideo)
    - [ErrorEvent](#ErrorEvent)
    - [EventData](#EventData)
    - [ExportLayerOptions](#ExportLayerOptions)
    - [FilteredPropertyQuery](#FilteredPropertyQuery)
    - [FlexibleIoDevice](#FlexibleIoDevice)
    - [GpuConfiguration](#GpuConfiguration)
    - [GuestConnection](#GuestConnection)
    - [GuestConnectionInfo](#GuestConnectionInfo)
    - [GuestCrash](#GuestCrash)
    - [GuestCrashReporting](#GuestCrashReporting)
    - [GuestModifySettingRequest](#GuestModifySettingRequest)
    - [GuestOs](#GuestOs)
    - [GuestState](#GuestState)
    - [Heartbeat](#Heartbeat)
    - [HostedSystem](#HostedSystem)
    - [HvSocketAddress](#HvSocketAddress)
    - [HvSocketServiceConfig](#HvSocketServiceConfig)
    - [HvSocketSystemConfig](#HvSocketSystemConfig)
    - [IdleProcessorsRequest](#IdleProcessorsRequest)
    - [InjectNonMaskableInterrupt](#InjectNonMaskableInterrupt)
    - [IntegrationComponentStatus](#IntegrationComponentStatus)
    - [IovSettings](#IovSettings)
    - [KernelIntegration](#KernelIntegration)
    - [Keyboard](#Keyboard)
    - [Layer](#Layer)
    - [LayerData](#LayerData)
    - [LinuxKernelDirect](#LinuxKernelDirect)
    - [MappedDirectory](#MappedDirectory)
    - [MappedPipe](#MappedPipe)
    - [MappedVirtualDisk](#MappedVirtualDisk)
    - [MemoryInformationForVm](#MemoryInformationForVm)
    - [MemoryStats](#MemoryStats)
    - [ModificationRequest](#ModificationRequest)
    - [ModifySettingRequest](#ModifySettingRequest)
    - [Mouse](#Mouse)
    - [NetworkAdapter](#NetworkAdapter)
    - [Networking](#Networking)
    - [NetworkModifySettingRequest](#NetworkModifySettingRequest)
    - [NumaSetting](#NumaSetting)
    - [OperationFailure](#OperationFailure)
    - [OsLayerOptions](#OsLayerOptions)
    - [PauseNotification](#PauseNotification)
    - [PauseOptions](#PauseOptions)
    - [Plan9](#Plan9)
    - [Plan9Share](#Plan9Share)
    - [ProcessDetails](#ProcessDetails)
    - [ProcessModifyRequest](#ProcessModifyRequest)
    - [ProcessorLimits](#ProcessorLimits)
    - [ProcessorStats](#ProcessorStats)
    - [ProcessParameters](#ProcessParameters)
    - [ProcessStatus](#ProcessStatus)
    - [Properties](#Properties)
    - [QoSCapabilities](#QoSCapabilities)
    - [RdpConnectionOptions](#RdpConnectionOptions)
    - [RegistryChanges](#RegistryChanges)
    - [RegistryFlushState](#RegistryFlushState)
    - [RegistryKey](#RegistryKey)
    - [RegistryValue](#RegistryValue)
    - [RestoreState](#RestoreState)
    - [ResultError](#ResultError)
    - [Rs4NetworkModifySettingRequest](#Rs4NetworkModifySettingRequest)
    - [SaveOptions](#SaveOptions)
    - [Scsi](#Scsi)
    - [Service_PropertyQuery](#Service_PropertyQuery)
    - [ServiceProperties](#ServiceProperties)
    - [Services](#Services)
    - [SharedMemoryConfiguration](#SharedMemoryConfiguration)
    - [SharedMemoryRegion](#SharedMemoryRegion)
    - [SharedMemoryRegionInfo](#SharedMemoryRegionInfo)
    - [SignalProcessOptions](#SignalProcessOptions)
    - [Statistics](#Statistics)
    - [Storage](#Storage)
    - [StorageQoS](#StorageQoS)
    - [StorageStats](#StorageStats)
    - [System_PropertyQuery](#System_PropertyQuery)
    - [SystemExit](#SystemExit)
    - [SystemExitStatus](#SystemExitStatus)
    - [SystemQuery](#SystemQuery)
    - [SystemTime](#SystemTime)
    - [TimeZoneInformation](#TimeZoneInformation)
    - [Topology](#Topology)
    - [TripleFault](#TripleFault)
    - [Uefi](#Uefi)
    - [UefiBootEntry](#UefiBootEntry)
    - [Version](#Version)
    - [VideoMonitor](#VideoMonitor)
    - [VirtioSerial](#VirtioSerial)
    - [VirtioSerialPort](#VirtioSerialPort)
    - [VirtualDeviceFailure](#VirtualDeviceFailure)
    - [VirtualMachine](#VirtualMachine)
    - [VirtualMachine_HvSocket](#VirtualMachine_HvSocket)
    - [VirtualMachine_Memory](#VirtualMachine_Memory)
    - [VirtualMachine_Processor](#VirtualMachine_Processor)
    - [VirtualNodeInfo](#VirtualNodeInfo)
    - [VirtualPciDevice](#VirtualPciDevice)
    - [VirtualPciFunction](#VirtualPciFunction)
    - [VirtualPMemController](#VirtualPMemController)
    - [VirtualPMemDevice](#VirtualPMemDevice)
    - [VirtualPMemMapping](#VirtualPMemMapping)
    - [VirtualSmb](#VirtualSmb)
    - [VirtualSmbShare](#VirtualSmbShare)
    - [VirtualSmbShareOptions](#VirtualSmbShareOptions)
    - [VmMemory](#VmMemory)
    - [WindowsCrashReport](#WindowsCrashReport)
    - [WindowsCrashReporting](#WindowsCrashReporting)
    - [WorkerExit](#WorkerExit)
- [JSON type table](#JSON-type)
- [Version Map](#Schema-Version-Map)
---
# Enums
Note: all variants listed should be used as string
<a name = "AppContainerLaunchType"></a>
## AppContainerLaunchType


|Variants|NewInVersion|Description|
|---|---|---|
|`"Default"`<br>|[2.1](#Schema-Version-Map)|Use None or global setting.|
|`"None"`<br>|[2.1](#Schema-Version-Map)|Launch VMWP normally.|
|`"AppContainer"`<br>|[2.1](#Schema-Version-Map)|Launch VMWP as an App Container.|

---

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
|`"AddInstance"`<br>|[2.1](#Schema-Version-Map)||
|`"RemoveInstance"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardTransport"></a>
## ContainerCredentialGuardTransport
Referenced by: [ContainerCredentialGuardAddInstanceRequest](#ContainerCredentialGuardAddInstanceRequest); [ContainerCredentialGuardState](#ContainerCredentialGuardState)



|Variants|NewInVersion|Description|
|---|---|---|
|`"LRPC"`<br>|[2.1](#Schema-Version-Map)||
|`"HvSocket"`<br>|[2.1](#Schema-Version-Map)||

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
|`"Empty"`<br>|[](#Schema-Version-Map)||
|`"String"`<br>|[](#Schema-Version-Map)||
|`"AnsiString"`<br>|[](#Schema-Version-Map)||
|`"SByte"`<br>|[](#Schema-Version-Map)||
|`"Byte"`<br>|[](#Schema-Version-Map)||
|`"Int16"`<br>|[](#Schema-Version-Map)||
|`"UInt16"`<br>|[](#Schema-Version-Map)||
|`"Int32"`<br>|[](#Schema-Version-Map)||
|`"UInt32"`<br>|[](#Schema-Version-Map)||
|`"Int64"`<br>|[](#Schema-Version-Map)||
|`"UInt64"`<br>|[](#Schema-Version-Map)||
|`"Single"`<br>|[](#Schema-Version-Map)||
|`"Double"`<br>|[](#Schema-Version-Map)||
|`"Boolean"`<br>|[](#Schema-Version-Map)||
|`"Binary"`<br>|[](#Schema-Version-Map)||
|`"Guid"`<br>|[](#Schema-Version-Map)||

---

<a name = "FlexibleIoDeviceHostingModel"></a>
## FlexibleIoDeviceHostingModel
Referenced by: [FlexibleIoDevice](#FlexibleIoDevice)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Internal"`<br>|[2.1](#Schema-Version-Map)||
|`"External"`<br>|[2.1](#Schema-Version-Map)||

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

<a name = "IntegrationComponentOperatingStateReason"></a>
## IntegrationComponentOperatingStateReason
Referenced by: [IntegrationComponentStatus](#IntegrationComponentStatus)

possible reason for integration component's state

|Variants|NewInVersion|Description|
|---|---|---|
|`"Unknown"`<br>|[2.3](#Schema-Version-Map)||
|`"AppsInCriticalState"`<br>|[2.3](#Schema-Version-Map)||
|`"CommunicationTimedOut"`<br>|[2.3](#Schema-Version-Map)||
|`"FailedCommunication"`<br>|[2.3](#Schema-Version-Map)||
|`"HealthyApps"`<br>|[2.3](#Schema-Version-Map)||
|`"ProtocolMismatch"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "IntegrationComponentOperationalState"></a>
## IntegrationComponentOperationalState
Referenced by: [IntegrationComponentStatus](#IntegrationComponentStatus)

operational status for integration component

|Variants|NewInVersion|Description|
|---|---|---|
|`"Unknown"`<br>|[2.3](#Schema-Version-Map)||
|`"Degraded"`<br>|[2.3](#Schema-Version-Map)||
|`"Dormant"`<br>|[2.3](#Schema-Version-Map)||
|`"Error"`<br>|[2.3](#Schema-Version-Map)||
|`"LostCommunication"`<br>|[2.3](#Schema-Version-Map)||
|`"NonRecoverableError"`<br>|[2.3](#Schema-Version-Map)||
|`"NoContact"`<br>|[2.3](#Schema-Version-Map)||
|`"Ok"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "MappedPipePathType"></a>
## MappedPipePathType
Referenced by: [MappedPipe](#MappedPipe)



|Variants|NewInVersion|Description|
|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)||
|`"VirtualSmbPipeName"`<br>|[2.1](#Schema-Version-Map)||

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

<a name = "NetworkModifyRequestType"></a>
## NetworkModifyRequestType
Referenced by: [NetworkModifySettingRequest](#NetworkModifySettingRequest); [Rs4NetworkModifySettingRequest](#Rs4NetworkModifySettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"PreAdd"`<br>|[](#Schema-Version-Map)||
|`"Add"`<br>|[](#Schema-Version-Map)||
|`"Remove"`<br>|[](#Schema-Version-Map)||

---

<a name = "NotificationType"></a>
## NotificationType
Referenced by: [Properties](#Properties); [SystemExitStatus](#SystemExitStatus)

Notification type generated by ComputeSystems

|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.1](#Schema-Version-Map)||
|`"GracefulExit"`<br>|[2.1](#Schema-Version-Map)||
|`"ForcedExit"`<br>|[2.1](#Schema-Version-Map)||
|`"UnexpectedExit"`<br>|[2.1](#Schema-Version-Map)||
|`"Unknown"`<br>|[2.1](#Schema-Version-Map)||

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
|`"Unknown"`<br>|[](#Schema-Version-Map)||
|`"Windows"`<br>|[](#Schema-Version-Map)||
|`"Linux"`<br>|[](#Schema-Version-Map)||

---

<a name = "PathType"></a>
## PathType
Referenced by: [Layer](#Layer); [MappedDirectory](#MappedDirectory)



|Variants|NewInVersion|Description|
|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)||
|`"VirtualSmbShareName"`<br>|[2.1](#Schema-Version-Map)||

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

<a name = "ProcessDumpType"></a>
## ProcessDumpType


|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[](#Schema-Version-Map)||
|`"Heap"`<br>|[](#Schema-Version-Map)||
|`"Mini"`<br>|[](#Schema-Version-Map)||
|`"Custom"`<br>|[](#Schema-Version-Map)||

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

<a name = "Service_PropertyType"></a>
## Service_PropertyType
Referenced by: [FilteredPropertyQuery](#FilteredPropertyQuery); [ModificationRequest](#ModificationRequest); [Service_PropertyQuery](#Service_PropertyQuery)

Service property types

|Variants|NewInVersion|Description|
|---|---|---|
|`"Basic"`<br>|[](#Schema-Version-Map)||
|`"Memory"`<br>|[](#Schema-Version-Map)||
|`"CpuGroup"`<br>|[](#Schema-Version-Map)||
|`"ProcessorTopology"`<br>|[](#Schema-Version-Map)||
|`"CacheAllocation"`<br>|[](#Schema-Version-Map)||
|`"CacheMonitoring"`<br>|[](#Schema-Version-Map)||
|`"ContainerCredentialGuard"`<br>|[](#Schema-Version-Map)||
|`"QoSCapabilities"`<br>|[2.1](#Schema-Version-Map)||
|`"MemoryBwAllocation"`<br>|[2.1](#Schema-Version-Map)||
|`"Undefined"`<br>|[](#Schema-Version-Map)||

---

<a name = "State"></a>
## State
Referenced by: [Properties](#Properties)

Compute system state which is exposed to external clients

|Variants|NewInVersion|Description|
|---|---|---|
|`"Created"`<br>|[](#Schema-Version-Map)||
|`"Running"`<br>|[](#Schema-Version-Map)||
|`"Paused"`<br>|[](#Schema-Version-Map)||
|`"Stopped"`<br>|[](#Schema-Version-Map)||
|`"SavedAsTemplate"`<br>|[](#Schema-Version-Map)||
|`"Unknown"`<br>|[](#Schema-Version-Map)||

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
|`"GuestMemory"`<br>|[2.1](#Schema-Version-Map)||
|`"Statistics"`<br>|[2.1](#Schema-Version-Map)||
|`"ProcessList"`<br>|[2.1](#Schema-Version-Map)||
|`"TerminateOnLastHandleClosed"`<br>|[2.1](#Schema-Version-Map)||
|`"SharedMemoryRegion"`<br>|[2.1](#Schema-Version-Map)||
|`"GuestConnection"`<br>|[2.1](#Schema-Version-Map)||
|`"ICHeartbeatStatus"`<br>|[2.3](#Schema-Version-Map)||

---

<a name = "SystemType"></a>
## SystemType
Referenced by: [Properties](#Properties); [SystemQuery](#SystemQuery)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Container"`<br>|[](#Schema-Version-Map)||
|`"VirtualMachine"`<br>|[](#Schema-Version-Map)||

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



|Variants|NewInVersion|Description|
|---|---|---|
|`"Inactive"`<br>|[](#Schema-Version-Map)||
|`"CrashValues"`<br>|[](#Schema-Version-Map)||
|`"Starting"`<br>|[](#Schema-Version-Map)||
|`"Started"`<br>|[](#Schema-Version-Map)||
|`"Writing"`<br>|[](#Schema-Version-Map)||
|`"Complete"`<br>|[](#Schema-Version-Map)||

---

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


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|[2.1](#Schema-Version-Map)||

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
This class is used by a modify request to add or remove a combined layers structure in the guest. For windows, the GCS applies a filter in ContainerRootPath using the specified layers as the parent content. Ignores property ScratchPath since the container path is already the scratch path. For linux, the GCS unions the specified layers and ScratchPath together, placing the resulting union filesystem at ContainerRootPath.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)||
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


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)||
|**HostingSystemId**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostedSystem**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)||
|**VirtualMachine**<br>|[VirtualMachine](#VirtualMachine)|[2.0](#Schema-Version-Map)||
|**ShouldTerminateOnLastHandleClosed**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

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



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**GuestOs**<br>|[GuestOs](#GuestOs)|[2.0](#Schema-Version-Map)||
|**Storage**<br>|[Storage](#Storage)|[2.0](#Schema-Version-Map)||
|**MappedDirectories**<br>|<[MappedDirectory](#MappedDirectory)> array|[2.0](#Schema-Version-Map)||
|**MappedPipes**<br>|<[MappedPipe](#MappedPipe)> array|[2.0](#Schema-Version-Map)||
|**Memory**<br>|[Container_Memory](#Container_Memory)|[2.0](#Schema-Version-Map)||
|**Processor**<br>|[Container_Processor](#Container_Processor)|[2.0](#Schema-Version-Map)||
|**Networking**<br>|[Networking](#Networking)|[2.0](#Schema-Version-Map)||
|**HvSocket**<br>|[Container_HvSocket](#Container_HvSocket)|[2.0](#Schema-Version-Map)||
|**ContainerCredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)||
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)||
|**AssignedDevices**<br>|<[Device](#Device)> array|[2.1](#Schema-Version-Map)||

---

<a name = "Container_HvSocket"></a>
## Container_HvSocket
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Config**<br>|[HvSocketSystemConfig](#HvSocketSystemConfig)|[2.0](#Schema-Version-Map)||
|**EnablePowerShellDirect**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Container_Memory"></a>
## Container_Memory
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SizeInMB**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)||

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


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardHvSocketServiceConfig"></a>
## ContainerCredentialGuardHvSocketServiceConfig
Referenced by: [ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ServiceId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||
|**ServiceConfig**<br>|[HvSocketServiceConfig](#HvSocketServiceConfig)|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardInstance"></a>
## ContainerCredentialGuardInstance
Referenced by: [ContainerCredentialGuardSystemInfo](#ContainerCredentialGuardSystemInfo)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**CredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)||
|**HvSocketConfig**<br>|[ContainerCredentialGuardHvSocketServiceConfig](#ContainerCredentialGuardHvSocketServiceConfig)|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardOperationRequest"></a>
## ContainerCredentialGuardOperationRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Operation**<br>|[ContainerCredentialGuardModifyOperation](#ContainerCredentialGuardModifyOperation)|[2.1](#Schema-Version-Map)||
|**OperationDetails**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardRemoveInstanceRequest"></a>
## ContainerCredentialGuardRemoveInstanceRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardState"></a>
## ContainerCredentialGuardState
Referenced by: [Container](#Container); [ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Cookie**<br>|[ByteArray](#JSON-type)|[2.1](#Schema-Version-Map)|Authentication cookie for calls to a Container Credential Guard instance.|
|**RpcEndpoint**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Name of the RPC endpoint of the Container Credential Guard instance.|
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)|Transport used for the configured Container Credential Guard instance.|
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|Credential spec used for the configured Container Credential Guard instance.|

---

<a name = "ContainerCredentialGuardSystemInfo"></a>
## ContainerCredentialGuardSystemInfo


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Instances**<br>|<[ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)> array|[2.1](#Schema-Version-Map)||

---

<a name = "CpuGroup"></a>
## CpuGroup
CPU groups allow Hyper-V administrators to better manage and allocate the host's CPU resources across guest virtual machines

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "CrashOptions"></a>
## CrashOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[CrashType](#CrashType)|[2.3](#Schema-Version-Map)||

---

<a name = "CrashReport"></a>
## CrashReport
crash information reported through CrashReport notifications

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SystemId**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**ActivityId**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**WindowsCrashInfo**<br>|[WindowsCrashReport](#WindowsCrashReport)|[](#Schema-Version-Map)||
|**CrashParameters**<br>|<[uint64](#JSON-type)> array|[](#Schema-Version-Map)||
|**CrashLog**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**VmwpDump**<br>|[CrashReportProcessDump](#CrashReportProcessDump)|[](#Schema-Version-Map)||

---

<a name = "CrashReportProcessDump"></a>
## CrashReportProcessDump
Referenced by: [CrashReport](#CrashReport)

Information on auxillary process dumps

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DumpFile**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Status**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||

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

<a name = "Devices"></a>
## Devices
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ComPorts**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [ComPort](#ComPort)>|[2.1](#Schema-Version-Map)||
|**VirtioSerial**<br>|[VirtioSerial](#VirtioSerial)|[2.2](#Schema-Version-Map)||
|**Scsi**<br>|[Map](#JSON-type)<[string](#JSON-type), [Scsi](#Scsi)>|[2.0](#Schema-Version-Map)|Map of named SCSI controllers|
|**VirtualPMem**<br>|[VirtualPMemController](#VirtualPMemController)|[2.0](#Schema-Version-Map)||
|**NetworkAdapters**<br>|[Map](#JSON-type)<[string](#JSON-type), [NetworkAdapter](#NetworkAdapter)>|[2.0](#Schema-Version-Map)||
|**VideoMonitor**<br>|[VideoMonitor](#VideoMonitor)|[2.0](#Schema-Version-Map)||
|**Keyboard**<br>|[Keyboard](#Keyboard)|[2.0](#Schema-Version-Map)||
|**Mouse**<br>|[Mouse](#Mouse)|[2.0](#Schema-Version-Map)||
|**HvSocket**<br>|[VirtualMachine_HvSocket](#VirtualMachine_HvSocket)|[2.1](#Schema-Version-Map)||
|**EnhancedModeVideo**<br>|[EnhancedModeVideo](#EnhancedModeVideo)|[2.1](#Schema-Version-Map)||
|**GuestCrashReporting**<br>|[GuestCrashReporting](#GuestCrashReporting)|[2.0](#Schema-Version-Map)||
|**VirtualSmb**<br>|[VirtualSmb](#VirtualSmb)|[2.0](#Schema-Version-Map)||
|**Plan9**<br>|[Plan9](#Plan9)|[2.0](#Schema-Version-Map)||
|**Battery**<br>|[Battery](#Battery)|[2.0](#Schema-Version-Map)||
|**FlexibleIov**<br>|[Map](#JSON-type)<[string](#JSON-type), [FlexibleIoDevice](#FlexibleIoDevice)>|[2.1](#Schema-Version-Map)||
|**SharedMemory**<br>|[SharedMemoryConfiguration](#SharedMemoryConfiguration)|[2.1](#Schema-Version-Map)||
|**KernelIntegration**<br>|[KernelIntegration](#KernelIntegration)|[2.1](#Schema-Version-Map)||
|**VirtualPci**<br>|[Map](#JSON-type)<[string](#JSON-type), [VirtualPciDevice](#VirtualPciDevice)>|[2.3](#Schema-Version-Map)||

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
|**Message**<br>|[string](#JSON-type)|[](#Schema-Version-Map)|Fully formated error message|
|**StackTrace**<br>|[string](#JSON-type)|[](#Schema-Version-Map)|Stack trace in string form|
|**Provider**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)|Event definition|
|**EventId**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Flags**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**Source**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Data**<br>|<[EventData](#EventData)> array|[](#Schema-Version-Map)||

---

<a name = "EventData"></a>
## EventData
Referenced by: [ErrorEvent](#ErrorEvent)

Event data element

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[EventDataType](#EventDataType)|[](#Schema-Version-Map)||
|**Value**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "ExportLayerOptions"></a>
## ExportLayerOptions


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IsWritableLayer**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "FilteredPropertyQuery"></a>
## FilteredPropertyQuery
Referenced by: [Service_PropertyQuery](#Service_PropertyQuery)

Structures used to perform a filtered property query.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyType**<br>|[Service_PropertyType](#Service_PropertyType)|[](#Schema-Version-Map)|Specifies which property to query.|
|**Filter**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)|Filter - Additional filter to query. The following map describes the relationship between property type and its filter. ["Memory" => HostMemoryQueryRequest]|

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
|**UseVsock**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Use Vsock rather than Hyper-V sockets to communicate with the guest service.|
|**UseConnectedSuspend**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Don't disconnect the guest connection when pausing the virtual machine.|

---

<a name = "GuestConnectionInfo"></a>
## GuestConnectionInfo
Referenced by: [Properties](#Properties)

Information about the guest.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|[](#Schema-Version-Map)|Each schema version x.y stands for the range of versions a.b where a==x and b<=y. This list comes from the SupportedSchemaVersions field in GcsCapabilities.|
|**ProtocolVersion**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**GuestDefinedCapabilities**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)||

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



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

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
Referenced by: [Services](#Services)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "HostedSystem"></a>
## HostedSystem


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)||
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)||

---

<a name = "HvSocketAddress"></a>
## HvSocketAddress
This class defines address settings applied to a VM by the GCS every time a VM starts or restores.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LocalAddress**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**ParentAddress**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||

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
Referenced by: [Properties](#Properties)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IsEnabled**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)|if IC is enabled on this compute system|
|**State**<br>|[IntegrationComponentOperationalState](#IntegrationComponentOperationalState)|[2.3](#Schema-Version-Map)|the current state of the IC inside the VM|
|**Reason**<br>|[IntegrationComponentOperatingStateReason](#IntegrationComponentOperatingStateReason)|[2.3](#Schema-Version-Map)|Explanation for the State|

---

<a name = "IovSettings"></a>
## IovSettings



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "KernelIntegration"></a>
## KernelIntegration
Referenced by: [Devices](#Devices)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

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
|**Id**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**PathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)||
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

<a name = "MappedDirectory"></a>
## MappedDirectory
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostPathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)||
|**ContainerPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SupportCloudFiles**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "MappedPipe"></a>
## MappedPipe
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ContainerPipeName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostPathType**<br>|[MappedPipePathType](#MappedPipePathType)|[2.1](#Schema-Version-Map)||

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



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**VirtualNodeCount**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**VirtualMachineMemory**<br>|[VmMemory](#VmMemory)|[](#Schema-Version-Map)||
|**VirtualNodes**<br>|<[VirtualNodeInfo](#VirtualNodeInfo)> array|[](#Schema-Version-Map)||

---

<a name = "MemoryStats"></a>
## MemoryStats
Referenced by: [Statistics](#Statistics)

Memory runtime statistics

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MemoryUsageCommitBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryUsageCommitPeakBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryUsagePrivateWorkingSetBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "ModificationRequest"></a>
## ModificationRequest
Structure used for service level modification request. Right now, we support modification of a single property type in a call.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyType**<br>|[Service_PropertyType](#Service_PropertyType)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)||

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

<a name = "Mouse"></a>
## Mouse
Referenced by: [Devices](#Devices)




**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

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

<a name = "NetworkModifySettingRequest"></a>
## NetworkModifySettingRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**RequestType**<br>|[NetworkModifyRequestType](#NetworkModifyRequestType)|[](#Schema-Version-Map)||
|**AdapterId**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "NumaSetting"></a>
## NumaSetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**VirtualNodeNumber**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**PhysicalNodeNumber**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**VirtualSocketNumber**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**CountOfProcessors**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**CountOfMemoryBlocks**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

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
|**ProcessId**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**ImageName**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**CreateTimestamp**<br>|[DateTime](#JSON-type)|[](#Schema-Version-Map)||
|**UserTime100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**KernelTime100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryCommitBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryWorkingSetPrivateBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryWorkingSetSharedBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

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
|**TotalRuntime100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**RuntimeUser100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**RuntimeKernel100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

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
Status of a process running in a container

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProcessId**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**Exited**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**ExitCode**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**LastWaitResult**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "Properties"></a>
## Properties


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**SystemType**<br>|[SystemType](#SystemType)|[](#Schema-Version-Map)||
|**RuntimeOsType**<br>|[OsType](#OsType)|[](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**RuntimeId**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**RuntimeTemplateId**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**State**<br>|[State](#State)|[](#Schema-Version-Map)||
|**Stopped**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**ExitType**<br>|[NotificationType](#NotificationType)|[](#Schema-Version-Map)||
|**Memory**<br>|[MemoryInformationForVm](#MemoryInformationForVm)|[](#Schema-Version-Map)||
|**Statistics**<br>|[Statistics](#Statistics)|[](#Schema-Version-Map)||
|**ProcessList**<br>|<[ProcessDetails](#ProcessDetails)> array|[](#Schema-Version-Map)||
|**TerminateOnLastHandleClosed**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**HostingSystemId**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**SharedMemoryRegionInfo**<br>|<[SharedMemoryRegionInfo](#SharedMemoryRegionInfo)> array|[](#Schema-Version-Map)||
|**GuestConnectionInfo**<br>|[GuestConnectionInfo](#GuestConnectionInfo)|[](#Schema-Version-Map)||
|**ICHeartbeatStatus**<br>|[IntegrationComponentStatus](#IntegrationComponentStatus)|[2.3](#Schema-Version-Map)||

---

<a name = "QoSCapabilities"></a>
## QoSCapabilities


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProcessorQoSSupported**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||

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

<a name = "RegistryFlushState"></a>
## RegistryFlushState
Represents the flush state of the registry hive for a windows container's job object.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Enabled**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|Determines whether the flush state of the registry hive is enabled or not. When not enabled, flushes are ignored and changes to the registry are not preserved.|

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
|**Error**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**ErrorMessage**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "Rs4NetworkModifySettingRequest"></a>
## Rs4NetworkModifySettingRequest
This class is only necessary because JSON marshaling complains when we have two fields identical except for capitalization in the same class. Remove this once we stop supporting RS4.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**RequestType**<br>|[NetworkModifyRequestType](#NetworkModifyRequestType)|[](#Schema-Version-Map)||
|**AdapterInstanceID**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)||

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


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyTypes**<br>|<[Service_PropertyType](#Service_PropertyType)> array|[](#Schema-Version-Map)||
|**FilteredQueries**<br>|<[FilteredPropertyQuery](#FilteredPropertyQuery)> array|[](#Schema-Version-Map)||

---

<a name = "ServiceProperties"></a>
## ServiceProperties
The service properties will be returned as an array corresponding to the requested property types.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Properties**<br>|<[Any](#JSON-type)> array|[](#Schema-Version-Map)||

---

<a name = "Services"></a>
## Services
Referenced by: [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Heartbeat**<br>|[Heartbeat](#Heartbeat)|[2.3](#Schema-Version-Map)||

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
|**SectionName**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**GuestPhysicalAddress**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

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
|**Timestamp**<br>|[DateTime](#JSON-type)|[](#Schema-Version-Map)||
|**ContainerStartTime**<br>|[DateTime](#JSON-type)|[](#Schema-Version-Map)||
|**Uptime100ns**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**Processor**<br>|[ProcessorStats](#ProcessorStats)|[](#Schema-Version-Map)||
|**Memory**<br>|[MemoryStats](#MemoryStats)|[](#Schema-Version-Map)||
|**Storage**<br>|[StorageStats](#StorageStats)|[](#Schema-Version-Map)||

---

<a name = "Storage"></a>
## Storage
Referenced by: [Container](#Container)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)|List of layers that describe the parent hierarchy for a container's storage. These layers combined together, presented as a disposable and/or committable working storage, are used by the container to record all changes done to the parent layers.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|Path that points to the scratch space of a container, where parent layers are combined together to present a new disposable and/or committable layer with the changes done during its runtime.|
|**QoS**<br>|[StorageQoS](#StorageQoS)|[2.0](#Schema-Version-Map)||

---

<a name = "StorageQoS"></a>
## StorageQoS
Referenced by: [Storage](#Storage); [VirtualMachine](#VirtualMachine)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IopsMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**BandwidthMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "StorageStats"></a>
## StorageStats
Referenced by: [Statistics](#Statistics)

Storage runtime statistics

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ReadCountNormalized**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**ReadSizeBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**WriteCountNormalized**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**WriteSizeBytes**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "System_PropertyQuery"></a>
## System_PropertyQuery
By default the basic properties will be returned. This query provides a way to request specific properties.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PropertyTypes**<br>|<[System_PropertyType](#System_PropertyType)> array|[](#Schema-Version-Map)||

---

<a name = "SystemExit"></a>
## SystemExit



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "SystemExitStatus"></a>
## SystemExitStatus
Document provided in the EventData parameter of an HcsEventSystemExited event.

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Status**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)|Exit status (HRESULT) for the system.|
|**ExitType**<br>|[NotificationType](#NotificationType)|[2.2](#Schema-Version-Map)|Detailed exit type for the system.|

---

<a name = "SystemQuery"></a>
## SystemQuery


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Ids**<br>|<[string](#JSON-type)> array|[](#Schema-Version-Map)||
|**Names**<br>|<[string](#JSON-type)> array|[](#Schema-Version-Map)||
|**Types**<br>|<[SystemType](#SystemType)> array|[](#Schema-Version-Map)||
|**Owners**<br>|<[string](#JSON-type)> array|[](#Schema-Version-Map)||

---

<a name = "SystemTime"></a>
## SystemTime
Referenced by: [TimeZoneInformation](#TimeZoneInformation); [TimeZoneInformation](#TimeZoneInformation)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Year**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Month**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**DayOfWeek**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Day**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Hour**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Minute**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Second**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Milliseconds**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "TimeZoneInformation"></a>
## TimeZoneInformation


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Bias**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**StandardName**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**StandardDate**<br>|[SystemTime](#SystemTime)|[](#Schema-Version-Map)||
|**StandardBias**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**DaylightName**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**DaylightDate**<br>|[SystemTime](#SystemTime)|[](#Schema-Version-Map)||
|**DaylightBias**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||

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



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Major**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Minor**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

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



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**StopOnReset**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Chipset**<br>|[Chipset](#Chipset)|[2.0](#Schema-Version-Map)||
|**ComputeTopology**<br>|[Topology](#Topology)|[2.0](#Schema-Version-Map)||
|**Devices**<br>|[Devices](#Devices)|[2.0](#Schema-Version-Map)||
|**Services**<br>|[Services](#Services)|[2.3](#Schema-Version-Map)||
|**GuestState**<br>|[GuestState](#GuestState)|[2.1](#Schema-Version-Map)||
|**RestoreState**<br>|[RestoreState](#RestoreState)|[2.0](#Schema-Version-Map)||
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)||
|**StorageQoS**<br>|[StorageQoS](#StorageQoS)|[2.1](#Schema-Version-Map)||
|**GuestConnection**<br>|[GuestConnection](#GuestConnection)|[2.1](#Schema-Version-Map)||

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
|**VirtualNodeIndex**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**PhysicalNodeNumber**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**VirtualProcessorCount**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**MemoryUsageInPages**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||

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
|**AvailableMemory**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**AvailableMemoryBuffer**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**ReservedMemory**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**AssignedMemory**<br>|[uint64](#JSON-type)|[](#Schema-Version-Map)||
|**SlpActive**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**BalancingEnabled**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**DmOperationInProgress**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "WindowsCrashReport"></a>
## WindowsCrashReport
Referenced by: [CrashReport](#CrashReport)

Windows specific crash information

|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DumpFile**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**OsMajorVersion**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsMinorVersion**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsBuildNumber**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsServicePackMajorVersion**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsServicePackMinorVersion**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsSuiteMask**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OsProductType**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**Status**<br>|[int32](#JSON-type)|[](#Schema-Version-Map)||
|**FinalPhase**<br>|[WindowsCrashPhase](#WindowsCrashPhase)|[](#Schema-Version-Map)||

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

The table shows the mapping from type name for field of classes to JSON type, as well as its format and pattern

|Name|JSON Type|Format|Pattern|
|---|---|---|---|
|Any|object|||
|bool|boolean|||
|ByteArray|string|binary||
|DateTime|string|date-time||
|Guid|string||^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$|
|int32|integer|int32||
|int64|integer|int64||
|MacAddress|string|mac-address||
|Map|object|||
|string|string|||
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
