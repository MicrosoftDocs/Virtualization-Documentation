---
title: What's new for Windows containers in Windows Server 2022
description: Find out what is new when using Windows containers in Windows Server 2022
keywords: containers, windows
author: v-susbo
ms.author: v-susbo
ms.date: 08/18/2021
ms.topic: conceptual
---  

# What's new for Windows containers in Windows Server 2022

This article describes some of the new features when using Windows containers with Windows Server 2022. Windows Server 2022 is built on the strong foundation of Windows Server 2019 and brings many innovations on three key themes: security, Azure hybrid integration and management, and application platform. 

## Platform improvements

### Server Core image size reduction

The size of an image is important when using containers because when you deploy a containerized application, you want it to start quickly. Before a container starts, the container image layers need to be downloaded and extracted on the container host. In Windows Server 2022, the size of the Server Core image is reduced, which allows the container to start faster than in previous Server Core versions.

### Virtualized time zone

With Windows Server 2022, Windows containers support the ability to maintain a virtualized time zone configuration separate from the host. All of the configurations traditionally used for the host time zone have been virtualized and are instanced for each container. To configure the container time zone, you can use the [tzutil](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tzutil) command utility or the [Set-TimeZone](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-timezone?view=powershell-7.1) Powershell cmdlet. To learn more, see [Virtualized time zone](./manage-containers/virtual-time-zone.md).

### Nano server support lifecycle

With Windows Server 2022, the Nano Server base container image is released with a longer support cycle: the image will be supported until 2026. This extended lifecycle aligns with the mainstream support of Windows Server 2022 and lets customers use that image for a longer period of time.

### Scalability improvements for overlay networking support

Windows Server 2022 aggregates several performance and scale improvements that have been made across the last four Semi-Annual Channel (SAC) releases of Windows Server (but have not been backported into Windows Server 2019). The areas of improvement are listed below:

- The port exhaustion issue when using hundreds of Kubernetes services and pods on a node is now fixed.
- Improved packet forwarding performance in the Hyper-V virtual switch (vSwitch).
- Increased reliability across Container Networking Interface (CNI) restarts in Kubernetes.
- Improvements in the Host Networking Service (HNS) control plane and in the data plane used by Windows Server containers and Kubernetes networking.

To learn more about the performance and scalability improvements for overlay networking support, see [Kubernetes Overlay Networking for Windows](https://techcommunity.microsoft.com/t5/networking-blog/introducing-kubernetes-overlay-networking-for-windows/ba-p/363082).

### Direct Server Return routing for overlay and l2bridge networks

Direct Server Return (DSR) is an implementation of asymmetric network load distribution in load balanced systems, which means that the request and response traffic use different network paths. Using different network paths helps avoid extra hops and reduces the latency which not only speeds up the response time between the client and the service, but also removes some extra load from the load balancer. DSR transparently achieves increased network performance for applications with little to no infrastructure changes.

To learn more, see [DSR in Introduction to Windows support in Kubernetes](https://kubernetes.io/docs/setup/production-environment/windows/intro-windows-in-kubernetes/#load-balancing-and-services).


## Application compatibility

### gMSA improvements

You can use Group Managed Service Accounts (gMSA) with Windows containers to facilitate Active Directory (AD) authentication. When introduced in Windows Server 2019, gMSA required joining the container host to a domain to retrieve the gMSA credentials from Active Directory. In Windows Server 2022, gMSA for containers with a non-domain joined host uses a portable user identity instead of a host identity to retrieve gMSA credentials, and therefore, manually joining Windows worker nodes to a domain is no longer necessary. The user identity is saved as a secret in Kubernetes. gMSA for containers with a non-domain joined host provides the flexibility of creating containers with gMSA without joining the host node to the domain.

To learn more about the gMSA improvements, see [Create gMSAs for Windows containers](./manage-containers/manage-serviceaccounts.md).

### IPv6 support

The first step to fully supporting the IPv6 dual stack has been implemented for Kuberenetes in Windows. The IPv6 dual stack is supported for L2Bridge-based networks on the platform. IPv6 is dependent on the CNI used in Kubernetes, and it also required Kubernetes version 1.20 to enable the IPv6 support end-to-end. For more information, see [IPv4/IPv6 in Introduction to Windows support in Kubernetes](https://kubernetes.io/docs/setup/production-environment/windows/intro-windows-in-kubernetes/#ipv4-ipv6-dual-stack).


## Improved Kubernetes experience

### Multi-subnet support for Windows worker nodes with Calico for Windows

The Host Network Service (HNS) has been improved and now allows the use of more restrictive subnets (such as subnets with a longer prefix length) as well as multiple subnets for each Windows worker node. Previously, HNS was restricting the Kubernetes container endpoint configurations to only use the prefix length of the underlying subnet. The first CNI that makes use of this functionality is [Calico for Windows](https://techcommunity.microsoft.com/t5/networking-blog/calico-for-windows-goes-open-source/ba-p/1620297).  For information on using multi-subnet with Windows containers, see _link to new topic_.

### HostProcess containers for node management

HostProcess containers are a new container type that extend the Windows container model to enable a wider range of Kubernetes cluster management scenarios. HostProcess containers run directly on the host and maintain behavior and access similar to that of a regular process. With HostProcess containers, users can package and distribute management operations that require host access while retaining versioning and deployment methods provided by containers. This allows Windows containers to be used for a variety of device plug-in, storage, and networking management scenarios in Kubernetes. A host network mode is introduced so that HostProcess containers can be created within the host's network namespace instead of their own namespace.
HostProcess containers have the following benefits:

- Cluster users no longer need to log in to and individually configure each Windows node for administrative tasks and management of Windows services. 
- Users can utilize the container model to deploy management logic to as many clusters as needed.
- HostProcess containers can be built on top of existing Windows server 2019 (or later) base images, managed through the Windows container runtime, and run as any user that is available in the domain of the host machine. 
- HostProcess containers provide the best way to manage Windows nodes in Kubernetes.


## Tooling for containers

### Windows Admin Center improvements

The Containers extension was previously added to Windows Admin Center to help you containerize existing web applications based on ASP.Net from .NET Framework. You could either provide a static folder or a Visual Studio solution from your developer. 

Windows Admin Center includes the following enhancements:

- The Containers extension includes added support for Web Deploy files, allowing you to extract the app and its configuration from a running server and then containerize the application. 
- You can validate the image locally and then push that image to Azure Container Registry.
- Basic management functionality has been added for Azure Container Registry and Azure Container Instance. This allows you to create and delete registries, manage images, start and stop new container instances &mdash; all directly from the Windows Admin Center UI.

### Azure Migrate App Containerization tooling

Azure Migrate App Containerization is an end-to-end solution to containerize and move existing web applications to Azure Kubernetes Service. It’s step-by-step approach provides functionality to assess existing web servers, create a container image, push the image to ACR, create a Kubernetes deployment, and finally deploy it to AKS.

For more information on using this tool, see the following topics:

[ASP.NET app containerization and migration to Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/migrate/tutorial-app-containerization-aspnet-kubernetes)

[Java web app containerization and migration to Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/migrate/tutorial-app-containerization-java-kubernetes)