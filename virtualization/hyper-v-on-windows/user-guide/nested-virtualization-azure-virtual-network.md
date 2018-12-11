---
title: Configuring Nested VMs to Communicate Directly with Resources in an Azure Virtual Network
description: Nested Virtualization
keywords: windows 10, hyper-v, Azure
author: johncslack
ms.date: 12/10/2018
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 1ecb85a6-d938-4c30-a29b-d18bd007ba08
---

# Configuring Nested VMs to Communicate Directly with Resources in an Azure Virtual Network

The original guidance on deploying and configuring nested virtual machines within Azure necessitates that you access these VMs through a NAT Switch. This presents several limitations:

1. Nested VMs cannot access resources on-premises or within an Azure Virtual Network.
2. On-premises resources or resources within Azure can only access the nested VMs through a NAT, which means multiple guests cannot share the same port.

This document will walk through a deployment whereby we make use of RRAS, some User Defined Routes, and a “floating” address space to allow Nested VMs to behave and communicate like any other virtual machine deployed directly to a VNet within Azure.

Before starting this guide, please:

1. Read the [guidance provided here](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nested-virtualization) on nested virtualization, create your nesting capable VMs, and install the Hyper-V role within those VMs. Do not proceed past setting up the Hyper-V role.
2. Read this entire article prior to implementation.

This guide makes the following assumptions about the target environment:

1. We are operating in a [hub and spoke topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke), with our hub being connected to an ExpressRoute.
1. Our spoke network is assigned the address space of 10.0.0.0/23, which is carved out into two /24 subnets.
    * 10.0.0.0/24 – Subnet where our Hyper-V host resides.
    * 10.0.1.0/24 – this will be a “floating” subnet. This address space will be consumed by our nested VMs and exists to handle route advertisements back to on-premises.
    * The spoke VNet is cleverly named "Spoke".

1. Our hub networks IP range is not relevant, but know that its name is "Hub".
1. Our Hyper-V is assigned the address of 10.0.0.4/24.
1. We have a DNS server at 10.0.0.10/24, this is not a requirement, but an assumption of our walkthrough.

## High Level Overview of What We're Doing and Why

* Background: Nested VMs WILL NOT receive DHCP from the VNet that their host is connected to even if you configure an Internal or External switch. 
  * This means that the Hyper-V host must provide DHCP.
* We will allocate a block of IPs for use JUST by the Hyper-V host.  The Hyper-V host is not aware of the currently assigned leases on the VNet, so in order to avoid a situation in which the host assigns an IP already in existence we must allocate a block of IPs for use just by the Hyper-V host. This will allow us to avoid a duplicate IP scenario. 
  * The block of IPs we choose will correspond to a Subnet within the VNet that your Hyper-V host resides on.
  * The reason we want this to correspond to an existing Subnet is to handle BGP advertisements back over the ExpressRoute. If we just made up an IP range for the Hyper-V host to use then we'd have to create a series of static routes to allow clients on-prem to communicate with the nested VMs. This does mean that this isn't a hard requirement as you COULD make up an IP range for the nested VMs and then create all the routes needed to direct clients to the Hyper-V host for that range.
* We will create an Internal Switch within Hyper-V and then we will assign the newly created interface an IP address within a range we set aside for DHCP. This IP address will become the default gateway for our nested VMs and be used to route between the Internal Switch and the NIC of the host that's connected to our VNet.
* We will install the Routing and Remote Access role on the host, which will turn our host into a router.  This is necessary to allow communication between resources external to the host and our nested VMs.
* We will to tell other resources how to access these nested VMs. This necessitates that we create a User Defined Route table which contains a static route for the IP Range that the nested VMs reside in. This static route will point to the IP address for the Hyper-V.
* You will then place this UDR on the Gateway Subnet so that clients coming from on-premises know how to reach our nested VMs.
* You will also place this UDR on any other Subnet within Azure that requires connectivity to the nested VMs.
* For multiple Hyper-V hosts you'd create additional "floating" subnets and add an additional static route to the UDR.
* When you decommission a Hyper-V host you will delete/repurpose our "floating" subnet and remove that static route from our UDR, or if this is the last Hyper-V host, remove the UDR altogether.

