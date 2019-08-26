# JSON Schema Reference

<a name="attachment"></a>
## Attachment

|Name|Schema|
|---|---|
|**CachingMode**  <br>*optional*|enum (Uncached, Cached, ReadOnlyCached)|
|**Path**  <br>*optional*|string|
|**ReadOnly**  <br>*optional*|boolean|
|**Type**  <br>*optional*|enum (VirtualDisk, Iso, PassThru)|


<a name="battery"></a>
## Battery
*Type* : object


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


<a name="closehandle"></a>
## CloseHandle

|Name|Schema|
|---|---|
|**Handle**  <br>*optional*|enum (StdIn, StdOut, StdErr, All)|


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


<a name="containercredentialguardstate"></a>
## ContainerCredentialGuardState

|Name|Description|Schema|
|---|---|---|
|**Cookie**  <br>*optional*|Authentication cookie for calls to a Container Credential Guard instance.|string (binary)|
|**CredentialSpec**  <br>*optional*|Credential spec used for the configured Container Credential Guard instance.|string|
|**RpcEndpoint**  <br>*optional*|Name of the RPC endpoint of the Container Credential Guard instance.|string|
|**Transport**  <br>*optional*|Transport used for the configured Container Credential Guard instance.|enum (LRPC, HvSocket)|


<a name="device"></a>
## Device

|Name|Description|Schema|
|---|---|---|
|**InterfaceClassGuid**  <br>*optional*|The interface class guid of the device interfaces to assign to the  container.  Only used when Type is ClassGuid.  <br>**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**LocationPath**  <br>*optional*|The location path of the device to assign to the container.  Only used when Type is DeviceInstance.|string|
|**Type**  <br>*optional*|The type of device to assign to the container.|enum (ClassGuid, DeviceInstance, GpuMirror)|


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
|**VirtualSmb**  <br>*optional*|[VirtualSmb](#virtualsmb)|


<a name="enhancedmodevideo"></a>
## EnhancedModeVideo

|Name|Schema|
|---|---|
|**ConnectionOptions**  <br>*optional*|[RdpConnectionOptions](#rdpconnectionoptions)|


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
|**UseVsock**  <br>*optional*|Use Vsock rather than Hyper-V sockets to communicate with the guest service.|boolean|


<a name="guestconnectioninfo"></a>
## GuestConnectionInfo
Information about the guest.


|Name|Description|Schema|
|---|---|---|
|**GuestDefinedCapabilities**  <br>*optional*||object|
|**ProtocolVersion**  <br>*optional*||integer (uint32)|
|**SupportedSchemaVersions**  <br>*optional*|Each schema version x.y stands for the range of versions a.b where a==x  and b<=y. This list comes from the SupportedSchemaVersions field in  GcsCapabilities.|< [Version](#version) > array|


<a name="guestcrashreporting"></a>
## GuestCrashReporting

|Name|Schema|
|---|---|
|**WindowsCrashSettings**  <br>*optional*|[WindowsCrashReporting](#windowscrashreporting)|


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


<a name="hvsocket"></a>
## HvSocket

|Name|Schema|
|---|---|
|**Config**  <br>*optional*|[HvSocketSystemConfig](#hvsocketsystemconfig)|
|**EnablePowerShellDirect**  <br>*optional*|boolean|


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


<a name="kernelintegration"></a>
## KernelIntegration
*Type* : object


<a name="keyboard"></a>
## Keyboard
*Type* : object


<a name="layer"></a>
## Layer

|Name|Description|Schema|
|---|---|---|
|**Cache**  <br>*optional*|Unspecified defaults to Enabled|enum (, Disabled, Enabled, Private, PrivateAllowSharing)|
|**Id**  <br>*optional*|**Pattern** : `"^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"`|string|
|**Path**  <br>*optional*||string|
|**PathType**  <br>*optional*||enum (AbsolutePath, VirtualSmbShareName)|


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


<a name="mappedpipe"></a>
## MappedPipe

|Name|Schema|
|---|---|
|**ContainerPipeName**  <br>*optional*|string|
|**HostPath**  <br>*optional*|string|
|**HostPathType**  <br>*optional*|enum (AbsolutePath, VirtualSmbPipeName)|


<a name="memory"></a>
## Memory

|Name|Schema|
|---|---|
|**SizeInMB**  <br>*optional*|integer (uint64)|


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
|**EnableColdHint**  <br>*optional*|If enabled, then the memory cold hint feature is exposed to the VM, allowing it to trim pages  from its working set (if supported by the guest operating system).|boolean|
|**EnableDeferredCommit**  <br>*optional*|If enabled, then commit is not charged for each backing page until first access.|boolean|
|**EnableHotHint**  <br>*optional*|If enabled, then the memory hot hint feature is exposed to the VM, allowing it to prefetch  pages into its working set. (if supported by the guest operating system).|boolean|
|**ForbidSmallBackingPages**  <br>*optional*|If enabled, then backing page chunks smaller than the backing page size are never used unless  the system is under extreme memory pressure. If the backing page size is Small, then it is  forced to Large when this option is enabled.|boolean|
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

|Name|Schema|
|---|---|
|**Count**  <br>*optional*|integer (uint32)|
|**Maximum**  <br>*optional*|integer (uint64)|
|**Weight**  <br>*optional*|integer (uint64)|


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


<a name="properties"></a>
## Properties

|Name|Description|Schema|
|---|---|---|
|**ExitType**  <br>*optional*||enum (None, GracefulExit, ForcedExit, UnexpectedExit, Unknown)|
|**GuestConnectionInfo**  <br>*optional*||[GuestConnectionInfo](#guestconnectioninfo)|
|**HostingSystemId**  <br>*optional*||string|
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
|**PropertyTypes**  <br>*optional*|< enum (Memory, GuestMemory, Statistics, ProcessList, TerminateOnLastHandleClosed, SharedMemoryRegion, GuestConnection) > array|


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


<a name="restorestate"></a>
## RestoreState

|Name|Description|Schema|
|---|---|---|
|**SaveStateFilePath**  <br>*optional*|The path to the save state file to restore the system from.|string|
|**TemplateSystemId**  <br>*optional*|The ID of the template system to clone this new system off of. An empty  string indicates the system should not be cloned from a template.|string|


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


<a name="topology"></a>
## Topology

|Name|Schema|
|---|---|
|**Memory**  <br>*optional*|[Memory_2](#memory_2)|
|**Processor**  <br>*optional*|[Processor_2](#processor_2)|


<a name="uefi"></a>
## Uefi

|Name|Description|Schema|
|---|---|---|
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


<a name="virtualsmb"></a>
## VirtualSmb

|Name|Schema|
|---|---|
|**DirectFileMappingInMB**  <br>*optional*|integer (int64)|
|**Shares**  <br>*optional*|< [VirtualSmbShare](#virtualsmbshare) > array|


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


<a name="windowscrashreporting"></a>
## WindowsCrashReporting

|Name|Schema|
|---|---|
|**DumpFileName**  <br>*optional*|string|
|**MaxDumpSize**  <br>*optional*|integer (int64)|



