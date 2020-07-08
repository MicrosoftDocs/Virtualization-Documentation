# Host Compute System API Reference

The following section contains the definitions of the host Compute System APIs. The DLL exports a set of C-style Windows API functions, using JSON schema as configuration. 


## Data types

|Type|Description|
|---|---|
|[HCS_CREATE_OPTIONS](./HCS_CREATE_OPTIONS.md)|Versions available used by [HcsCreateComputeSystemInNamespace](./HcsCreateComputeSystemInNamespace.md)|
|[HCS_EVENT_TYPE](./HCS_EVENT_TYPE.md)|Events indicated to callbacks registered by [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) or [HcsSetProcessCallback](./HcsSetProcessCallback.md)|
|[HCS_EVENT_OPTIONS](./HCS_EVENT_OPTIONS.md)|Options for an event callback registration|
|[HCS_NOTIFICATION_FLAGS](./HCS_NOTIFICATION_FLAGS.md)|Flags applicable to HCS_NOTIFICATIONS|
|[HCS_NOTIFICATIONS](./HCS_NOTIFICATIONS.md)|Notifications indicated to callbacks registered by [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) or [HcsSetProcessCallback](./HcsSetProcessCallback.md)|
|[HCS_OPERATION_TYPE](./HCS_OPERATION_TYPE.md)|Type of an operation used in the functions that invoke the operation|
|[HCS_PROCESS_INFORMATION](./HCS_PROCESS_INFORMATION.md)|Struct containing information about a process created by [HcsCreateProcess](./HcsCreateProcess.md)|

## Handle types

|Type|Description|
|---|---|
|HCS_SYSTEM|Handle to a compute system|
|HCS_PROCESS|Handle to a process running in a compute system|
|HCS_OPERATION|Handle to an operation on a compute system|
|HCS_CALLBACK|Handle to a callback registered on a compute system or process handle|

## Function types

|Type|Description|
|---|---|
[HCS_OPERATION_COMPLETION](./HCS_OPERATION_COMPLETION.md)|the completion callback of an operation|
|[HCS_EVENT_CALLBACK](./HCS_EVENT_CALLBACK.md)|compute system event callbacks|
|[HCS_NOTIFICATION_CALLBACK](./HCS_NOTIFICATION_CALLBACK.md)|compute system notification callbacks|


###

## Operations
|Function|Description|
|---|---|
|[HcsCreateOperation](./HcsCreateOperation.md)|Create a new operation|
|[HcsCloseOperation](./HcsCloseOperation.md)|Close an operation|
|[HcsGetOperationContext](./HcsGetOperationContext.md)|Get the context pointer of an operation|
|[HcsSetOperationContext](./HcsSetOperationContext.md)|Set the context pointer on an operation|
|[HcsGetComputeSystemFromOperation](./HcsGetComputeSystemFromOperation.md)|Get the compute system associated with operation|
|[HcsGetProcessFromOperation](./HcsGetProcessFromOperation.md)|Return the handle to the process associated with an operation|
|[HcsGetOperationType](./HcsGetOperationType.md)|Get the type of the operation|
|[HcsGetOperationId](./HcsGetOperationId.md)|Get the id of the operation|
|[HcsGetOperationResult](./HcsGetOperationResult.md)|Get the result of the operation|
|[HcsGetOperationResultAndProcessInfo](./HcsGetOperationResultAndProcessInfo.md)|Return the result of an operation|
|[HcsWaitForOperationResult](./HcsWaitForOperationResult.md)| Wait for the completion of the create operation
|[HcsWaitForOperationResultAndProcessInfo](./HcsWaitForOperationResultAndProcessInfo.md)| Wait for the completion of the create operation and returns the result
|[HcsSetOperationCallback](./HcsSetOperationCallback.md)|Set the callbck that is invoked on completion of an operation|
|[HcsCancelOperation](./HcsCancelOperation.md)|Cancel the operation|

## Compute System Operations
|Function|Description|
|---|---|
|[HcsCreateComputeSystem](./HcsCreateComputeSystem.md)|Create a new compute system|
|[HcsCreateComputeSystemInNamespace](./HcsCreateComputeSystemInNamespace.md)|Create a new compute system in a given namespace|
|[HcsOpenComputeSystem](./HcsOpenComputeSystem.md)|Open a handle to an existing compute system|
|[HcsOpenComputeSystemInNamespace](./HcsOpenComputeSystemInNamespace.md)|Open a handle to an existing  compute system in a given namespace|
|[HcsCloseComputeSystem](./HcsCloseComputeSystem.md)|Close a handle to a compute system|
|[HcsStartComputeSystem](./HcsStartComputeSystem.md)|Start a compute system|
|[HcsShutDownComputeSystem](./HcsShutDownComputeSystem.md)|Cleanly  Shut down a compute system|
|[HcsTerminateComputeSystem](./HcsTerminateComputeSystem.md)|Forcefully terminate a compute system|
|[HcsCrashComputeSystem](./HcsCrashComputeSystem.md)|Forcefully terminate a compute system|
|[HcsPauseComputeSystem](./HcsPauseComputeSystem.md)|Pause the execution of a compute system|
|[HcsResumeComputeSystem](./HcsResumeComputeSystem.md)|Resume the execution of a compute system|
|[HcsSaveComputeSystem](./HcsSaveComputeSystem.md)|Save the state of a compute system|
|[HcsGetComputeSystemProperties](./HcsGetComputeSystemProperties.md)| Query properties of a compute system|
|[HcsModifyComputeSystem](./HcsModifyComputeSystem.md)|Modify setting of a compute system|
|[HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md)|Register a callback function to receive notifications for the compute system|
|[HcsEnumerateComputeSystems](./HcsEnumerateComputeSystems.md)|Enumerates existing compute systems|
|[HcsEnumerateComputeSystemsInNamespace](./HcsEnumerateComputeSystemsInNamespace.md)|Enumerates existing compute systems in a given namespace|


