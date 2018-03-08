---
title: Kubernetes on Windows 
author: gkudra-msft
ms.author: gekudray
ms.date: 11/16/2017
ms.topic: get-started-article
ms.prod: containers

description: Joining a Windows node to a Kubernetes cluster with v1.9 beta.
keywords: kubernetes, 1.9, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---


# Kubernetes on Windows #
With the latest release of Kubernetes 1.9 and Windows Server [version 1709](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1709#networking), users can take advantage of the latest features in Windows networking:

  - **shared pod compartments**: infrastructure and worker pods now share a network compartment (analagous to a Linux namespace)
  - **endpoint optimization**: thanks to compartment sharing, container services need to track (at least) half as many endpoints as before
  - **data-path optimization**: improvements to the Virtual Filtering Platform and the Host Networking Service allow kernel-based load-balancing


This page serves as a guide for getting started joining a brand new Windows node to an existing Linux-based cluster. To start completely from scratch, refer to [this page](./creating-a-linux-master.md) &mdash; one of many resources available for deploying a Kubernetes cluster &mdash; to set a master up from scratch the same way we did.


<a name="definitions"></a>
These are definitions for some terms that are referenced throughout this guide:

  - The **external network** is the network across which your nodes communicate.
  - <a name="cluster-subnet-def"></a>The **cluster subnet** is a routable virtual network; nodes are assigned smaller subnets from this for their pods to use.
  - The **service subnet** is a non-routable, purely virtual subnet on 11.0/16 that is used by pods to uniformally access services without caring about the network topology. It is translated to/from routable address space by `kube-proxy` running on the nodes.


## What We Will Accomplish ##
By the end of this guide, we will have:

> [!div class="checklist"]  
> * Configured a [Linux master](#preparing-the-linux-master) node.  
> * Joined a [Windows worker node](#preparing-a-windows-node) to it.  
> * Prepared our [network topology](#network-topology).  
> * Deployed a [sample Windows service](#running-a-sample-service).  
> * Covered [common problems and mistakes](./common-problems.md).  


## Preparing the Linux Master ##
Regardless of whether you followed [our instructions](./creating-a-linux-master.md) or already have an existing cluster, only one thing is needed from the Linux master is Kubernetes' certificate configuration. This could be in `/etc/kubernetes/admin.conf`, `~/.kube/config`, or elsewhere depending on your setup.


## Preparing a Windows Node ##
> [!Note]  
> All code snippets in Windows sections are to be run in _elevated_ PowerShell.

Kubernetes uses [Docker](https://www.docker.com/) as its container orchestrator, so we need to install it. You can follow the [official MSDN instructions](../manage-docker/configure-docker-daemon.md#install-docker), the [Docker instructions](https://store.docker.com/editions/enterprise/docker-ee-server-windows), or try these steps:

```powershell
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name Docker -ProviderName DockerMsftProvider
Restart-Computer -Force
```

If you are behind a proxy, the following PowerShell environment variables must be defined:
```powershell
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://proxy.example.com:80/", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "http://proxy.example.com:443/", [EnvironmentVariableTarget]::Machine)
```

There is a collection of scripts on [this Microsoft repository](https://github.com/Microsoft/SDN) that will help us join this node to the cluster. You can download the ZIP file directly [here](https://github.com/Microsoft/SDN/archive/master.zip). The only thing we need is the `Kubernetes/windows` folder, the contents of which should be moved to `C:\k\`:

```powershell
wget https://github.com/Microsoft/SDN/archive/master.zip -o master.zip
Expand-Archive master.zip -DestinationPath master
mkdir C:/k/
mv master/SDN-master/Kubernetes/windows/* C:/k/
rm -recurse -force master,master.zip
```

Copy the certificate file [identified earlier](#preparing-the-linux-master) to this new `C:\k` directory.


## Network Topology ##
There are multiple ways to make the virtual [cluster subnet](#cluster-subnet-def) routable. You can:

  - Configure [host-gateway mode](./configuring-host-gateway-mode.md), setting static next-hop routes between nodes to enable pod-to-pod communication.
  - Configure a smart top-of-rack (ToR) switch to route the subnet.
  - Use a 3rd-party overlay plugin such as [Flannel](https://coreos.com/flannel/docs/latest/kubernetes.html) (Windows support for Flannel is in beta).


### Creating the "Pause" Image ###
Now that `docker` is installed, we need to prepare a "pause" image that's used by Kubernetes to prepare the infrastructure pods.

```powershell
docker pull microsoft/windowsservercore:1709
docker tag microsoft/windowsservercore:1709 microsoft/windowsservercore:latest
cd C:/k/
docker build -t kubeletwin/pause .
```

> [!Note]  
> We tag it as the `:latest` because the sample service we will be deploying later depends on it, though this may not actually _be_ the latest Windows Server Core image available. It's important to be careful of conflicting container images; not having the expected tag can cause a `docker pull` of an incompatible container image, causing [deployment problems](./common-problems.md#when-deploying-docker-containers-keep-restarting). 


### Downloading Binaries ###
In the meantime while the `pull` occurs, download the following client-side binaries from Kubernetes:

  - `kubectl.exe`
  - `kubelet.exe`
  - `kube-proxy.exe`

You can download these from the links in the `CHANGELOG.md` file of the latest 1.9 release. As of this writing, that is [1.9.1](https://github.com/kubernetes/kubernetes/releases/tag/v1.9.1), and the Windows binaries are [here](https://storage.googleapis.com/kubernetes-release/release/v1.9.1/kubernetes-node-windows-amd64.tar.gz). Use a tool like [7-Zip](http://www.7-zip.org/) to extract the archive and place the binaries in `C:\k\`.

In order to make the `kubectl` command available outside of the `C:\k\` directory, modify the `PATH` environment variable:

```powershell
$env:Path += ";C:\k"
```

If you would like to make this change permanent, modify the variable in machine target:

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\k", [EnvironmentVariableTarget]::Machine)
```

### Joining the Cluster ###
Verify that cluster configuration is valid using:

```powershell
kubectl version
```

If you are receiving a connection error,

```
Unable to connect to the server: dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.
```

check if the configuration has been discovered properly:

```powershell
kubectl config view
```

In order to change location where `kubectl` looks for the configuration file, you may pass the `--kubeconfig` parameter or modify `KUBECONFIG` environment variable. For example, if the configuration is located at `C:\k\config`:

```powershell
$env:KUBECONFIG="C:\k\config"
```

To make this setting permanent for current user's scope:

```powershell
[Environment]::SetEnvironmentVariable("KUBECONFIG", "C:\k\config", [EnvironmentVariableTarget]::User)
```

The node is now ready to join the cluster. In two separate, *elevated* PowerShell windows, run these scripts (in this order). The `-ClusterCidr` parameter in the first script is the configured [cluster subnet](#cluster-subnet-def); here, it's `192.168.0.0/16`.

```powershell
./start-kubelet.ps1 -ClusterCidr 192.168.0.0/16
./start-kubeproxy.ps1
```

The Windows node will be visible from the Linux master under `kubectl get nodes` within a minute!


### Validating Your Network Topology ###
There are a few basic tests that will validate a proper network configuration:

  - **Node to node connectivity**: pings between master and Windows worker nodes should succeed in both directions.

  - **Pod subnet to node connectivity**: pings between the virtual pod interface and the nodes. Find the gateway address under `route -n` and `ipconfig` on Linux and Windows, respectively, looking for the `cbr0` interface.

If any of these basic tests don't work, try the [troubleshooting page](./common-problems.md#common-networking-errors) to solve common issues.


## Running a Sample Service ##
We'll be deploying a very simple [PowerShell-based web service](https://github.com/Microsoft/SDN/blob/master/Kubernetes/WebServer.yaml) to ensure we joined the cluster successfully and our network is properly configured.


On the Linux master, download and run the service:

```bash
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/WebServer.yaml -O win-webserver.yaml
kubectl apply -f win-webserver.yaml
watch kubectl get pods -o wide
```

This will create a deployment and a service, then watch the pods indefinitely to track their status; simply press `Ctrl+C` to exit the `watch` command when done observing.


If all went well, it will be possible to:

  - see 4 containers under a `docker ps` command on the Windows node
  - see 2 pods under a `kubectl get pods` command from the Linux master
  - `curl` on the *pod* IPs on port 80 from the Linux master gets a web server response; this demonstrates proper node to pod communication across the network.
  - ping *between pods* (including across hosts, if you have more than one Windows node) via `docker exec`; this demonstrates proper pod-to-pod communication
  - `curl` the virtual *service IP* (seen under `kubectl get services`) from the Linux master and from individual pods.
  - `curl` the *service name* with the Kubernetes [default DNS suffix](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services), demonstrating DNS functionality.

> [!Warning]  
> Windows nodes will not be able to access the service IP. This is a [known platform limitation](./common-problems.md#my-windows-node-cannot-access-my-services-using-the-service-ip) that will be improved in the next update to Windows Server.


### Port Mapping ### 
It is also possible to access services hosted in pods through their respective nodes by mapping a port on the node. There is [another sample YAML available](https://github.com/Microsoft/SDN/blob/master/Kubernetes/PortMapping.yaml) with a mapping of port 4444 on the node to port 80 on the pod to demonstrate this feature. To deploy it, follow the same steps as before:


```bash
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/PortMapping.yaml -O win-webserver-port-mapped.yaml
kubectl apply -f win-webserver-port-mapped.yaml
watch kubectl get pods -o wide
```

It should now be possible to `curl` on the *node* IP on port 4444 and receive a web server response. Keep in mind that this limits scaling to a single pod per node since it must enforce a one-to-one mapping.
