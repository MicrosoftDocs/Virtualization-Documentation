# Host Compute System API Definitions - mamezgeb branch

The following section contains the definitions of the host Compute System APIs. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.

## TODO - all

- Gap: v2 return values
- Align formatting style (device virtualization has a different format)
- Align formatting style for return values
- Question: Where to cross reference device virtualization parameters in code base?
- Fix camelcasing on device virtualization parameters
- Make sure cross-links are in place
- Add barCount parameter to code snippet in HDV_PCI_DEVICE_GET_DETAILS if you keep the formatting style of including a code snippet on the function pages
- HdvReadGuestMemory.md has content for HdvInitializeDeviceHost
- HdvTeardownDeviceHost.md has content for HdvTeardownDeviceHost but is named HdvInitializeDeviceHost
- Right description for the operation parameter in HcsCreateProcess and others in the Process Execution group of functions? And HcsExportLayer
- HcsRegisterProcessCallback is not in v2. Make sure to remove HcsRegisterProcessCallback.md from public view. Same with 
    - Im assuming that HcsSetProcessCallback should also be removed from public view.
- HcsDestroyLayer.md did not exist
- HCSCLoseProcess.md does not have return values. question for devs; does it return values at least and Hresult?
- Seems HCN (Compute Network) is documented here https://docs.microsoft.com/en-us/windows-server/networking/technologies/hcn/hcn-top

## Compute System Operations

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateComputeSystem](./HcsCreateComputeSystem.md)|Creates a new compute system|
|[HcsCreateOperation](./HcsCreateOperation.md)|Creates a new operation|
|[HcsCloseOperation](./HcsCloseOperation.md)|Close an operation|
|[HcsGetOperationContext](./HcsGetOperationContext.md)|Gets the context pointer of an operation|
|[HcsSetOperationContext](./HcsSetOperationContext.md)|Sets the context pointer on an operation|
|[HcsGetComputeSystemFromOperation](.HcsGetComputeSystemFromOperation.md)|Get the compute system associated with operation|
|[HcsGetProcessFromOperation](.HcsGetProcessFromOperation.md)|Returns the handle to the process associated with an operation|
|[HcsGetOperationType](.HcsGetOperationType.md)|Get the type of the operation|
|[HcsGetOperationId](.HcsGetOperationId.md)|Get the id of the operation|
|[HcsGetOperationResult](.HcsGetOperationResult.md)|Get the result of the operation|
|[HcsGetOperationResultAndProcessInfo](.HcsGetOperationResultAndProcessInfo.md)|Returns the result of an operation|
|[HcsWaitForOperationResult](./HcsWaitForOperationResult.md)| Wait for the completion of the create operation
|[HcsCancelOperation](./HcsCancelOperation.md)|Cancel the operation|
|[HcsEnumerateComputeSystems](./HcsEnumerateComputeSystems.md)|Enumerates existing compute systems|
|[HcsGetComputeSystemProperties](./HcsGetComputeSystemProperties.md)| Query a compute system's properties|
|[HcsModifyComputeSystem](./HcsModifyComputeSystem.md)|Modify a compute system|
|[HcsOpenComputeSystem](./HcsOpenComputeSystem.md)|Open a compute system|
|[HcsCloseComputeSystem](./HcsCloseComputeSystem.md)|Closes a handle to a compute system|
|[HcsPauseComputeSystem](./HcsPauseComputeSystem.md)|Pause a compute system|
|[HcsResumeComputeSystem](./HcsResumeComputeSystem.md)|Resume a compute system|
|[HcsSaveComputeSystem](./HcsSaveComputeSystem.md)|Save a compute system|
|[HcsStartComputeSystem](./HcsStartComputeSystem.md)|Start a compute system|
|[HcsShutDownComputeSystem](./HcsShutDownComputeSystem.md)|Shut down a compute system|
|[HcsTerminateComputeSystem](./HcsTerminateComputeSystem.md)|Terminate a compute system|
|   |   |

