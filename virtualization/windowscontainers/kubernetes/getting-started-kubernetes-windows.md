---
title: Kubernetes on Windows 
author: gkudra-msft
ms.author: gekudray
ms.date: 11/02/2018
ms.topic: get-started-article
ms.prod: containers

description: Joining a Windows node to a Kubernetes cluster with v1.12.
keywords: kubernetes, 1.12, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---

# Kubernetes on Windows #
This page serves as an overview for getting started with Kubernetes on Windows by joining Windows nodes to a Linux-based cluster. With the release of Kubernetes 1.12 on Windows Server [version 1803](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1803#kubernetes) beta, users can take advantage of the [latest features](https://kubernetes.io/docs/getting-started-guides/windows/#supported-features) in Kubernetes on Windows:

  - **simplified network management**: use Flannel in host-gateway mode for automatic route management between nodes
  - **scalability improvements**: enjoy faster and more reliable container start-up times thanks to [deviceless vNICs for Windows Server containers](https://blogs.technet.microsoft.com/networking/2018/04/27/network-start-up-and-performance-improvements-in-windows-10-spring-creators-update-and-windows-server-version-1803/)
  - **hyper-v isolation (alpha)**: orchestrate [hyper-v containers](https://kubernetes.io/docs/getting-started-guides/windows/#hyper-v-containers) with kernel-mode isolation for enhanced security ([see Windows container types](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/#windows-container-types))
  - **storage plugins**:  use the [FlexVolume storage plugin](https://github.com/Microsoft/K8s-Storage-Plugins) with SMB and iSCSI support for Windows containers

> [!TIP] 
> If you would like to deploy a cluster on Azure, the open source ACS-Engine tool makes this easy. A step by step [walkthrough](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/windows.md) is available.

## Prerequisites ##

### Plan IP addressing for your cluster ###
<a name="definitions"></a>
As Kubernetes clusters introduce new subnets for pods and services, it is important to ensure that none of them collide with any other existing networks in your environment. Here are all the address spaces that need to be freed up in order to deploy Kubernetes successfully:

| Subnet / Address range | Description | Default Value |
| --------- | ------------- | ------------- |
| <a name="service-subnet-def"></a>**Service Subnet** | A non-routable, purely virtual subnet that is used by pods to uniformally access services without caring about the network topology. It is translated to/from routable address space by `kube-proxy` running on the nodes. | "10.96.0.0/12" |
| <a name="cluster-subnet-def"></a>**Cluster Subnet** |  This is a global subnet that is used by all pods in the cluster. Each nodes is assigned a smaller /24 subnet from this for their pods to use. It must be large enough to accommodate all pods used in your cluster. To calculate *minimum* subnet size: `(number of nodes) + (number of nodes * maximum pods per node that you configure)` <p/>Example for a 5 node cluster for 100 pods per node: `(5) + (5 *  100) = 505`.  | "10.244.0.0/16" |
| **Kubernetes DNS Service IP** | IP address of "kube-dns" service that will be used for DNS resolution & cluster service discovery. | "10.96.0.10" |
> [!NOTE]
> There is another Docker network (NAT) that gets created by default when you install Docker. It is not needed to operate Kubernetes on Windows as we assign IPs from the cluster subnet instead.

### Disable anti-spoofing protection ###
> [!Important] 
> Please read this section carefully as it is required for anyone to successfully use VMs to deploy Kubernetes on Windows today.

Ensure MAC address spoofing and virtualization is enabled for the Windows container host VMs (guests). To achieve this, you should run the following as Administrator on the machine hosting the VMs (example given for Hyper-V):

```powershell
Set-VMProcessor -VMName "<name>" -ExposeVirtualizationExtensions $true 
Get-VMNetworkAdapter -VMName "<name>" | Set-VMNetworkAdapter -MacAddressSpoofing On
```
> [!TIP]
> If you are using a VMware-based product to meet your virtualization needs, please look into enabling [promiscuous mode](https://kb.vmware.com/s/article/1004099) for the MAC spoofing requirement.

>[!TIP]
> If you are deploying Kubernetes on Azure IaaS VMs yourself, please look into VMs that support [nested virtualization](https://azure.microsoft.com/en-us/blog/nested-virtualization-in-azure/) for this requirement.

## What you will accomplish ##

By the end of this guide, you will have:

> [!div class="checklist"]
> * Created a [Kubernetes master](./creating-a-linux-master.md) node.  
> * Selected a [network solution](./network-topologies.md).  
> * Joined a [Windows worker node](./joining-windows-workers.md) or [Linux worker node](./joining-linux-workers.md) to it.  
> * Deployed a [sample Kubernetes resource](./deploying-resources.md).  
> * Covered [common problems and mistakes](./common-problems.md).

## Next steps ##
In this section, we talked about important pre-requisites & assumptions needed to deploy Kubernetes on Windows successfully today. Continue to learn how to setup a Kubernetes master:

> [!div class="nextstepaction"]
> [Create a Kubernetes Master](./creating-a-linux-master.md)