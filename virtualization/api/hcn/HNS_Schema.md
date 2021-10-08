---
title: HcnSchema
description: HcnSchema
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnSchema
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# Agenda
- [Enums](#enums)
- [Structs](#structs)
- [JSON type table](#JSON-type)
- [Version Map](#Schema-Version-Map)
---
<a name = "enums"></a>
# Enums
Note: all variants listed should be used as string
<a name = "ActionType"></a>
## ActionType
Referenced by: [CommonAclPolicySetting](#CommonAclPolicySetting); [TierAclRule](#TierAclRule)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Allow"`<br>|[2.0](#Schema-Version-Map)||
|`"Block"`<br>|[2.0](#Schema-Version-Map)||
|`"Pass"`<br>|[2.10](#Schema-Version-Map)||

---

<a name = "AuthenticationType"></a>
## AuthenticationType
Referenced by: [PrioritizedAuthenticationMethod](#PrioritizedAuthenticationMethod)



|Variants|NewInVersion|Description|
|---|---|---|
|`"PresharedKey"`<br>|[2.1](#Schema-Version-Map)||
|`"Certificate"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "DirectionType"></a>
## DirectionType
Referenced by: [CommonAclPolicySetting](#CommonAclPolicySetting); [TierAclPolicySetting](#TierAclPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"In"`<br>|[2.0](#Schema-Version-Map)||
|`"Out"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "EncryptionMethod"></a>
## EncryptionMethod
Referenced by: [EncryptionPolicySetting](#EncryptionPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Ipsec"`<br>|[2.1](#Schema-Version-Map)||

---

<a name = "EndpointFlags"></a>
## EndpointFlags
Referenced by: [HostComputeEndpoint](#HostComputeEndpoint)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"RemoteEndpoint"`<br>|[2.0](#Schema-Version-Map)||
|`"DisableInterComputeCommunication"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableMirroring"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableLowInterfaceMetric"`<br>|[2.0](#Schema-Version-Map)||
|`"OverrideDNSServerOrder"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableDhcp"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "EndpointPolicyType"></a>
## EndpointPolicyType
Referenced by: [EndpointPolicy](#EndpointPolicy)



|Variants|NewInVersion|Description|
|---|---|---|
|`"PortMapping"`<br>|[2.0](#Schema-Version-Map)||
|`"ACL"`<br>|[2.0](#Schema-Version-Map)||
|`"QOS"`<br>|[2.0](#Schema-Version-Map)||
|`"L2Driver"`<br>|[2.0](#Schema-Version-Map)||
|`"OutBoundNAT"`<br>|[2.0](#Schema-Version-Map)||
|`"SDNRoute"`<br>|[2.0](#Schema-Version-Map)||
|`"L4Proxy"`<br>|[2.0](#Schema-Version-Map)||
|`"L4WFPPROXY"`<br>|[2.5](#Schema-Version-Map)||
|`"ProviderAddress"`<br>|[2.0](#Schema-Version-Map)|Maps to VNET policy with PA|
|`"PortName"`<br>|[2.0](#Schema-Version-Map)||
|`"EncapOverhead"`<br>|[2.0](#Schema-Version-Map)||
|`"InterfaceConstraint"`<br>|[2.0](#Schema-Version-Map)||
|`"Encryption"`<br>|[2.1](#Schema-Version-Map)||
|`"VLAN"`<br>|[2.4](#Schema-Version-Map)||
|`"InterfaceParameters"`<br>|[2.4](#Schema-Version-Map)||
|`"Iov"`<br>|[2.9](#Schema-Version-Map)||
|`"TierAcl"`<br>|[2.10](#Schema-Version-Map)||

---

<a name = "EndpointResourceType"></a>
## EndpointResourceType
Referenced by: [ModifyEndpointSettingRequest](#ModifyEndpointSettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Port"`<br>|[2.0](#Schema-Version-Map)||
|`"Policy"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "EntityFlags"></a>
## EntityFlags


|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableNonPersistent"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "GuestEndpointResourceType"></a>
## GuestEndpointResourceType
Referenced by: [ModifyGuestEndpointSettingRequest](#ModifyGuestEndpointSettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Interface"`<br>|[2.0](#Schema-Version-Map)||
|`"Route"`<br>|[2.0](#Schema-Version-Map)||
|`"IPAddress"`<br>|[2.0](#Schema-Version-Map)||
|`"DNS"`<br>|[2.0](#Schema-Version-Map)||
|`"RegistryKey"`<br>|[2.0](#Schema-Version-Map)||
|`"Encryption"`<br>|[2.1](#Schema-Version-Map)||
|`"MacAddress"`<br>|[2.5](#Schema-Version-Map)||
|`"L4Proxy"`<br>|[2.5](#Schema-Version-Map)||
|`"L4WFPPROXY"`<br>|[2.5](#Schema-Version-Map)||
|`"Xlat"`<br>|[2.5](#Schema-Version-Map)||
|`"Neighbor"`<br>|[2.5](#Schema-Version-Map)||

---

<a name = "GuestNamespaceResourceType"></a>
## GuestNamespaceResourceType
Referenced by: [ModifyGuestNamespaceSettingRequest](#ModifyGuestNamespaceSettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Container"`<br>|[2.0](#Schema-Version-Map)||
|`"Endpoint"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceFlags"></a>
## GuestNetworkServiceFlags
Referenced by: [GuestNetworkService](#GuestNetworkService)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.12](#Schema-Version-Map)||
|`"IsFlowsteered"`<br>|[2.12](#Schema-Version-Map)||
|`"IsFlowsteeredSelfManaged"`<br>|[2.14](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceInterfaceState"></a>
## GuestNetworkServiceInterfaceState
Referenced by: [GuestNetworkServiceInterface](#GuestNetworkServiceInterface)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Created"`<br>|[2.2](#Schema-Version-Map)||
|`"Bootstrapping"`<br>|[2.2](#Schema-Version-Map)||
|`"Synchronized"`<br>|[2.2](#Schema-Version-Map)||
|`"Desynchronized"`<br>|[2.2](#Schema-Version-Map)||
|`"Paused"`<br>|[2.2](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceNotificationType"></a>
## GuestNetworkServiceNotificationType
Referenced by: [GuestNetworkServiceInterface](#GuestNetworkServiceInterface)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.7](#Schema-Version-Map)||
|`"DNSCacheParam"`<br>|[2.7](#Schema-Version-Map)||
|`"DHCPParam"`<br>|[2.7](#Schema-Version-Map)||
|`"InterfaceParam"`<br>|[2.7](#Schema-Version-Map)||
|`"AddressParam"`<br>|[2.7](#Schema-Version-Map)||
|`"Route"`<br>|[2.7](#Schema-Version-Map)||
|`"DNSParam"`<br>|[2.7](#Schema-Version-Map)||
|`"XlatParam"`<br>|[2.7](#Schema-Version-Map)||
|`"Neighbor"`<br>|[2.7](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceResourceType"></a>
## GuestNetworkServiceResourceType
Referenced by: [ModifyGuestNetworkServiceSettingRequest](#ModifyGuestNetworkServiceSettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"State"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceState"></a>
## GuestNetworkServiceState
Referenced by: [GuestNetworkServiceNotificationData](#GuestNetworkServiceNotificationData); [GuestNetworkServiceStateRequest](#GuestNetworkServiceStateRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"Created"`<br>|[2.0](#Schema-Version-Map)||
|`"Bootstrapping"`<br>|[2.0](#Schema-Version-Map)||
|`"Synchronized"`<br>|[2.0](#Schema-Version-Map)||
|`"Paused"`<br>|[2.0](#Schema-Version-Map)||
|`"Desynchronized"`<br>|[2.5](#Schema-Version-Map)||
|`"Rehydrating"`<br>|[2.5](#Schema-Version-Map)||
|`"Degraded"`<br>|[2.0](#Schema-Version-Map)||
|`"Destroyed"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "GuestResourceType"></a>
## GuestResourceType
Referenced by: [GuestModifySettingRequest](#GuestModifySettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Endpoint"`<br>|[2.0](#Schema-Version-Map)||
|`"Namespace"`<br>|[2.0](#Schema-Version-Map)||
|`"Service"`<br>|[2.0](#Schema-Version-Map)||
|`"Firewall"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeQueryFlags"></a>
## HostComputeQueryFlags
Referenced by: [HostComputeQuery](#HostComputeQuery)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"Detailed"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "HostResourceType"></a>
## HostResourceType


|Variants|NewInVersion|Description|
|---|---|---|
|`"Network"`<br>|[](#Schema-Version-Map)||
|`"Endpoint"`<br>|[](#Schema-Version-Map)||
|`"Container"`<br>|[](#Schema-Version-Map)||
|`"Namespace"`<br>|[](#Schema-Version-Map)||
|`"PolicyList"`<br>|[](#Schema-Version-Map)||

---

<a name = "IovInterruptModerationType"></a>
## IovInterruptModerationType
Referenced by: [IovPolicySetting](#IovPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"IovInterruptModerationDefault"`<br>|[2.9](#Schema-Version-Map)||
|`"IovInterruptModerationAdaptive"`<br>|[2.9](#Schema-Version-Map)||
|`"IovInterruptModerationOff"`<br>|[2.9](#Schema-Version-Map)||
|`"IovInterruptModerationLow"`<br>|[2.9](#Schema-Version-Map)||
|`"IovInterruptModerationMedium"`<br>|[2.9](#Schema-Version-Map)||
|`"IovInterruptModerationHigh"`<br>|[2.9](#Schema-Version-Map)||

---

<a name = "IpamType"></a>
## IpamType
Referenced by: [Ipam](#Ipam)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Static"`<br>|[2.0](#Schema-Version-Map)||
|`"Dhcp"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "IPSubnetFlags"></a>
## IPSubnetFlags
Referenced by: [IpSubnet](#IpSubnet)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.5](#Schema-Version-Map)||
|`"EnableBroadcast"`<br>|[2.5](#Schema-Version-Map)||
|`"ReserveNetworkAddress"`<br>|[2.5](#Schema-Version-Map)||

---

<a name = "LoadBalancerDistribution"></a>
## LoadBalancerDistribution
Referenced by: [LoadBalancerPortMapping](#LoadBalancerPortMapping)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.7](#Schema-Version-Map)||
|`"SourceIPProtocol"`<br>|[2.7](#Schema-Version-Map)||
|`"SourceIP"`<br>|[2.7](#Schema-Version-Map)||

---

<a name = "LoadBalancerFlags"></a>
## LoadBalancerFlags
Referenced by: [HostComputeLoadBalancer](#HostComputeLoadBalancer)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableDirectServerReturn"`<br>|[2.0](#Schema-Version-Map)||
|`"IPv6"`<br>|[2.8](#Schema-Version-Map)||

---

<a name = "LoadBalancerPortMappingFlags"></a>
## LoadBalancerPortMappingFlags
Referenced by: [LoadBalancerPortMapping](#LoadBalancerPortMapping)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableInternalLoadBalancer"`<br>|[2.0](#Schema-Version-Map)||
|`"LocalRoutedVip"`<br>|[2.0](#Schema-Version-Map)||
|`"NotUsed"`<br>|[2.0](#Schema-Version-Map)||
|`"EnablePreserveDip"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyRequestType"></a>
## ModifyRequestType
Referenced by: [ModifySettingRequest](#ModifySettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Add"`<br>|[](#Schema-Version-Map)||
|`"Remove"`<br>|[](#Schema-Version-Map)||
|`"Update"`<br>|[](#Schema-Version-Map)||
|`"Refresh"`<br>|[](#Schema-Version-Map)||
|`"Reset"`<br>|[](#Schema-Version-Map)||

---

<a name = "NamespaceResourceType"></a>
## NamespaceResourceType
Referenced by: [ModifyNamespaceSettingRequest](#ModifyNamespaceSettingRequest); [NamespaceResource](#NamespaceResource)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Container"`<br>|[2.0](#Schema-Version-Map)||
|`"Endpoint"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "NamespaceType"></a>
## NamespaceType
Referenced by: [HostComputeNamespace](#HostComputeNamespace)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Host"`<br>|[](#Schema-Version-Map)||
|`"HostDefault"`<br>|[](#Schema-Version-Map)||
|`"Guest"`<br>|[](#Schema-Version-Map)||
|`"GuestDefault"`<br>|[](#Schema-Version-Map)||

---

<a name = "NatFlags"></a>
## NatFlags
Referenced by: [OutboundNatPolicySetting](#OutboundNatPolicySetting); [PortMappingPolicySetting](#PortMappingPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"LocalRoutedVip"`<br>|[2.0](#Schema-Version-Map)||
|`"IPv6"`<br>|[2.8](#Schema-Version-Map)||

---

<a name = "NetworkFlags"></a>
## NetworkFlags
Referenced by: [HostComputeNetwork](#HostComputeNetwork)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableDnsProxy"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableDhcpServer"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableMirroring"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableNonPersistent"`<br>|[2.0](#Schema-Version-Map)||
|`"EnablePersistent"`<br>|[2.0](#Schema-Version-Map)||
|`"IsolateVSwitch"`<br>|[2.0](#Schema-Version-Map)||
|`"EnableFlowSteering"`<br>|[2.11](#Schema-Version-Map)||
|`"DisableSharing"`<br>|[2.14](#Schema-Version-Map)||
|`"EnableFirewall"`<br>|[2.14](#Schema-Version-Map)||

---

<a name = "NetworkMode"></a>
## NetworkMode
Referenced by: [HostComputeNetwork](#HostComputeNetwork)



|Variants|NewInVersion|Description|
|---|---|---|
|`"NAT"`<br>|[2.0](#Schema-Version-Map)||
|`"ICS"`<br>|[2.0](#Schema-Version-Map)||
|`"Transparent"`<br>|[2.0](#Schema-Version-Map)||
|`"L2Bridge"`<br>|[2.0](#Schema-Version-Map)||
|`"L2Tunnel"`<br>|[2.0](#Schema-Version-Map)||
|`"Overlay"`<br>|[2.0](#Schema-Version-Map)||
|`"Private"`<br>|[2.0](#Schema-Version-Map)||
|`"Internal"`<br>|[2.0](#Schema-Version-Map)||
|`"Mirrored"`<br>|[2.4](#Schema-Version-Map)|Flow Steering Engine|
|`"Infiniband"`<br>|[2.4](#Schema-Version-Map)||
|`"ConstrainedICS"`<br>|[2.10](#Schema-Version-Map)||

---

<a name = "NetworkPolicyType"></a>
## NetworkPolicyType
Referenced by: [NetworkPolicy](#NetworkPolicy)



|Variants|NewInVersion|Description|
|---|---|---|
|`"SourceMacAddress"`<br>|[2.0](#Schema-Version-Map)||
|`"NetAdapterName"`<br>|[2.0](#Schema-Version-Map)||
|`"InterfaceConstraint"`<br>|[2.0](#Schema-Version-Map)||
|`"VSwitchExtension"`<br>|[2.0](#Schema-Version-Map)||
|`"ProviderAddress"`<br>|[2.0](#Schema-Version-Map)||
|`"DrMacAddress"`<br>|[2.0](#Schema-Version-Map)||
|`"AutomaticDNS"`<br>|[2.0](#Schema-Version-Map)||
|`"RemoteSubnetRoute"`<br>|[2.0](#Schema-Version-Map)||
|`"VxlanPort"`<br>|[2.0](#Schema-Version-Map)||
|`"HostRoute"`<br>|[2.0](#Schema-Version-Map)||
|`"SetPolicy"`<br>|[2.0](#Schema-Version-Map)||
|`"L4Proxy"`<br>|[2.0](#Schema-Version-Map)||
|`"LayerConstraint"`<br>|[2.0](#Schema-Version-Map)||
|`"NetworkACL"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkResourceType"></a>
## NetworkResourceType
Referenced by: [ModifyNetworkSettingRequest](#ModifyNetworkSettingRequest)



|Variants|NewInVersion|Description|
|---|---|---|
|`"DNS"`<br>|[2.0](#Schema-Version-Map)||
|`"Extension"`<br>|[2.0](#Schema-Version-Map)||
|`"Policy"`<br>|[2.0](#Schema-Version-Map)||
|`"Subnet"`<br>|[2.6](#Schema-Version-Map)||
|`"IPSubnet"`<br>|[2.6](#Schema-Version-Map)||

---

<a name = "ProtocolType"></a>
## ProtocolType
Referenced by: [CommonL4ProxyPolicySetting](#CommonL4ProxyPolicySetting); [LoadBalancerPortMapping](#LoadBalancerPortMapping); [PortMappingPolicySetting](#PortMappingPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Unknown"`<br>|[2.0](#Schema-Version-Map)||
|`"ICMPv4"`<br>|[2.0](#Schema-Version-Map)||
|`"IGMP"`<br>|[2.0](#Schema-Version-Map)||
|`"TCP"`<br>|[2.0](#Schema-Version-Map)||
|`"UDP"`<br>|[2.0](#Schema-Version-Map)||
|`"ICMPv6"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "ProxyType"></a>
## ProxyType


|Variants|NewInVersion|Description|
|---|---|---|
|`"VFP"`<br>|[2.5](#Schema-Version-Map)|Virtual Filtering Platform|
|`"WFP"`<br>|[2.5](#Schema-Version-Map)|Windows Filtering Platform|

---

<a name = "RpcEndpointType"></a>
## RpcEndpointType
Referenced by: [RpcConnectionInformation](#RpcConnectionInformation)



|Variants|NewInVersion|Description|
|---|---|---|
|`"HvSocket"`<br>|[2.13](#Schema-Version-Map)||
|`"LRpc"`<br>|[2.13](#Schema-Version-Map)||

---

<a name = "RuleType"></a>
## RuleType
Referenced by: [CommonAclPolicySetting](#CommonAclPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"Host"`<br>|[2.0](#Schema-Version-Map)|WFP|
|`"Switch"`<br>|[2.0](#Schema-Version-Map)|VFP|

---

<a name = "SetPolicyTypes"></a>
## SetPolicyTypes
Referenced by: [SetPolicySetting](#SetPolicySetting)



|Variants|NewInVersion|Description|
|---|---|---|
|`"IPSET"`<br>|[2.0](#Schema-Version-Map)||
|`"NESTEDIPSET"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "SubnetFlags"></a>
## SubnetFlags
Referenced by: [Subnet](#Subnet)



|Variants|NewInVersion|Description|
|---|---|---|
|`"None"`<br>|[2.7](#Schema-Version-Map)||
|`"DoNotReserveGatewayAddress"`<br>|[2.7](#Schema-Version-Map)||

---

<a name = "SubnetPolicyType"></a>
## SubnetPolicyType
Referenced by: [SubnetPolicy](#SubnetPolicy)



|Variants|NewInVersion|Description|
|---|---|---|
|`"VLAN"`<br>|[2.0](#Schema-Version-Map)||
|`"VSID"`<br>|[2.0](#Schema-Version-Map)||

---

<a name = "structs"></a>
# Structs
<a name = "AclPolicySetting"></a>
## AclPolicySetting


Derived from parent class: [FiveTuple](#FiveTuple); [CommonAclPolicySetting](#CommonAclPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Action**<br>|[ActionType](#ActionType)|[](#Schema-Version-Map)||
|**Direction**<br>|[DirectionType](#DirectionType)|[](#Schema-Version-Map)||
|**RuleType**<br>|[RuleType](#RuleType)|[2.0](#Schema-Version-Map)||

---

<a name = "AuthenticationCertificate"></a>
## AuthenticationCertificate


Derived from parent class: [AuthenticationMethod](#AuthenticationMethod)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**CertificateName**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "AuthenticationMethod"></a>
## AuthenticationMethod



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "AuthenticationPresharedKey"></a>
## AuthenticationPresharedKey


Derived from parent class: [AuthenticationMethod](#AuthenticationMethod)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Key**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "AutomaticDNSNetworkPolicySetting"></a>
## AutomaticDNSNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Enable**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Base"></a>
## Base


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "BasePolicy"></a>
## BasePolicy


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Type**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Data**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "CommonAclPolicySetting"></a>
## CommonAclPolicySetting


Derived from parent class: [FiveTuple](#FiveTuple)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Action**<br>|[ActionType](#ActionType)|[](#Schema-Version-Map)||
|**Direction**<br>|[DirectionType](#DirectionType)|[](#Schema-Version-Map)||
|**RuleType**<br>|[RuleType](#RuleType)|[2.0](#Schema-Version-Map)||

---

<a name = "CommonL4ProxyPolicySetting"></a>
## CommonL4ProxyPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Port**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Protocol**<br>|[ProtocolType](#ProtocolType)|[2.0](#Schema-Version-Map)||
|**ExceptionList**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Destination**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**OutboundNat**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "DNS"></a>
## DNS
Referenced by: [HostComputeEndpoint](#HostComputeEndpoint); [HostComputeNetwork](#HostComputeNetwork)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Domain**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Search**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**ServerList**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Options**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||

---

<a name = "DNS_2"></a>
## DNS_2
Referenced by: [GuestEndpointState](#GuestEndpointState)



Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Domain**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Search**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ServerList**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Options**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "DrMacAddressNetworkPolicySetting"></a>
## DrMacAddressNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Address**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "EncapOverheadEndpointPolicySetting"></a>
## EncapOverheadEndpointPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Overhead**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "EncryptionPolicySetting"></a>
## EncryptionPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EncryptionMethodType**<br>|[EncryptionMethod](#EncryptionMethod)|[2.1](#Schema-Version-Map)||
|**AuthenticationMethods**<br>|<[PrioritizedAuthenticationMethod](#PrioritizedAuthenticationMethod)> array|[2.1](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Endpoints1**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|default Any|
|**Endpoints2**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|default Any|
|**ProtocolType**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)|default Any|
|**Endpoint1Ports**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|default All ports|
|**Endpoint2Ports**<br>|<[string](#JSON-type)> array|[2.1](#Schema-Version-Map)|default All ports|

---

<a name = "EndpointAdditionalParams"></a>
## EndpointAdditionalParams


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SwitchId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SwitchPortId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "EndpointPolicy"></a>
## EndpointPolicy
Referenced by: [HostComputeEndpoint](#HostComputeEndpoint); [PolicyEndpointRequest](#PolicyEndpointRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[EndpointPolicyType](#EndpointPolicyType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Extension"></a>
## Extension


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**IsEnabled**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "ExtraParams"></a>
## ExtraParams
Referenced by: [Health](#Health)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Resources**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SharedContainers**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**LayeredOn**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SwitchGuid**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**UtilityVM**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**VirtualMachine**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Feature"></a>
## Feature


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Enabled**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Data**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "FiveTuple"></a>
## FiveTuple
Referenced by: [L4WfpProxyPolicySetting](#L4WfpProxyPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "FiveTuple_2"></a>
## FiveTuple_2


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "GuestEndpoint"></a>
## GuestEndpoint


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NamespaceId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "GuestEndpointState"></a>
## GuestEndpointState


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NetworkInterfaces**<br>|<[NetworkInterface](#NetworkInterface)> array|[2.4](#Schema-Version-Map)||
|**Routes**<br>|<[Route_2](#Route_2)> array|[2.4](#Schema-Version-Map)||
|**IPAddresses**<br>|<[IPAddress](#IPAddress)> array|[2.4](#Schema-Version-Map)||
|**DNS**<br>|<[DNS_2](#DNS_2)> array|[2.4](#Schema-Version-Map)||
|**Xlat**<br>|<[Xlat](#Xlat)> array|[2.5](#Schema-Version-Map)||

---

<a name = "GuestFirewall"></a>
## GuestFirewall


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "GuestModifySettingRequest"></a>
## GuestModifySettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[GuestResourceType](#GuestResourceType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "GuestNamespace"></a>
## GuestNamespace


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CompartmentId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Resources**<br>|<[NamespaceResource_2](#NamespaceResource_2)> array|[2.0](#Schema-Version-Map)||

---

<a name = "GuestNetworkService"></a>
## GuestNetworkService
Schema to hold the GNS info in HNS

Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**VirtualMachineId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**MirroredInterfaces**<br>|<[GuestNetworkServiceInterface](#GuestNetworkServiceInterface)> array|[2.2](#Schema-Version-Map)||
|**MirrorHostNetworking**<br>|[bool](#JSON-type)|[2.5](#Schema-Version-Map)||
|**GnsRpcServerInformation**<br>|[RpcConnectionInformation](#RpcConnectionInformation)|[2.11](#Schema-Version-Map)||
|**Flags**<br>|[GuestNetworkServiceFlags](#GuestNetworkServiceFlags)|[2.12](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceInterface"></a>
## GuestNetworkServiceInterface
Referenced by: [GuestNetworkService](#GuestNetworkService); [GuestNetworkServiceNotificationData](#GuestNetworkServiceNotificationData)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EndpointId**<br>|[Guid](#JSON-type)|[2.2](#Schema-Version-Map)||
|**InterfaceGuid**<br>|[Guid](#JSON-type)|[2.2](#Schema-Version-Map)||
|**State**<br>|[GuestNetworkServiceInterfaceState](#GuestNetworkServiceInterfaceState)|[2.2](#Schema-Version-Map)||
|**MissedNotifications**<br>|[GuestNetworkServiceNotificationType](#GuestNetworkServiceNotificationType)|[2.7](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceNotificationData"></a>
## GuestNetworkServiceNotificationData


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**State**<br>|[GuestNetworkServiceState](#GuestNetworkServiceState)|[2.2](#Schema-Version-Map)||
|**Interfaces**<br>|<[GuestNetworkServiceInterface](#GuestNetworkServiceInterface)> array|[2.2](#Schema-Version-Map)||

---

<a name = "GuestNetworkServiceStateRequest"></a>
## GuestNetworkServiceStateRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**State**<br>|[GuestNetworkServiceState](#GuestNetworkServiceState)|[2.0](#Schema-Version-Map)||

---

<a name = "GuestService"></a>
## GuestService


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ServiceId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Base64EncodedData**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Health"></a>
## Health
Referenced by: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Data**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Extra**<br>|[ExtraParams](#ExtraParams)|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeEndpoint"></a>
## HostComputeEndpoint


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostComputeNetwork**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostComputeNamespace**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Policies**<br>|<[EndpointPolicy](#EndpointPolicy)> array|[2.0](#Schema-Version-Map)||
|**IpConfigurations**<br>|<[IpConfig](#IpConfig)> array|[2.0](#Schema-Version-Map)||
|**Dns**<br>|[DNS](#DNS)|[2.0](#Schema-Version-Map)||
|**Routes**<br>|<[Route](#Route)> array|[2.0](#Schema-Version-Map)||
|**MacAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[EndpointFlags](#EndpointFlags)|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeLoadBalancer"></a>
## HostComputeLoadBalancer


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostComputeNetwork**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**HostComputeEndpoints**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**SourceVIP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**FrontendVIPs**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**PortMappings**<br>|<[LoadBalancerPortMapping](#LoadBalancerPortMapping)> array|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[LoadBalancerFlags](#LoadBalancerFlags)|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeNamespace"></a>
## HostComputeNamespace


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NamespaceId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NamespaceGuid**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Type**<br>|[NamespaceType](#NamespaceType)|[2.0](#Schema-Version-Map)||
|**Resources**<br>|<[NamespaceResource](#NamespaceResource)> array|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeNetwork"></a>
## HostComputeNetwork


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Type**<br>|[NetworkMode](#NetworkMode)|[2.0](#Schema-Version-Map)||
|**Policies**<br>|<[NetworkPolicy](#NetworkPolicy)> array|[2.0](#Schema-Version-Map)||
|**MacPool**<br>|[MacPool](#MacPool)|[2.0](#Schema-Version-Map)||
|**Dns**<br>|[DNS](#DNS)|[2.0](#Schema-Version-Map)||
|**Ipams**<br>|<[Ipam](#Ipam)> array|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[NetworkFlags](#NetworkFlags)|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputePolicyList"></a>
## HostComputePolicyList


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**References**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Policies**<br>|<[Any](#JSON-type)> array|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeQuery"></a>
## HostComputeQuery


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[HostComputeQueryFlags](#HostComputeQueryFlags)|[](#Schema-Version-Map)||
|**Filter**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "HostComputeRoute"></a>
## HostComputeRoute


Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**HostComputeNetwork**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**HostComputeEndpoints**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Routes**<br>|<[SDNRoutePolicySetting](#SDNRoutePolicySetting)> array|[2.0](#Schema-Version-Map)||

---

<a name = "HostRoutePolicySetting"></a>
## HostRoutePolicySetting



**Note:** This is an empty struct with no fields, and to be used in the JSON document must be specified as an empty object: `"{}"`.

---

<a name = "InterfaceConstraintEndpointPolicySetting"></a>
## InterfaceConstraintEndpointPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**InterfaceGuid**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceLuid**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceIndex**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceMediaType**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceAlias**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceDescription**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "InterfaceConstraintNetworkPolicySetting"></a>
## InterfaceConstraintNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**InterfaceGuid**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceLuid**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceIndex**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceMediaType**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceAlias**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**InterfaceDescription**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "InterfaceNotificationMessage"></a>
## InterfaceNotificationMessage


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "InterfaceParametersPolicySetting"></a>
## InterfaceParametersPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Mtu**<br>|[uint16](#JSON-type)|[2.4](#Schema-Version-Map)||

---

<a name = "IovPolicySetting"></a>
## IovPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IovOffloadWeight**<br>|[uint32](#JSON-type)|[2.9](#Schema-Version-Map)||
|**QueuePairsRequested**<br>|[uint32](#JSON-type)|[2.9](#Schema-Version-Map)||
|**InterruptModeration**<br>|[IovInterruptModerationType](#IovInterruptModerationType)|[2.9](#Schema-Version-Map)||

---

<a name = "IPAddress"></a>
## IPAddress
Referenced by: [GuestEndpointState](#GuestEndpointState)



Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Address**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**PrefixOrigin**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**SuffixOrigin**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**ValidLifetime**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**PreferredLifetime**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**OnLinkPrefixLength**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**SkipAsSource**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "Ipam"></a>
## Ipam
Referenced by: [HostComputeNetwork](#HostComputeNetwork)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[IpamType](#IpamType)|[2.0](#Schema-Version-Map)|Type : dhcp|
|**Subnets**<br>|<[Subnet](#Subnet)> array|[2.0](#Schema-Version-Map)||

---

<a name = "IpConfig"></a>
## IpConfig
Referenced by: [HostComputeEndpoint](#HostComputeEndpoint)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IpAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**PrefixLength**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||
|**IpSubnetId**<br>|[Guid](#JSON-type)|[2.3](#Schema-Version-Map)||

---

<a name = "IpSubnet"></a>
## IpSubnet
Referenced by: [IPSubnetNetworkRequest](#IPSubnetNetworkRequest); [Subnet](#Subnet)



Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**IpAddressPrefix**<br>|[string](#JSON-type)|[2.3](#Schema-Version-Map)||
|**Flags**<br>|[IPSubnetFlags](#IPSubnetFlags)|[2.5](#Schema-Version-Map)||

---

<a name = "IPSubnetNetworkRequest"></a>
## IPSubnetNetworkRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SubnetId**<br>|[Guid](#JSON-type)|[2.6](#Schema-Version-Map)||
|**IpSubnets**<br>|<[IpSubnet](#IpSubnet)> array|[2.6](#Schema-Version-Map)||

---

<a name = "L4ProxyPolicySetting"></a>
## L4ProxyPolicySetting


Derived from parent class: [CommonL4ProxyPolicySetting](#CommonL4ProxyPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Port**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Protocol**<br>|[ProtocolType](#ProtocolType)|[2.0](#Schema-Version-Map)||
|**ExceptionList**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Destination**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**OutboundNat**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "L4ProxyPolicySetting_2"></a>
## L4ProxyPolicySetting_2


Derived from parent class: [CommonL4ProxyPolicySetting](#CommonL4ProxyPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Port**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Protocol**<br>|[ProtocolType](#ProtocolType)|[2.0](#Schema-Version-Map)||
|**ExceptionList**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Destination**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**OutboundNat**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "L4WfpProxyPolicySetting"></a>
## L4WfpProxyPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**InboundProxyPort**<br>|[string](#JSON-type)|[2.11](#Schema-Version-Map)|Port to deliver inbound proxied traffic to.|
|**OutboundProxyPort**<br>|[string](#JSON-type)|[2.11](#Schema-Version-Map)|Port to deliver outbound proxied traffic to.|
|**FilterTuple**<br>|[FiveTuple](#FiveTuple)|[2.5](#Schema-Version-Map)|Matching conditions traffic filtering.|
|**UserSID**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)|User account of the Proxy container.|
|**InboundExceptions**<br>|[ProxyExceptions](#ProxyExceptions)|[2.14](#Schema-Version-Map)|IP Addresses or ports to exempt from redirection on inbound traffic.|
|**OutboundExceptions**<br>|[ProxyExceptions](#ProxyExceptions)|[2.14](#Schema-Version-Map)|IP Addresses or ports to exempt from redirection on oubound traffic.|

---

<a name = "LayerConstraintNetworkPolicySetting"></a>
## LayerConstraintNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**LayerId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "LoadBalancerPortMapping"></a>
## LoadBalancerPortMapping
Referenced by: [HostComputeLoadBalancer](#HostComputeLoadBalancer)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocol**<br>|[ProtocolType](#ProtocolType)|[2.0](#Schema-Version-Map)||
|**InternalPort**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ExternalPort**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DistributionType**<br>|[LoadBalancerDistribution](#LoadBalancerDistribution)|[2.7](#Schema-Version-Map)||
|**Flags**<br>|[LoadBalancerPortMappingFlags](#LoadBalancerPortMappingFlags)|[](#Schema-Version-Map)||

---

<a name = "MacAddress"></a>
## MacAddress


Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**PhysicalAddress**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "MacPool"></a>
## MacPool
Referenced by: [HostComputeNetwork](#HostComputeNetwork)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Ranges**<br>|<[MacRange](#MacRange)> array|[2.0](#Schema-Version-Map)||

---

<a name = "MacRange"></a>
## MacRange
Referenced by: [MacPool](#MacPool)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**StartMacAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**EndMacAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyEndpointSettingRequest"></a>
## ModifyEndpointSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[EndpointResourceType](#EndpointResourceType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyGuestEndpointSettingRequest"></a>
## ModifyGuestEndpointSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[GuestEndpointResourceType](#GuestEndpointResourceType)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyGuestNamespaceSettingRequest"></a>
## ModifyGuestNamespaceSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[GuestNamespaceResourceType](#GuestNamespaceResourceType)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyGuestNetworkServiceSettingRequest"></a>
## ModifyGuestNetworkServiceSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[GuestNetworkServiceResourceType](#GuestNetworkServiceResourceType)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyNamespaceSettingRequest"></a>
## ModifyNamespaceSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[NamespaceResourceType](#NamespaceResourceType)|[](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyNamespaceSettingResponse"></a>
## ModifyNamespaceSettingResponse
Find out if Modify can return with a response?

Derived from parent class: [Response](#Response)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Success**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**Error**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ErrorCode**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**CompartmentId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifyNetworkSettingRequest"></a>
## ModifyNetworkSettingRequest


Derived from parent class: [ModifySettingRequest](#ModifySettingRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||
|**ResourceType**<br>|[NetworkResourceType](#NetworkResourceType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifySettingRequest"></a>
## ModifySettingRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ResourceUri**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RequestType**<br>|[ModifyRequestType](#ModifyRequestType)|[2.0](#Schema-Version-Map)||

---

<a name = "ModifySettingResponse"></a>
## ModifySettingResponse


Derived from parent class: [Response](#Response)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Success**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**Error**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ErrorCode**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Data**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NamespaceContainerRequest"></a>
## NamespaceContainerRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ContainerId**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NamespaceEndpointRequest"></a>
## NamespaceEndpointRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EndpointId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NamespaceResource"></a>
## NamespaceResource
Referenced by: [HostComputeNamespace](#HostComputeNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[NamespaceResourceType](#NamespaceResourceType)|[](#Schema-Version-Map)||
|**Data**<br>|[Any](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "NamespaceResource_2"></a>
## NamespaceResource_2
Referenced by: [GuestNamespace](#GuestNamespace)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**EndpointId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ContainerId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NamespaceResourceContainer"></a>
## NamespaceResourceContainer


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "NamespaceResourceEndpoint"></a>
## NamespaceResourceEndpoint


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "Neighbor"></a>
## Neighbor


Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**Address**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**InterfaceLuid**<br>|[uint64](#JSON-type)|[2.5](#Schema-Version-Map)||
|**InterfaceIndex**<br>|[uint32](#JSON-type)|[2.5](#Schema-Version-Map)||
|**PhysicalAddress**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**PhysicalAddressLength**<br>|[uint64](#JSON-type)|[2.5](#Schema-Version-Map)||
|**State**<br>|[uint8](#JSON-type)|[2.5](#Schema-Version-Map)||
|**IsRouter**<br>|[bool](#JSON-type)|[2.5](#Schema-Version-Map)||
|**IsUnreachable**<br>|[bool](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Flags**<br>|[uint8](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LastReachable**<br>|[uint64](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LastUnreachable**<br>|[uint64](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "NetAdapterNameNetworkPolicySetting"></a>
## NetAdapterNameNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NetworkAdapterName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkAclPolicySetting"></a>
## NetworkAclPolicySetting


Derived from parent class: [FiveTuple](#FiveTuple)



[CommonAclPolicySetting](#CommonAclPolicySetting)
|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Id**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**Action**<br>|[ActionType](#ActionType)|[](#Schema-Version-Map)||
|**Direction**<br>|[DirectionType](#DirectionType)|[](#Schema-Version-Map)||
|**RuleType**<br>|[RuleType](#RuleType)|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkAdditionalParams"></a>
## NetworkAdditionalParams


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ICSFlags**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkInterface"></a>
## NetworkInterface
Referenced by: [GuestEndpointState](#GuestEndpointState)

POST /networkInterfaces/<Id> {message}

Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**AdvertisingEnabled**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ForwardingEnabled**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**WeakHostSend**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**WeakHostReceive**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**UseAutomaticMetric**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**UseNeighborUnreachabilityDetection**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ManagedAddressConfigurationSupported**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**OtherStatefulConfigurationSupported**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdvertiseDefaultRoute**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RouterDiscoveryBehavior**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DadTransmits**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|DupAddrDetectTransmits in RFC 2462.|
|**BaseReachableTime**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**RetransmitTime**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**PathMtuDiscoveryTimeout**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|Path MTU discovery timeout (in ms).|
|**LinkLocalAddressBehavior**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||
|**LinkLocalAddressTimeout**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)|In ms.|
|**ZoneIndices**<br>|<[uint32](#JSON-type)> array|[2.0](#Schema-Version-Map)|Zone part of a SCOPE_ID.|
|**SitePrefixLength**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Metric**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NlMtu**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Connected**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SupportsWakeUpPatterns**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SupportsNeighborDiscovery**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**SupportsRouterDiscovery**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ReachableTime**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**TransmitOffload**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ReceiveOffload**<br>|[uint8](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DisableDefaultRoutes**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NetworkPolicy"></a>
## NetworkPolicy
Referenced by: [HostComputeNetwork](#HostComputeNetwork); [PolicyNetworkRequest](#PolicyNetworkRequest)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[NetworkPolicyType](#NetworkPolicyType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "NotificationBase"></a>
## NotificationBase


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[](#Schema-Version-Map)||
|**Flags**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Data**<br>|[Any](#JSON-type)|[2.2](#Schema-Version-Map)||

---

<a name = "OutboundNatPolicySetting"></a>
## OutboundNatPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**VirtualIP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Destinations**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Exceptions**<br>|<[string](#JSON-type)> array|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[NatFlags](#NatFlags)|[](#Schema-Version-Map)||

---

<a name = "PolicyEndpointRequest"></a>
## PolicyEndpointRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Policies**<br>|<[EndpointPolicy](#EndpointPolicy)> array|[2.0](#Schema-Version-Map)||

---

<a name = "PolicyNetworkRequest"></a>
## PolicyNetworkRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Policies**<br>|<[NetworkPolicy](#NetworkPolicy)> array|[2.0](#Schema-Version-Map)||

---

<a name = "PortMappingPolicySetting"></a>
## PortMappingPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocol**<br>|[ProtocolType](#ProtocolType)|[2.0](#Schema-Version-Map)||
|**InternalPort**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ExternalPort**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**VIP**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Flags**<br>|[NatFlags](#NatFlags)|[](#Schema-Version-Map)||

---

<a name = "PortnameEndpointPolicySetting"></a>
## PortnameEndpointPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "PrioritizedAuthenticationMethod"></a>
## PrioritizedAuthenticationMethod
Referenced by: [EncryptionPolicySetting](#EncryptionPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[AuthenticationType](#AuthenticationType)|[2.1](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "ProviderAddressEndpointPolicySetting"></a>
## ProviderAddressEndpointPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProviderAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ProviderAddressNetworkPolicySetting"></a>
## ProviderAddressNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ProviderAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "ProxyExceptions"></a>
## ProxyExceptions
Referenced by: [L4WfpProxyPolicySetting](#L4WfpProxyPolicySetting)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IpAddressExceptions**<br>|<[string](#JSON-type)> array|[2.14](#Schema-Version-Map)||
|**PortExceptions**<br>|<[string](#JSON-type)> array|[2.14](#Schema-Version-Map)||

---

<a name = "QosPolicySetting"></a>
## QosPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MaximumOutgoingBandwidthInBytes**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "RegistryKey"></a>
## RegistryKey


Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**RegKeys**<br>|<[RegKey](#RegKey)> array|[2.1](#Schema-Version-Map)||
|**Keyword**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**AdapterCLSID**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "RegKey"></a>
## RegKey
Referenced by: [RegistryKey](#RegistryKey)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Path**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Key**<br>|[string](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Type**<br>|[uint16](#JSON-type)|[2.1](#Schema-Version-Map)||
|**Value**<br>|[ByteArray](#JSON-type)|[2.1](#Schema-Version-Map)||

---

<a name = "RemoteSubnetRoutePolicySetting"></a>
## RemoteSubnetRoutePolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DestinationPrefix**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**IsolationId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ProviderAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DistributedRouterMacAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Response"></a>
## Response


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Success**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**Error**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**ErrorCode**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Route"></a>
## Route
Referenced by: [HostComputeEndpoint](#HostComputeEndpoint); [Subnet](#Subnet)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NextHop**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**DestinationPrefix**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Metric**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Route_2"></a>
## Route_2
Referenced by: [GuestEndpointState](#GuestEndpointState)



Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**NextHop**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**DestinationPrefix**<br>|[string](#JSON-type)|[](#Schema-Version-Map)||
|**SitePrefixLength**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**ValidLifetime**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**PreferredLifetime**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**Metric**<br>|[uint32](#JSON-type)|[](#Schema-Version-Map)||
|**Protocol**<br>|[uint8](#JSON-type)|[](#Schema-Version-Map)||
|**Loopback**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**AutoconfigureAddress**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**Publish**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||
|**Immortal**<br>|[bool](#JSON-type)|[](#Schema-Version-Map)||

---

<a name = "RpcConnectionInformation"></a>
## RpcConnectionInformation
Referenced by: [GuestNetworkService](#GuestNetworkService)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**NetworkAddress**<br>|[string](#JSON-type)|[2.11](#Schema-Version-Map)||
|**EndpointAddress**<br>|[string](#JSON-type)|[2.11](#Schema-Version-Map)||
|**EndpointType**<br>|[RpcEndpointType](#RpcEndpointType)|[2.13](#Schema-Version-Map)||
|**ObjectUuid**<br>|[Guid](#JSON-type)|[2.13](#Schema-Version-Map)||

---

<a name = "SDNRoutePolicySetting"></a>
## SDNRoutePolicySetting
Referenced by: [HostComputeRoute](#HostComputeRoute)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**DestinationPrefix**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NextHop**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**NeedEncap**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AutomaticEndpointMonitor**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "SetPolicySetting"></a>
## SetPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Id**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**PolicyType**<br>|[SetPolicyTypes](#SetPolicyTypes)|[2.0](#Schema-Version-Map)||
|**Values**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "SourceMacAddressNetworkPolicySetting"></a>
## SourceMacAddressNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**SourceMacAddress**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Subnet"></a>
## Subnet
Referenced by: [Ipam](#Ipam); [SubnetNetworkRequest](#SubnetNetworkRequest)



Derived from parent class: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Owner**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Name**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Version**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**AdditionalParams**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Health**<br>|[Health](#Health)|[2.0](#Schema-Version-Map)||
|**SchemaVersion**<br>|[Version](#Version)|[2.0](#Schema-Version-Map)|Schema version should be present in all objects|
|**Telemetry**<br>|[Telemetry](#Telemetry)|[2.0](#Schema-Version-Map)||
|**State**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||
|**IpAddressPrefix**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Policies**<br>|<[SubnetPolicy](#SubnetPolicy)> array|[2.0](#Schema-Version-Map)||
|**Routes**<br>|<[Route](#Route)> array|[2.0](#Schema-Version-Map)||
|**IpSubnets**<br>|<[IpSubnet](#IpSubnet)> array|[2.3](#Schema-Version-Map)||
|**Flags**<br>|[SubnetFlags](#SubnetFlags)|[2.7](#Schema-Version-Map)||

---

<a name = "SubnetNetworkRequest"></a>
## SubnetNetworkRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Subnets**<br>|<[Subnet](#Subnet)> array|[2.6](#Schema-Version-Map)||

---

<a name = "SubnetPolicy"></a>
## SubnetPolicy
Referenced by: [Subnet](#Subnet)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Type**<br>|[SubnetPolicyType](#SubnetPolicyType)|[2.0](#Schema-Version-Map)||
|**Settings**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Telemetry"></a>
## Telemetry
Referenced by: [Base](#Base)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Data**<br>|[Any](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "TierAclPolicySetting"></a>
## TierAclPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Name**<br>|[string](#JSON-type)|[2.10](#Schema-Version-Map)||
|**Direction**<br>|[DirectionType](#DirectionType)|[2.10](#Schema-Version-Map)||
|**Order**<br>|[uint16](#JSON-type)|[2.10](#Schema-Version-Map)||
|**TierAclRules**<br>|<[TierAclRule](#TierAclRule)> array|[2.10](#Schema-Version-Map)||

---

<a name = "TierAclRule"></a>
## TierAclRule
Referenced by: [TierAclPolicySetting](#TierAclPolicySetting)



Derived from parent class: [FiveTuple](#FiveTuple)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Protocols**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemoteAddresses**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePorts**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Priority**<br>|[uint16](#JSON-type)|[2.5](#Schema-Version-Map)||
|**Id**<br>|[string](#JSON-type)|[2.10](#Schema-Version-Map)||
|**TierAclRuleAction**<br>|[ActionType](#ActionType)|[2.10](#Schema-Version-Map)||

---

<a name = "Version"></a>
## Version
Referenced by: [Base](#Base); [HostComputeQuery](#HostComputeQuery)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Major**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Minor**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "VlanPolicySetting"></a>
## VlanPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IsolationId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "VmEndpointRequest"></a>
## VmEndpointRequest


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**PortId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**VirtualNicName**<br>|[string](#JSON-type)|[2.0](#Schema-Version-Map)||
|**VirtualMachineId**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "VsidPolicySetting"></a>
## VsidPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**IsolationId**<br>|[uint32](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "VSwitchExtensionNetworkPolicySetting"></a>
## VSwitchExtensionNetworkPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**ExtensionID**<br>|[Guid](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Enable**<br>|[bool](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "VxlanPortPolicySetting"></a>
## VxlanPortPolicySetting


|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**Port**<br>|[uint16](#JSON-type)|[2.0](#Schema-Version-Map)||

---

<a name = "Xlat"></a>
## Xlat
Referenced by: [GuestEndpointState](#GuestEndpointState)



Derived from parent class: [InterfaceNotificationMessage](#InterfaceNotificationMessage)



|Field|Type|NewInVersion|Description|
|---|---|---|---|
|**MessageNumber**<br>|[uint64](#JSON-type)|[2.0](#Schema-Version-Map)||
|**Family**<br>|[uint16](#JSON-type)|[](#Schema-Version-Map)||
|**SyntheticIPv4Address**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**FallbackIPv4Address**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPrefix**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**LocalPrefixLength**<br>|[uint8](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePrefix**<br>|[string](#JSON-type)|[2.5](#Schema-Version-Map)||
|**RemotePrefixLength**<br>|[uint8](#JSON-type)|[2.5](#Schema-Version-Map)||

---

<a name = "JSON-type"></a>
## JSON type

The table shows the mapping from type name for field of classes to JSON type, its format and pattern. See details in [Swagger IO spec](https://swagger.io/specification/#data-types)

|Name|JSON Type|Format|Pattern|
|---|---|---|---|
|Any|object|||
|bool|boolean|||
|ByteArray|string|byte||
|Guid|string||^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$|
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
|2.6|Windows 10, version 2004 (10.0.19041.0)|
|2.11|Windows Server 2022 (10.0.20348.0)|
|2.14|Windows 11, version 2004 (10.0.2200.0)|

---