## Creating our Virtual Switch

1. Open PowerShell in Administrative mode.
2. Create an Internal switch: `New-VMSwitch -Name "NestedSwitch" -SwitchType Internal`
3. Assign the newly created interface an IP: `New-NetIPAddress –IPAddress 10.0.1.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NestedSwitch)"`

## Install and Configure DHCP

*Many people miss this component when they're first trying to get nested virtualization working. Unlike in on-premises where your guest VMs will receive DHCP from the network that your host resides on, nested VMs in Azure must be provided DHCP via the host they run on. That or you need to statically assign an IP address to every nested VM, which is not scalable.*

1. Install the DHCP Role: `Install-WindowsFeature DHCP -IncludeManagementTools`
2. Create the DHCP Scope: `Add-DhcpServerV4Scope -Name "Nested VMs" -StartRange 10.0.1.2 -EndRange 10.0.1.254 -SubnetMask 255.255.255.0`
3. Configure the DNS and Default Gateway options for the scope: `Set-DhcpServerV4OptionValue -DnsServer 10.0.0.10 -Router 10.0.1.1`
    * Be sure to input a valid DNS Server. In this case I happen to have a server on the 10.0.0.0/24 network that's serving up Windows DNS.

## Installing Remote Access

* Open Server Manager and select "Add roles and features".
* Select "Next" until you get to "Server Roles".
* Check "Remote Access" and click "Next" until you get to "Role Services".
* Check "Routing", select "Add Features", and then select "Next", and then "Install". Complete the wizard and wait for installation to complete.

## Configuring Remote Access

* Open Server Manager and select "Tools" and then select "Routing and Remote Access".
* On the right hand side of the Routing and Remote Access management panel you will see an icon with your servers name next to it, right click this and select "Configure and Enable Routing and Remote Access".
* At the wizard select "Next", check the radial button for "Secure connection between two private networks", and then select "Next".
* Select the radial button for "No" when asked if you want to use demand-dial connections, and then select "Next", and then select "Finish".

## Creating a Route Table Within Azure

Refer to [this article](https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-create-route-table-portal) for a more in depth read on creating and managing routes within Azure.

* Navigate to https://portal.azure.com.
* In the upper left hand corner select "Create a resource".
* In the search field type "Route Table" and hit enter.
* The top result will be Route Table, select this, and then select "Create"
* Name the Route Table, in my case I named it "Routes-for-nested-VMs".
* Make sure you select the same subscription that your Hyper-V hosts reside in.
* Either create a new Resource Group or select an existing one and be sure that the region you create the Route Table in is the same region that your Hyper-V host resides in.
* Select "Create".

## Configuring the Route Table

* Navigate to the Route Table we just created. You can do this by searching for the name of the Route Table from the search bar at the top center of the portal.
* After you've selected the Route Table go to "Routes" from within the blade.
* Select "Add".
* Give your route a name, I went with "Nested-VMs".
* For address prefix input the IP range for our "floating" Subnet. In this case it would be 10.0.1.0/24.
* For "Next hop type" select "Virtual Appliance" and then enter the IP address for the Hyper-V host, which would be 10.0.0.4, and then select "OK".
* Now from within the blade select "Subnets", this will be directly below "Routes".
* Select "Associate", then select our "Hub" Virtual Network and then select the "GatewaySubnet", and then select "OK".
* Do this same process for the Subnet that our Hyper-V host resides on as well as for any other Subnets that need to access the nested VMs.

## Conclusion

You should now be able to deploy a virtual machine (possibly even a 32-bit VM!) to your Hyper-V host and have it be accessible from on-premises and within Azure.