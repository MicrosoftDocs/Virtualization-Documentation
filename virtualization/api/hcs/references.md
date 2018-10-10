# Host Compute System API Definitions

The following section contains the definitions of the host Compute System APIs. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.


## Compute System Opterations
|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateComputeSystem](reference/HcsCreateComputeSystem.md)|Create a compute system|
|[HcsGetComputeSystemProperties](reference/HcsGetComputeSystemProperties.md)| Query a compute system's properties|
|[HcsModifyComputeSystem](reference/HcsModifyComputeSystem.md)|Modify a compute system|
|[HcsOpenComputeSystem](reference/HcsOpenComputeSystem.md)|Open a compute system|
|[HcsPauseComputeSystem](reference/HcsPauseComputeSystem.md)|Pause a compute system|
|[HcsResumeComputeSystem](reference/HcsResumeComputeSystem.md)|Resume a compute system|
|[HcsSaveComputeSystem](reference/HcsSaveComputeSystem.md)|Save a compute system|
|[HcsStartComputeSystem](reference/HcsStartComputeSystem.md)|Start a compute system|
|[HcsShutDownComputeSystem](reference/HcsShutDownComputeSystem.md)|Shut down a compute system|
|[HcsTerminateComputeSystem](reference/HcsTerminateComputeSystem.md)|Terminate a compute system|
|   |   |

## Process Execution
The following functions enable applications to execute a process in a compute system. For containers, these functions are the main way for an application to start and interact wit hte workload running in the container. Unlike the compute system operations, these process execution functions are executed synchronously. 

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCloseProcess](reference/HcsCloseProcess.md)|Close a process in a compute system |
|[HcsCreateProcess](reference/HcsCreateProcess.md)|Start a process in a compute system |
|[HcsGetProcessInfo](reference/HcsGetProcessInfo.md)|Return the initial startup info of a process in a compute system |
|[HcsGetProcessProperties](reference/HcsGetProcessProperties.md)|Return properties a process in a compute system |
|[HcsModifyProcess](reference/HcsModifyProcess.md)|Modify a process in a compute system |
|[HcsOpenProcess](reference/HcsOpenProcess.md)|Open a process in a compute system |
|[HcsRegisterProcessCallback](reference/HcsRegisterProcessCallback.md)|Register a callback function to process in a compute system |
|[HcsSignalProcess](reference/HcsSignalProcess.md)|Send a signal to a process in a compute system |
|[HcsTerminateProcess](reference/HcsTerminateProcess.md)|Terminate a process in a compute system |
|[HcsUnregisterProcessCallback](reference/HcsUnregisterProcessCallback.md)|Unregister a callback function to process in a compute system |
|   |   |

## Utility Functions for Virtual Machines
The following set of functions allow applications to set up the environment to run virtual machines.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsCreateEmptyGuestStateFile](reference/HcsCreateEmptyGuestStateFile.md)|Create a guest-state file for VMs that are expected to persist or restart multiple times |
|[HcsCreateEmptyRuntimeStateFile](reference/HcsCreateEmptyRuntimeStateFile.md)|Create a funtime-state file which is used to save running VMs|
|[HcsGrantVmAccess](reference/HcsGrantVmAccess.md)|Grant access to a user account to run a VM|
|[HcsRevokeVmAccess](reference/HcsrevokeVmAccess.md)|Revoke access to a user account to run a VM|
|   |   |

## Storage Utility Functions for Containers
The following functions allow applications to create and manage the file system and storage environment that is required to run containers.

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HcsAttachLayerStorageFilter](reference/HcsAttachLayerStorageFilter.md)|Sets up the container storage filter on a layer directory|
|[HcsDestroyLayer](reference/HcsDestoryLayer.md)|Deletes layer from the host|
|[HcsDetachLayerStorageFilter](reference/HcsDetachLayerStorageFilter.md)|Detaches the container storage filter from the root directory of a layer|
|[HcsExportLayer](reference/HcsExportLayer.md)|Exports a container layer that can be copied to another host or uploaded to a container registry|
|[HcsFormatWritableLayerVhd](reference/HcsFormatWritableLayerVhd.md)|Creates and formats a partition that is to be used as a writable layer for a container|
|[HcsGetLayerVhdMountPath](reference/HcsGetLayerVhdMountPath.md)| Returns the volume path for a layer VHD mounted on the host|
|[HcsImportLayer](reference/HcsImportLayer.md)|Imports a container layer and sets it up on the host|
|[HcsInitializeWritableLayer](reference/HcsInitializeWritableLayer.md)|Initializes the writable layer for a container (i.e. the layer that captures the filesystem)|
|[HcsSetupBaseOSLayer](reference/HcsSetupBaseOSLayer.md)|Sets up a base OS layer on the host|
|   |   |