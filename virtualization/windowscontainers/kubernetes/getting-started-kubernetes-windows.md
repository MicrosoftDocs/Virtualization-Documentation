---
title: Kubernetes on Windows 
author: gkudra-msft
ms.author: gekudray
ms.date: 02/09/2018
ms.topic: get-started-article
ms.prod: containers

description: Joining a Windows node to a Kubernetes cluster with v1.13.
keywords: kubernetes, 1.13, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---

# Kubernetes on Windows #
This page serves as an overview for getting started with Kubernetes on Windows by joining Windows nodes to a Linux-based cluster. With the release of Kubernetes 1.13 on Windows Server [version 1809](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1809#container-networking-with-kubernetes), users can take advantage of the [latest features](https://kubernetes.io/docs/getting-started-guides/windows/#supported-features) in Kubernetes on Windows beta:

  - **overlay networking**: use Flannel in vxlan mode to configure a virtual overlay network
    - requires either Windows Server 2019 with KB4482887 installed or [Windows Server vNext Insider Preview](https://blogs.windows.com/windowsexperience/tag/windows-insider-program/) Build 18317+
    - requires Kubernetes v1.14 (or above) with `WinOverlay` feature gate enabled
    - requires Flannel v0.11.0 (or above)
  - **simplified network management**: use Flannel in host-gateway mode for automatic route management between nodes
  - **scalability improvements**: enjoy faster and more reliable container start-up times thanks to [deviceless vNICs for Windows Server containers](https://blogs.technet.microsoft.com/networking/2018/04/27/network-start-up-and-performance-improvements-in-windows-10-spring-creators-update-and-windows-server-version-1803/)
  - **hyper-v isolation (alpha)**: orchestrate [hyper-v containers](https://kubernetes.io/docs/getting-started-guides/windows/#hyper-v-containers) with kernel-mode isolation for enhanced security ([see Windows container types](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/#windows-container-types))
    - requires Kubernetes v1.10 (or above) with `HyperVContainer` feature gate enabled
  - **storage plugins**:  use the [FlexVolume storage plugin](https://github.com/Microsoft/K8s-Storage-Plugins) with SMB and iSCSI support for Windows containers

> [!TIP] 
> If you would like to deploy a cluster on Azure, the open source AKS-Engine tool makes this easy. A step by step [walkthrough](https://github.com/Azure/aks-engine/blob/master/docs/topics/windows.md) is available.

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