## Process Execution

The following functions enable applications to execute a process in a compute system. For containers, these functions are the main way for an application to start and interact with the workload running in the container. Unlike the compute system operations, these process execution functions are executed synchronously.

|Function|Description|
|---|---|
|[HcsCreateProcess](./HcsCreateProcess.md)|Start a process in a compute system |
|[HcsOpenProcess](./HcsOpenProcess.md)|Open an existing process in a compute system |
|[HcsCloseProcess](./HcsCloseProcess.md)|Close the handle to a  process in a compute system |
|[HcsTerminateProcess](./HcsTerminateProcess.md)|Terminate a process in a compute system |
|[HcsSignalProcess](./HcsSignalProcess.md)|Send a signal to a process in a compute system |
|[HcsGetProcessInfo](./HcsGetProcessInfo.md)|Return the initial startup info of a process in a compute system |
|[HcsGetProcessProperties](./HcsGetProcessProperties.md)|Return properties a process in a compute system |
|[HcsModifyProcess](./HcsModifyProcess.md)|Modify the parameters in a process of a compute system |
|[HcsSetProcessCallback](./HcsSetProcessCallback.md)|Register a callback function to receive notifications for a process in a compute system |

## Host Service Operations

The following functions provide functionality for host compute service.

|Function|Description|
|---|---|
|[HcsGetServiceProperties](./HcsGetServiceProperties.md)|Return the properties of the Host Compute Service|
|[HcsModifyServiceSettings](./HcsModifyServiceSettings.md)|Modify the settings of the Host Compute Service|
|[HcsSubmitWerReport](./HcsSubmitWerReport.md)|Submit a WER report|

## Utility Functions for Virtual Machines

The following set of functions allow applications to set up the environment to run virtual machines.

|Function|Description|
|---|---|
|[HcsCreateEmptyGuestStateFile](./HcsCreateEmptyGuestStateFile.md)|Create an empty guest-state file (.vmgs) for VMs|
|[HcsCreateEmptyRuntimeStateFile](./HcsCreateEmptyRuntimeStateFile.md)|Create an empty runtime-state file (.vmrs) for a VM|
|[HcsGrantVmAccess](./HcsGrantVmAccess.md)|Add an entry to a file's ACL that grants access for a VM|
|[HcsRevokeVmAccess](./HcsRevokeVmAccess.md)|Remove an entry to a file's ACL that granted access for a VM|
|[HcsGrantVmGroupAccess](./HcsGrantVmGroupAccess.md)|Grant VM group access (R/O) to the specified file.|
|[HcsRevokeVmGroupAccess](./HcsRevokeVmGroupAccess.md)|Remove VM group access for the specified file.|

## Storage Utility Functions for Containers

The following functions allow applications to create and manage the file system and storage environment that is required to run containers.

|Function|Description|
|---|---|
|[HcsImportLayer](./HcsImportLayer.md)|Imports a container layer and configures it for use on the host|
|[HcsExportLayer](./HcsExportLayer.md)|Exports a container layer that can be copied to another host or uploaded to a container registry|
|[HcsExportLegacyWritableLayer](./HcsExportLegacyWritableLayer.md)|Exports a legacy container writable layer|
|[HcsDestroyLayer](./HcsDestroyLayer.md)|Deletes a container layer from the host|
|[HcsSetupBaseOSLayer](./HcsSetupBaseOSLayer.md)|Sets up a layer that contains a base OS for a container|
|[HcsInitializeWritableLayer](./HcsInitializeWritableLayer.md)|Initializes the writable layer for a container (i.e. the layer that captures the filesystem)|
|[HcsInitializeLegacyWritableLayer](./HcsInitializeLegacyWritableLayer.md)|Initializes the writable layer for a container using the legacy hive folder format|
|[HcsAttachLayerStorageFilter](./HcsAttachLayerStorageFilter.md)|Sets up the layer storage filter on a writable container layers|
|[HcsDetachLayerStorageFilter](./HcsDetachLayerStorageFilter.md)|Detaches the layer storage filter from a writable container layer|
|[HcsFormatWritableLayerVhd](./HcsFormatWritableLayerVhd.md)|Formats a virtual disk for the use as a writable container layer|
|[HcsGetLayerVhdMountPath](./HcsGetLayerVhdMountPath.md)| Returns the volume path for a virtual disk of a writable container layer|
|   |   |