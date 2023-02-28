---
title: What's new for Windows containers in Windows Server 2022
description: Find out what is new when using Windows containers in Windows Server 2022.
author: v-susbo
ms.author: mabrigg
ms.date: 08/18/2021
ms.topic: overview
---

# What's new for Windows containers in Windows Server 2022

> Applies to: Windows Server 2022

This article describes some of the new features when using Windows containers with Windows Server 2022. Windows Server 2022 is built on the strong foundation of Windows Server 2019 and brings many innovations on three key themes: security, Azure hybrid integration and management, and application platform.

## Platform improvements

### Server Core image size reduction

The size of an image is important when using containers because when you deploy a containerized application, you want it to start quickly. Before a container starts, the container image layers need to be downloaded and extracted on the container host. In Windows Server 2022, the size of the Server Core image is reduced, which allows the container to start faster than in previous Server Core versions.

In Windows Server 2022, the Server Core container image RTM layer at the time of GA clocks in at 2.76 GB uncompressed on disk. Compared to the Windows Server 2019 RTM layer at the time of GA, which clocks in at 3.47 GB uncompressed on disk, that is 33% reduction in on-disk footprint for that layer. While you should not expect the **total** image size to be reduced by 33%, a smaller RTM layer size generally means the total image size will be smaller on the whole.

> [!NOTE]
> Remember that Windows container base images ship as two layers: an RTM layer and a patch layer containing the latest security fixes for OS libraries and binaries which gets overlaid onto the RTM layer. The patch layer's size fluctuates over the life of the container image's support cycle, growing or shrinking from month to month depending on the delta of changes in the binaries. When a Windows container base image is pulled on a new host, both layers must be pulled.

### Longer support cycle for all Windows container images

Five years of mainstream support and an additional five years of extended support is now offered for all Windows Server 2022 images: Server Core, Nano Server, and the recently announced [Server image](https://techcommunity.microsoft.com/t5/containers/announcing-a-new-windows-server-container-image-preview/ba-p/2304897). This longer support cycle will ensure you have time to implement, use, and upgrade or migrate when appropriate for your organization. For more information, see [Windows containers base image lifecycles](../deploy-containers/base-image-lifecycle.md) and [Windows Server 2022 lifecycles](/lifecycle/products/windows-server-2022).

### Virtualized time zone

With Windows Server 2022, Windows containers support the ability to maintain a virtualized time zone configuration separate from the host. All of the configurations traditionally used for the host time zone have been virtualized and are instanced for each container. To configure the container time zone, you can use the [tzutil](/windows-server/administration/windows-commands/tzutil) command utility or the [Set-TimeZone](/powershell/module/microsoft.powershell.management/set-timezone?view=powershell-7.1&preserve-view=true) Powershell cmdlet. To learn more, see [Virtualized time zone](../manage-containers/virtual-time-zone.md).

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

To learn more about the gMSA improvements, see [Create gMSAs for Windows containers](../manage-containers/manage-serviceaccounts.md).

### IPv6 support

The first step to fully supporting the IPv6 dual stack has been implemented for Kuberenetes in Windows. The IPv6 dual stack is supported for L2Bridge-based networks on the platform. IPv6 is dependent on the CNI used in Kubernetes, and it also required Kubernetes version 1.20 to enable the IPv6 support end-to-end. For more information, see [IPv4/IPv6 in Introduction to Windows support in Kubernetes](https://kubernetes.io/docs/setup/production-environment/windows/intro-windows-in-kubernetes/#ipv4-ipv6-dual-stack).


## Improved Kubernetes experience

### Multi-subnet support for Windows worker nodes with Calico for Windows

The Host Network Service (HNS) has been improved and now allows the use of more restrictive subnets (such as subnets with a longer prefix length) as well as multiple subnets for each Windows worker node. Previously, HNS was restricting the Kubernetes container endpoint configurations to only use the prefix length of the underlying subnet. The first CNI that makes use of this functionality is [Calico for Windows](https://techcommunity.microsoft.com/t5/networking-blog/calico-for-windows-goes-open-source/ba-p/1620297).  For more information, see [Multiple subnet support in Host Networking Service](../container-networking/multi-subnet.md).

### HostProcess containers for node management

HostProcess containers are a new container type that runs directly on the host and extends the Windows container model to enable a wider range of Kubernetes cluster management scenarios. With HostProcess containers, users can package and distribute management operations that require host access while retaining versioning and deployment methods provided by containers. This allows you to use Windows containers for a variety of device plug-in, storage, and networking management scenarios in Kubernetes.

HostProcess containers have the following benefits:

- Cluster users no longer need to log in and individually configure each Windows node for administrative tasks and management of Windows services.
- Users can utilize the container model to deploy management logic to as many clusters as needed.
- HostProcess containers can be built on top of existing Windows server 2019 (or later) base images, managed through the Windows container runtime, and run as any user that is available in the domain of the host machine.
- HostProcess containers provide the best way to manage Windows nodes in Kubernetes.

For more information, see [Windows HostProcess Containers](https://kubernetes.io/blog/2021/08/16/windows-hostprocess-containers/).

## Windows container tooling

### Windows Admin Center improvements

The Containers extension was previously added to Windows Admin Center to help you containerize existing web applications based on ASP.Net from .NET Framework. You could either provide a static folder or a Visual Studio solution from your developer.

Windows Admin Center includes the following enhancements:

- The Containers extension includes added support for Web Deploy files, allowing you to extract the app and its configuration from a running server and then containerize the application.
- You can validate the image locally and then push that image to Azure Container Registry.
- Basic management functionality has been added for Azure Container Registry and Azure Container Instance. This allows you to create and delete registries, manage images, start and stop new container instances &mdash; all directly from the Windows Admin Center UI.

### Azure Migrate App Containerization tooling

Azure Migrate App Containerization is an end-to-end solution to containerize and move existing web applications to Azure Kubernetes Service. It’s step-by-step approach provides functionality to assess existing web servers, create a container image, push the image to ACR, create a Kubernetes deployment, and finally deploy it to AKS.

For more information on using the Azure Migrate App Containerization tool, see the following topics:

[ASP.NET app containerization and migration to Azure Kubernetes Service](/azure/migrate/tutorial-app-containerization-aspnet-kubernetes)

[Java web app containerization and migration to Azure Kubernetes Service](/azure/migrate/tutorial-app-containerization-java-kubernetes)
