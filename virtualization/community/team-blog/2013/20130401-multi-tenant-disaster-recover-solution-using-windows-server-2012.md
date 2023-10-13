---
title:      "Multi-tenant disaster recover solution using Windows Server 2012"
author: sethmanheim
ms.author: mabrigg
description: Multi-tenant disaster recover solution using Windows Server 2012
ms.date: 04/01/2013
date:       2013-04-01 12:54:00
categories: hvr
---
# Multi-tenant disaster recover solution using Windows Server 2012

**Windows Server 2012** introduces fundamental improvements that make it a cloud-ready operating system. The capabilities provide a flexible and scalable solution which opens up a wide range of opportunities for hosting providers to build new cloud services.

This blog post is co-authored by **Uma Mahesh** , Senior Program Manager and **Yigal Edery** , Principal Program Manager in the Windows Server division. The blog article is based on Yigal’s TechEd talk on “[Building Hosted Public and Private Clouds Using Windows Server 2012](https://channel9.msdn.com/events/TechEd/Europe/2012/WSV301)”

In this post, Contoso.com, a Washington DC based fictitious company, replicates its business critical VMs to a hosting provider offering DR as a cloud service.   This article describes integration between different Windows Server 2012 features to enable a complete end to end service which hosting providers (or ‘hoster’) can offer. It uses **Hyper-V Replica** , **Network Virtualization** and **Remote Access** (including both site-to-site (S2S) VPN   &  DirectAccess), which enables a hoster to build a complete, multi-tenant disaster recover (DR) service, using Windows Server 2012.

The technology building blocks are:

  1. [**Hyper-V Replica**](https://technet.microsoft.com/library/jj134172): Hyper-V Replica in Windows Server 2012 allows you to replicate multiple VMs from different tenants on single physical host.

  2. [**Hyper-V Network Virtualization**](https://technet.microsoft.com/library/jj134230): Hyper-V Network Virtualization allows a multiple  tenant virtual networks with overlapping IP address space to be created on the same hoster physical network yet providing isolation between tenant network. A replicated VM of a tenant can be brought live in a dedicated virtual network  for the tenant in the hosting provider’s physical   network.

  3. [**Site-to-Site VPN support**](https://technet.microsoft.com/library/hh831614\(v=ws.11\).aspx): Using the S2S VPN solution which is available in Windows Server 2012 (which includes support for S2S VPN over IPsec), tenants can connect to their respective virtual network in the hoster premises.

  4. [**DirectAccess with multi-pathing**](https://technet.microsoft.com/library/hh831664): Multi-Pathing enables employees of  each tenants to connect to the on-premises DA under normal operations. If the replicated VMs are brought up in the hosting provider premises (say, due to a disaster in the tenant’s site), employees smoothly failover to the hoster DA server and through it to the replicated VMs in their respective virtual network with the hoster. ****
  
In this article, we will demonstrate the steps required to set up a deployment to replicate a mission critical app (which is hosted in a VM) from the customers premise to a hoster. When a disaster strikes the customer premises, the administrator fails over to the replicated VM (on the hosting provider premises) which comes up with the same IP address. Clients using DA can seamlessly be routed to the service that’s currently up and running in the hosting provider premises.

<!-- The topology is as follows:

[https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7558.image_thumb_56749DC8.png](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6472.image_5097697E.png) -->

Contoso.com’s Washington site consists of  an:

  1. Edge Gateway **(EDGE1)** is a Windows Server 2012 VM in which Remote Access is configured.   EDGE1 connects to Internet via a NIC  (131.107.0.2) which connects to the Internet Router (131.107.0.1). It also connects to rest of Contoso’s corporate network (10.0.0.0/24) via another NIC (10.0.0.2, 2001:db8:dc::1)

  2. Domain controller **DC1** (10.0.0.1, 2001:db8:dc::1)

  3. Applications server **APP1** ((10.0.0.1, 2001:db8:dc::1)   run as VMs on another  WS2012 Hyper-v Server (ContosoP1 – also referred to as the “ **Primary Server** ”).  Hyper-V Replica is enabled on this (APP1) VM and the VM is replicated to a Windows Server 2012 Hyper-V server on the hosting provide premises (HosterR1 – also referred to as the “ **Replica Server** ”) .

## Client

  1. **Client1** is a client VM of Contoso that is connected to Internet (131.107.0.200)

  2. DA is configured on Client1 which ensures that it can connect to  Contoso’s corporate  network and access  applications like APP1. Client1 is not concerned whether APP1 is physically present in Washington site or in hoster network as it accesses the application by it’s name  app1.corp.contoso.com using DireactAccess. Furthermore, it can connect to DA server in the enterprise viz, EDGE1 or connect to DA server of Contoso at the hoster premises 3-DAS1. If connectivity to any DA server is lost,  the DA connection automatically reconnects to other active DA server.

## Hosting Provider

  1. **HosterGW,** which is running on Windows Server 2012,  is connected to “Internet” (131.107.0.101). The hoster’s internal network is 192.168.1.101.

  2. NAT is enabled on HosterGW so that applications/services (like Hyper-V Replica )  on  hoster internal network  (eg:HosterR1 ,192.168.1.101) are available over Internet.  HosterR1 can host VMs directly created on it or replicated to it using Hyper-v Replica.

  3. HosterGW machine hosts GW VMs per tenant  so that  the hoster can provide connectivity  between the tenant’s virtual network and  tenant’s on-prem network. In this topology, **ContosoCloudGW** VM is the S2S VPN GW for Contoso. This VM connects the contoso virtual network at hoster to the contoso corporate network. **Hyper-V Network Virtualization** is used to create the Contoso’s virtual network of 10.0.0.0/24, 10.6.0.0/24, 2001:db8:dc::/48 and 2001:db8:dc::/48 (collectively called the Customer Address space or CA) over the hoster’s  address space  192.168.1.0/24 (called Provider Address space  or PA).

## Building the above deployment

### Step 1: Building Contoso ’s environment

This step is similar to creating the base environment for DA. The [test lab guide](https://www.microsoft.com/en-us/download/details.aspx?id=29031) which demonstrates Direct Access single server setup has detailed steps on creating the environment. Once the steps are completed, you will have a setup where Client1 from Internet (directly connected or behind NAT) can access APP1 over Direct Access. <!--as shown in the below diagram.-->

<!-- [https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7532.image_thumb_459DDBAB.png](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5707.image_48B039A0.png) -->

### Step 2: Building Hosters ’s environment

The objectives of the hosting provider are:

* Allow Contoso.com to bring VMs with an IP of their choice
* Connect Contoso VMs back to their on-prem network.
* Allow customers to replicate their on-prem VMs to the hosting provider

<!-- [https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7838.image_thumb_368C1E33.png](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7851.image_7078D06E.png) -->

#### 2a) Steps required to “bring your own IP address”

Hyper-V Network Virtualization (HNV) allows Contoso to bring VMs with an IP address to the hoster. The following cmdlets demonstrate how HNV can be deployed on two hosts viz., **HosterGW** & **HosterR1**.

In this example, HosterGW has two NICs one connected to “Internet” (131.107.0.101) and once connected to hoster internal network (192.168.1.101). HosterR1 has one NIC connected to hoster internal network(192.168.1.111). The following PS cmdlets need to be run on both **HosterGW and HosterR1** to configure HNV.

**Rename the NIC connected to internal network  as  “WnvNIC” and run the following cmdlets.**

`$WnvNIC   = "WnvNIC"`

`$WnvDRV   = "ms_netwnv"`

`Disable-NetAdapterBinding $WnvNIC -ComponentID $WnvDRV`

`Enable-NetAdapterBinding  $WnvNIC -ComponentID $WnvDRV`

**Run the following cmdlets to enable Contoso virtual network.**

##### ContosoCloudGW 10.6.0.2

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "10.6.0.2"        -ProviderAddress "192.168.1.101" -VirtualSubnetID "5001" -MACAddress "00155d05df03" -Rule "TranslationMethodEncap" -VMName "ContosoCloudGW-v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "0.0.0.0"         -ProviderAddress "192.168.1.101" -VirtualSubnetID "5001" -MACAddress "00155d05df03" -Rule "TranslationMethodEncap" -VMName "wildcard v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "2001:db8:ba::2"  -ProviderAddress "192.168.1.101" -VirtualSubnetID "5001" -MACAddress "00155d05df03" -Rule "TranslationMethodEncap" -VMName "ContosoCloudGW-v6"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "::"              -ProviderAddress "192.168.1.101" -VirtualSubnetID "5001" -MACAddress "00155d05df03" -Rule "TranslationMethodEncap" -VMName "wildcard v6"
```

##### ContosoCloudDAServer

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "10.6.0.6"        -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059701" -Rule "TranslationMethodEncap" -VMName "ContosoCloudDAServer-v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "0.0.0.0"         -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059701" -Rule "TranslationMethodEncap" -VMName "wildcard v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "2001:db8:ba::6"  -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059701" -Rule "TranslationMethodEncap" -VMName "ContosoCloudDAServer-v6"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "::"              -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059701" -Rule "TranslationMethodEncap" -VMName "wildcard v6"
```

##### ContosoCloudDC

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "10.6.0.3"        -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059700" -Rule "TranslationMethodEncap" -VMName "ContosoCloudDC-v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "2001:db8:ba::3"  -ProviderAddress "192.168.1.111" -VirtualSubnetID "5001" -MACAddress "00155d059700" -Rule "TranslationMethodEncap" -VMName "ContosoCloudDC-v6"
```

##### Customer Routes for VSID 5001

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "10.6.0.0/24" -NextHop "0.0.0.0"  -Metric 255 
```

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "0.0.0.0/0"   -NextHop "10.6.0.2" -Metric 255 
```

```xml
#New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "10.0.0.0/24" -NextHop "10.6.0.2" -Metric 255 
```

```xml
#New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "10.2.0.0/24" -NextHop "10.6.0.2" -Metric 255 
```

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "2001:db8:ba::/48" -NextHop "::"  -Metric 255 
```

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "2001:db8:dc::/48" -NextHop "2001:db8:ba::2" -Metric 255 
```

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "2001:db8:fa::/48" -NextHop "2001:db8:ba::2" -Metric 255 
```

```xml
New-NetVirtualizationCustomerRoute -RoutingDomainID "{11111111-2222-3333-4444-000000005001}" -VirtualSubnetID "5001" -DestinationPrefix "2001:db8:ba:1000::/64" -NextHop "2001:db8:ba::6"  -Metric 255 
```

##### App1

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "10.0.0.80"       -ProviderAddress "192.168.1.111" -VirtualSubnetID "5002" -MACAddress "00155db1c505" -Rule "TranslationMethodEncap" -VMName "APP1-v4"
```

```xml
New-NetVirtualizationLookupRecord -CustomerAddress "2001:db8:dc::80" -ProviderAddress "192.168.1.111" -VirtualSubnetID "5002" -MACAddress "00155db1c505" -Rule "TranslationMethodEncap" -VMName "APP1-v6"  
```

**Replace the MAC addrersses if required.**

On the HosterGW, run the following cmdlets:

`$iface = Get-NetAdapter $WnvNIC`

```xml
New-NetVirtualizationProviderAddress -InterfaceIndex $iface.InterfaceIndex -ProviderAddress "192.168.1.101" -PrefixLength 24 
```

**Make sure the adapter name is correct.**

```xml
Rename-VMNetworkAdapter -vmname ContosoCloudGW -Name "Network Adapter" -NewName "Wnv-CA-NIC"
```

```xml
Set-VMNetworkAdapter "ContosoCloudGW"   -Name "Wnv-CA-NIC" -VirtualSubnetID 5001;
```

```xml
 Get-VMNetworkAdapter "ContosoCloudGW" | where {$_.MacAddress -eq "808080808002"} | Set-VMNetworkAdapter -VirtualSubnetID 5002 
```

On HosterR1, run the following cmdlets:

`$iface = Get-NetAdapter $WnvNIC`

```xml
New-NetVirtualizationProviderAddress -InterfaceIndex $iface.InterfaceIndex -ProviderAddress "192.168.1.111" -PrefixLength 24 
```

```xml
New-NetVirtualizationProviderRoute -InterfaceIndex $iface.ifIndex -DestinationPrefix "0.0.0.0/0" -NextHop "192.168.1.101"
```

**Make sure the adapter name is correct.**

```xml
Rename-VMNetworkAdapter -vmname ContosoCloudDAServer -Name "Network Adapter" -NewName "Wnv-CA-NIC"
```

```xml
Set-VMNetworkAdapter "ContosoCloudDAServer" -Name "Wnv-CA-NIC" -VirtualSubnetID 5001;
```

**Make sure the adapter name is correct.**

```xml
Rename-VMNetworkAdapter -vmname 3-APP1 -Name "WnvNic" -NewName "Wnv-CA-NIC"
```

```xml
Get-VMNetworkAdapter "ContosoCloudDC" | where {$_.MacAddress -eq "00155d059700"} | Set-VMNetworkAdapter -VirtualSubnetID 5001
```

```xml
Set-VMNetworkAdapter App1 -Name "Private Corpnet" -VirtualSubnetID 5002 –Passthru
```

#### Step 2b: Connect Contoso VMs back to their on-prem network

While the above steps create the necessary network infrastructure to create Contoso virtual network the following steps are required to create the VMs and ensure that the VMs are able to connect to Contoso on-prem network.

On **HosterGW:**

* Create a Windows Server 2012 VM ContosoCloudGW with 2 VM NICs
* Connect one VM NIC to the V-Switch connecting to Internet NIC (131.107.0.101)  and another VM NIC to V-switch connecting to Internal NIC.
* Configure MAC address of internal VM NIC as 00155d05df03
* Configure the following IP address scheme:
* Assign IPv4 address 10.6.0.2/24 &2001:db8:6::2/64 to NIC connected to internal NI
* Create site-to-site VPN connections between  ContosoCloudGw & EDGE1 using the following cmdlets

`ipmo servermanger`

`add-windowsFeature -name routing -IncludeManagementTools`

`ipmo remoteaccess`

```xml
install-remoteaccess -vpntype vpns2s –IPv6Prefix 2001:db8:6:200::/64 -IPAddressRange ("10.6.0.200","10.6.0.210") 
```

```xml
Add-VpnS2SInterface EDGE1 131.107.0.2 -Protocol IKEv2  -AuthenticationMethod PSKOnly -SharedSecret abc -IPv4Subnet10.2.0.0/24:100 –IPv6Subnet2001:db8:2::/48:100 
```

**On EDGE1:**

```xml
Add-VpnS2SInterface 3-EDGE1 131.107.0.30 -Protocol IKEv2  -AuthenticationMethod PSKOnly -SharedSecret abc -IPv4Subnet 
10.6.0.0/24:100 –IPv6Subnet 2001:db8:6::/48:100
```

The above steps ensure that  VMs of Contoso hosted @ the hoster are accessible from Contoso  Washington site and  Internet Via DirectAccesss from EDGE1.

<!-- **[![the above steps](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2161.image_thumb_0BD5D4C5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4705.image_2F033F77.png)** -->

#### Step 2c: Configure Hyper-V Replica

This replica server is ‘published’ using the hoster’s GW via regular HTTPS (customers use cert-based authentication to replicate).

<!-- [![configure Hyper-V Replica](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6862.image_thumb_517F8045.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3644.image_323A48C1.png) -->

The following links illustrate on how to achieve this:

* Create certificates using makecert – Appendix C of the Understanding and Troubleshooting guide for Hyper-V Replica
* (or) Create certificates from a [standalone CA](https://techcommunity.microsoft.com/t5/virtualization/requesting-hyper-v-replica-certificates-from-a-ca/ba-p/381939)
* (or) Create certificates from an [Enterprise CA](https://techcommunity.microsoft.com/t5/virtualization/requesting-hyper-v-replica-certificates-from-an-enterprise-ca/ba-p/381936)
* Setup replication for the virtual machine [using](https://techcommunity.microsoft.com/t5/virtualization/hyper-v-replica-8211-certificate-based-authentication-in-windows/ba-p/381925) the certificate based authentication.

Since EDGE1 is acting as DA server it will not allow any non-IPsec traffic thru it. In general customer deployment there would be an IPS device in front of EDGE1. In the above topology to allow HTTPS HVR traffic thru EDGE1, we need to disable IPsec dosp with the following cmdlet

```xml
netsh ipsecdosprotection set miscellaneous defaultblock=disable
```

As Hyper-V Replica takes on the end-server name (not IP address) as input, you could resolve the server name by making an entry in the host file of ContosP1. To achieve this, add an entry in `%systemdrive%\drivers\etc\hosts`

`_131.107.0.101 HosterR1_`

Similarly on HosterR1, add the following entry in hosts file

`_131.107.0.101 ContosP1_`

### Step 3: Configuring Cloud DA site on top of Hyper-v Network Virtualization

Now that  we have ensured the the VMs are replicated to the hoster we need to provide and option to Contoso employees  to connect  to their  replicated VMs  from Internet even if Washington DA server is not available.  This is done by deploying a DA server in Contoso cloud. Since DA in WS 2012 supports multiple DA sites, all that’s required here is to enable  a new  Cloud DA entry point.  <!--Following diagram  describes the topology.-->

<!-- [![Configuring Cloud DA site on top of Hyper-v Network Virtualization](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3247.image_thumb_621C9C95.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1588.image_77E3F441.png) -->

#### Here are the steps to configure DA cloud site:

**Configure NAT on 3-EDG1**

  1. Open rrasmgmt.msc
  2. Right click on IPv4 general node
  3. Click new Routing Protocol
  4. Select NAT
  5. Right click on NAT node.
  6. Select New Interface.
  7. Select the interface connected to Internet.
  8. In NAT tab, select Public Interface connected to private network and check “Enable NAT on this interface” option.
  9. Select services and ports tab, select “Secure web server (HTTPS) option

<!-- [![Configure NAT on 3-EDG1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8461.clip_image002_thumb_1459CAD4.gif)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3618.clip_image002_5C18C30A.gif)

3\. Click new Routing Protocol…

[![Click new Routing Protocol](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8787.image11_thumb_712EF0D2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2548.image11_5426420A.png) 

4\. Select NAT

5\. Right click on NAT node.

 [![Right click on NAT node.](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1680.image41_thumb_2FB95FDB.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2783.image41_02A1E25C.png)  
---  
  |    
  
6\. Select New Interface.

7\. Select the interface connected to Internet.

[![Select the interface connected to Internet.](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4743.image7_thumb_0D460965.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5633.image7_46C688AB.png)  
---  
  |    
  
8\. In NAT tab, select Public Interface connected to private network and check “Enable NAT on this interface” option.

9\. Select services and ports tab, select “Secure web server (HTTPS) option

 [![Select services and ports tab, select “Secure web server (HTTPS) option](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1513.image101_thumb_677273B2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8037.image101_03146EF8.png) -->

##### Enter the IP address of 3-DAS1, 10.6.0.6 in Private address

**Configure 3-DAS1**

Configure IP address `10.6.0.6/24` (default route `10.6.0.2`) & `2001:db8:2::/64` (default route `2001:db8:6::/64`) with DNS server as `10.0.0.1/24`, `10.2.0.1/24` & `2001:db8:1::1/64`, `2001:db8:2::1/64` respectively.

1. In the Server Manager console, click Local Server, and then in the Properties area, next to Avez-CA-NIC , click the link.
2. Right-click Avez-CA-NIC, and then click Properties.
3. Click Internet Protocol Version 4 (TCP/IPv4), and then click Properties.
4. Click Use the following IP address. In IP address, type 10.6.0.6, in Subnet mask, type 255.255.255.0.
5. Click Use the following DNS server addresses. In Preferred DNS server, type 10.0.0.1, and in Alternate DNS server, type 10.2.0.1.
6. Click Advanced, and then click the DNS tab.
7. In DNS suffix for this connection, type corp.contoso.com, and then click OK twice.
8. Click Internet Protocol Version 6 (TCP/IPv6), and then click Properties.
9. Click Use the following IPv6 address. In IPv6 address, type `2001:db8:6::6`, in Subnet prefix length, type `64`. Click Use the following DNS server addresses, and in Preferred DNS server, type `2001:db8:1::1`, in Alternate DNS server, type `2001:db8:2::1`
10. Click Advanced, and then click the DNS tab.
11. In DNS suffix for this connection, type corp.contoso.com, and then click OK twice.
12. On the 2-Corpnet Properties dialog box, click Close.

##### Join 3-DAS1 to corp.contoso.com. Configure 3-DAS1 as 3rd entry point (similar to step 11)

**Obtain certificates on 3-DAS1**

1. Click Start, type mmc, and then press ENTER.
2. In the MMC console, on the File menu, click Add/Remove Snap-in.
3. On the Add or Remove Snap-ins dialog box, click Certificates, click Add, click Computer account, click Next, click Local computer, click Finish, and then click OK.
4. In the console tree of the Certificates snap-in, open Certificates (Local Computer)\Personal.
5. Right-click Personal, point to All Tasks, and then click Request New Certificate.
6. Click Next twice.
7. On the Request Certificates page, select the Client-Server Authentication and the Web Server 2008 check boxes, and then click More information is required to enroll for this certificate.
8. On the Certificate Properties dialog box, on the Subject tab, in the Subject name area, in Type, select Common name.
9. In Value, type 3-DAS1.contoso.com, and then click Add.
10. In the Alternative name area, in Type, select DNS.
11. In Value, enter 3-DAS1.contoso.com, and then click Add.
12. On the General tab, in Friendly name, type IP-HTTPS Certificate.
13. Click OK, click Enroll, and then click Finish.
14. In the details pane of the Certificates snap-in, verify that new certificates with the names 3-DAS1.contoso.com and nls.corp.contoso.com were enrolled with Intended Purposes of Server Authentication, and a new certificate with the name 3-DAS1.corp2.corp.contoso.com was enrolled with Intended Purposes of Client Authentication and Server Authentication.
15. Close the console window. If you are prompted to save settings, click No.  

**Install the Remote Access role on 3-DAS1**  
  
1. Click Start, click Server Manager, and in the Dashboard, click add roles.
2. Click Next three times to get to the server role selection screen.
3. On the Select Server Roles dialog, select Remote Access, click Add Required Features, and then click Next.
4. On the Select features dialog, expand Remote Server Administration Tools, expand Role Administration Tools, and then select Remote Access Management Tools, and then click Next.
5. Click Next four times.
6. On the Confirm installation selections dialog, click Install.
7. On the Installation progress dialog, verify that the installation was successful, and then click Close.  

**To add 3-DAS1 as third entry-point**  
  
1. In the Remote Access Management Console of Edge-1, in the Tasks pane, click Add an Entry Point.
2. In the Add an Entry Point Wizard, on the Entry Point Details page, in Remote Access server, type 3-DAS1.corp.contoso.com, in Entry point name, type 3-Edge1-Site, and then click Next.
3. On the Network Topology page, click Behind NAT, and then click Next.
4. On the Network Name/IP Address page, in Type the public name or IP address to which remote access clients connect, type 3-Das1.contoso.com, and then click Next.
5. On the Network Adapters page, make sure that the External adapter is Internet, and the Internal adapter is 2-Corpnet, and then click Next.
6. On the Prefix Configuration page, in IPv6 prefix assigned to client computers, type 2001:db8:2:2000::/64, and then click Next.
7. On the Client Support page, click Allow client computers running Windows 7 to access this entry point, and click Add.
8. On the Select Groups dialog box, in Enter the object names to select, type Win7_Clients_Site2, click OK, and then click Next.
9. On the Client GPO Settings page, click Next.
10. On the Server GPO Settings page, click Next.
11. On the Network Location Server page, click Browse. On the Windows Security dialog box, click the nls.corp.contoso.com certificate, click OK, and then click Next.
12. On the Summary page click Commit.
13. On the Applying Server Configuration dialog box, click Close and then on the Add an Entry Point Wizard, click Close.
14. Manually Add subnet 20.6.0/24 & 2001:db8:6::/48 in AD site on DC1.

Open Active Directory sites and serices UI from Server Manger on DC1:
<!-- 
|    
---  
  |    
[![image131](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1184.image131_thumb_3362F5C1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7457.image131_0DD6E7AF.png)  
  
****  -->

**Configure 3-DC1:**

Deploy 3-DC1 as  replica DC VM .  Configure IP address `10.6.0.3/24` & `2001:db8:6::3/64` with DNS server as `10.0.0.1/24` & `2001:db8:1::1/64` respectively. Join 3-DC1 to corp.contoso.com.

Now employees of Contoso could connect to either EDGE1 or 3-DAS1 via DirectAccess and access VMs in Washington site or VMs hosted  in  Contoso virtual network @ hoster.

In case of a disaster at Washington site, managed machines (laptops) of Contoso connect to 3-DAS1, DirectAccess Server hosted in Contoso virtual network @ hoster and access application  VMs like APP1 that are recovered using Hyper-V Replica.

### Step 4: Validating Disaster Recover as a service

The Hoster  infrastructure in place to replicate the apps. In our case,  Hyper-V server is also running a per-customer DA server and domain controller.

Now that everything is setup lets simulate failover of Washington site and see how it works:

<!-- #### [![Validating Disaster Recover as a service](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5314.image_thumb_4B1F4E89.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5126.image_00957FFE.png)

####   -->

* Bring down Contoso Washington site by shutting down EDGE1 & ContosoP1 hosts
* Use Hyper-V Replica to failover the VM on Hoster
* VM APP1 now comes up with same IP address as it had @ Washington site
* Clients of Contoso are now redirected automatically to 3-DAS1 by DA configuration.
* Clients can now access APP1 VMs.
* Validate  that clients can continue to work with minimal service interruption.

The convergence of these platform technologies in Windows Server 2012 provides a big & seamless opportunity for hosters to build powerful services such as Disaster Recovery. Try it out and let us know your experience!
