---
title: HCN Error Code
description: HCN Error Code
author: kemange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HCN Error Code
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCN Error Code

Most of the the HCN functions use `HRESULT` return codes. These return codes can be found in the [Winerror.h](https://docs.microsoft.com/en-us/windows/win32/api/winerror/) header file. The following table shows HCN specific error codes:



|Name|Description|Value|
|---|---|---|
|`S_OK`|Success|`0x00000000`|
|`HCN_E_NETWORK_NOT_FOUND`|The network was not found|`0x803b0001`|
|`HCN_E_ENDPOINT_NOT_FOUND`|The endpoint was not found|`0x803b0002`|
|`HCN_E_LAYER_NOT_FOUND`|The network's underlying layer was not found|`0x803b0003`|
|`HCN_E_SWITCH_NOT_FOUND`|The virtual switch was not found|`0x803b0004`|
|`HCN_E_SUBNET_NOT_FOUND`|The network does not have a subnet for this endpoint|`0x803b0005`|
|`HCN_E_ADAPTER_NOT_FOUND`|An adapter was not found|`0x803b0006`|
|`HCN_E_PORT_NOT_FOUND`|The switch-port was not found|`0x803b0007`|
|`HCN_E_POLICY_NOT_FOUND`|An expected policy was not found|`0x803b0008`|
|`HCN_E_VFP_PORTSETTING_NOT_FOUND`|A required VFP port setting was not found|`0x803b0009`|
|`HCN_E_INVALID_NETWORK`|The provided network configuration is invalid or missing parameters|`0x803b000a`|
|`HCN_E_INVALID_NETWORK_TYPE`|Invalid network type|`0x803b000b`|
|`HCN_E_INVALID_ENDPOINT`|The provided endpoint configuration is invalid or missing parameters|`0x803b000c`|
|`HCN_E_INVALID_POLICY`|The provided policy configuration is invalid or missing parameters|`0x803b000d`|
|`HCN_E_INVALID_POLICY_TYPE`|Invalid policy type|`0x803b000e`|
|`HCN_E_INVALID_REMOTE_ENDPOINT_OPERATION`|This requested operation is invalid for a remote endpoint|`0x803b000f`|
|`HCN_E_NETWORK_ALREADY_EXISTS`|A network with this name already exists|`0x803b0010`|
|`HCN_E_LAYER_ALREADY_EXISTS`|A network with this name already exists|`0x803b0011`|
|`HCN_E_POLICY_ALREADY_EXISTS`|Policy information already exists on this object|`0x803b0012`|
|`HCN_E_PORT_ALREADY_EXISTS`|The specified port already exists|`0x803b0013`|
|`HCN_E_ENDPOINT_ALREADY_ATTACHED`|This endpoint is already attached to the switch|`0x803b0014`|
|`HCN_E_REQUEST_UNSUPPORTED`|The specified request is unsupported|`0x803b0015`|
|`HCN_E_MAPPING_NOT_SUPPORTED`|Port mapping is not supported on the given network|`0x803b0016`|
|`HCN_E_DEGRADED_OPERATION`|There was an operation attempted on a degraded object|`0x803b0017`|
|`HCN_E_SHARED_SWITCH_MODIFICATION`|Cannot modify a switch shared by multiple networks|`0x803b0018`|
|`HCN_E_GUID_CONVERSION_FAILURE`|Failed to interpret a parameter as a GUID|`0x803b0019`|
|`HCN_E_REGKEY_FAILURE`|Failed to process registry key|`0x803b001a`|
|`HCN_E_INVALID_JSON`|Invalid JSON document string|`0x803b001b`|
|`HCN_E_INVALID_JSON_REFERENCE`|The reference is invalid in the JSON document|`0x803b001c`|
|`HCN_E_ENDPOINT_SHARING_DISABLED`|Endpoint sharing is disabled|`0x803b001d`|
|`HCN_E_INVALID_IP`|IP address is either invalid or not part of any configured subnet(s)|`0x803b001e`|
|`HCN_E_SWITCH_EXTENSION_NOT_FOUND`|The specified switch extension does not exist on this switch|`0x803b001f`|
|`HCN_E_MANAGER_STOPPED`|Operation cannot be performed while service is stopping|`0x803b0020`|
|`GCN_E_MODULE_NOT_FOUND`|Operation cannot be performed while service module not found|`0x803b0021`|
|`GCN_E_NO_REQUEST_HANDLERS`|Request Handlers not present to handle the JSON request|`0x803b0022`|
|`GCN_E_REQUEST_UNSUPPORTED`|The specified request is unsupported|`0x803b0023`|
|`GCN_E_RUNTIMEKEYS_FAILED`|Add runtime keys to container failed|`0x803b0024`|
|`GCN_E_NETADAPTER_TIMEOUT`|Timeout while waiting for network adapter with the given instance id|`0x803b0025`|
|`GCN_E_NETADAPTER_NOT_FOUND`|Network adapter not found for the given instance id|`0x803b0026`|
|`GCN_E_NETCOMPARTMENT_NOT_FOUND`|Network compartment not found for the given id|`0x803b0027`|
|`GCN_E_NETINTERFACE_NOT_FOUND`|Network interface not found for the given id|`0x803b0028`|
|`GCN_E_DEFAULTNAMESPACE_EXISTS`|Default Namespace already exists|`0x803b0029`|
|`HCN_E_ICS_DISABLED`|Internet Connection Sharing service (SharedAccess) is disabled and cannot be started|`0x803b002A`|
|`HCN_E_ENDPOINT_NAMESPACE_ALREADY_EXISTS`|This requested operation is invalid as endpoint is already part of a network namespace|`0x803b002B`|
|`HCN_E_ENTITY_HAS_REFERENCES`|The specified entity cannot be removed while it still has references|`0x803b002C`|
|`HCN_E_INVALID_INTERNAL_PORT`|The internal port must exist and cannot be zero|`0x803b002D`|
|`HCN_E_NAMESPACE_ATTACH_FAILED`|The requested operation for attach namespace failed|`0x803b002E`|
|`HCN_E_ADDR_INVALID_OR_RESERVED`|An address provided is invalid or reserved|`0x803b002F`|
|`HCN_E_INVALID_PREFIX`|The prefix provided is invalid|`0x803b0030`|
|`HCN_E_OBJECT_USED_AFTER_UNLOAD`|A call was performed against an object that was torn down|`0x803b0031`|
|`HCN_E_INVALID_SUBNET`|The provided subnet configuration is invalid or missing parameters|`0x803b0032`|
|`HCN_E_INVALID_IP_SUBNET`|he provided IP subnet configuration is invalid or missing parameters|`0x803b0033`|
|`HCN_E_ENDPOINT_NOT_ATTACHED`|The endpoint must be attached to complete the operation|`0x803b0034`|
|`HCN_E_ENDPOINT_NOT_LOCAL`|The endpoint must be local to complete the operation|`0x803b0035`|
|`HCN_INTERFACEPARAMETERS_ALREADY_APPLIED`|Cannot apply more than one InterfaceParameters policy|`0x803b0036`|
|`HCN_E_VFP_NOT_ALLOWED`|A network of this type can not be created because VFP is not available|`0x803b0037`|
