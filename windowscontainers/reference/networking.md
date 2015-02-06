ms.ContentId: 72B3E3F6-03C5-4739-A6F3-266EFF2D1702
title: Networking Reference


# Networking in Containers #

**Updated 2/6/2015**

Even though the functionality is in the build, it is not easy to setup container networking yet as it involves configuring multiple networking objects.
Here is a set of PowerShell script cmdlets that implement the Docker network driver proposal. The script exposes 7 cmdlets that implement the proposed “docker net” commands and more.

The verbs and objects (below) are taken directly from the proposal. Cmdlets automatically configure vSwitch, NAT and IP settings so the user can setup a very Docker-like network environment for Windows Containers without having to understand the underlying details. This should provide some convenience until our host agent service and docker tools arrive.


	Docker CLI command    Windows PS cmdlet
	==================    =======================
	docker net create  -> New-ContainerNetwork
	docker net destroy -> Remove-ContainerNetwork
	                      Get-ContainerNetwork
	docker net join    -> Join-ContainerNetwork
	docker net leave   -> Leave-ContainerNetwork
	                      Open-ContainerPort
	                      Close-ContainerPort

To try:
1. [Install the latest build](..\quick_start\run_local.md).
2. Type \\corenetfs1\users\ofiliz\argon\ContainerNet.ps1 to install the ContainerNet module. You may need to Set-ExecutionPolicy before installing it.

The cmdlets store state in session variables, so do not close your PS session and always use that same PS session when entering cmdlets. When running for the first time, the script will offer to install Hyper-V if it is not already installed.


After you create your containers, you can provide network connectivity to them in 2 easy steps:

1. Create a container network:

	PS> New-ContainerNetwork cnet1 -EnableNat

Creating a vSwitch for the network...done.
Enabling IP forwarding between network and external adapter...done.
Picking the NAT external IP address and prefix...done.
Configuring NAT...done.
Network cnet1 created successfully.

This cmd creates a container network named “cnet1” and puts it behind a NAT. Public mode (without NAT) is currently not supported so -EnableNat parameter is mandatory. Unless you want to segment your containers in multiple networks, you only need one network, so this command needs to be run only once.

2. Join the container(s) to the network:

	PS> Join-ContainerNetwork Container1 cnet1
	Configuring compartment...done.
	Creating endpoint...done.
	Setting default routes...done.
	Container Container1 joined network cnet1 successfully.

	Name                                                                         Id IPv4Address
	Container1_cnet1                                                              2 192.168.1.2

This cmd joins the container named “Container1” to network “cnet1”. You can join multiple containers to the same network. Each container will be automatically assigned a private IPv4 address from the 192.168/16 range. You can connect the same container to multiple networks, or to the same network multiple times. See “Join-ContainerNetwork -?” for more details.

At this point, from within the container, you can “ping 192.168.1.1” to ping the container host, or any other external IP address. You cannot use hostnames since the script does not configure DNS (yet). Do not forget that Windows Firewall by default blocks ping (type wf.msc to configure), and is already compartment-aware so it will enforce firewall rules on container IP interfaces just like the host’s IP interfaces.

3. Optionally, if you have a listening socket inside the container that you want to be accessible from the outside: 

	PS> Open-ContainerPort Container1 cnet1 -Protocol TCP -ExternalPort 50000 -InternalPort 3389
	
	StaticMappingID               : 1
	NatName                       : ContainerNat
	Protocol                      : TCP
	RemoteExternalIPAddressPrefix : 0.0.0.0/0
	ExternalIPAddress             : 10.91.68.239
	ExternalPort                  : 50000
	InternalIPAddress             : 192.168.1.2
	InternalPort                  : 3389
	InternalRoutingDomainId       : {00000000-0000-0000-0000-000000000000}
	Active                        : True

Since the containers are behind NAT, they are not accessible from outside via unsolicited traffic. This cmd makes container “Container1”’s RDP listener (3389) accessible over network “cnet1” via TCP Port 50000. Now we should be able to RDP into the container from an external host by typing “mstsc /v 10.91.68.239:50000”. ExternalPort must be in the [50000-60000] range.

There are 3 more cmdlets for reversing the above steps (Close-ContainerPort, Leave-ContainerNetwork, Remove-ContainerNetwork), and Get-ContainerNetwork to enumerate existing containers and endpoints in them.
