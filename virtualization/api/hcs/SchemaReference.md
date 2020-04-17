# JSON Schema Reference - mamezgeb-hcs branch
[//]: # does Schema.linix.mars shows all classes as private


<a name="attributionrecord"></a>
## AttributionRecord

|Name|Schema|
|---|---|
|**WorkerExit**  <br>*optional*|WorkerExit|
|**GuestCrash**  <br>*optional*|GuestCrash|
|**TripleFault**  <br>*optional*|TripleFault|
|**OperationFailure**  <br>*optional*|OperationFailure|
|**SystemExit**  <br>*optional*|SystemExit|
|**VirtualDeviceFailure**  <br>*optional*|VirtualDeviceFailure|
|**InjectNonMaskableInterrupt**  <br>*optional*|InjectNonMaskableInterrupt|
|**VirtualDeviceFailure**  <br>*optional*|VirtualDeviceFailure|


<a name="attachment"></a>
## Attachment

|Name|Schema|
|---|---|
|**CachingMode**  <br>*optional*|enum (Uncached, Cached, ReadOnlyCached)|
|**Path**  <br>*optional*|string|
|**ReadOnly**  <br>*optional*|boolean|
|**SupportCompressedVolumes**  <br>*optional*|boolean|
|**Type**  <br>*optional*|enum (VirtualDisk, Iso, PassThru)|


<a name="battery"></a>
## Battery
*Type* : object

<a name="BatchedBinding"></a>
## BatchedBinding

|Name|Schema|
|---|---|
|**FilePath**  <br>*optional*|string|
|**BindingRoots[]**  <br>*optional*|string|


<a name="cachequerystatsresponse"></a>
## CacheQueryStatsResponse

|Name|Schema|
|---|---|
|**L3OccupancyBytes**  <br>|uint64|
|**L3TotalBwBytes**  <br>|uint64|
|**L3LocalBwBytes**  <br>|uint64|


<a name="chipset"></a>
## Chipset

|Name|Schema|
|---|---|
|**BaseBoardSerialNumber**  <br>*optional*|string|
|**ChassisAssetTag**  <br>*optional*|string|
|**ChassisSerialNumber**  <br>*optional*|string|
|**IsNumLockDisabled**  <br>*optional*|boolean|
|**LinuxKernelDirect**  <br>*optional*|[LinuxKernelDirect](#linuxkerneldirect)|
|**Uefi**  <br>*optional*|[Uefi](#uefi)|
|**UseUtc**  <br>*optional*|boolean|


<a name="cimmount"></a>
## CimMount

|Name|Schema|
|---|---|
|**ImagePath**  <br>|string|
|**FileSystemName**  <br>|string|
|**VolumeGuid**  <br>|guid|


<a name="closehandle"></a>
## CloseHandle

|Name|Schema|
|---|---|
|**Handle**  <br>*optional*|enum (StdIn, StdOut, StdErr, All)|


<a name="combinedlayers"></a>
## CombinedLayers
This class is used by a modify request to add or remove a combined layers structure in the guest. For windows, the GCS applies a filter in ContainerRootPath using the specified layers as the parent content. Ignores property ScratchPath since the container path is already the scratch path. For linux, the GCS unions the specified layers and ScratchPath together, placing the resulting union filesystem at ContainerRootPath.


|Name|Schema|
|---|---|
|**Layers**  <br>*optional*|Layer array|
|**ScratchPath**  <br>*optional*|string|
|**ContainerRootPath**  <br>*optional*|string|




<a name="comport"></a>
## ComPort
ComPort specifies the named pipe that will be used for the port, with empty string indicating a disconnected port.


|Name|Schema|
|---|---|
|**NamedPipe**  <br>*optional*|string|
|**OptimizeForDebugger**  <br>*optional*|boolean|


<a name="computesystem"></a>
## ComputeSystem

|Name|Schema|
|---|---|
|**Container**  <br>*optional*|[Container](#container)|
|**HostedSystem**  <br>*optional*|object|
|**HostingSystemId**  <br>*optional*|string|
|**Owner**  <br>*optional*|string|
|**SchemaVersion**  <br>*optional*|[Version](#version)|
|**ShouldTerminateOnLastHandleClosed**  <br>*optional*|boolean|
|**VirtualMachine**  <br>*optional*|[VirtualMachine](#virtualmachine)|


<a name="consolesize"></a>
## ConsoleSize

|Name|Schema|
|---|---|
|**Height**  <br>*optional*|integer (uint16)|
|**Width**  <br>*optional*|integer (uint16)|


<a name="container"></a>
## Container

|Name|Schema|
|---|---|
|**AssignedDevices**  <br>*optional*|< [Device](#device) > array|
|**ContainerCredentialGuard**  <br>*optional*|[ContainerCredentialGuardState](#containercredentialguardstate)|
|**GuestOs**  <br>*optional*|[GuestOs](#guestos)|
|**HvSocket**  <br>*optional*|[HvSocket](#hvsocket)|
|**MappedDirectories**  <br>*optional*|< [MappedDirectory](#mappeddirectory) > array|
|**MappedPipes**  <br>*optional*|< [MappedPipe](#mappedpipe) > array|
|**Memory**  <br>*optional*|[Memory](#memory)|
|**Networking**  <br>*optional*|[Networking](#networking)|
|**Processor**  <br>*optional*|[Processor](#processor)|
|**RegistryChanges**  <br>*optional*|[RegistryChanges](#registrychanges)|
|**Storage**  <br>*optional*|[Storage](#storage)|


<a name="ContainerCredentialGuardAddInstanceRequest"></a>
## ContainerCredentialGuardAddInstanceRequest

|Name|Description|Schema|
|---|---|---|
|**Id**  <br>*optional*|string|
|**CredentialSpec**  <br>*optional*|string|
|**Transport**  <br>*optional*|ContainerCredentialGuardTransport|

<a name="ContainerCredentialGuardInstance"></a>
## ContainerCredentialGuardInstance

|Name|Description|Schema|
|---|---|---|
|**Id**  <br>*optional*|string|
|**CredentialGuard**  <br>*optional*|ContainerCredentialGuardState|
|**HvSocketConfig**  <br>*optional*|ContainerCredentialGuardHvSocketServiceConfig?|


<a name="ContainerCredentialGuardSystemInfo"></a>
## ContainerCredentialGuardSystemInfo

|Name|Description|Schema|
|---|---|---|
|**Instances[]**  <br>*optional*|ContainerCredentialGuardInstance|


<a name="ContainerCredentialGuardHvSocketServiceConfig"></a>
## ContainerCredentialGuardHvSocketServiceConfig

|Name|Description|Schema|
|---|---|---|
|**ServiceId**  <br>*optional*|Guid|
|**ServiceConfig**  <br>*optional*|Schema.HvSocket.HvSocketServiceConfig?|


<a name="containercredentialguardstate"></a>
## ContainerCredentialGuardState

|Name|Description|Schema|
|---|---|---|
|**Cookie**  <br>*optional*|Authentication cookie for calls to a Container Credential Guard instance.|string (binary)|
|**CredentialSpec**  <br>*optional*|Credential spec used for the configured Container Credential Guard instance.|string|
|**RpcEndpoint**  <br>*optional*|Name of the RPC endpoint of the Container Credential Guard instance.|string|
|**Transport**  <br>*optional*|Transport used for the configured Container Credential Guard instance.|enum (LRPC, HvSocket)|


<a name="cpugroup"></a>
## CpuGroup

|Name|Description|Schema|
|---|---|---|
|**Id**  <br>*optional*|guid|


<a name="crashoptions"></a>
## CrashOptions

|Name|Description|Schema|
|---|---|---|
|**Type**  <br>*optional*|enum (CrashGuest = 0)|


<a name="crashreport"></a>
## CrashReport

crash information reported through CrashReport notifications

|Name|Description|Schema|
|---|---|---|
|**SystemId**  <br>|string|
|**ActivityId**  <br>*optional*|guid|
|**WindowsCrashInfo**  <br>*optional*|WindowsCrashReport|
|**CrashParameters**  <br>*optional*|uint64|
|**CrashLog**  <br>*optional*|string|
|**VmwpDump**  <br>*optional*|CrashReportProcessDump|


<a name="crashreportprocessdump"></a>
## CrashReportProcessDump

Information on auxillary process dumps

|Name|Description|Schema|
|---|---|---|
|**DumpFile**  <br>*optional*|string|
|**Status**  <br>*optional*|int32|


<a name="debugoptions"></a>
## DebugOptions

|Name|Description|Schema|
|---|---|---|
|**BugcheckSavedStateFileName**  <br>*optional*|Capture a save state to the given file if the guest crashes.|string|
|**BugcheckNoCrashdumpSavedStateFileName**  <br>*optional*|Capture a save state to the given file if the guest crashes and no crash dump can be written.|string|
|**TripleFaultSavedStateFileName**  <br>*optional*|Capture a save state to the given file if the guest triple faults.|string|
|**FirmwareDumpFileName**  <br>*optional*|Name of a dump file to use for firmware crashes.|string|



<a name="device"></a>
## Device
Container device information

|Name|Description|Schema|
|---|---|---|
|**InterfaceClassGuid**  <br>*optional*|The interface class guid of the device interfaces to assign to the  container.  Only used when Type is ClassGuid.  <br>**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**LocationPath**  <br>*optional*|The location path of the device to assign to the container.  Only used when Type is DeviceInstance.|string|
|**Type**  <br>*optional*|The type of device to assign to the container.|enum (ClassGuid, DeviceInstance, GpuMirror)|



<a name="device"></a>
## Device
Guest device information

|Name|Description|Schema|
|---|---|---|
|**version**  <br>*optional*|version|
|**States**  <br>*optional*|Map(string, any)|
|**Type**  <br>*optional*|guid|


<a name="devices"></a>
## Devices

|Name|Schema|
|---|---|
|**Battery**  <br>*optional*|[Battery](#battery)|
|**ComPorts**  <br>*optional*|< string, [ComPort](#comport) > map|
|**EnhancedModeVideo**  <br>*optional*|[EnhancedModeVideo](#enhancedmodevideo)|
|**FlexibleIov**  <br>*optional*|< string, [FlexibleIoDevice](#flexibleiodevice) > map|
|**GuestCrashReporting**  <br>*optional*|[GuestCrashReporting](#guestcrashreporting)|
|**HvSocket**  <br>*optional*|[HvSocket_2](#hvsocket_2)|
|**KernelIntegration**  <br>*optional*|[KernelIntegration](#kernelintegration)|
|**Keyboard**  <br>*optional*|[Keyboard](#keyboard)|
|**Mouse**  <br>*optional*|[Mouse](#mouse)|
|**NetworkAdapters**  <br>*optional*|< string, [NetworkAdapter](#networkadapter) > map|
|**Plan9**  <br>*optional*|[Plan9](#plan9)|
|**Scsi**  <br>*optional*|< string, [Scsi](#scsi) > map|
|**SharedMemory**  <br>*optional*|[SharedMemoryConfiguration](#sharedmemoryconfiguration)|
|**VideoMonitor**  <br>*optional*|[VideoMonitor](#videomonitor)|
|**VirtioSerial**  <br>*optional*|[VirtioSerial](#virtioserial)|
|**VirtualPMem**  <br>*optional*|[VirtualPMemController](#virtualpmemcontroller)|
|**VirtualPci**  <br>*optional*|< string, [VirtualPciDevice](#virtualpcidevice) > map|
|**VirtualSmb**  <br>*optional*|[VirtualSmb](#virtualsmb)|


<a name="enhancedmodevideo"></a>
## EnhancedModeVideo

|Name|Schema|
|---|---|
|**ConnectionOptions**  <br>*optional*|[RdpConnectionOptions](#rdpconnectionoptions)|


<a name="errorevent"></a>
## ErrorEvent

Error descriptor that provides the info of an error object

|Name|Schema|
|---|---|
|**Message**  <br>*optional*|Fully formated error message|string|
|**StackTrace**  <br>*optional*|Stack trace in string form|string|
|**Provider**  <br>|Event definition|guid|
|**EventId**  <br>|Event definition|uint16|
|**Flags**  <br>*optional*|uint32|
|**Source**  <br>*optional*|string|
|**Data**  <br>*optional*|EventData|array|


<a name="eventdata"></a>
## EventData

Event data element

|Name|Schema|
|---|---|
|**Value**  <br>*optional*|string|
|**Type**  <br>*optional*|enum (Empty = 0, String = 1, AnsiString = 2, SByte = 3, Byte = 4, Int16 = 5, UInt16 = 6,Int32 = 7, UInt32 = 8, Int64 = 9, UInt64 = 10, Single = 11, Double  = 12, Boolean = 13, Binary = 14, Guid = 15)|


<a name="exportlayeroptions"></a>
## ExportLayerOptions

|Name|Schema|
|---|---|
|**IsWritableLayer**  <br>*optional*|bool|


<a name="filteredpropertyquery"></a>
## FilteredPropertyQuery

Structures used to perform a filtered propertyquery. 

|Name|Description|Schema|
|---|---|---|
|**Filter**  <br>*optional*|Additional filter to query.|any|
|**PropertyType**  <br>|Specifies which property to query.|enum ( Basic, Memory, CpuGroup, ProcessorTopology, CacheAllocation, CacheMonitoring, ContainerCredentialGuard, QoSCapabilities, MemoryBwAllocation, Undefined)|


<a name="flexibleiodevice"></a>
## FlexibleIoDevice

|Name|Description|Schema|
|---|---|---|
|**Configuration**  <br>*optional*||< string > array|
|**EmulatorId**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**HostingModel**  <br>*optional*||enum (Internal, External)|


<a name="guestconnection"></a>
## GuestConnection

|Name|Description|Schema|
|---|---|---|
|**UseConnectedSuspend**  <br>*optional*|Don't disconnect the guest connection when pausing the virtual machine.|boolean|
|**UseHostTimeZone**  <br>*optional*|Set the guest's time zone to that of the host|boolean|
|**UseVsock**  <br>*optional*|Use Vsock rather than Hyper-V sockets to communicate with the guest service.|boolean|


<a name="guestconnectioninfo"></a>
## GuestConnectionInfo
Information about the guest.


|Name|Description|Schema|
|---|---|---|
|**GuestDefinedCapabilities**  <br>*optional*||object|
|**ProtocolVersion**  <br>*optional*||integer (uint32)|
|**SupportedSchemaVersions**  <br>*optional*|Each schema version x.y stands for the range of versions a.b where a==x  and b<=y. This list comes from the SupportedSchemaVersions field in  GcsCapabilities.|< [Version](#version) > array|


<a name="guestcrash"></a>
## GuestCrash

Crash parameters as reported by the guest.

|Name|Schema|
|---|---|
|**CrashParameters**  <br>*optional*|Crash parameters as reported by the guest.|uint64 array|


<a name="guestcrashreporting"></a>
## GuestCrashReporting

|Name|Schema|
|---|---|
|**WindowsCrashSettings**  <br>*optional*|[WindowsCrashReporting](#windowscrashreporting)|


<a name="guestmemoryinfo"></a>
## GuestMemoryInfo

Memory usage as viewed from the guest OS.

|Name|Description|Schema|
|---|---|---|
|**TotalPhysicalBytes**  <br>|uint64|
|**TotalUsage**  <br>|uint64|
|**CommittedBytes**  <br>|uint64|
|**SharedCommittedBytes**  <br>|uint64|
|**CommitLimitBytes**  <br>|uint64|
|**PeakCommitmentBytes**  <br>|uint64|



<a name="guestmodifysettingrequest"></a>
## GuestModifySettingRequest

|Name|Description|Schema|
|---|---|---|
|**Settings**  <br>*optional*|Any|
|**RequestType**  <br>|Schema.Requests.ModifyRequestType|
|**ResourceType**  <br>|enum (Memory,MappedDirectory,MappedPipe,MappedVirtualDisk,CombinedLayers,NetworkNamespace,CimMount)|


<a name="guestos"></a>
## GuestOs

|Name|Schema|
|---|---|
|**HostName**  <br>*optional*|string|


<a name="gueststate"></a>
## GuestState

|Name|Description|Schema|
|---|---|---|
|**ForceTransientState**  <br>*optional*|If true, the guest state and runtime state files will be used as templates  to populate transient, in-memory state instead of using the files as persistent backing store.|boolean|
|**GuestStateFilePath**  <br>*optional*|The path to an existing file uses for persistent guest state storage.  An empty string indicates the system should initialize new transient, in-memory guest state.|string|
|**RuntimeStateFilePath**  <br>*optional*|The path to an existing file for persistent runtime state storage.  An empty string indicates the system should initialize new transient, in-memory runtime state.|string|


<a name="gpuconfiguration"></a>
## GpuConfiguration

|Name|Description|Schema|
|---|---|---|
|**AssignmentMode**  <br>*optional*|The mode used to assign GPUs to the guest.|enum (Disabled, Default //Assign the single default GPU to guest, which currently is POST GPU., List // Assign the GPU(s)/partition(s) specified in AssignmentRequest to guest. If AssignmentRequest is empty, do not assign GPU to the guest., Mirror //Assign all current and future GPUs to guest.)
|**AssignmentRequest**  <br>*optional*|This only applies to List mode, and is ignored in other modes. In GPU-P, string is GPU device interface, and unit16 is partition id. HCS simply assigns the partition with the input id. In GPU-PV, string is GPU device interface, and unit16 is 0xffff. HCS needs to find an available partition to assign.|Map (string, uint16)|
|**AllowVendorExtension**  <br>*optional*|Whether we allow vendor extension.|bool|


<a name="heartbeat"></a>
## Heartbeat
*Type* : object


<a name="hostedsystem"></a>
## HostedSystem

|Name|Description|Schema|
|---|---|---|
|**SchemaVersion**  <br>|Version|
|**Container**  <br>|Container|


<a name="hvsocket"></a>
## HvSocket

|Name|Schema|
|---|---|
|**Config**  <br>*optional*|[HvSocketSystemConfig](#hvsocketsystemconfig)|
|**EnablePowerShellDirect**  <br>*optional*|boolean|


<a name="hvsocketaddress"></a>
## HvSocketAddress
This class defines address settings applied to a VM by the GCS every time a VM starts or restores.

|Name|Schema|
|---|---|
|**LocalAddress**  <br>*optional*|guid|
|**ParentAddress**  <br>*optional*|guid|


<a name="hvsocketserviceconfig"></a>
## HvSocketServiceConfig

|Name|Description|Schema|
|---|---|---|
|**AllowWildcardBinds**  <br>*optional*|If true, HvSocket will process wildcard binds for this service/system combination.  Wildcard binds are secured in the registry at  SOFTWARE/Microsoft/Windows NT/CurrentVersion/Virtualization/HvSocket/WildcardDescriptors|boolean|
|**BindSecurityDescriptor**  <br>*optional*|SDDL string that HvSocket will check before allowing a host process to bind  to this specific service.  If not specified, defaults to the system DefaultBindSecurityDescriptor, defined in  HvSocketSystemWpConfig in V1.|string|
|**ConnectSecurityDescriptor**  <br>*optional*|SDDL string that HvSocket will check before allowing a host process to connect  to this specific service.  If not specified, defaults to the system DefaultConnectSecurityDescriptor, defined in  HvSocketSystemWpConfig in V1.|string|


<a name="hvsocketsystemconfig"></a>
## HvSocketSystemConfig
This is the HCS Schema version of the HvSocket configuration. The VMWP version is  located in Config.Devices.IC in V1.


|Name|Description|Schema|
|---|---|---|
|**DefaultBindSecurityDescriptor**  <br>*optional*|SDDL string that HvSocket will check before allowing a host process to bind  to an unlisted service for this specific container/VM (not wildcard binds).|string|
|**DefaultConnectSecurityDescriptor**  <br>*optional*|SDDL string that HvSocket will check before allowing a host process to connect  to an unlisted service in the VM/container.|string|
|**ServiceTable**  <br>*optional*||< string, [HvSocketServiceConfig](#hvsocketserviceconfig) > map|


<a name="hvsocket_2"></a>
## HvSocket_2
HvSocket configuration for a VM


|Name|Schema|
|---|---|
|**HvSocketConfig**  <br>*optional*|[HvSocketSystemConfig](#hvsocketsystemconfig)|


<a name="idledprocessorresponse"></a>
## IdledProcessorResponse

|Name|Description|Schema|
|---|---|---|
|**RequestedIdle**  <br>|uint32|
|**IdleStatus**  <br>|uint32|
|**CurrentIdle**  <br>|uint32|


<a name="idleprocessorsrequest"></a>
## IdleProcessorsRequest

|Name|Description|Schema|
|---|---|---|
|**IdleProcessorCount**  <br>|uint32|


<a name="injectnonmaskableinterrupt"></a>
## InjectNonMaskableInterrupt

A non-maskable interrupt (NMI) was inject by the host management client or other tool.


<a name="integrationcomponentstatus"></a>
## IntegrationComponentStatus

|Name|Description|Schema|
|---|---|---|
|**IsEnabled**  <br>*optional*|if IC is enabled on this compute system|boolean|
|**Reason**  <br>*optional*|Explanation for the State|enum (Unknown, AppsInCriticalState, CommunicationTimedOut, FailedCommunication, HealthyApps, ProtocolMismatch)|
|**State**  <br>*optional*|the current state of the IC inside the VM|enum (Unknown, Degraded, Dormant, Error, LostCommunication, NonRecoverableError, NoContact, Ok)|


<a name="kernelintegration"></a>
## KernelIntegration
*Type* : object


<a name="keyboard"></a>
## Keyboard
*Type* : object


<a name="launchoptions"></a>
## LaunchOptions

|Name|Description|Schema|
|---|---|---|
|**Type**  <br>*optional*|enum (Default, None // Launch VMWP normally, AppContainer // Launch VMWP as an App Container)|


<a name="layer"></a>
## Layer

|Name|Description|Schema|
|---|---|---|
|**Cache**  <br>*optional*|Unspecified defaults to Enabled|enum (, Disabled, Enabled, Private, PrivateAllowSharing)|
|**Id**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**Path**  <br>*optional*||string|
|**PathType**  <br>*optional*||enum (AbsolutePath, VirtualSmbShareName)|


<a name="layerData"></a>
## Layer

|Name|Description|Schema|
|---|---|---|
|**SchemaVersion**  <br>*optional*|Schema.Version|
|**Layers[]**  <br>*optional*|Schema.Common.Resources.Layer|


<a name="licensing></a>
## Licensing

|Name|Schema|
|---|---|
|**ContainerID**  <br>*optional*|guid|
|**PackageFamilyNames**  <br>*optional*|string array|


<a name="linuxkerneldirect"></a>
## LinuxKernelDirect

|Name|Schema|
|---|---|
|**InitRdPath**  <br>*optional*|string|
|**KernelCmdLine**  <br>*optional*|string|
|**KernelFilePath**  <br>*optional*|string|


<a name="mappeddirectory"></a>
## MappedDirectory

|Name|Schema|
|---|---|
|**ContainerPath**  <br>*optional*|string|
|**HostPath**  <br>*optional*|string|
|**HostPathType**  <br>*optional*|enum (AbsolutePath, VirtualSmbShareName)|
|**ReadOnly**  <br>*optional*|boolean|
|**SupportCloudFiles**  <br>*optional*|boolean|


<a name="mappedpipe"></a>
## MappedPipe

|Name|Schema|
|---|---|
|**ContainerPipeName**  <br>*optional*|string|
|**HostPath**  <br>*optional*|string|
|**HostPathType**  <br>*optional*|enum (AbsolutePath, VirtualSmbPipeName)|


<a name="mappedvirtualdisk"></a>
## MappedVirtualDisk

|Name|Schema|
|---|---|
|**ContainerPath**  <br>*optional*|string|
|**Lun**  <br>*optional*|integer (uint8)|


<a name="memory"></a>
## Memory

This class is used for Virtual Machines and containers. Container related items are listed in the description.

|Name|Schema|
|---|---|
|**SizeInMB**  <br>*optional*|Used for Virtual machines and Containers|integer (uint64)|


<a name="memoryinformationforvm"></a>
## MemoryInformationForVm

|Name|Schema|
|---|---|
|**VirtualMachineMemory**  <br>*optional*|[VmMemory](#vmmemory)|
|**VirtualNodeCount**  <br>*optional*|integer (uint8)|
|**VirtualNodes**  <br>*optional*|< [VirtualNodeInfo](#virtualnodeinfo) > array|


<a name="memorystats"></a>
## MemoryStats
Memory runtime statistics


|Name|Schema|
|---|---|
|**MemoryUsageCommitBytes**  <br>*optional*|integer (uint64)|
|**MemoryUsageCommitPeakBytes**  <br>*optional*|integer (uint64)|
|**MemoryUsagePrivateWorkingSetBytes**  <br>*optional*|integer (uint64)|


<a name="memory_2"></a>
## Memory_2

|Name|Description|Schema|
|---|---|---|
|**AllowOvercommit**  <br>*optional*|If enabled, then the VM's memory is backed by the Windows pagefile rather than physically  backed, statically allocated memory.|boolean|
|**BackingPageSize**  <br>*optional*|The preferred page size unit (chunk size) used when allocating backing pages for the VM.|enum (Small, Large)|
|**DirectMapFaultClusterSizeShift**  <br>*optional*|Fault clustering size for direct mapped memory.|integer (uint32)|
|**EnableColdDiscardHint**  <br>*optional*|If enabled, then the memory cold discard hint feature is exposed to the VM, allowing it to trim  non-zeroed pages from the working set (if supported by the guest operating system).|boolean|
|**EnableColdHint**  <br>*optional*|If enabled, then the memory cold hint feature is exposed to the VM, allowing it to trim zeroed  pages from its working set (if supported by the guest operating system).|boolean|
|**EnableDeferredCommit**  <br>*optional*|If enabled, then commit is not charged for each backing page until first access.|boolean|
|**EnableHotHint**  <br>*optional*|If enabled, then the memory hot hint feature is exposed to the VM, allowing it to prefetch  pages into its working set. (if supported by the guest operating system).|boolean|
|**FaultClusterSizeShift**  <br>*optional*|Fault clustering size for primary RAM.|integer (uint32)|
|**ForbidSmallBackingPages**  <br>*optional*|If enabled, then backing page chunks smaller than the backing page size are never used unless  the system is under extreme memory pressure. If the backing page size is Small, then it is  forced to Large when this option is enabled.|boolean|
|**HighMmioBaseInMB**  <br>*optional*|High MMIO region allocated above 4GB (base and size)|integer (uint64)|
|**HighMmioGapInMB**  <br>*optional*||integer (uint64)|
|**LowMmioGapInMB**  <br>*optional*|Low MMIO region allocated below 4GB|integer (uint64)|
|**PinBackingPages**  <br>*optional*|If enabled, then each backing page is physically pinned on first access.|boolean|
|**SizeInMB**  <br>*optional*||integer (uint64)|


<a name="modifysettingrequest"></a>
## ModifySettingRequest

|Name|Schema|
|---|---|
|**GuestRequest**  <br>*optional*|object|
|**RequestType**  <br>*optional*|enum (Add, Remove, Update)|
|**ResourcePath**  <br>*optional*|string|
|**Settings**  <br>*optional*|object|


<a name="mouse"></a>
## Mouse
*Type* : object


<a name="networkadapter"></a>
## NetworkAdapter

|Name|Description|Schema|
|---|---|---|
|**EndpointId**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**InstanceId**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**MacAddress**  <br>*optional*||string (mac-address)|


<a name="networking"></a>
## Networking

|Name|Description|Schema|
|---|---|---|
|**AllowUnqualifiedDnsQuery**  <br>*optional*||boolean|
|**DnsSearchList**  <br>*optional*||string|
|**Namespace**  <br>*optional*|Guid in windows; string in linux|string|
|**NetworkAdapters**  <br>*optional*||< string > array|
|**NetworkSharedContainerName**  <br>*optional*||string|


<a name="networkmodifysettingrequest"></a>
## NetworkModifySettingRequest

|Name|Description|Schema|
|---|---|---|
|**AdapterId**  <br>*optional*||string|
|**Settings**  <br>*optional*||any|
|**RequestType**  <br>|enum (PreAdd,Add,Remove)|


<a name="numa"></a>
## Numa

|Name|Description|Schema|
|---|---|---|
|**VirtualNodeCount**  <br>*optional*|Integer (uint8)|
|**PreferredPhysicalNodes**  <br>*optional*|Integer (uint8) array|
|**Settings**  <br>*optional*|numasetting array|


<a name="numasetting"></a>
## NumaSetting

|Name|Description|Schema|
|---|---|---|
|**VirtualNodeNumber**  <br>*optional*|Integer (uint32)|
|**PhysicalNodeNumber**  <br>*optional*|Integer (uint32)|
|**VirtualSocketNumber**  <br>*optional*|Integer (uint32)|
|**CountOfProcessors**  <br>*optional*|Integer (uint32)|
|**CountOfMemoryBlocks**  <br>*optional*|Integer (uint32)|


<a name="nvram"></a>
## Nvram

|Name|Description|Schema|
|---|---|---|
|**Vendors**  <br>*optional*|Map<Guid, NvramVendor> |
|**LastUpdateTime**  <br>*optional*|DateTime|


<a name="nvramvariable"></a>
## NvramVariable

|Name|Description|Schema|
|---|---|---|
|**Attributes**  <br>*optional*|Integer (uint32)|
|**Timestamp**  <br>*optional*|DateTime|
|**Data**  <br>*optional*|Integer (uint8) array|


<a name="nvramvendor"></a>
## NvramVendor

|Name|Description|Schema|
|---|---|---|
|**Variables**  <br>*optional*|CaseInsensitiveStringMap(NvramVariable)|


<a name="operationfailure"></a>
## OperationFailure


|Name|Schema|
|---|---|
|**Detail**  <br>*optional*|enum (Invalid, CreateInternalError, ConstructStateError, RuntimeOsTypeMismatch, Construct, Start, Pause, Resume, Shutdown, Terminate, Save, GetProperties, Modify, Crash, GuestCrash, LifecycleNotify, ExecuteProcess, GetProcessInfo, WaitForProcess, SignalProcess, ModifyProcess, PrepareForHosting, RegisterHostedSystem, UnregisterHostedSystem, PrepareForClone, GetCloneTemplate)|


<a name="oslayeroptions"></a>
## OsLayerOptions


|Name|Schema|
|---|---|
|**DisableCiCacheOptimization**  <br>*optional*|bool|
|**Type**  <br>*optional*|enum (Container,Vm)|


<a name="pausenotification"></a>
## PauseNotification
Notification data that is indicated to components running in the Virtual Machine.


|Name|Schema|
|---|---|
|**Reason**  <br>*optional*|enum (None, Save, Template)|


<a name="pauseoptions"></a>
## PauseOptions
Options for HcsPauseComputeSystem


|Name|Schema|
|---|---|
|**HostedNotification**  <br>*optional*|[PauseNotification](#pausenotification)|
|**SuspensionLevel**  <br>*optional*|enum (Suspend, MemoryLow, MemoryMedium, MemoryHigh)|


<a name="plan9"></a>
## Plan9

|Name|Schema|
|---|---|
|**Shares**  <br>*optional*|< [Plan9Share](#plan9share) > array|


<a name="plan9share"></a>
## Plan9Share

|Name|Description|Schema|
|---|---|---|
|**AccessName**  <br>*optional*|The name by which the guest operation system can access this share, via  the aname parameter in the Plan9 protocol.|string|
|**AllowedFiles**  <br>*optional*||< string > array|
|**Name**  <br>*optional*||string|
|**Path**  <br>*optional*||string|
|**Port**  <br>*optional*||integer (uint32)|


<a name="processdetails"></a>
## ProcessDetails
Information about a process running in a container


|Name|Schema|
|---|---|
|**CreateTimestamp**  <br>*optional*|string (date-time)|
|**ImageName**  <br>*optional*|string|
|**KernelTime100ns**  <br>*optional*|integer (uint64)|
|**MemoryCommitBytes**  <br>*optional*|integer (uint64)|
|**MemoryWorkingSetPrivateBytes**  <br>*optional*|integer (uint64)|
|**MemoryWorkingSetSharedBytes**  <br>*optional*|integer (uint64)|
|**ProcessId**  <br>*optional*|integer (uint32)|
|**UserTime100ns**  <br>*optional*|integer (uint64)|


<a name="processdump"></a>
## ProcessDump
Configuration for a process dump


|Name|Schema|
|---|---|
|**Type**  <br>*optional*|enum (None, Heap, Mini, Custom)|
|**CustomDumpFlags**  <br>*optional*|Custom MINIDUMP_TYPE flags used if Type is ProcessDumpType::Custom|uint32|
|**DumpFileName**  <br>|string|


<a name="processmodifyrequest"></a>
## ProcessModifyRequest
Passed to HcsRpc_ModifyProcess


|Name|Schema|
|---|---|
|**CloseHandle**  <br>*optional*|[CloseHandle](#closehandle)|
|**ConsoleSize**  <br>*optional*|[ConsoleSize](#consolesize)|
|**Operation**  <br>*optional*|enum (ConsoleSize, CloseHandle)|


<a name="processparameters"></a>
## ProcessParameters

|Name|Description|Schema|
|---|---|---|
|**ApplicationName**  <br>*optional*||string|
|**CommandArgs**  <br>*optional*|optional alternative to CommandLine, currently only supported by Linux GCS|< string > array|
|**CommandLine**  <br>*optional*||string|
|**ConsoleSize**  <br>*optional*|height then width|< integer (uint16) > array|
|**CreateStdErrPipe**  <br>*optional*||boolean|
|**CreateStdInPipe**  <br>*optional*||boolean|
|**CreateStdOutPipe**  <br>*optional*||boolean|
|**EmulateConsole**  <br>*optional*|if set, ignore StdErrPipe|boolean|
|**Environment**  <br>*optional*||< string, string > map|
|**RestrictedToken**  <br>*optional*|if set, will run as low-privilege process|boolean|
|**UseExistingLogin**  <br>*optional*|if set, find an existing session for the user and create the process in it|boolean|
|**UseLegacyConsole**  <br>*optional*|if set, use the legacy console instead of conhost|boolean|
|**User**  <br>*optional*||string|
|**WorkingDirectory**  <br>*optional*||string|


<a name="processstatus"></a>
## ProcessStatus
Status of a process running in a container


|Name|Schema|
|---|---|
|**ExitCode**  <br>*optional*|integer (uint32)|
|**Exited**  <br>*optional*|boolean|
|**LastWaitResult**  <br>*optional*|integer (int32)|
|**ProcessId**  <br>*optional*|integer (uint32)|


<a name="processor"></a>
## Processor
Specifies CPU limits for a container.  Count, Maximum and Weight are all mutually exclusive.


|Name|Description|Schema|
|---|---|---|
|**Count**  <br>*optional*|Optional property that represents the fraction of the configured processor  count in a container in relation to the processors available in the host.  The fraction ultimately determines the portion of processor cycles that the  threads in a container can use during each scheduling interval,  as the number of cycles per 10,000 cycles.|integer (uint32)|
|**Maximum**  <br>*optional*|Optional property that determines the portion of processor cycles  that the threads in a container can use during each scheduling interval,  as the number of cycles per 10,000 cycles.  Set processor maximum to a percentage times 100.|integer (int64)|
|**Weight**  <br>*optional*|Optional property that limits the share of processor time given to the container  relative to other workloads on the processor.  The processor weight is a value between 0 and 10000.|integer (int64)|


<a name="processorlimits"></a>
## ProcessorLimits
Used when modifying processor scheduling limits of a virtual machine.


|Name|Description|Schema|
|---|---|---|
|**Weight**  <br>*optional*|Value describing the relative priority of this virtual machine compared to other virtual machines.  The processor weight is a value between 0 and 10000.|integer (int64)|
|**Limit**  <br>*optional*|Maximum amount of host CPU resources that the virtual machine can use.|integer (int64)|
|**Reservation**  <br>*optional*|Minimum amount of host CPU resources that the virtual machine is guaranteed.|integer (int64)|
|**MaximumFrequencyMHz**  <br>*optional*|Provides the target maximum CPU frequency, in MHz, for a virtual machine.|integer (int64)|


<a name="processorstats"></a>
## ProcessorStats
CPU runtime statistics


|Name|Schema|
|---|---|
|**RuntimeKernel100ns**  <br>*optional*|integer (uint64)|
|**RuntimeUser100ns**  <br>*optional*|integer (uint64)|
|**TotalRuntime100ns**  <br>*optional*|integer (uint64)|


<a name="processor_2"></a>
## Processor_2
Specifies CPU limits for a Virtual Machines

|Name|Schema|
|---|---|
|**Count**  <br>*optional*|integer (uint32)|
|**EnablePerfmonIpt**  <br>*optional*|boolean|
|**EnablePerfmonLbr**  <br>*optional*|boolean|
|**EnablePerfmonPebs**  <br>*optional*|boolean|
|**EnablePerfmonPmu**  <br>*optional*|boolean|
|**ExposeVirtualizationExtensions**  <br>*optional*|boolean|
|**Limit**  <br>*optional*|integer (uint64)|
|**Weight**  <br>*optional*|integer (uint64)|
**Reservation**  <br>*optional*|Minimum amount of host CPU resources that the virtual machine is guaranteed.|integer (int64)|
**MaximumFrequencyMHz**  <br>*optional*|Provides the target maximum CPU frequency, in MHz, for a virtual machine.|integer (int64)|


<a name="properties"></a>
## Properties

|Name|Description|Schema|
|---|---|---|
|**ExitType**  <br>*optional*||enum (None, GracefulExit, ForcedExit, UnexpectedExit, Unknown)|
|**GuestConnectionInfo**  <br>*optional*||[GuestConnectionInfo](#guestconnectioninfo)|
|**HostingSystemId**  <br>*optional*||string|
|**ICHeartbeatStatus**  <br>*optional*||[IntegrationComponentStatus](#integrationcomponentstatus)|
|**Id**  <br>*optional*||string|
|**Memory**  <br>*optional*||[MemoryInformationForVm](#memoryinformationforvm)|
|**Name**  <br>*optional*||string|
|**Owner**  <br>*optional*||string|
|**ProcessList**  <br>*optional*||< [ProcessDetails](#processdetails) > array|
|**RuntimeId**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**RuntimeOsType**  <br>*optional*||enum (, Windows, Linux)|
|**RuntimeTemplateId**  <br>*optional*||string|
|**SharedMemoryRegionInfo**  <br>*optional*||< [SharedMemoryRegionInfo](#sharedmemoryregioninfo) > array|
|**State**  <br>*optional*||enum (Created, Running, Paused, Stopped, SavedAsTemplate, Unknown)|
|**Statistics**  <br>*optional*||[Statistics](#statistics)|
|**Stopped**  <br>*optional*||boolean|
|**SystemType**  <br>*optional*||enum (Container, VirtualMachine, Host)|
|**TerminateOnLastHandleClosed**  <br>*optional*||boolean|


<a name="propertyquery"></a>
## PropertyQuery
By default the basic properties will be returned. This query provides a way to  request specific properties.


|Name|Schema|
|---|---|
|**PropertyTypes**  <br>*optional*|< enum (Memory, GuestMemory, Statistics, ProcessList, TerminateOnLastHandleClosed, SharedMemoryRegion, GuestConnection, ICHeartbeatStatus) > array|


<a name="qoscapabilities"></a>
## QoSCapabilities

|Name|Schema|
|---|---|
|**ProcessorQoSSupported**  <br>*optional*|bool|


<a name="rdpconnectionoptions"></a>
## RdpConnectionOptions

|Name|Schema|
|---|---|
|**AccessSids**  <br>*optional*|< string > array|
|**NamedPipe**  <br>*optional*|string|


<a name="registrychanges"></a>
## RegistryChanges

|Name|Schema|
|---|---|
|**AddValues**  <br>*optional*|< [RegistryValue](#registryvalue) > array|
|**DeleteKeys**  <br>*optional*|< [RegistryKey](#registrykey) > array|


<a name="registryflushstate"></a>
## RegistryFlushState

Represents the flush state of the registry hive for a windows container's job object.

|Name|Schema|
|---|---|
|**Hive**  <br>*optional*|Determines whether the flush state of the registry hive is enabled or not. When not enabled, flushes are ignored and changes to the registry are not preserved.|bool|


<a name="registrykey"></a>
## RegistryKey

|Name|Schema|
|---|---|
|**Hive**  <br>*optional*|enum (System, Software, Security, Sam)|
|**Name**  <br>*optional*|string|
|**Volatile**  <br>*optional*|boolean|


<a name="registryvalue"></a>
## RegistryValue

|Name|Description|Schema|
|---|---|---|
|**BinaryValue**  <br>*optional*||string (binary)|
|**CustomType**  <br>*optional*|Only used if RegistryValueType is CustomType  The data is in BinaryValue|integer (uint32)|
|**DWordValue**  <br>*optional*||integer (uint32)|
|**Key**  <br>*optional*||[RegistryKey](#registrykey)|
|**Name**  <br>*optional*||string|
|**QWordValue**  <br>*optional*||integer (uint64)|
|**StringValue**  <br>*optional*|One and only one value type must be set.|string|
|**Type**  <br>*optional*||enum (None, String, ExpandedString, MultiString, Binary, DWord, QWord, CustomType)|


<a name="registrychanges"></a>
## RegistryChanges

|Name|Description|Schema|
|---|---|---|
|**AddValues[]**  <br>*optional*||RegistryValue|
|**DeleteKeys[]**  <br>*optional*|RegistryKey|


<a name="resulterror"></a>
## ResultError

Extended error information returned by the HCS

|Name|Description|Schema|
|---|---|---|
|**Error**  <br>|int32|
|**ErrorMessage**  <br>|string|
|**ErrorEvents**  <br>*optional*|ErrorEvents|array|
|**Attribution**  <br>*optional*|AttributionRecord|array|

<a name="restorestate"></a>
## RestoreState

|Name|Description|Schema|
|---|---|---|
|**SaveStateFilePath**  <br>*optional*|The path to the save state file to restore the system from.|string|
|**TemplateSystemId**  <br>*optional*|The ID of the template system to clone this new system off of. An empty  string indicates the system should not be cloned from a template.|string|


<a name="runtimestate"></a>
## RuntimeState
guest runtime state

|Name|Description|Schema|
|---|---|---|
|**Version**  <br>*optional*|version|
|**Devices**  <br>*optional*|Map(Guid, Device)|


<a name="saveoptions"></a>
## SaveOptions

|Name|Description|Schema|
|---|---|---|
|**SaveStateFilePath**  <br>*optional*|The path to the file that will container the saved state.|string|
|**SaveType**  <br>*optional*|The type of save operation to be performed.|enum (ToFile, AsTemplate)|


<a name="scsi"></a>
## Scsi

|Name|Description|Schema|
|---|---|---|
|**Attachments**  <br>*optional*|Map of attachments, where the key is the integer LUN number on the controller.|< string, [Attachment](#attachment) > map|


<a name="secureboottemplate"></a>
## SecureBootTemplate
guest secure boot template

|Name|Schema|
|---|---|
|**TemplateGuid**  <br>*optional*|guid|
|**TemplateVersion**  <br>*optional*|Integer (uint16)|


<a name="services"></a>
## Services

|Name|Schema|
|---|---|
|**Heartbeat**  <br>*optional*|[Heartbeat](#heartbeat)|


<a name="serviceproperties"></a>
## ServiceProperties

The service properties will be returned as an array corresponding to the requested property types.

|Name|Schema|
|---|---|
|**Properties**  <br>*optional*|array|


<a name="sharedmemoryconfiguration"></a>
## SharedMemoryConfiguration

|Name|Schema|
|---|---|
|**Regions**  <br>*optional*|< [SharedMemoryRegion](#sharedmemoryregion) > array|


<a name="sharedmemoryregion"></a>
## SharedMemoryRegion

|Name|Schema|
|---|---|
|**AllowGuestWrite**  <br>*optional*|boolean|
|**HiddenFromGuest**  <br>*optional*|boolean|
|**Length**  <br>*optional*|integer (uint64)|
|**SectionName**  <br>*optional*|string|
|**StartOffset**  <br>*optional*|integer (uint64)|


<a name="sharedmemoryregioninfo"></a>
## SharedMemoryRegionInfo

|Name|Schema|
|---|---|
|**GuestPhysicalAddress**  <br>*optional*|integer (uint64)|
|**SectionName**  <br>*optional*|string|


<a name="shutdown"></a>
## Shutdown

#object

<a name="siloproperties"></a>
## SiloProperties

|Name|Schema|
|---|---|
|**Enabled**  <br>|bool|
|**JobName**  <br>*optional*|string|


<a name="silosettings"></a>
## SiloSettings

|Name|Schema|
|---|---|
|**SiloBaseOsPath**  <br>*optional*|If running this virtual machine inside a silo, the base OS path to use for the silo.|string|
|**NotifySiloJobCreated**  <br>*optional*|Request a notification when the job object for the silo is available.|bool|
|**FileSystemLayers**  <br>*optional*|The filesystem layers to use for the silo.|Layer array|


<a name="signalprocessoptions"></a>
## SignalProcessOptions

|Name|Schema|
|---|---|
|**Signal**  <br>*optional*|enum (CtrlC = 0, CtrlBreak = 1, CtrlClose = 2,CtrlLogOff = 5,CtrlShutdown = 6)|



<a name="statistics"></a>
## Statistics
Runtime statistics for a container


|Name|Schema|
|---|---|
|**ContainerStartTime**  <br>*optional*|string (date-time)|
|**Memory**  <br>*optional*|[MemoryStats](#memorystats)|
|**Processor**  <br>*optional*|[ProcessorStats](#processorstats)|
|**Storage**  <br>*optional*|[StorageStats](#storagestats)|
|**Timestamp**  <br>*optional*|string (date-time)|
|**Uptime100ns**  <br>*optional*|integer (uint64)|


<a name="storage"></a>
## Storage

|Name|Description|Schema|
|---|---|---|
|**Layers**  <br>*optional*|List of layers that describe the parent hierarchy for a container's  storage. These layers combined together, presented as a disposable  and/or committable working storage, are used by the container to  record all changes done to the parent layers.|< [Layer](#layer) > array|
|**Path**  <br>*optional*|Path that points to the scratch space of a container, where parent  layers are combined together to present a new disposable and/or committable  layer with the changes done during its runtime.|string|
|**QoS**  <br>*optional*||[StorageQoS](#storageqos)|


<a name="storageqos"></a>
## StorageQoS

|Name|Schema|
|---|---|
|**BandwidthMaximum**  <br>*optional*|integer (uint64)|
|**IopsMaximum**  <br>*optional*|integer (uint64)|


<a name="storagestats"></a>
## StorageStats
Storage runtime statistics


|Name|Schema|
|---|---|
|**ReadCountNormalized**  <br>*optional*|integer (uint64)|
|**ReadSizeBytes**  <br>*optional*|integer (uint64)|
|**WriteCountNormalized**  <br>*optional*|integer (uint64)|
|**WriteSizeBytes**  <br>*optional*|integer (uint64)|


<a name="systemexit"></a>
## SystemExit


|Name|Schema|
|---|---|
|**Initiator**  <br>*optional*|enum(None, GuestOS, Client, Internal,Unknown)|
|**Detail**  <br>*optional*|enum (None, GracefulExit, ForcedExit, UnexpectedExit, Unknown)|


<a name="systemexitstatus"></a>
## SystemExitStatus

|Name|Schema|
|---|---|
|**Status**  <br>|Exit status (HRESULT) for the system.|int32|
|**ExitType**  <br>*optional*|enum (Invalid, HcsApiFatalError, ServiceStop, Shutdown,Terminate, UnexpectedExit)|
|**Attribution**  <br>*optional*|AttributionRecord|array|


<a name="systemquery"></a>
## SystemQuery


|Name|Schema|
|---|---|
|**Ids**  <br>*optional*|array|string|
|**Names**  <br>*optional*|array|string|
|**Types**  <br>*optional*|array|Schema.Responses.System.SystemType|
|**Owners**  <br>*optional*|array|string|


<a name="systemtime"></a>
## SystemTime


|Name|Schema|
|---|---|
|**Year**  <br>*optional*|Integer (uint16)|
|**Month**  <br>*optional*|Integer (uint16)|
|**DayOfWeek**  <br>*optional*|Integer (uint16)|
|**Day**  <br>*optional*|Integer (uint16)|
|**Hour**  <br>*optional*|Integer (uint16)|
|**Minute**  <br>*optional*|Integer (uint16)|
|**Second**  <br>*optional*|Integer (uint16)|
|**Milliseconds**  <br>*optional*|Integer (uint16)|


<a name="timesync"></a>
## TimeSync
#object

<a name="timezoneinformation"></a>
## TimeZoneInformation

|Name|Schema|
|---|---|
|**Bias**  <br>*optional*|int32|
|**StandardName**  <br>*optional*|string|
|**StandardDate**  <br>*optional*|SystemTime|
|**StandardBias**  <br>*optional*|int32|
|**DaylightName**  <br>*optional*|string|
|**DaylightBias**  <br>*optional*|int32|
|**DaylightDate**  <br>*optional*|SystemTime|


<a name="topology"></a>
## Topology

|Name|Schema|
|---|---|
|**Memory**  <br>*optional*|[Memory_2](#memory_2)|
|**Processor**  <br>*optional*|[Processor_2](#processor_2)|


<a name="triplefault"></a>
## TripleFault

|Name|Schema|
|---|---|
|**ErrorType**  <br>*optional*|uint64|


<a name="uefi"></a>
## Uefi

|Name|Description|Schema|
|---|---|---|
|**ApplySecureBootTemplate**  <br>*optional*||enum (Skip, Apply)|
|**BootThis**  <br>*optional*||[UefiBootEntry](#uefibootentry)|
|**Console**  <br>*optional*||enum (Default, Disabled, ComPort1, ComPort2)|
|**EnableDebugger**  <br>*optional*||boolean|
|**SecureBootTemplateId**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**StopOnBootFailure**  <br>*optional*||boolean|


<a name="uefibootentry"></a>
## UefiBootEntry

|Name|Schema|
|---|---|
|**DevicePath**  <br>*optional*|string|
|**DeviceType**  <br>*optional*|enum (ScsiDrive, VmbFs, Network, File)|
|**DiskNumber**  <br>*optional*|integer (uint16)|
|**OptionalData**  <br>*optional*|string|
|**VmbFsRootPath**  <br>*optional*|string|


<a name="uefisysteminformation"></a>
## UefiSystemInformation

|Name|Schema|
|---|---|
|**Manufacturer**  <br>*optional*|string|
|**ProductName**  <br>*optional*|string|
|**Version**  <br>*optional*|string|
|**SerialNumber**  <br>*optional*|string|
|**UUID**  <br>*optional*|guid|
|**SKUNumber**  <br>*optional*|string|
|**Family**  <br>*optional*|string|


<a name="version"></a>
## Version

|Name|Schema|
|---|---|
|**Major**  <br>*optional*|integer (uint32)|
|**Minor**  <br>*optional*|integer (uint32)|


<a name="videomonitor"></a>
## VideoMonitor

|Name|Schema|
|---|---|
|**ConnectionOptions**  <br>*optional*|[RdpConnectionOptions](#rdpconnectionoptions)|
|**HorizontalResolution**  <br>*optional*|integer (uint16)|
|**VerticalResolution**  <br>*optional*|integer (uint16)|


<a name="virtioserial"></a>
## VirtioSerial

|Name|Schema|
|---|---|
|**Ports**  <br>*optional*|< string, [VirtioSerialPort](#virtioserialport) > map|


<a name="virtioserialport"></a>
## VirtioSerialPort

|Name|Schema|
|---|---|
|**Name**  <br>*optional*|string|
|**NamedPipe**  <br>*optional*|string|


<a name="virtualdevicefailure"></a>
## VirtualDeviceFailure

 Provides information on failures originated by a virtual device.

|Name|Schema|
|---|---|
|**InstanceId**  <br>*optional*|Guid|
|**DeviceId**  <br>*optional*|Guid|
|**Name**  <br>*optional*|string|
|**Detail**  <br>*optional*|enum VirtualDeviceFailureDetail ( None, Create, Initialize, StartReservingResources, FinishReservingResources, FreeReservedResources,  SaveReservedResources, PowerOnCold, PowerOnRestore, PowerOff, Save, Resume, Pause, EnableOptimizations, StartDisableOptimizations, FinishDisableOptimizations, Reset, PostReset, Teardown, SaveCompatibilityInfo, MetricRestore, MetricEnumerate, MetricEnumerateForSave, MetricReset, MetricEnable, MetricDisable)|


<a name="virtualmachine"></a>
## VirtualMachine

|Name|Schema|
|---|---|
|**Chipset**  <br>*optional*|[Chipset](#chipset)|
|**ComputeTopology**  <br>*optional*|[Topology](#topology)|
|**Devices**  <br>*optional*|[Devices](#devices)|
|**GuestConnection**  <br>*optional*|[GuestConnection](#guestconnection)|
|**GuestState**  <br>*optional*|[GuestState](#gueststate)|
|**RegistryChanges**  <br>*optional*|[RegistryChanges](#registrychanges)|
|**RestoreState**  <br>*optional*|[RestoreState](#restorestate)|
|**Services**  <br>*optional*|[Services](#services)|
|**StopOnReset**  <br>*optional*|boolean|
|**StorageQoS**  <br>*optional*|[StorageQoS](#storageqos)|


<a name="virtualnodeinfo"></a>
## VirtualNodeInfo

|Name|Schema|
|---|---|
|**MemoryUsageInPages**  <br>*optional*|integer (uint64)|
|**PhysicalNodeNumber**  <br>*optional*|integer (uint8)|
|**VirtualNodeIndex**  <br>*optional*|integer (uint8)|
|**VirtualProcessorCount**  <br>*optional*|integer (uint32)|


<a name="virtualpmemcontroller"></a>
## VirtualPMemController

|Name|Description|Schema|
|---|---|---|
|**Backing**  <br>*optional*||enum (Virtual, Physical)|
|**Devices**  <br>*optional*||< string, [VirtualPMemDevice](#virtualpmemdevice) > map|
|**MaximumCount**  <br>*optional*|/ This field indicates how many empty devices to add to the controller. / If non-zero, additional VirtualPMemDevice objects with no HostPath and / no Mappings will be added to the Devices map to get up to the MaximumCount. / These devices will be configured with either the MaximumSizeBytes field if non-zero, / or with the default maximum, 512 Mb.|integer (uint8)|
|**MaximumSizeBytes**  <br>*optional*||integer (uint64)|


<a name="virtualpmemdevice"></a>
## VirtualPMemDevice

|Name|Schema|
|---|---|
|**HostPath**  <br>*optional*|string|
|**ImageFormat**  <br>*optional*|enum (Vhdx, Vhd1)|
|**Mappings**  <br>*optional*|< string, [VirtualPMemMapping](#virtualpmemmapping) > map|
|**ReadOnly**  <br>*optional*|boolean|
|**SizeBytes**  <br>*optional*|integer (uint64)|


<a name="virtualpmemmapping"></a>
## VirtualPMemMapping

|Name|Schema|
|---|---|
|**HostPath**  <br>*optional*|string|
|**ImageFormat**  <br>*optional*|enum (Vhdx, Vhd1)|


<a name="virtualpcidevice"></a>
## VirtualPciDevice

|Name|Schema|
|---|---|
|**Functions**  <br>*optional*|< [VirtualPciFunction](#virtualpcifunction) > array|


<a name="virtualpcifunction"></a>
## VirtualPciFunction

|Name|Schema|
|---|---|
|**AllowDirectTranslatedP2P**  <br>*optional*|boolean|
|**DeviceInstancePath**  <br>*optional*|string|
|**VirtualFunction**  <br>*optional*|integer (uint16)|


<a name="virtualsmb"></a>
## VirtualSmb

|Name|Schema|
|---|---|
|**DirectFileMappingInMB**  <br>*optional*|integer (int64)|
|**Shares**  <br>*optional*|< [VirtualSmbShare](#virtualsmbshare) > array|


<a name="virtualsmbalternatedatastream"></a>
## VirtualSmbAlternateDataStream

|Name|Schema|
|---|---|
|**Name**  <br>*optional*|Name of the alternate data stream.|string|
|**Contents**  <br>*optional*|Data to be written to the alternate data stream.|ByteArray|


<a name="virtualsmbshare"></a>
## VirtualSmbShare

|Name|Schema|
|---|---|
|**AllowedFiles**  <br>*optional*|< string > array|
|**Name**  <br>*optional*|string|
|**Options**  <br>*optional*|[VirtualSmbShareOptions](#virtualsmbshareoptions)|
|**Path**  <br>*optional*|string|


<a name="virtualsmbshareoptions"></a>
## VirtualSmbShareOptions

|Name|Description|Schema|
|---|---|---|
|**CacheIo**  <br>*optional*|all opens will use cached I/O|boolean|
|**FilterEncryptionAttributes**  <br>*optional*|Filter EFS attributes from the guest|boolean|
|**ForceLevelIIOplocks**  <br>*optional*|disable all oplocks except Level II|boolean|
|**NoDirectmap**  <br>*optional*|disable Direct Mapping|boolean|
|**NoDirnotify**  <br>*optional*|disable Directory CHange Notifications|boolean|
|**NoLocks**  <br>*optional*|disable Byterange locks|boolean|
|**NoOplocks**  <br>*optional*|disable oplock support|boolean|
|**NonCacheIo**  <br>*optional*|All opens will use non-cached IO|boolean|
|**PseudoDirnotify**  <br>*optional*|Enable pseudo directory change notifications|boolean|
|**PseudoOplocks**  <br>*optional*|Enable pseudo-oplocks|boolean|
|**ReadOnly**  <br>*optional*||boolean|
|**ReparseBaseLayer**  <br>*optional*|Allow the host to reparse this base layer|boolean|
|**RestrictFileAccess**  <br>*optional*|allow access only to the files specified in AllowedFiles|boolean|
|**ShareRead**  <br>*optional*|convert exclusive access to shared read access|boolean|
|**SingleFileMapping**  <br>*optional*|Block directory enumeration, renames, and deletes.|boolean|
|**SupportCloudFiles**  <br>*optional*|Support Cloud Files functionality|boolean| 
|**TakeBackupPrivilege**  <br>*optional*|Acquire the backup privilege when attempting to open|boolean|
|**UseShareRootIdentity**  <br>*optional*|Use the identity of the share root when opening|boolean|
|**VmSharedMemory**  <br>*optional*|share is use for VM shared memory|boolean|


<a name="vmmemory"></a>
## VmMemory

|Name|Schema|
|---|---|
|**AssignedMemory**  <br>*optional*|integer (uint64)|
|**AvailableMemory**  <br>*optional*|integer (int32)|
|**AvailableMemoryBuffer**  <br>*optional*|integer (int32)|
|**BalancingEnabled**  <br>*optional*|boolean|
|**DmOperationInProgress**  <br>*optional*|boolean|
|**ReservedMemory**  <br>*optional*|integer (uint64)|
|**SlpActive**  <br>*optional*|boolean|


<a name="windowscrashreport"></a>
## WindowsCrashReport

Windows specific crash information

|Name|Schema|
|---|---|
|**DumpFile**  <br>*optional*|string|
|**OsMajorVersion**  <br>*optional*|integer (int32)|
|**OsMinorVersion**  <br>*optional*|integer (int32)|
|**OsBuildNumber**  <br>*optional*|integer (int32)|
|**OsServicePackMajorVersion**  <br>*optional*|integer (int32)|
|**OsServicePackMinorVersion**  <br>*optional*|integer (int32)|
|**OsSuiteMask**  <br>*optional*|integer (int32)|
|**OsProductType**  <br>*optional*|integer (int32)|
|**Status**  <br>*optional*|integer (int32)|
|**FinalPhase**  <br>*optional*|enum(Inactive, CrashValues, Starting, Started, Writing, Complete)|


<a name="windowscrashreporting"></a>
## WindowsCrashReporting

|Name|Schema|
|---|---|
|**DumpFileName**  <br>*optional*|string|
|**MaxDumpSize**  <br>*optional*|integer (int64)|


<a name="workerexit"></a>
## WorkerExit

Exit code of the virtual machine worker process.

|Name|Schema|
|---|---|
|**ExitCode**  <br>*optional*|uint32|
|**Type**  <br>*optional*|enum WorkerExitType (None // VM Failed to initialize., InitializationFailed // VM shutdown after complete stop, Stopped // VM shutdown after complete save, Saved // VM reset and the VM was configured to stop on reset, StoppedOnReset // VM worker process exited unexpectedly, UnexpectedStop // VM exit after failing to reset, ResetFailed // VM stopped because of an unrecoverable error (e.g., storage failure), UnrecoverableError)|
|**Detail**  <br>*optional*|enum WorkerExitDetail (Invalid, PowerOff, PowerOffCritical, Reset, GuestCrash, GuestFirmwareCrash, TripleFault, DeviceFatalApicRequest, DeviceFatalMsrRequest, DeviceFatalException, DeviceFatalError, DeviceMachineCheck, EmulatorError, VidTerminate, ProcessUnexpectedExit, InitializationFailure, InitializationStartTimeout, ColdStartFailure, ResetStartFailure, FastRestoreStartFailure, RestoreStartFailure, FastSavePreservePartition, FastSavePreservePartitionHandleTransfer, FastSave, CloneTemplate, Save, Migrate, MigrateFailure, CannotReferenceVm, MgotUnregister)|
|**Initiator**  <br>*optional*|enum ExitInitiator (None , GuestOS //Initiated by the guest OS (e.g. guest OS shutdown), Client  //Initiated by the management client, Internal  //Initiated internally (e.g. due to an error) by the virtual machine or HCS.,Unknown  //Initiator is unknown, e.g. a process was terminated or crashed.)|
