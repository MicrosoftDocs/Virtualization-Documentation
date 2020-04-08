---
title: Configuring Nested VMs to Communicate Directly with Resources in an Azure Virtual Network
description: Nested Virtualization
keywords: windows 10, hyper-v, Azure
author: mrajess
ms.date: 12/10/2018
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 1ecb85a6-d938-4c30-a29b-d18bd007ba08
---

# Configure nested VMs to communicate with resources in an Azure virtual network

The original guidance on deploying and configuring nested virtual machines within Azure necessitates that you access these VMs through a NAT Switch. This presents several limitations:

1. Nested VMs cannot access resources on-premises or within an Azure Virtual Network.
2. On-premises resources or resources within Azure can only access the nested VMs through a NAT, which means multiple guests cannot share the same port.

This document will walk through a deployment whereby we make use of RRAS, User Defined Routes, a Subnet dedicated to outbound NAT to allow guest internet access, and a "floating" address space to allow Nested VMs to behave and communicate like any other virtual machine deployed directly to a VNet within Azure.

Before starting this guide, please:

1. Read the [guidance provided here](https://docs.microsoft.com/azure/virtual-machines/windows/nested-virtualization) on nested virtualization.
2. Read this entire article prior to implementation.

## High level overview of what we're doing and why
* We'll create a nesting capable VM that has two NICs. 
* One NIC will be used to provide our nested VMs with internet access via NAT and the other NIC will be used to route traffic from our internal switch to resources external to the hypervisor. Each NIC will need to be in a different routing domain, meaning a different subnet.
* This means that we'll need a Virtual Network with at a minimum three subnets. One for NAT, one for LAN routing, and one that's not used, but is "reserved" for our nested VMs. The names we use for the subnets in this doc are, "NAT", "Hyper-V-LAN", and "Ghosted".
* The size of these subnets is at your discretion, but there are some considerations. The size of the "Ghosted" subnets determines how many IPs you have for your nested VMs. Also, the size of the "NAT" and "Hyper-V-LAN" subnets determines how many IPs you have for Hypervisors. So you could technically make really small subnets here if you were only planning on having one or two hypervisors.
* Background: Nested VMs WILL NOT receive DHCP from the VNet that their host is connected to even if you configure an Internal or External switch. 
  * This means that the Hyper-V host must provide DHCP.
* The Hyper-V host is not aware of the currently assigned leases on the VNet, so in order to avoid a situation in which the host assigns an IP already in existence we must allocate a block of IPs for use just by the Hyper-V host. This will allow us to avoid a duplicate IP scenario.
  * The block of IPs we choose will correspond to a Subnet within the same VNet that your Hyper-V is in.
  * The reason we want this to correspond to an existing Subnet is to handle BGP advertisements back over an ExpressRoute. If we just made up an IP range for the Hyper-V host to use then we'd have to create a series of static routes to allow clients on-prem to communicate with the nested VMs. This does mean that this isn't a hard requirement as you COULD make up an IP range for the nested VMs and then create all the routes needed to direct clients to the Hyper-V host for that range.
* We will create an Internal Switch within Hyper-V and then we will assign the newly created interface an IP address within a range we set aside for DHCP. This IP address will become the default gateway for our nested VMs and be used to route between the Internal Switch and the NIC of the host that's connected to our VNet.
* We will install the Routing and Remote Access role on the host, which will turn our host into a router.  This is necessary to allow communication between resources external to the host and our nested VMs.
* We will tell other resources how to access these nested VMs. This necessitates that we create a User Defined Route table which contains a static route for the IP Range that the nested VMs reside in. This static route will point to the IP address for the Hyper-V.
* You will then place this UDR on the Gateway Subnet so that clients coming from on-premises know how to reach our nested VMs.
* You will also place this UDR on any other Subnet within Azure that requires connectivity to the nested VMs.
* For multiple Hyper-V hosts you'd create additional "floating" subnets and add an additional static route to the UDR.
* When you decommission a Hyper-V host you will delete/repurpose our "floating" subnet and remove that static route from our UDR, or if this is the last Hyper-V host, remove the UDR altogether.

## Creating the host

I will gloss over any configuration values that are up to personal preference, such as VM Name, Resource Group, etc..

1. Navigate to portal.azure.com
2. Click "Create a resource" in upper left
3. Select "Window Server 2016 VM" from the Popular column
4. On the "Basics" tab be sure to select a VM Size that's capable of nested virtualization
5. Move to the "Networking" tab
6. Create a new Virtual Network with the following configuration
    * VNet Address Space: 10.0.0.0/22
    * Subnet 1
        * Name: NAT
        * Address Space: 10.0.0.0/24
    * Subnet 2
        * Name: Hyper-V-LAN
        * Address Space: 10.0.1.0/24
    * Subnet 3
        * Name: Ghosted
        * Address Space: 10.0.2.0/24
    * Subnet 4
        * Name: Azure-VMs
        * Address Space: 10.0.3.0/24
7. Ensure you've selected the NAT subnet for the VM
8. Go to "Review + create" and select "Create"

## Create the second network interface
1. After the VM has finished provisioning browse to it within the Azure Portal
2. Stop the VM
3. Once stopped go to "Networking" under Settings
4. "Attach network interface"
5. "Create network interface"
6. Give it a name (doesn't matter what you name it, but be sure to remember it)
7. Select "Hyper-V-LAN" for the subnet
8. Ensure you select the same Resource Group your host resides in
9. "Create"
10. This will take you back to the previous screen, make sure to select the newly created Network Interface and select "OK"
11. Go back to the "Overview" pane and Start your VM again once the previous action has completed
12. Navigate to the second NIC we just created, you can find it in the Resource Group you selected previously
13. Go to "IP configurations" and toggle "IP forwarding" to "Enabled" and then save the change

## Setting up Hyper-V
1. Remote into your host
2. Open an elevated PowerShell prompt
3. Run the following command `Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart`
4. This will restart the host
5. Reconnect to the host to continue with the rest of the setup

## Creating our virtual switch

1. Open PowerShell in Administrative mode.
2. Create an Internal switch: `New-VMSwitch -Name "NestedSwitch" -SwitchType Internal`
3. Assign the newly created interface an IP: `New-NetIPAddress –IPAddress 10.0.2.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NestedSwitch)"`

## Install and configure DHCP

*Many people miss this component when they're first trying to get nested virtualization working. Unlike in on-premises where your guest VMs will receive DHCP from the network that your host resides on, nested VMs in Azure must be provided DHCP via the host they run on. That or you need to statically assign an IP address to every nested VM, which is not scalable.*

1. Install the DHCP Role: `Install-WindowsFeature DHCP -IncludeManagementTools`
2. Create the DHCP Scope: `Add-DhcpServerV4Scope -Name "Nested VMs" -StartRange 10.0.2.2 -EndRange 10.0.2.254 -SubnetMask 255.255.255.0`
3. Configure the DNS and Default Gateway options for the scope: `Set-DhcpServerV4OptionValue -DnsServer 168.63.129.16 -Router 10.0.2.1`
    * Be sure to input a valid DNS Server if you want name resolution to work. In this case I'm using [Azure's recursive DNS](https://docs.microsoft.com/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances).

## Installing Remote Access

1. Open Server Manager and select "Add roles and features".
2. Select "Next" until you get to "Server Roles".
3. Check "Remote Access" and click "Next" until you get to "Role Services".
4. Check "Routing", select "Add Features", and then select "Next", and then "Install". Complete the wizard and wait for installation to complete.

## Configuring Remote Access

1. Open Server Manager and select "Tools" and then select "Routing and Remote Access".
2. On the left hand side of the Routing and Remote Access management panel you will see an icon with your servers name next to it, right click this and select "Configure and Enable Routing and Remote Access".
3. At the wizard select "Next", select "Custom Configuration", and then select "Next".
4. Check “NAT” and “LAN routing” and then select “Next” and then “Finish”. If it asks you to start the service then do so.
5. Now navigate to the “IPv4” node and expand it so that the “NAT” node is made available.
6. Right click “NAT”, select “New Interface...” and select "Ethernet", this should be your first NIC with the IP of "10.0.0.4" and select Public interface connect to the Internet and Enable NAT on this interface. 
7. Now we need to create some static routes to force LAN traffic out the second NIC. You do this by going to the "Static Routes" node under "IPv4".
8. Once there we'll create the following routes.
    * Route 1
        * Interface: Ethernet
        * Destination: 10.0.0.0
        * Network Mask: 255.255.255.0
        * Gateway: 10.0.0.1
        * Metric: 256
        * Note: We put this here to allow the primary NIC to respond to traffic destined to it out its own interface. If we didn't have this here the following route would cause traffic meant for NIC 1 to go out NIC 2. This would create an asymmetric route. 10.0.0.1 is the IP address that Azure assigns to the NAT subnet. Azure uses the first available IP in a range as the default gateway. So if you were to have used 192.168.0.0/24 for your NAT subnet, the gateway would be 192.168.0.1. In routing the more specific route wins, meaning this route will supercede the below route.

    * Route 2
        * Interface: Ethernet 2
        * Destination: 10.0.0.0
        * Network Mask: 255.255.252.0
        * Gateway: 10.0.1.1
        * Metric: 256
        * Note: This is a catch all route for traffic meant to our Azure VNet. It will force traffic out the second NIC. You'll need to add additional routes for other ranges you want your nested VMs to access. So if you're on-prem network is 172.16.0.0/22 then you'd want to have another route to send that traffic out the second NIC of our hypervisor.

## Creating a route table within Azure

Refer to [this article](https://docs.microsoft.com/azure/virtual-network/tutorial-create-route-table-portal) for a more in depth read on creating and managing routes within Azure.

1. Navigate to https://portal.azure.com.
2. In the upper left hand corner select "Create a resource".
3. In the search field type "Route Table" and hit enter.
4. The top result will be Route Table, select this, and then select "Create"
5. Name the Route Table, in my case I named it "Routes-for-nested-VMs".
6. Make sure you select the same subscription that your Hyper-V hosts reside in.
7. Either create a new Resource Group or select an existing one and be sure that the region you create the Route Table in is the same region that your Hyper-V host resides in.
8. Select "Create".

## Configuring the route table

1. Navigate to the Route Table we just created. You can do this by searching for the name of the Route Table from the search bar at the top center of the portal.
2. After you've selected the Route Table go to "Routes" from within the blade.
3. Select "Add".
4. Give your route a name, I went with "Nested-VMs".
5. For address prefix input the IP range for our "floating" Subnet. In this case it would be 10.0.2.0/24.
6. For "Next hop type" select "Virtual Appliance" and then enter the IP address for the Hyper-V hosts second NIC, which would be 10.0.1.4, and then select "OK".
7. Now from within the blade select "Subnets", this will be directly below "Routes".
8. Select "Associate", then select our "Nested-Fun" VNet and then select the "Azure-VMs" subnet, and then select "OK".
9. Do this same process for the Subnet that our Hyper-V host resides on as well as for any other Subnets that need to access the nested VMs. If connected 

# End state configuration reference
The environment in this guide has the below configurations. This section is inteded to be used as a reference.

1. Azure Virtual Network Information.
    * VNet High Level Configuration.
        * Name: Nested-Fun
        * Address Space: 10.0.0.0/22
        * Note: This will be made up of four Subnets. Also, these ranges are not set in stone. Feel free to address your environment however you want. 

    * First Subnet High Level Configuration.
        * Name: NAT
        * Address Space: 10.0.0.0/24
        * Note: This is where our Hyper-V hosts primary NIC resides. This will be used to handle outbound NAT for the nested VMs. It will be the gateway to the internet for your nested VMs.

    * Second Subnet High Level Configuration.
        * Name: Hyper-V-LAN
        * Address Space: 10.0.1.0/24
        * Note:  Our Hyper-V host will have a second NIC that will be used to handle the routing between the nested VMs and non-internet resources external to the Hyper-V host.

    * Third Subnet High Level Configuration.
        * Name: Ghosted
        * Address Space: 10.0.2.0/24
        * Note:  This will be a “floating” subnet. The address space will be consumed by our nested VMs and exists to handle route advertisements back to on-premises. No VMs will actually be deployed into this subnet.

    * Fourth Subnet High Level Configuration.
        * Name: Azure-VMs
        * Address Space: 10.0.3.0/24
        * Note: Subnet containing Azure VMs.

1. Our Hyper-V host has the below NIC configurations.
    * Primary NIC 
        * IP Address: 10.0.0.4
        * Subnet Mask: 255.255.255.0
        * Default Gateway: 10.0.0.1
        * DNS: Configured for DHCP
        * IP Forwarding Enabled: No

    * Secondary NIC
        * IP Address: 10.0.1.4
        * Subnet Mask: 255.255.255.0
        * Default Gateway: Empty
        * DNS: Configured for DHCP
        * IP Forwarding Enabled: Yes

    * Hyper-V Created NIC for Internal Virtual Switch
        * IP Address: 10.0.2.1
        * Subnet Mask: 255.255.255.0
        * Default Gateway: Empty

3. Our Route Table will have a single rule.
    * Rule 1
        * Name: Nested-VMs
        * Destination: 10.0.2.0/24
        * Next Hop: Virtual Appliance - 10.0.1.4

## Conclusion

You should now be able to deploy a virtual machine (even a 32-bit VM!) to your Hyper-V host and have it be accessible from on-premises and within Azure.
