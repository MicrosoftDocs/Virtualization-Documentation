# Host Compute System API Definitions

The following section contains the definitions of the host Compute System APIs. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.


## Compute System Opterations
|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateComputeSystem](./HcsCreateComputeSystem.md)|Create a compute system|
|[HcsGetComputeSystemProperties](./HcsGetComputeSystemProperties.md)| Query a compute system's properties|
|[HcsModifyComputeSystem](./HcsModifyComputeSystem.md)|Modify a compute system|
|[HcsOpenComputeSystem](./HcsOpenComputeSystem.md)|Open a compute system|
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
|[HdvCreateDeviceInstance function](./hdv/HdvCreateDeviceInstance.md)|Create a compute system|
|[HdvCreateGuestMemoryAperture function](./hdv/HdvCreateGuestMemoryAperture.md)|Create a compute system|
|[HdvDeliverGuestInterrupt function](./hdv/HdvDeliverGuestInterrupt.md)|Create a compute system|
|[HdvPciDeviceGetDetails function](./hdv/HdvPciDeviceGetDetails.md)|Create a compute system|
|[HdvPciDeviceInitialize function](./hdv/HdvPciDeviceInitialize.md)|Create a compute system|
|[HdvPciDeviceInterface structure](./hdv/HdvPciDeviceInterface.md)|Create a compute system|
|[HdvPciDeviceSetConfiguration function](./hdv/HdvPciDeviceSetConfiguration.md)|Create a compute system|
|[HdvPciDeviceStart function](./hdv/HdvPciDeviceStart.md)|Create a compute system|
|[HdvPciDeviceStop function](./hdv/HdvPciDeviceStop.md)|Create a compute system|
|[HdvPciDeviceTeardown function](./hdv/HdvPciDeviceTeardown.md)|Create a compute system|
|[HdvPciReadConfigSpace function](./hdv/HdvPciReadConfigSpace.md)|Create a compute system|
|[HdvPciReadInterceptedMemory function](./hdv/HdvPciReadInterceptedMemory.md)|Create a compute system|
|[HdvPciWriteConfigSpace function](./hdv/HdvPciWriteConfigSpace.md)|Create a compute system|
|[HdvPciWriteInterceptedMemory function](./hdv/HdvPciWriteInterceptedMemory.md)|Create a compute system|
|[HdvReadGuestMemory function](./hdv/HdvReadGuestMemory.md)|Create a compute system|
|[HdvTeardownDeviceHost function](./hdv/HdvTeardownDeviceHost.md)|Create a compute system|
|[HdvWriteGuestMemory function](./hdv/HdvWriteGuestMemory.md)|Create a compute system|
|   |   |

## Process Execution
The following functions enable applications to execute a process in a compute system. For containers, these functions are the main way for an application to start and interact wit hte workload running in the container. Unlike the compute system operations, these process execution functions are executed synchronously. 

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCloseProcess](./HcsCloseProcess.md)|Close a process in a compute system |
|[HcsCreateProcess](./HcsCreateProcess.md)|Start a process in a compute system |
|[HcsGetProcessInfo](./HcsGetProcessInfo.md)|Return the initial startup info of a process in a compute system |
|[HcsGetProcessProperties](./HcsGetProcessProperties.md)|Return properties a process in a compute system |
|[HcsModifyProcess](./HcsModifyProcess.md)|Modify a process in a compute system |
|[HcsOpenProcess](./HcsOpenProcess.md)|Open a process in a compute system |
|[HcsRegisterProcessCallback](./HcsRegisterProcessCallback.md)|Register a callback function to process in a compute system |
|[HcsSignalProcess](./HcsSignalProcess.md)|Send a signal to a process in a compute system |
|[HcsTerminateProcess](./HcsTerminateProcess.md)|Terminate a process in a compute system |
|[HcsUnregisterProcessCallback](./HcsUnregisterProcessCallback.md)|Unregister a callback function to process in a compute system |
|   |   |

## Utility Functions for Virtual Machines
The following set of functions allow applications to set up the environment to run virtual machines.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateEmptyGuestStateFile](./HcsCreateEmptyGuestStateFile.md)|Create a guest-state file for VMs that are expected to persist or restart multiple times |
|[HcsCreateEmptyRuntimeStateFile](./HcsCreateEmptyRuntimeStateFile.md)|Create a funtime-state file which is used to save running VMs|
|[HcsGrantVmAccess](./HcsGrantVmAccess.md)|Grant access to a user account to run a VM|
|[HcsRevokeVmAccess](./HcsrevokeVmAccess.md)|Revoke access to a user account to run a VM|
|   |   |

## Storage Utility Functions for Containers
The following functions allow applications to create and manage the file system and storage environment that is required to run containers.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsAttachLayerStorageFilter](./HcsAttachLayerStorageFilter.md)|Sets up the container storage filter on a layer directory|
|[HcsDestroyLayer](./HcsDestoryLayer.md)|Deletes layer from the host|
|[HcsDetachLayerStorageFilter](./HcsDetachLayerStorageFilter.md)|Detaches the container storage filter from the root directory of a layer|
|[HcsExportLayer](./HcsExportLayer.md)|Exports a container layer that can be copied to another host or uploaded to a container registry|
|[HcsFormatWritableLayerVhd](./HcsFormatWritableLayerVhd.md)|Creates and formats a partition that is to be used as a writable layer for a container|
|[HcsGetLayerVhdMountPath](./HcsGetLayerVhdMountPath.md)| Returns the volume path for a layer VHD mounted on the host|
|[HcsImportLayer](./HcsImportLayer.md)|Imports a container layer and sets it up on the host|
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