## Device Virtualization

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HdvCreateDeviceInstance](./hdv/HdvCreateDeviceInstance.md)|Creates a device instance in the current host and associates it with a device emulation interface and context.|
|[HdvCreateGuestMemoryAperture](./hdv/HdvCreateGuestMemoryAperture.md)|Creates a guest RAM aperture into the address space of the calling process.|
|[HdvDeliverGuestInterrupt](./hdv/HdvDeliverGuestInterrupt.md)|Delivers a message signalled interrupt (MSI) to the guest partition.|
|[HdvPciDeviceGetDetails](./hdv/HdvPciDeviceGetDetails.md)|Function invoked to query the PCI description of the emulated device.|
|[HdvPciDeviceInitialize](./hdv/HdvPciDeviceInitialize.md)|Function invoked to initialize the emulated device.|
|[HdvPciDeviceSetConfiguration](./hdv/HdvPciDeviceSetConfiguration.md)|Function invoked to set the configuration of the emulated device.|
|[HdvPciDeviceStart](./hdv/HdvPciDeviceStart.md)|Function called to notify the emulated device that the virtual processors of the VM are about to start.|
|[HdvPciDeviceStop](./hdv/HdvPciDeviceStop.md)|Function called to notify the emulated device that the virtual processors of the VM are about to be stopped.|
|[HdvPciDeviceTeardown](./hdv/HdvPciDeviceTeardown.md)|Function invoked to tear down the emulated device.|
|[HdvPciReadConfigSpace](./hdv/HdvPciReadConfigSpace.md)|Function called to execute a read into the emulated device's PCI config space.|
|[HdvPciReadInterceptedMemory](./hdv/HdvPciReadInterceptedMemory.md)|Function called to execute an intercepted MMIO read for the emulated device.|
|[HdvPciWriteConfigSpace](./hdv/HdvPciWriteConfigSpace.md)|Function called to execute a write to the emulated device's PCI config space.|
|[HdvPciWriteInterceptedMemory](./hdv/HdvPciWriteInterceptedMemory.md)|Function called to execute an intercepted MMIO write for the emulated device.|
|[HdvReadGuestMemory function](./hdv/HdvReadGuestMemory.md)|Reads guest primary memory (RAM) contents into the supplied buffer.|
|[HdvTeardownDeviceHost function](./hdv/HdvTeardownDeviceHost.md)|Tears down the device emulator host in the caller's process.|
|[HdvWriteGuestMemory](./hdv/HdvWriteGuestMemory.md)|Writes the contents of the supplied buffer to guest primary memory (RAM).|
|   |   |

## Process Execution

The following functions enable applications to execute a process in a compute system. For containers, these functions are the main way for an application to start and interact with the workload running in the container. Unlike the compute system operations, these process execution functions are executed synchronously.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCloseProcess](./HcsCloseProcess.md)|Closes the handle to a  process in a compute system |
|[HcsCreateProcess](./HcsCreateProcess.md)|Starts a process in a compute system |
|[HcsGetProcessInfo](./HcsGetProcessInfo.md)|Returns the initial startup info of a process in a compute system |
|[HcsGetProcessProperties](./HcsGetProcessProperties.md)|Returns properties a process in a compute system |
|[HcsModifyProcess](./HcsModifyProcess.md)|Modifies a process in a compute system |
|[HcsOpenProcess](./HcsOpenProcess.md)|Opens a process in a compute system |
|[HcsSignalProcess](./HcsSignalProcess.md)|Sends a signal to a process in a compute system |
|[HcsTerminateProcess](./HcsTerminateProcess.md)|Terminates a process in a compute system |

|   |   |

## Utility Functions for Virtual Machines

The following set of functions allow applications to set up the environment to run virtual machines.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateEmptyGuestStateFile](./HcsCreateEmptyGuestStateFile.md)|Creates an empty guest-state file (.vmgs) for VMs that are expected to be persisted or restarted multiple times |
|[HcsCreateEmptyRuntimeStateFile](./HcsCreateEmptyRuntimeStateFile.md)|Creates an empty runtime-state file (.vmrs) for a VM. Used to save running VMs.|
|[HcsGrantVmAccess](./HcsGrantVmAccess.md)|Grants access for a VM|
|[HcsRevokeVmAccess](./HcsRevokeVmAccess.md)|Revokes access to a user account to run a VM|
|   |   |

## Storage Utility Functions for Containers

The following functions allow applications to create and manage the file system and storage environment that is required to run containers.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsAttachLayerStorageFilter](./HcsAttachLayerStorageFilter.md)|Sets up the layer storage filter on a writable container layer|
|[HcsDestroyLayer](./HcsDestroyLayer.md)|Deletes a container layer from the host|
|[HcsDetachLayerStorageFilter](./HcsDetachLayerStorageFilter.md)|Detaches the layer storage filter from a writable container layer|
|[HcsExportLayer](./HcsExportLayer.md)|Exports a container layer that can be copied to another host or uploaded to a container registry|
|[HcsFormatWritableLayerVhd](./HcsFormatWritableLayerVhd.md)|Formats a virtual disk for the use as a writable container layer|
|[HcsGetLayerVhdMountPath](./HcsGetLayerVhdMountPath.md)| Returns the volume path for a virtual disk of a writable container layer|
|[HcsImportLayer](./HcsImportLayer.md)|Imports a container layer and configures it for use on the host|
|[HcsInitializeWritableLayer](./HcsInitializeWritableLayer.md)|Initializes the writable layer for a container (i.e. the layer that captures the filesystem)|
|[HcsSetupBaseOSLayer](./HcsSetupBaseOSLayer.md)|Sets up a base OS layer on the host|
|   |   |

## Host Operations

The following functions provide functionality that is not specified to a compute system.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsGetServiceProperties](./HcsGetServiceProperties.md)|Returns the properties of the Host Compute System|
|[HcsModifyServiceSettings](./HcsModifyServiceSettings.md)|Modifies the settings of the Host Compute System|
|[HcsSubmitWerReport](./HcsSubmitWerReport.md)|Submits a WER report for a bugcheck of a VM|
|   |   |
