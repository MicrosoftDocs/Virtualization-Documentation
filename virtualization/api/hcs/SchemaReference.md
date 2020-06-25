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
    - [ExitInitiator](#ExitInitiator)
    - [FlexibleIoDeviceHostingModel](#FlexibleIoDeviceHostingModel)
    - [GpuAssignmentMode](#GpuAssignmentMode)
    - [IntegrationComponentOperatingStateReason](#IntegrationComponentOperatingStateReason)
    - [IntegrationComponentOperationalState](#IntegrationComponentOperationalState)
    - [InterruptModerationMode](#InterruptModerationMode)
    - [MappedPipePathType](#MappedPipePathType)
    - [MemoryBackingPageSize](#MemoryBackingPageSize)
    - [ModifyOperation](#ModifyOperation)
    - [ModifyRequestType](#ModifyRequestType)
    - [ModifyResourceType](#ModifyResourceType)
    - [NetworkModifyRequestType](#NetworkModifyRequestType)
    - [NotificationType](#NotificationType)
    - [OperationFailureDetail](#OperationFailureDetail)
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
    - [StateOverride](#StateOverride)
    - [StdHandle](#StdHandle)
    - [System_PropertyType](#System_PropertyType)
    - [SystemExitDetail](#SystemExitDetail)
    - [SystemType](#SystemType)
    - [UefiBootDevice](#UefiBootDevice)
    - [VirtualDeviceFailureDetail](#VirtualDeviceFailureDetail)
    - [VirtualPMemBackingType](#VirtualPMemBackingType)
    - [VirtualPMemImageFormat](#VirtualPMemImageFormat)
    - [WindowsCrashPhase](#WindowsCrashPhase)
    - [WorkerExitDetail](#WorkerExitDetail)
    - [WorkerExitType](#WorkerExitType)
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

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Default"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Use None or global setting.|
|`"None"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Launch VMWP normally.|
|`"AppContainer"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Launch VMWP as an App Container.|

---

<a name = "ApplySecureBootTemplateType"></a>
## ApplySecureBootTemplateType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Skip"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Apply"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "AttachmentType"></a>
## AttachmentType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"VirtualDisk"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Iso"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PassThru"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "CacheMode"></a>
## CacheMode

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Unspecified"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Use the default caching scheme (typically Enabled).|
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Disable caching entirely.|
|`"Enabled"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Enable caching in the system memory partition.|
|`"Private"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Enable caching in the private memory partition.|
|`"PrivateAllowSharing"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Enable caching in the private memory partition, but allow access by other partitions.|

---

<a name = "CachingMode"></a>
## CachingMode

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Uncached"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Use uncached IO to read and write VHD files (default).|
|`"Cached"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Use cached IO for all files.|
|`"ReadOnlyCached"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|Use cached IO for all read-only files in the VHD chain, and uncached IO for writable files.|

---

<a name = "ContainerCredentialGuardModifyOperation"></a>
## ContainerCredentialGuardModifyOperation

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"AddInstance"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"RemoveInstance"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "ContainerCredentialGuardTransport"></a>
## ContainerCredentialGuardTransport

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"LRPC"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"HvSocket"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "CrashType"></a>
## CrashType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"CrashGuest"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)|Crash the guest through an architectured defined mechanism|

---

<a name = "DeviceType"></a>
## DeviceType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"ClassGuid"`<br>|[2.2](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceInstance"`<br>|[2.2](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GpuMirror"`<br>|[2.2](#Schema-Version-Map)|[](#Schema-Version-Map)|Make all GPUs on the host visible to the container.|

---

<a name = "EventDataType"></a>
## EventDataType
Data types for event data elements, based on EVT_VARIANT_TYPE
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Empty"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"String"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"AnsiString"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SByte"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Byte"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Int16"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"UInt16"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Int32"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"UInt32"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Int64"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"UInt64"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Single"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Double"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Boolean"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Binary"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Guid"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "ExitInitiator"></a>
## ExitInitiator
Initiator of an exit (guest, management client, etc.)
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GuestOS"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Initiated by the guest OS (e.g. guest OS shutdown)|
|`"Client"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Initiated by the management client|
|`"Internal"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Initiated internally (e.g. due to an error) by the virtual machine or HCS.|
|`"Unknown"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Initiator is unknown, e.g. a process was terminated or crashed.|

---

<a name = "FlexibleIoDeviceHostingModel"></a>
## FlexibleIoDeviceHostingModel

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Internal"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"External"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "GpuAssignmentMode"></a>
## GpuAssignmentMode

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Do not assign GPU to the guest.|
|`"Default"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Assign the single default GPU to guest, which currently is POST GPU.|
|`"List"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Assign the GPU(s)/partition(s) specified in AssignmentRequest to guest. If AssignmentRequest is empty, do not assign GPU to the guest.|
|`"Mirror"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Assign all current and future GPUs to guest.|

---

<a name = "IntegrationComponentOperatingStateReason"></a>
## IntegrationComponentOperatingStateReason
possible reason for integration component's state
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Unknown"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"AppsInCriticalState"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CommunicationTimedOut"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FailedCommunication"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"HealthyApps"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ProtocolMismatch"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "IntegrationComponentOperationalState"></a>
## IntegrationComponentOperationalState
operational status for integration component
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Unknown"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Degraded"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Dormant"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Error"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"LostCommunication"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"NonRecoverableError"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"NoContact"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Ok"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "InterruptModerationMode"></a>
## InterruptModerationMode
The valid interrupt moderation modes for I/O virtualization (IOV) offloading.
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Default"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Adaptive"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Off"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Low"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Medium"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"High"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "MappedPipePathType"></a>
## MappedPipePathType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"VirtualSmbPipeName"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "MemoryBackingPageSize"></a>
## MemoryBackingPageSize

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Small"`<br>|[2.2](#Schema-Version-Map)|[](#Schema-Version-Map)|Small (4KB) page size unit|
|`"Large"`<br>|[2.2](#Schema-Version-Map)|[](#Schema-Version-Map)|Large (2MB) page size unit|

---

<a name = "ModifyOperation"></a>
## ModifyOperation

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"ConsoleSize"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Update the console size|
|`"CloseHandle"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)|Close one or all of the std handles|

---

<a name = "ModifyRequestType"></a>
## ModifyRequestType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Add"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Remove"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Update"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "ModifyResourceType"></a>
## ModifyResourceType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Memory"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MappedDirectory"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MappedPipe"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MappedVirtualDisk"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CombinedLayers"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"NetworkNamespace"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CimMount"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "NetworkModifyRequestType"></a>
## NetworkModifyRequestType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"PreAdd"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Add"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Remove"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "NotificationType"></a>
## NotificationType
Notification type generated by ComputeSystems
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GracefulExit"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ForcedExit"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"UnexpectedExit"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Unknown"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "OperationFailureDetail"></a>
## OperationFailureDetail

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Invalid"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CreateInternalError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ConstructStateError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"RuntimeOsTypeMismatch"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Construct"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsCreateComputeSystem|
|`"Start"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsStartComputeSystem|
|`"Pause"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsPauseComputeSystem|
|`"Resume"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsResumeComputeSystem|
|`"Shutdown"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsShutdownComputeSystem|
|`"Terminate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsTerminateComputeSystem|
|`"Save"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsSaveComputeSystem|
|`"GetProperties"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsGetComputeSystemProperties|
|`"Modify"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsModifyComputeSystem|
|`"Crash"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsCrashComputeSystem|
|`"GuestCrash"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|A guest OS crash occurred during an HCS API call.|
|`"LifecycleNotify"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ExecuteProcess"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsCreateProcess|
|`"GetProcessInfo"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsGetProcessInfo|
|`"WaitForProcess"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SignalProcess"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsSignalProcess|
|`"ModifyProcess"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|HcsModifyProcess|
|`"PrepareForHosting"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"RegisterHostedSystem"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"UnregisterHostedSystem"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PrepareForClone"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GetCloneTemplate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "OsLayerType"></a>
## OsLayerType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Container"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Vm"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "OsType"></a>
## OsType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Unknown"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Windows"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Linux"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "PathType"></a>
## PathType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"AbsolutePath"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"VirtualSmbShareName"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "PauseReason"></a>
## PauseReason
Pause reason that is indicated to components running in the Virtual Machine.
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Save"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Template"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "PauseSuspensionLevel"></a>
## PauseSuspensionLevel

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Suspend"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MemoryLow"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MemoryMedium"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MemoryHigh"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "ProcessDumpType"></a>
## ProcessDumpType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Heap"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Mini"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Custom"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "ProcessSignal"></a>
## ProcessSignal

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"CtrlC"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CtrlBreak"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CtrlClose"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CtrlLogOff"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CtrlShutdown"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "RegistryHive"></a>
## RegistryHive

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"System"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Software"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Security"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Sam"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "RegistryValueType"></a>
## RegistryValueType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"String"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ExpandedString"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MultiString"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Binary"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DWord"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"QWord"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CustomType"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "SaveType"></a>
## SaveType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"ToFile"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|The system's memory and device states are saved to the runtime state file.|
|`"AsTemplate"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)|The system's device state is saved to the runtime state file. The system is then placed in a state such that other systems can be cloned from it.|

---

<a name = "SerialConsole"></a>
## SerialConsole

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Default"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Disabled"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ComPort1"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ComPort2"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "Service_PropertyType"></a>
## Service_PropertyType
Service property types
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Basic"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Memory"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CpuGroup"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ProcessorTopology"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CacheAllocation"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CacheMonitoring"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ContainerCredentialGuard"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"QoSCapabilities"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MemoryBwAllocation"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Undefined"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "State"></a>
## State
Compute system state which is exposed to external clients
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Created"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Running"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Paused"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Stopped"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SavedAsTemplate"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Unknown"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "StateOverride"></a>
## StateOverride

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Default"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Use the default mode specified by the system|
|`"Disabled"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Enabled"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "StdHandle"></a>
## StdHandle

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"StdIn"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"StdOut"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"StdErr"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"All"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "System_PropertyType"></a>
## System_PropertyType
Compute system property types. The properties will be returned as a Schema.Responses.System.Properties instance.
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Memory"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GuestMemory"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Statistics"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ProcessList"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"TerminateOnLastHandleClosed"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SharedMemoryRegion"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GuestConnection"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ICHeartbeatStatus"`<br>|[2.3](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "SystemExitDetail"></a>
## SystemExitDetail

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Invalid"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"HcsApiFatalError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|An non-recoverable error occurred during an HCS API call.|
|`"ServiceStop"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Forced exit due to stopping the vmcompute service.|
|`"Shutdown"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|If the initiator is ExitInitiator::Client, the exit is due to HcsShutdownComputeSystem If the initiator is ExitInitiator::GuestOS, the exit was initiated by the guest OS.|
|`"Terminate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|Forced exit due to HcsTerminateComputeSystem|
|`"UnexpectedExit"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|The system exited unexpectedly, other attribution records may provide more information.|

---

<a name = "SystemType"></a>
## SystemType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Container"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"VirtualMachine"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Host"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "UefiBootDevice"></a>
## UefiBootDevice

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"ScsiDrive"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"VmbFs"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Network"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"File"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "VirtualDeviceFailureDetail"></a>
## VirtualDeviceFailureDetail
Provides detail on the context in which a virtual device failed.
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Create"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Initialize"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"StartReservingResources"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FinishReservingResources"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FreeReservedResources"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SaveReservedResources"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PowerOnCold"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PowerOnRestore"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PowerOff"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Save"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Resume"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Pause"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"EnableOptimizations"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"StartDisableOptimizations"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FinishDisableOptimizations"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Reset"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PostReset"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Teardown"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"SaveCompatibilityInfo"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricRestore"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricEnumerate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricEnumerateForSave"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricReset"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricEnable"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MetricDisable"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "VirtualPMemBackingType"></a>
## VirtualPMemBackingType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Virtual"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Physical"`<br>|[2.1](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "VirtualPMemImageFormat"></a>
## VirtualPMemImageFormat

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Vhdx"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Vhd1"`<br>|[2.0](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "WindowsCrashPhase"></a>
## WindowsCrashPhase

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Inactive"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CrashValues"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Starting"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Started"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Writing"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Complete"`<br>|[](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "WorkerExitDetail"></a>
## WorkerExitDetail
Detailed reasons for a VM stop
|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"Invalid"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PowerOff"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"PowerOffCritical"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Reset"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GuestCrash"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"GuestFirmwareCrash"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"TripleFault"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceFatalApicRequest"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceFatalMsrRequest"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceFatalException"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceFatalError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"DeviceMachineCheck"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"EmulatorError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"VidTerminate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ProcessUnexpectedExit"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"InitializationFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"InitializationStartTimeout"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ColdStartFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"ResetStartFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FastRestoreStartFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"RestoreStartFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FastSavePreservePartition"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FastSavePreservePartitionHandleTransfer"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"FastSave"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CloneTemplate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Save"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"Migrate"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MigrateFailure"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"CannotReferenceVm"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"MgotUnregister"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||

---

<a name = "WorkerExitType"></a>
## WorkerExitType

|Variants|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|
|`"None"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)||
|`"InitializationFailed"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM Failed to initialize.|
|`"Stopped"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM shutdown after complete stop|
|`"Saved"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM shutdown after complete save|
|`"StoppedOnReset"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM reset and the VM was configured to stop on reset|
|`"UnexpectedStop"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM worker process exited unexpectedly|
|`"ResetFailed"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM exit after failing to reset|
|`"UnrecoverableError"`<br>|[2.4](#Schema-Version-Map)|[](#Schema-Version-Map)|VM stopped because of an unrecoverable error (e.g., storage failure)|

---

# Structs
<a name = "Attachment"></a>
## Attachment

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Type**<br>|[AttachmentType](#AttachmentType)|[2.0](#Schema-Version-Map)|||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CachingMode**<br>|[CachingMode](#CachingMode)|[2.1](#Schema-Version-Map)|||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**SupportCompressedVolumes**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)|||

---

<a name = "AttributionRecord"></a>
## AttributionRecord

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**WorkerExit**<br>|[WorkerExit](#WorkerExit)|[2.4](#Schema-Version-Map)|||
|**GuestCrash**<br>|[GuestCrash](#GuestCrash)|[2.4](#Schema-Version-Map)|||
|**TripleFault**<br>|[TripleFault](#TripleFault)|[2.4](#Schema-Version-Map)|||
|**InjectNonMaskableInterrupt**<br>|[InjectNonMaskableInterrupt](#InjectNonMaskableInterrupt)|[2.4](#Schema-Version-Map)|||
|**OperationFailure**<br>|[OperationFailure](#OperationFailure)|[2.4](#Schema-Version-Map)|||
|**SystemExit**<br>|[SystemExit](#SystemExit)|[2.4](#Schema-Version-Map)|||
|**VirtualDeviceFailure**<br>|[VirtualDeviceFailure](#VirtualDeviceFailure)|[2.4](#Schema-Version-Map)|||

---

<a name = "BasicInformation"></a>
## BasicInformation

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "Battery"></a>
## Battery

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "Chipset"></a>
## Chipset

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Uefi**<br>|[Uefi](#Uefi)|[2.0](#Schema-Version-Map)|||
|**IsNumLockDisabled**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**BaseBoardSerialNumber**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ChassisSerialNumber**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ChassisAssetTag**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**UseUtc**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**LinuxKernelDirect**<br>|[LinuxKernelDirect](#LinuxKernelDirect)|[2.2](#Schema-Version-Map)|||

---

<a name = "CimMount"></a>
## CimMount

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ImagePath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)|||
|**FileSystemName**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)|||
|**VolumeGuid**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)|||

---

<a name = "CloseHandle"></a>
## CloseHandle

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Handle**<br>|[StdHandle](#StdHandle)|[2.0](#Schema-Version-Map)|||

---

<a name = "CombinedLayers"></a>
## CombinedLayers
This class is used by a modify request to add or remove a combined layers structure in the guest. For windows, the GCS applies a filter in ContainerRootPath using the specified layers as the parent content. Ignores property ScratchPath since the container path is already the scratch path. For linux, the GCS unions the specified layers and ScratchPath together, placing the resulting union filesystem at ContainerRootPath.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)|||
|**ScratchPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ContainerRootPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "ComPort"></a>
## ComPort
ComPort specifies the named pipe that will be used for the port, with empty string indicating a disconnected port.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**NamedPipe**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**OptimizeForDebugger**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "ComputeSystem"></a>
## ComputeSystem

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|||
|**HostingSystemId**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**HostedSystem**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)|||
|**VirtualMachine**<br>|[VirtualMachine](#VirtualMachine)|[2.0](#Schema-Version-Map)|||
|**ShouldTerminateOnLastHandleClosed**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "ConsoleSize"></a>
## ConsoleSize

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Height**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Width**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "Container"></a>
## Container

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**GuestOs**<br>|[GuestOs](#GuestOs)|[2.0](#Schema-Version-Map)|||
|**Storage**<br>|[Storage](#Storage)|[2.0](#Schema-Version-Map)|||
|**MappedDirectories**<br>|<[MappedDirectory](#MappedDirectory)> array|[2.0](#Schema-Version-Map)|||
|**MappedPipes**<br>|<[MappedPipe](#MappedPipe)> array|[2.0](#Schema-Version-Map)|||
|**Memory**<br>|[Container_Memory](#Container_Memory)|[2.0](#Schema-Version-Map)|||
|**Processor**<br>|[Container_Processor](#Container_Processor)|[2.0](#Schema-Version-Map)|||
|**Networking**<br>|[Networking](#Networking)|[2.0](#Schema-Version-Map)|||
|**HvSocket**<br>|[Container_HvSocket](#Container_HvSocket)|[2.0](#Schema-Version-Map)|||
|**ContainerCredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)|||
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)|||
|**AssignedDevices**<br>|<[Device](#Device)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "Container_HvSocket"></a>
## Container_HvSocket

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Config**<br>|[HvSocketSystemConfig](#HvSocketSystemConfig)|[2.0](#Schema-Version-Map)|||
|**EnablePowerShellDirect**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "Container_Memory"></a>
## Container_Memory

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SizeInMB**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "Container_Processor"></a>
## Container_Processor
Specifies CPU limits for a container. Count, Maximum and Weight are all mutually exclusive.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Count**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||Optional property that represents the fraction of the configured processor count in a container in relation to the processors available in the host. The fraction ultimately determines the portion of processor cycles that the threads in a container can use during each scheduling interval, as the number of cycles per 10,000 cycles.|
|**Weight**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)||Optional property that limits the share of processor time given to the container relative to other workloads on the processor. The processor weight is a value between 0 and 10000.|
|**Maximum**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)||Optional property that determines the portion of processor cycles that the threads in a container can use during each scheduling interval, as the number of cycles per 10,000 cycles. Set processor maximum to a percentage times 100.|

---

<a name = "ContainerCredentialGuardAddInstanceRequest"></a>
## ContainerCredentialGuardAddInstanceRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)|||

---

<a name = "ContainerCredentialGuardHvSocketServiceConfig"></a>
## ContainerCredentialGuardHvSocketServiceConfig

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ServiceId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**ServiceConfig**<br>|[HvSocketServiceConfig](#HvSocketServiceConfig)|[2.1](#Schema-Version-Map)|||

---

<a name = "ContainerCredentialGuardInstance"></a>
## ContainerCredentialGuardInstance

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**CredentialGuard**<br>|[ContainerCredentialGuardState](#ContainerCredentialGuardState)|[2.1](#Schema-Version-Map)|||
|**HvSocketConfig**<br>|[ContainerCredentialGuardHvSocketServiceConfig](#ContainerCredentialGuardHvSocketServiceConfig)|[2.1](#Schema-Version-Map)|||

---

<a name = "ContainerCredentialGuardOperationRequest"></a>
## ContainerCredentialGuardOperationRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Operation**<br>|[ContainerCredentialGuardModifyOperation](#ContainerCredentialGuardModifyOperation)|[2.1](#Schema-Version-Map)|||
|**OperationDetails**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "ContainerCredentialGuardRemoveInstanceRequest"></a>
## ContainerCredentialGuardRemoveInstanceRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "ContainerCredentialGuardState"></a>
## ContainerCredentialGuardState

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Cookie**<br>|[ByteArray](#JSON-type)|[2.1](#Schema-Version-Map)||Authentication cookie for calls to a Container Credential Guard instance.|
|**RpcEndpoint**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||Name of the RPC endpoint of the Container Credential Guard instance.|
|**Transport**<br>|[ContainerCredentialGuardTransport](#ContainerCredentialGuardTransport)|[2.1](#Schema-Version-Map)||Transport used for the configured Container Credential Guard instance.|
|**CredentialSpec**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||Credential spec used for the configured Container Credential Guard instance.|

---

<a name = "ContainerCredentialGuardSystemInfo"></a>
## ContainerCredentialGuardSystemInfo

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Instances**<br>|<[ContainerCredentialGuardInstance](#ContainerCredentialGuardInstance)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "CpuGroup"></a>
## CpuGroup
CPU groups allow Hyper-V administrators to better manage and allocate the host's CPU resources across guest virtual machines
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "CrashOptions"></a>
## CrashOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Type**<br>|[CrashType](#CrashType)|[2.3](#Schema-Version-Map)|||

---

<a name = "CrashReport"></a>
## CrashReport
crash information reported through CrashReport notifications
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SystemId**<br>|[string](#JSON-type)||||
|**ActivityId**<br>|[Guid](#JSON-type)||||
|**WindowsCrashInfo**<br>|[WindowsCrashReport](#WindowsCrashReport)||||
|**CrashParameters**<br>|<[uint64](#JSON-type)> array||||
|**CrashLog**<br>|[string](#JSON-type)||||
|**VmwpDump**<br>|[CrashReportProcessDump](#CrashReportProcessDump)||||
|**Status**<br>|[int32](#JSON-type)|[2.4](#Schema-Version-Map)||Provides overall status on crash reporting|
|**PreOSId**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)|||
|**CrashStackUnavailable**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)||If true, the guest OS reported that a crash dump stack/handler was unavailable or could not be invoked|

---

<a name = "CrashReportProcessDump"></a>
## CrashReportProcessDump
Information on auxillary process dumps
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DumpFile**<br>|[string](#JSON-type)||||
|**Status**<br>|[int32](#JSON-type)||||

---

<a name = "Device"></a>
## Device

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Type**<br>|[DeviceType](#DeviceType)|[2.2](#Schema-Version-Map)||The type of device to assign to the container.|
|**InterfaceClassGuid**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)||The interface class guid of the device interfaces to assign to the container. Only used when Type is ClassGuid.|
|**LocationPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)||The location path of the device to assign to the container. Only used when Type is DeviceInstance.|

---

<a name = "Devices"></a>
## Devices

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ComPorts**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [ComPort](#ComPort)>|[2.1](#Schema-Version-Map)|||
|**VirtioSerial**<br>|[VirtioSerial](#VirtioSerial)|[2.2](#Schema-Version-Map)|||
|**Scsi**<br>|[Map](#JSON-type)<[string](#JSON-type), [Scsi](#Scsi)>|[2.0](#Schema-Version-Map)|||
|**VirtualPMem**<br>|[VirtualPMemController](#VirtualPMemController)|[2.0](#Schema-Version-Map)|||
|**NetworkAdapters**<br>|[Map](#JSON-type)<[string](#JSON-type), [NetworkAdapter](#NetworkAdapter)>|[2.0](#Schema-Version-Map)|||
|**VideoMonitor**<br>|[VideoMonitor](#VideoMonitor)|[2.0](#Schema-Version-Map)|||
|**Keyboard**<br>|[Keyboard](#Keyboard)|[2.0](#Schema-Version-Map)|||
|**Mouse**<br>|[Mouse](#Mouse)|[2.0](#Schema-Version-Map)|||
|**HvSocket**<br>|[VirtualMachine_HvSocket](#VirtualMachine_HvSocket)|[2.1](#Schema-Version-Map)|||
|**EnhancedModeVideo**<br>|[EnhancedModeVideo](#EnhancedModeVideo)|[2.1](#Schema-Version-Map)|||
|**GuestCrashReporting**<br>|[GuestCrashReporting](#GuestCrashReporting)|[2.0](#Schema-Version-Map)|||
|**VirtualSmb**<br>|[VirtualSmb](#VirtualSmb)|[2.0](#Schema-Version-Map)|||
|**Plan9**<br>|[Plan9](#Plan9)|[2.0](#Schema-Version-Map)|||
|**Battery**<br>|[Battery](#Battery)|[2.0](#Schema-Version-Map)|||
|**FlexibleIov**<br>|[Map](#JSON-type)<[string](#JSON-type), [FlexibleIoDevice](#FlexibleIoDevice)>|[2.1](#Schema-Version-Map)|||
|**SharedMemory**<br>|[SharedMemoryConfiguration](#SharedMemoryConfiguration)|[2.1](#Schema-Version-Map)|||
|**KernelIntegration**<br>|[KernelIntegration](#KernelIntegration)|[2.1](#Schema-Version-Map)|||
|**VirtualPci**<br>|[Map](#JSON-type)<[string](#JSON-type), [VirtualPciDevice](#VirtualPciDevice)>|[2.3](#Schema-Version-Map)|||

---

<a name = "EnhancedModeVideo"></a>
## EnhancedModeVideo

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ConnectionOptions**<br>|[RdpConnectionOptions](#RdpConnectionOptions)|[2.1](#Schema-Version-Map)|||

---

<a name = "ErrorEvent"></a>
## ErrorEvent
Error descriptor that provides the info of an error object
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Message**<br>|[string](#JSON-type)|||Fully formated error message|
|**StackTrace**<br>|[string](#JSON-type)|||Stack trace in string form|
|**Provider**<br>|[Guid](#JSON-type)|||Event definition|
|**EventId**<br>|[uint16](#JSON-type)||||
|**Flags**<br>|[uint32](#JSON-type)||||
|**Source**<br>|[string](#JSON-type)||||
|**Data**<br>|<[EventData](#EventData)> array||||

---

<a name = "EventData"></a>
## EventData
Event data element
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Type**<br>|[EventDataType](#EventDataType)||||
|**Value**<br>|[string](#JSON-type)||||

---

<a name = "ExportLayerOptions"></a>
## ExportLayerOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**IsWritableLayer**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "FilteredPropertyQuery"></a>
## FilteredPropertyQuery
Structures used to perform a filtered property query.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**PropertyType**<br>|[Service_PropertyType](#Service_PropertyType)|||Specifies which property to query.|
|**Filter**<br>|[Any](#JSON-type)|||Filter - Additional filter to query. The following map describes the relationship between property type and its filter. ["Memory" => HostMemoryQueryRequest]|

---

<a name = "FlexibleIoDevice"></a>
## FlexibleIoDevice

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**EmulatorId**<br>|[Guid](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**HostingModel**<br>|[FlexibleIoDeviceHostingModel](#FlexibleIoDeviceHostingModel)|[2.1](#Schema-Version-Map)|||
|**Configuration**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "GpuConfiguration"></a>
## GpuConfiguration

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**AssignmentMode**<br>|[GpuAssignmentMode](#GpuAssignmentMode)|[2.0](#Schema-Version-Map)||The mode used to assign GPUs to the guest.|
|**AssignmentRequest**<br>|[Map](#JSON-type)<[string](#JSON-type), [uint16](#JSON-type)>|[2.0](#Schema-Version-Map)||This only applies to List mode, and is ignored in other modes. In GPU-P, string is GPU device interface, and unit16 is partition id. HCS simply assigns the partition with the input id. In GPU-PV, string is GPU device interface, and unit16 is 0xffff. HCS needs to find an available partition to assign.|
|**AllowVendorExtension**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||Whether we allow vendor extension.|

---

<a name = "GuestConnection"></a>
## GuestConnection

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**UseVsock**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Use Vsock rather than Hyper-V sockets to communicate with the guest service.|
|**UseConnectedSuspend**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Don't disconnect the guest connection when pausing the virtual machine.|
|**UseHostTimeZone**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)||Set the guest's time zone to that of the host|

---

<a name = "GuestConnectionInfo"></a>
## GuestConnectionInfo
Information about the guest.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SupportedSchemaVersions**<br>|<[Version](#Version)> array|||Each schema version x.y stands for the range of versions a.b where a==x and b<=y. This list comes from the SupportedSchemaVersions field in GcsCapabilities.|
|**ProtocolVersion**<br>|[uint32](#JSON-type)||||
|**GuestDefinedCapabilities**<br>|[Any](#JSON-type)||||

---

<a name = "GuestCrash"></a>
## GuestCrash

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**CrashParameters**<br>|<[uint64](#JSON-type)> array|[2.4](#Schema-Version-Map)||Crash parameters as reported by the guest.|

---

<a name = "GuestCrashReporting"></a>
## GuestCrashReporting

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**WindowsCrashSettings**<br>|[WindowsCrashReporting](#WindowsCrashReporting)|[2.0](#Schema-Version-Map)|||

---

<a name = "GuestModifySettingRequest"></a>
## GuestModifySettingRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ResourceType**<br>|[ModifyResourceType](#ModifyResourceType)|[2.1](#Schema-Version-Map)|||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.1](#Schema-Version-Map)|||
|**Settings**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "GuestOs"></a>
## GuestOs

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HostName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "GuestState"></a>
## GuestState

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**GuestStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||The path to an existing file uses for persistent guest state storage. An empty string indicates the system should initialize new transient, in-memory guest state.|
|**RuntimeStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||The path to an existing file for persistent runtime state storage. An empty string indicates the system should initialize new transient, in-memory runtime state.|
|**ForceTransientState**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||If true, the guest state and runtime state files will be used as templates to populate transient, in-memory state instead of using the files as persistent backing store.|

---

<a name = "Heartbeat"></a>
## Heartbeat

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "HostedSystem"></a>
## HostedSystem

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|||
|**Container**<br>|[Container](#Container)|[2.0](#Schema-Version-Map)|||

---

<a name = "HvSocketAddress"></a>
## HvSocketAddress
This class defines address settings applied to a VM by the GCS every time a VM starts or restores.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**LocalAddress**<br>|[Guid](#JSON-type)||||
|**ParentAddress**<br>|[Guid](#JSON-type)||||

---

<a name = "HvSocketServiceConfig"></a>
## HvSocketServiceConfig

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**BindSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||SDDL string that HvSocket will check before allowing a host process to bind to this specific service. If not specified, defaults to the system DefaultBindSecurityDescriptor, defined in HvSocketSystemWpConfig in V1.|
|**ConnectSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||SDDL string that HvSocket will check before allowing a host process to connect to this specific service. If not specified, defaults to the system DefaultConnectSecurityDescriptor, defined in HvSocketSystemWpConfig in V1.|
|**AllowWildcardBinds**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||If true, HvSocket will process wildcard binds for this service/system combination. Wildcard binds are secured in the registry at SOFTWARE/Microsoft/Windows NT/CurrentVersion/Virtualization/HvSocket/WildcardDescriptors|

---

<a name = "HvSocketSystemConfig"></a>
## HvSocketSystemConfig

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DefaultBindSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||SDDL string that HvSocket will check before allowing a host process to bind to an unlisted service for this specific container/VM (not wildcard binds).|
|**DefaultConnectSecurityDescriptor**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||SDDL string that HvSocket will check before allowing a host process to connect to an unlisted service in the VM/container.|
|**ServiceTable**<br>|[Map](#JSON-type)<Guid, [HvSocketServiceConfig](#HvSocketServiceConfig)>|[2.0](#Schema-Version-Map)|||

---

<a name = "IdleProcessorsRequest"></a>
## IdleProcessorsRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**IdleProcessorCount**<br>|[uint32](#JSON-type)|[2.3](#Schema-Version-Map)|||

---

<a name = "InjectNonMaskableInterrupt"></a>
## InjectNonMaskableInterrupt
A non-maskable interrupt (NMI) was inject by the host management client or other tool.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "IntegrationComponentStatus"></a>
## IntegrationComponentStatus

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**IsEnabled**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||if IC is enabled on this compute system|
|**State**<br>|[IntegrationComponentOperationalState](#IntegrationComponentOperationalState)|[2.3](#Schema-Version-Map)||the current state of the IC inside the VM|
|**Reason**<br>|[IntegrationComponentOperatingStateReason](#IntegrationComponentOperatingStateReason)|[2.3](#Schema-Version-Map)||Explanation for the State|

---

<a name = "IovSettings"></a>
## IovSettings

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**OffloadWeight**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||The weight assigned to this port for I/O virtualization (IOV) offloading. Setting this to 0 disables IOV offloading.|
|**QueuePairsRequested**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||The number of queue pairs requested for this port for I/O virtualization (IOV) offloading.|
|**InterruptModeration**<br>|[InterruptModerationMode](#InterruptModerationMode)|[2.4](#Schema-Version-Map)||The interrupt moderation mode for I/O virtualization (IOV) offloading.|

---

<a name = "KernelIntegration"></a>
## KernelIntegration

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "Keyboard"></a>
## Keyboard

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "Layer"></a>
## Layer
Describe the parent hierarchy for a container's storage
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**PathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)|||
|**Cache**<br>|[CacheMode](#CacheMode)|[2.0](#Schema-Version-Map)||Unspecified defaults to Enabled|

---

<a name = "LayerData"></a>
## LayerData

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.1](#Schema-Version-Map)|||
|**Layers**<br>|<[Layer](#Layer)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "LinuxKernelDirect"></a>
## LinuxKernelDirect

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**KernelFilePath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**InitRdPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**KernelCmdLine**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||

---

<a name = "MappedDirectory"></a>
## MappedDirectory

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**HostPathType**<br>|[PathType](#PathType)|[2.1](#Schema-Version-Map)|||
|**ContainerPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**SupportCloudFiles**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)|||

---

<a name = "MappedPipe"></a>
## MappedPipe

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ContainerPipeName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**HostPathType**<br>|[MappedPipePathType](#MappedPipePathType)|[2.1](#Schema-Version-Map)|||

---

<a name = "MappedVirtualDisk"></a>
## MappedVirtualDisk

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ContainerPath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**Lun**<br>|[uint8](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "MemoryInformationForVm"></a>
## MemoryInformationForVm

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**VirtualNodeCount**<br>|[uint8](#JSON-type)||||
|**VirtualMachineMemory**<br>|[VmMemory](#VmMemory)||||
|**VirtualNodes**<br>|<[VirtualNodeInfo](#VirtualNodeInfo)> array||||

---

<a name = "MemoryStats"></a>
## MemoryStats
Memory runtime statistics
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**MemoryUsageCommitBytes**<br>|[uint64](#JSON-type)||||
|**MemoryUsageCommitPeakBytes**<br>|[uint64](#JSON-type)||||
|**MemoryUsagePrivateWorkingSetBytes**<br>|[uint64](#JSON-type)||||

---

<a name = "ModificationRequest"></a>
## ModificationRequest
Structure used for service level modification request. Right now, we support modification of a single property type in a call.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**PropertyType**<br>|[Service_PropertyType](#Service_PropertyType)||||
|**Settings**<br>|[Any](#JSON-type)||||

---

<a name = "ModifySettingRequest"></a>
## ModifySettingRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ResourcePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)|||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**GuestRequest**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "Mouse"></a>
## Mouse

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|

---

<a name = "NetworkAdapter"></a>
## NetworkAdapter

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**EndpointId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**MacAddress**<br>|[MacAddress](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**InstanceId**<br>|[Guid](#JSON-type)|[2.4](#Schema-Version-Map)|||
|**DisableInterruptBatching**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)||Disable interrupt batching (MNF) for network to decrease latency and increase throughput, at per-interrupt processing cost.|
|**IovSettings**<br>|[IovSettings](#IovSettings)|[2.4](#Schema-Version-Map)||The I/O virtualization (IOV) offloading configuration.|
|**ConnectionState**<br>|[StateOverride](#StateOverride)|[2.4](#Schema-Version-Map)||When updating a network adapter, indicates whether the adapter should be connected, disconnected, or updated in place.|

---

<a name = "Networking"></a>
## Networking

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**AllowUnqualifiedDnsQuery**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**DnsSearchList**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**NetworkSharedContainerName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Namespace**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||Guid in windows; string in linux|
|**NetworkAdapters**<br>|<[Guid](#JSON-type)> array|[2.0](#Schema-Version-Map)|||

---

<a name = "NetworkModifySettingRequest"></a>
## NetworkModifySettingRequest

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**RequestType**<br>|[NetworkModifyRequestType](#NetworkModifyRequestType)||||
|**AdapterId**<br>|[string](#JSON-type)||||
|**Settings**<br>|[Any](#JSON-type)||||

---

<a name = "NumaSetting"></a>
## NumaSetting

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**VirtualNodeNumber**<br>|[uint32](#JSON-type)||||
|**PhysicalNodeNumber**<br>|[uint32](#JSON-type)||||
|**VirtualSocketNumber**<br>|[uint32](#JSON-type)||||
|**CountOfProcessors**<br>|[uint32](#JSON-type)||||
|**CountOfMemoryBlocks**<br>|[uint64](#JSON-type)||||

---

<a name = "OperationFailure"></a>
## OperationFailure

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Detail**<br>|[OperationFailureDetail](#OperationFailureDetail)|[2.4](#Schema-Version-Map)|||

---

<a name = "OsLayerOptions"></a>
## OsLayerOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Type**<br>|[OsLayerType](#OsLayerType)|[2.1](#Schema-Version-Map)|||
|**DisableCiCacheOptimization**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "PauseNotification"></a>
## PauseNotification
Notification data that is indicated to components running in the Virtual Machine.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Reason**<br>|[PauseReason](#PauseReason)|[2.1](#Schema-Version-Map)|||

---

<a name = "PauseOptions"></a>
## PauseOptions
Options for HcsPauseComputeSystem
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SuspensionLevel**<br>|[PauseSuspensionLevel](#PauseSuspensionLevel)|[2.0](#Schema-Version-Map)|||
|**HostedNotification**<br>|[PauseNotification](#PauseNotification)|[2.1](#Schema-Version-Map)|||

---

<a name = "Plan9"></a>
## Plan9

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Shares**<br>|<[Plan9Share](#Plan9Share)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "Plan9Share"></a>
## Plan9Share

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**AccessName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||The name by which the guest operation system can access this share, via the aname parameter in the Plan9 protocol.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Port**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**AllowedFiles**<br>|<[string](#JSON-type)> array|[2.2](#Schema-Version-Map)|||

---

<a name = "ProcessDetails"></a>
## ProcessDetails
Information about a process running in a container
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ProcessId**<br>|[uint32](#JSON-type)||||
|**ImageName**<br>|[string](#JSON-type)||||
|**CreateTimestamp**<br>|[DateTime](#JSON-type)||||
|**UserTime100ns**<br>|[uint64](#JSON-type)||||
|**KernelTime100ns**<br>|[uint64](#JSON-type)||||
|**MemoryCommitBytes**<br>|[uint64](#JSON-type)||||
|**MemoryWorkingSetPrivateBytes**<br>|[uint64](#JSON-type)||||
|**MemoryWorkingSetSharedBytes**<br>|[uint64](#JSON-type)||||

---

<a name = "ProcessModifyRequest"></a>
## ProcessModifyRequest
Passed to HcsRpc_ModifyProcess
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Operation**<br>|[ModifyOperation](#ModifyOperation)|[2.0](#Schema-Version-Map)|||
|**ConsoleSize**<br>|[ConsoleSize](#ConsoleSize)|[2.0](#Schema-Version-Map)|||
|**CloseHandle**<br>|[CloseHandle](#CloseHandle)|[2.0](#Schema-Version-Map)|||

---

<a name = "ProcessorLimits"></a>
## ProcessorLimits
Used when modifying processor scheduling limits of a virtual machine.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Limit**<br>|[uint64](#JSON-type)|[2.4](#Schema-Version-Map)||Maximum amount of host CPU resources that the virtual machine can use.|
|**Weight**<br>|[uint64](#JSON-type)|[2.4](#Schema-Version-Map)||Value describing the relative priority of this virtual machine compared to other virtual machines.|
|**Reservation**<br>|[uint64](#JSON-type)|[2.4](#Schema-Version-Map)||Minimum amount of host CPU resources that the virtual machine is guaranteed.|
|**MaximumFrequencyMHz**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||Provides the target maximum CPU frequency, in MHz, for a virtual machine.|

---

<a name = "ProcessorStats"></a>
## ProcessorStats
CPU runtime statistics
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**TotalRuntime100ns**<br>|[uint64](#JSON-type)||||
|**RuntimeUser100ns**<br>|[uint64](#JSON-type)||||
|**RuntimeKernel100ns**<br>|[uint64](#JSON-type)||||

---

<a name = "ProcessParameters"></a>
## ProcessParameters

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ApplicationName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CommandLine**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CommandArgs**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||optional alternative to CommandLine, currently only supported by Linux GCS|
|**User**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**WorkingDirectory**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Environment**<br>|[Map](#JSON-type)<[string](#JSON-type), [string](#JSON-type)>|[2.0](#Schema-Version-Map)|||
|**RestrictedToken**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||if set, will run as low-privilege process|
|**EmulateConsole**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||if set, ignore StdErrPipe|
|**CreateStdInPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CreateStdOutPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CreateStdErrPipe**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ConsoleSize**<br>|<[uint16](#JSON-type), 2> array|[2.0](#Schema-Version-Map)||height then width|
|**UseExistingLogin**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||if set, find an existing session for the user and create the process in it|
|**UseLegacyConsole**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||if set, use the legacy console instead of conhost|

---

<a name = "ProcessStatus"></a>
## ProcessStatus
Status of a process running in a container
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ProcessId**<br>|[uint32](#JSON-type)||||
|**Exited**<br>|[bool](#JSON-type)||||
|**ExitCode**<br>|[uint32](#JSON-type)||||
|**LastWaitResult**<br>|[int32](#JSON-type)||||

---

<a name = "Properties"></a>
## Properties

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Id**<br>|[string](#JSON-type)||||
|**SystemType**<br>|[SystemType](#SystemType)||||
|**RuntimeOsType**<br>|[OsType](#OsType)||||
|**Name**<br>|[string](#JSON-type)||||
|**Owner**<br>|[string](#JSON-type)||||
|**RuntimeId**<br>|[Guid](#JSON-type)||||
|**RuntimeTemplateId**<br>|[string](#JSON-type)||||
|**State**<br>|[State](#State)||||
|**Stopped**<br>|[bool](#JSON-type)||||
|**ExitType**<br>|[NotificationType](#NotificationType)||||
|**Memory**<br>|[MemoryInformationForVm](#MemoryInformationForVm)||||
|**Statistics**<br>|[Statistics](#Statistics)||||
|**ProcessList**<br>|<[ProcessDetails](#ProcessDetails)> array||||
|**TerminateOnLastHandleClosed**<br>|[bool](#JSON-type)||||
|**HostingSystemId**<br>|[string](#JSON-type)||||
|**SharedMemoryRegionInfo**<br>|<[SharedMemoryRegionInfo](#SharedMemoryRegionInfo)> array||||
|**GuestConnectionInfo**<br>|[GuestConnectionInfo](#GuestConnectionInfo)||||
|**ICHeartbeatStatus**<br>|[IntegrationComponentStatus](#IntegrationComponentStatus)|[2.3](#Schema-Version-Map)|||

---

<a name = "QoSCapabilities"></a>
## QoSCapabilities

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ProcessorQoSSupported**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "RdpConnectionOptions"></a>
## RdpConnectionOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**AccessSids**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|||
|**NamedPipe**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "RegistryChanges"></a>
## RegistryChanges

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**AddValues**<br>|<[RegistryValue](#RegistryValue)> array|[2.0](#Schema-Version-Map)|||
|**DeleteKeys**<br>|<[RegistryKey](#RegistryKey)> array|[2.0](#Schema-Version-Map)|||

---

<a name = "RegistryFlushState"></a>
## RegistryFlushState
Represents the flush state of the registry hive for a windows container's job object.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Enabled**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Determines whether the flush state of the registry hive is enabled or not. When not enabled, flushes are ignored and changes to the registry are not preserved.|

---

<a name = "RegistryKey"></a>
## RegistryKey

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Hive**<br>|[RegistryHive](#RegistryHive)|[2.0](#Schema-Version-Map)|||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Volatile**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "RegistryValue"></a>
## RegistryValue

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Key**<br>|[RegistryKey](#RegistryKey)|[2.0](#Schema-Version-Map)|||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Type**<br>|[RegistryValueType](#RegistryValueType)|[2.0](#Schema-Version-Map)|||
|**StringValue**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||One and only one value type must be set.|
|**BinaryValue**<br>|[ByteArray](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**DWordValue**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**QWordValue**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**CustomType**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||Only used if RegistryValueType is CustomType The data is in BinaryValue|

---

<a name = "RestoreState"></a>
## RestoreState

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SaveStateFilePath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||The path to the save state file to restore the system from.|
|**TemplateSystemId**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||The ID of the template system to clone this new system off of. An empty string indicates the system should not be cloned from a template.|

---

<a name = "ResultError"></a>
## ResultError
Extended error information returned by the HCS
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Error**<br>|[int32](#JSON-type)||||
|**ErrorMessage**<br>|[string](#JSON-type)||||
|**ErrorEvents**<br>|<[ErrorEvent](#ErrorEvent)> array|[2.4](#Schema-Version-Map)|||
|**Attribution**<br>|<[AttributionRecord](#AttributionRecord)> array|[2.4](#Schema-Version-Map)|||

---

<a name = "Rs4NetworkModifySettingRequest"></a>
## Rs4NetworkModifySettingRequest
This class is only necessary because JSON marshaling complains when we have two fields identical except for capitalization in the same class. Remove this once we stop supporting RS4.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**RequestType**<br>|[NetworkModifyRequestType](#NetworkModifyRequestType)||||
|**AdapterInstanceID**<br>|[Guid](#JSON-type)||||
|**Settings**<br>|[Any](#JSON-type)||||

---

<a name = "SaveOptions"></a>
## SaveOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SaveType**<br>|[SaveType](#SaveType)|[2.1](#Schema-Version-Map)||The type of save operation to be performed.|
|**SaveStateFilePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||The path to the file that will container the saved state.|

---

<a name = "Scsi"></a>
## Scsi

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Attachments**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [Attachment](#Attachment)>|[2.0](#Schema-Version-Map)||Map of attachments, where the key is the integer LUN number on the controller.|
|**DisableInterruptBatching**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)||Disable interrupt batching (MNF) for storage to decrease latency and increase throughput, at per-interrupt processing cost.|

---

<a name = "Service_PropertyQuery"></a>
## Service_PropertyQuery

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**PropertyTypes**<br>|<[Service_PropertyType](#Service_PropertyType)> array||||
|**FilteredQueries**<br>|<[FilteredPropertyQuery](#FilteredPropertyQuery)> array||||

---

<a name = "ServiceProperties"></a>
## ServiceProperties
The service properties will be returned as an array corresponding to the requested property types.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Properties**<br>|<[Any](#JSON-type)> array||||

---

<a name = "Services"></a>
## Services

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Heartbeat**<br>|[Heartbeat](#Heartbeat)|[2.3](#Schema-Version-Map)|||

---

<a name = "SharedMemoryConfiguration"></a>
## SharedMemoryConfiguration

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Regions**<br>|<[SharedMemoryRegion](#SharedMemoryRegion)> array|[2.1](#Schema-Version-Map)|||

---

<a name = "SharedMemoryRegion"></a>
## SharedMemoryRegion

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SectionName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**StartOffset**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Length**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**AllowGuestWrite**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**HiddenFromGuest**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "SharedMemoryRegionInfo"></a>
## SharedMemoryRegionInfo

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SectionName**<br>|[string](#JSON-type)||||
|**GuestPhysicalAddress**<br>|[uint64](#JSON-type)||||

---

<a name = "SignalProcessOptions"></a>
## SignalProcessOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Signal**<br>|[ProcessSignal](#ProcessSignal)|[2.1](#Schema-Version-Map)|||

---

<a name = "Statistics"></a>
## Statistics
Runtime statistics for a container
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Timestamp**<br>|[DateTime](#JSON-type)||||
|**ContainerStartTime**<br>|[DateTime](#JSON-type)||||
|**Uptime100ns**<br>|[uint64](#JSON-type)||||
|**Processor**<br>|[ProcessorStats](#ProcessorStats)||||
|**Memory**<br>|[MemoryStats](#MemoryStats)||||
|**Storage**<br>|[StorageStats](#StorageStats)||||

---

<a name = "Storage"></a>
## Storage

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Layers**<br>|<[Layer](#Layer)> array|[2.0](#Schema-Version-Map)||List of layers that describe the parent hierarchy for a container's storage. These layers combined together, presented as a disposable and/or committable working storage, are used by the container to record all changes done to the parent layers.|
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||Path that points to the scratch space of a container, where parent layers are combined together to present a new disposable and/or committable layer with the changes done during its runtime.|
|**QoS**<br>|[StorageQoS](#StorageQoS)|[2.0](#Schema-Version-Map)|||

---

<a name = "StorageQoS"></a>
## StorageQoS

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**IopsMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**BandwidthMaximum**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "StorageStats"></a>
## StorageStats
Storage runtime statistics
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ReadCountNormalized**<br>|[uint64](#JSON-type)||||
|**ReadSizeBytes**<br>|[uint64](#JSON-type)||||
|**WriteCountNormalized**<br>|[uint64](#JSON-type)||||
|**WriteSizeBytes**<br>|[uint64](#JSON-type)||||

---

<a name = "System_PropertyQuery"></a>
## System_PropertyQuery
By default the basic properties will be returned. This query provides a way to request specific properties.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**PropertyTypes**<br>|<[System_PropertyType](#System_PropertyType)> array||||

---

<a name = "SystemExit"></a>
## SystemExit

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Detail**<br>|[SystemExitDetail](#SystemExitDetail)|[2.4](#Schema-Version-Map)|||
|**Initiator**<br>|[ExitInitiator](#ExitInitiator)|[2.4](#Schema-Version-Map)|||

---

<a name = "SystemExitStatus"></a>
## SystemExitStatus
Document provided in the EventData parameter of an HcsEventSystemExited event.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Status**<br>|[int32](#JSON-type)|[2.1](#Schema-Version-Map)||Exit status (HRESULT) for the system.|
|**ExitType**<br>|[NotificationType](#NotificationType)|[2.2](#Schema-Version-Map)||Detailed exit type for the system.|
|**Attribution**<br>|<[AttributionRecord](#AttributionRecord)> array|[2.4](#Schema-Version-Map)|||

---

<a name = "SystemQuery"></a>
## SystemQuery

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Ids**<br>|<[string](#JSON-type)> array||||
|**Names**<br>|<[string](#JSON-type)> array||||
|**Types**<br>|<[SystemType](#SystemType)> array||||
|**Owners**<br>|<[string](#JSON-type)> array||||

---

<a name = "SystemTime"></a>
## SystemTime

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Year**<br>|[uint16](#JSON-type)||||
|**Month**<br>|[uint16](#JSON-type)||||
|**DayOfWeek**<br>|[uint16](#JSON-type)||||
|**Day**<br>|[uint16](#JSON-type)||||
|**Hour**<br>|[uint16](#JSON-type)||||
|**Minute**<br>|[uint16](#JSON-type)||||
|**Second**<br>|[uint16](#JSON-type)||||
|**Milliseconds**<br>|[uint16](#JSON-type)||||

---

<a name = "TimeZoneInformation"></a>
## TimeZoneInformation

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Bias**<br>|[int32](#JSON-type)||||
|**StandardName**<br>|[string](#JSON-type)||||
|**StandardDate**<br>|[SystemTime](#SystemTime)||||
|**StandardBias**<br>|[int32](#JSON-type)||||
|**DaylightName**<br>|[string](#JSON-type)||||
|**DaylightDate**<br>|[SystemTime](#SystemTime)||||
|**DaylightBias**<br>|[int32](#JSON-type)||||

---

<a name = "Topology"></a>
## Topology

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Memory**<br>|[VirtualMachine_Memory](#VirtualMachine_Memory)|[2.0](#Schema-Version-Map)|||
|**Processor**<br>|[VirtualMachine_Processor](#VirtualMachine_Processor)|[2.0](#Schema-Version-Map)|||

---

<a name = "TripleFault"></a>
## TripleFault

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ErrorType**<br>|[uint64](#JSON-type)|[2.4](#Schema-Version-Map)|||

---

<a name = "Uefi"></a>
## Uefi

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**EnableDebugger**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**SecureBootTemplateId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ApplySecureBootTemplate**<br>|[ApplySecureBootTemplateType](#ApplySecureBootTemplateType)|[2.3](#Schema-Version-Map)|||
|**BootThis**<br>|[UefiBootEntry](#UefiBootEntry)|[2.0](#Schema-Version-Map)|||
|**Console**<br>|[SerialConsole](#SerialConsole)|[2.0](#Schema-Version-Map)|||
|**StopOnBootFailure**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|||

---

<a name = "UefiBootEntry"></a>
## UefiBootEntry

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DeviceType**<br>|[UefiBootDevice](#UefiBootDevice)|[2.1](#Schema-Version-Map)|||
|**DevicePath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**DiskNumber**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**OptionalData**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**VmbFsRootPath**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "Version"></a>
## Version

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Major**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Minor**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "VideoMonitor"></a>
## VideoMonitor

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HorizontalResolution**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**VerticalResolution**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**ConnectionOptions**<br>|[RdpConnectionOptions](#RdpConnectionOptions)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtioSerial"></a>
## VirtioSerial

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Ports**<br>|[Map](#JSON-type)<[uint32](#JSON-type), [VirtioSerialPort](#VirtioSerialPort)>|[2.2](#Schema-Version-Map)|||

---

<a name = "VirtioSerialPort"></a>
## VirtioSerialPort

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**NamedPipe**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**Name**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||

---

<a name = "VirtualDeviceFailure"></a>
## VirtualDeviceFailure
Provides information on failures originated by a virtual device.
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Detail**<br>|[VirtualDeviceFailureDetail](#VirtualDeviceFailureDetail)|[2.4](#Schema-Version-Map)|||
|**Name**<br>|[string](#JSON-type)|[2.4](#Schema-Version-Map)||Friendly name of the virtual device.|
|**DeviceId**<br>|[Guid](#JSON-type)|[2.4](#Schema-Version-Map)||Id of the virtual device.|
|**InstanceId**<br>|[Guid](#JSON-type)|[2.4](#Schema-Version-Map)||Instance Id of the virtual device.|

---

<a name = "VirtualMachine"></a>
## VirtualMachine

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Version**<br>|[Version](#Version)|[2.5](#Schema-Version-Map)||The virtual machine's version that defines which virtual device's features and which virtual machine features the virtual machine supports. If a version isn't specified, the latest version will be used|
|**StopOnReset**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Chipset**<br>|[Chipset](#Chipset)|[2.0](#Schema-Version-Map)|||
|**ComputeTopology**<br>|[Topology](#Topology)|[2.0](#Schema-Version-Map)|||
|**Devices**<br>|[Devices](#Devices)|[2.0](#Schema-Version-Map)|||
|**Services**<br>|[Services](#Services)|[2.3](#Schema-Version-Map)|||
|**GuestState**<br>|[GuestState](#GuestState)|[2.1](#Schema-Version-Map)|||
|**RestoreState**<br>|[RestoreState](#RestoreState)|[2.0](#Schema-Version-Map)|||
|**RegistryChanges**<br>|[RegistryChanges](#RegistryChanges)|[2.0](#Schema-Version-Map)|||
|**StorageQoS**<br>|[StorageQoS](#StorageQoS)|[2.1](#Schema-Version-Map)|||
|**GuestConnection**<br>|[GuestConnection](#GuestConnection)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtualMachine_HvSocket"></a>
## VirtualMachine_HvSocket
HvSocket configuration for a VM
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HvSocketConfig**<br>|[HvSocketSystemConfig](#HvSocketSystemConfig)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtualMachine_Memory"></a>
## VirtualMachine_Memory

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**SizeInMB**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**AllowOvercommit**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||If enabled, then the VM's memory is backed by the Windows pagefile rather than physically backed, statically allocated memory.|
|**BackingPageSize**<br>|[MemoryBackingPageSize](#MemoryBackingPageSize)|[2.2](#Schema-Version-Map)||The preferred page size unit (chunk size) used when allocating backing pages for the VM.|
|**FaultClusterSizeShift**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||Fault clustering size for primary RAM.|
|**DirectMapFaultClusterSizeShift**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||Fault clustering size for direct mapped memory.|
|**PinBackingPages**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||If enabled, then each backing page is physically pinned on first access.|
|**ForbidSmallBackingPages**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||If enabled, then backing page chunks smaller than the backing page size are never used unless the system is under extreme memory pressure. If the backing page size is Small, then it is forced to Large when this option is enabled.|
|**EnableHotHint**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||If enabled, then the memory hot hint feature is exposed to the VM, allowing it to prefetch pages into its working set. (if supported by the guest operating system).|
|**EnableColdHint**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||If enabled, then the memory cold hint feature is exposed to the VM, allowing it to trim zeroed pages from its working set (if supported by the guest operating system).|
|**EnableColdDiscardHint**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)||If enabled, then the memory cold discard hint feature is exposed to the VM, allowing it to trim non-zeroed pages from the working set (if supported by the guest operating system).|
|**EnableDeferredCommit**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||If enabled, then commit is not charged for each backing page until first access.|
|**LowMmioGapInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)||Low MMIO region allocated below 4GB|
|**HighMmioBaseInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)||High MMIO region allocated above 4GB (base and size)|
|**HighMmioGapInMB**<br>|[uint64](#JSON-type)|[2.3](#Schema-Version-Map)|||

---

<a name = "VirtualMachine_Processor"></a>
## VirtualMachine_Processor

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Count**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Limit**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**Weight**<br>|[uint64](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**Reservation**<br>|[uint64](#JSON-type)|[2.4](#Schema-Version-Map)|||
|**MaximumFrequencyMHz**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||Provides the target maximum CPU frequency, in MHz, for a virtual machine.|
|**ExposeVirtualizationExtensions**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**EnablePerfmonPmu**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**EnablePerfmonPebs**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**EnablePerfmonLbr**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**EnablePerfmonIpt**<br>|[bool](#JSON-type)|[2.2](#Schema-Version-Map)|||

---

<a name = "VirtualNodeInfo"></a>
## VirtualNodeInfo

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**VirtualNodeIndex**<br>|[uint8](#JSON-type)||||
|**PhysicalNodeNumber**<br>|[uint8](#JSON-type)||||
|**VirtualProcessorCount**<br>|[uint32](#JSON-type)||||
|**MemoryUsageInPages**<br>|[uint64](#JSON-type)||||

---

<a name = "VirtualPciDevice"></a>
## VirtualPciDevice

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Functions**<br>|<[VirtualPciFunction](#VirtualPciFunction)> array|[2.3](#Schema-Version-Map)|||

---

<a name = "VirtualPciFunction"></a>
## VirtualPciFunction

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DeviceInstancePath**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)|||
|**VirtualFunction**<br>|[uint16](#JSON-type)|[2.3](#Schema-Version-Map)|||
|**AllowDirectTranslatedP2P**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)|||

---

<a name = "VirtualPMemController"></a>
## VirtualPMemController

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Devices**<br>|[Map](#JSON-type)<[uint8](#JSON-type), [VirtualPMemDevice](#VirtualPMemDevice)>|[2.0](#Schema-Version-Map)|||
|**MaximumCount**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||This field indicates how many empty devices to add to the controller. If non-zero, additional VirtualPMemDevice objects with no HostPath and no Mappings will be added to the Devices map to get up to the MaximumCount. These devices will be configured with either the MaximumSizeBytes field if non-zero, or with the default maximum, 512 Mb.|
|**MaximumSizeBytes**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Backing**<br>|[VirtualPMemBackingType](#VirtualPMemBackingType)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtualPMemDevice"></a>
## VirtualPMemDevice

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ReadOnly**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**ImageFormat**<br>|[VirtualPMemImageFormat](#VirtualPMemImageFormat)|[2.0](#Schema-Version-Map)|||
|**SizeBytes**<br>|[uint64](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**Mappings**<br>|[Map](#JSON-type)<[uint64](#JSON-type), [VirtualPMemMapping](#VirtualPMemMapping)>|[2.2](#Schema-Version-Map)|||

---

<a name = "VirtualPMemMapping"></a>
## VirtualPMemMapping

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**HostPath**<br>|[string](#JSON-type)|[2.2](#Schema-Version-Map)|||
|**ImageFormat**<br>|[VirtualPMemImageFormat](#VirtualPMemImageFormat)|[2.2](#Schema-Version-Map)|||

---

<a name = "VirtualSmb"></a>
## VirtualSmb

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Shares**<br>|<[VirtualSmbShare](#VirtualSmbShare)> array|[2.1](#Schema-Version-Map)|||
|**DirectFileMappingInMB**<br>|[int64](#JSON-type)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtualSmbShare"></a>
## VirtualSmbShare

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**Path**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**AllowedFiles**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)|||
|**Options**<br>|[VirtualSmbShareOptions](#VirtualSmbShareOptions)|[2.1](#Schema-Version-Map)|||

---

<a name = "VirtualSmbShareOptions"></a>
## VirtualSmbShareOptions

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ReadOnly**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)|||
|**ShareRead**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||convert exclusive access to shared read access|
|**CacheIo**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||all opens will use cached I/O|
|**NoOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||disable oplock support|
|**TakeBackupPrivilege**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Acquire the backup privilege when attempting to open|
|**UseShareRootIdentity**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Use the identity of the share root when opening|
|**NoDirectmap**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||disable Direct Mapping|
|**NoLocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||disable Byterange locks|
|**NoDirnotify**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||disable Directory CHange Notifications|
|**VmSharedMemory**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||share is use for VM shared memory|
|**RestrictFileAccess**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||allow access only to the files specified in AllowedFiles|
|**ForceLevelIIOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||disable all oplocks except Level II|
|**ReparseBaseLayer**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Allow the host to reparse this base layer|
|**PseudoOplocks**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Enable pseudo-oplocks|
|**NonCacheIo**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||All opens will use non-cached IO|
|**PseudoDirnotify**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Enable pseudo directory change notifications|
|**SingleFileMapping**<br>|[bool](#JSON-type)|[2.1](#Schema-Version-Map)||Block directory enumeration, renames, and deletes.|
|**SupportCloudFiles**<br>|[bool](#JSON-type)|[2.3](#Schema-Version-Map)||Support Cloud Files functionality|
|**FilterEncryptionAttributes**<br>|[bool](#JSON-type)|[2.4](#Schema-Version-Map)||Filter EFS attributes from the guest|

---

<a name = "VmMemory"></a>
## VmMemory

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**AvailableMemory**<br>|[int32](#JSON-type)||||
|**AvailableMemoryBuffer**<br>|[int32](#JSON-type)||||
|**ReservedMemory**<br>|[uint64](#JSON-type)||||
|**AssignedMemory**<br>|[uint64](#JSON-type)||||
|**SlpActive**<br>|[bool](#JSON-type)||||
|**BalancingEnabled**<br>|[bool](#JSON-type)||||
|**DmOperationInProgress**<br>|[bool](#JSON-type)||||

---

<a name = "WindowsCrashReport"></a>
## WindowsCrashReport
Windows specific crash information
|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DumpFile**<br>|[string](#JSON-type)||||
|**OsMajorVersion**<br>|[uint32](#JSON-type)||||
|**OsMinorVersion**<br>|[uint32](#JSON-type)||||
|**OsBuildNumber**<br>|[uint32](#JSON-type)||||
|**OsServicePackMajorVersion**<br>|[uint32](#JSON-type)||||
|**OsServicePackMinorVersion**<br>|[uint32](#JSON-type)||||
|**OsSuiteMask**<br>|[uint32](#JSON-type)||||
|**OsProductType**<br>|[uint32](#JSON-type)||||
|**Status**<br>|[int32](#JSON-type)||||
|**FinalPhase**<br>|[WindowsCrashPhase](#WindowsCrashPhase)||||

---

<a name = "WindowsCrashReporting"></a>
## WindowsCrashReporting

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**DumpFileName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)|||
|**MaxDumpSize**<br>|[int64](#JSON-type)|[2.0](#Schema-Version-Map)|||

---

<a name = "WorkerExit"></a>
## WorkerExit

|Field|Type|NewInVersion|RemovedInVersion|Description|
|---|---|---|---|---|
|**ExitCode**<br>|[uint32](#JSON-type)|[2.4](#Schema-Version-Map)||Exit code of the virtual machine worker process.|
|**Type**<br>|[WorkerExitType](#WorkerExitType)|[2.4](#Schema-Version-Map)|||
|**Detail**<br>|[WorkerExitDetail](#WorkerExitDetail)|[2.4](#Schema-Version-Map)|||
|**Initiator**<br>|[ExitInitiator](#ExitInitiator)|[2.4](#Schema-Version-Map)|||

---

<a name = "JSON-type"></a>
### JSON type
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
### Schema Version Map

|Schema Version|Release Version|
|---|---|
|2.0|RS5|
|2.1|RS5|
|2.2|19H1|
|2.3|Vibranium|
|2.4|Manganese|
---