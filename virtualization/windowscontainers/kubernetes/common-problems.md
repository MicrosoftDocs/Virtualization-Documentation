---
title: Troubleshooting Kubernetes
author: daschott
ms.author: roharwoo
ms.date: 08/13/2020
ms.topic: troubleshooting
description: Solutions for common issues when deploying Kubernetes and joining Windows nodes.
---

# Troubleshooting Kubernetes

This page walks through several common issues with Kubernetes setup, networking, and deployments.

> [!TIP]
> Suggest an FAQ item by raising a PR to [our documentation repository](https://github.com/MicrosoftDocs/Virtualization-Documentation/).

This page is subdivided into the following categories:
1. [General questions](#general-questions)
2. [Common networking errors](#common-networking-errors)
3. [Common Windows errors](#common-windows-errors)
4. [Common Kubernetes master errors](#common-kubernetes-master-errors)

## General questions

### How do I know Kubernetes on Windows completed successfully?

You should see kubelet, kube-proxy, and (if you chose Flannel as your networking solution) flanneld host-agent processes running on your node. In addition to this, your Windows node should be listed as “Ready” in your Kubernetes cluster.

### Can I configure to run all of this in the background?

Starting with Kubernetes version 1.11, kubelet & kube-proxy can be run as native [Windows Services](https://kubernetes.io/docs/getting-started-guides/windows/#kubelet-and-kube-proxy-can-now-run-as-windows-services). You can also always use alternative service managers like [nssm.exe](https://nssm.cc/) to always run these processes (flanneld, kubelet & kube-proxy) in the background for you.

## Common networking errors

### Load balancers are plumbed inconsistently across the cluster nodes

On Windows, kube-proxy creates a HNS load balancer for every Kubernetes service in the cluster. In the (default) kube-proxy configuration, nodes in clusters containing many (usually 100+) load balancers may run out of available ephemeral TCP ports (a.k.a. dynamic port range, which by default covers ports 49152 through 65535). This is due to the high number of ports reserved on each node for every (non-DSR) load balancer. This issue may manifest itself through errors in kube-proxy such as:
```
Policy creation failed: hcnCreateLoadBalancer failed in Win32: The specified port already exists.
```

Users can identify this issue by running [CollectLogs.ps1](https://github.com/microsoft/SDN/blob/master/Kubernetes/windows/debug/collectlogs.ps1) script and consulting the `*portrange.txt` files.

The `CollectLogs.ps1` will also mimic HNS allocation logic to test port pool allocation availability in the ephemeral TCP port range, and report success/failure in `reservedports.txt`. The script reserves 10 ranges of 64 TCP ephemeral ports (to emulate HNS behavior), counts reservation successes & failures, then releases the allocated port ranges. A success number less than 10 indicates the ephemeral pool is running out of free space. A heuristical summary of how many 64-block port reservations are approximately available will also be generated in `reservedports.txt`.

To resolve this issue, a few steps can be taken:
1. For a permanent solution, kube-proxy load balancing should be set to [DSR mode](https://techcommunity.microsoft.com/t5/Networking-Blog/Direct-Server-Return-DSR-in-a-nutshell/ba-p/693710). DSR mode is fully implemented and available on newer [Windows Server Insider build 18945](https://blogs.windows.com/windowsexperience/2019/07/30/announcing-windows-server-vnext-insider-preview-build-18945/#o1bs7T2DGPFpf7HM.97) (or higher) only.
1. As a workaround, users can also increase the default Windows configuration of ephemeral ports available using a command such as `netsh int ipv4 set dynamicportrange TCP <start_port> <port_count>`. *WARNING:* Overriding the default dynamic port range can have consequences on other processes/services on the host that rely on available TCP ports from the non-ephemeral range, so this range should be selected carefully.
1. There is a scalability enhancement to non-DSR mode load balancers using intelligent port pool sharing included in cumulative update [KB4551853](https://support.microsoft.com/en-us/help/4551853) (and all newer cumulative updates).

### HostPort publishing is not working

To use HostPort feature, please ensure your CNI plugins are [v0.8.6](https://github.com/containernetworking/plugins/releases/tag/v0.8.6) release or higher, and that the CNI configuration file has the `portMappings` capabilities set:
```
"capabilities": {
    "portMappings":  true
}
```

### I am seeing errors such as "hnsCall failed in Win32: The wrong diskette is in the drive."

This error can occur when making custom modifications to HNS objects or installing new Windows Update that introduce changes to HNS without tearing down old HNS objects. It indicates that a HNS object which was previously created before an update is incompatible with the currently installed HNS version.

On Windows Server 2019 (and earlier), users can delete HNS objects by deleting the HNS.data file
```
Stop-Service HNS
rm C:\ProgramData\Microsoft\Windows\HNS\HNS.data
Start-Service HNS
```

Users should be able to directly delete any incompatible HNS endpoints or networks:
```
hnsdiag list endpoints
hnsdiag delete endpoints <id>
hnsdiag list networks
hnsdiag delete networks <id>
Restart-Service HNS
```

Users on Windows Server, version 1903 can go to the following registry location and delete any NICs starting with the network name (e.g. `vxlan0` or `cbr0`):
```
\\Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\NicList
```

### Containers on my Flannel host-gw deployment on Azure cannot reach the internet

When deploying Flannel in host-gw mode on Azure, packets have to go through the Azure physical host vSwitch. Users should program [user-defined routes](/azure/virtual-network/virtual-networks-udr-overview#user-defined) of type "virtual appliance" for each subnet assigned to a node. This can be done through the Azure portal (see an example [here](/azure/virtual-network/tutorial-create-route-table-portal)) or via `az` Azure CLI. Here is one example UDR with name "MyRoute" using az commands for a node with IP 10.0.0.4 and respective pod subnet 10.244.0.0/24:
```
az network route-table create --resource-group <my_resource_group> --name BridgeRoute 
az network route-table route create  --resource-group <my_resource_group> --address-prefix 10.244.0.0/24 --route-table-name BridgeRoute  --name MyRoute --next-hop-type VirtualAppliance --next-hop-ip-address 10.0.0.4 
```

>[!TIP]
> If you are deploying Kubernetes on Azure or IaaS VMs from other cloud providers yourself, you can also use `overlay networking` instead.

### My Windows pods cannot ping external resources

Windows pods do not have outbound rules programmed for the ICMP protocol today. However, TCP/UDP is supported. When trying to demonstrate connectivity to resources outside of the cluster, please substitute `ping <IP>` with corresponding `curl <IP>` commands.

If you are still facing problems, most likely your network configuration in [cni.conf](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/l2bridge/cni/config/cni.conf) deserves some extra attention. You can always edit this static file, the configuration will be applied to any newly created Kubernetes resources.

Why?
One of the Kubernetes networking requirements (see [Kubernetes model](https://kubernetes.io/docs/concepts/cluster-administration/networking/)) is for cluster communication to occur without NAT internally. To honor this requirement, we have an [ExceptionList](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/l2bridge/cni/config/cni.conf#L20) for all the communication where we do not want outbound NAT to occur. However, this also means that you need to exclude the external IP you are trying to query from the ExceptionList. Only then will the traffic originating from your Windows pods be SNAT’ed correctly to receive a response from the outside world. In this regard, your ExceptionList in `cni.conf` should look as follows:
```conf
"ExceptionList": [
  "10.244.0.0/16",  # Cluster subnet
  "10.96.0.0/12",   # Service subnet
  "10.127.130.0/24" # Management (host) subnet
]
```

### My Windows node cannot access a NodePort service

Local NodePort access from the node itself may fail. This is a known feature gap being addressed with cumulative update KB4571748 (or later). NodePort access will work from other nodes or external clients.

### My Windows node stops routing thourgh NodePorts after I scaled down my pods

Due to a design limitation, there needs to be at least one pod running on the Windows node for NodePort forwarding to work.

### After some time, vNICs and HNS endpoints of containers are being deleted

This issue can be caused when the `hostname-override` parameter is not passed to [kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/). To resolve it, users need to pass the hostname to kube-proxy as follows:
```
C:\k\kube-proxy.exe --hostname-override=$(hostname)
```

### On Flannel (vxlan) mode, my pods are having connectivity issues after rejoining the node

Whenever a previously deleted node is being rejoined to the cluster, flannelD will try to assign a new pod subnet to the node. Users should remove the old pod subnet configuration files in the following paths:
```powershell
Remove-Item C:\k\SourceVip.json
Remove-Item C:\k\SourceVipRequest.json
```

### After launching Kubernetes, Flanneld is stuck in "Waiting for the Network to be created"

This issue should be addressed with [Flannel v0.12.0](https://github.com/coreos/flannel/releases/tag/v0.12.0) (and above). If you are using an older version of Flanneld, there is a known race condition that can occur such that the management IP of the flannel network is not set. A workaround is to simply relaunch FlannelD manually.
```
PS C:> [Environment]::SetEnvironmentVariable("NODE_NAME", "<Windows_Worker_Hostname>")
PS C:> C:\flannel\flanneld.exe --kubeconfig-file=c:\k\config --iface=<Windows_Worker_Node_IP> --ip-masq=1 --kube-subnet-mgr=1
```

### My Windows pods cannot launch because of missing /run/flannel/subnet.env

This indicates that Flannel didn't launch correctly. You can either try to restart flanneld.exe or you can copy the files over manually from `/run/flannel/subnet.env`  on the Kubernetes master to `C:\run\flannel\subnet.env` on the Windows worker node and modify the `FLANNEL_SUBNET` row to the subnet that was assigned. For example, if node subnet 10.244.4.1/24 was assigned:
```
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.4.1/24
FLANNEL_MTU=1500
FLANNEL_IPMASQ=true
```
More often than not, there is another issue that could be causing this error that needs to be investigated first. It is recommended to let `flanneld.exe` generate this file for you.

### Pod-to-pod connectivity between hosts is broken on my Kubernetes cluster running on vSphere

Since both vSphere and Flannel reserves port 4789 (default VXLAN port) for overlay networking, packets can end up being intercepted. If vSphere is used for overlay networking, it should be configured to use a different port in order to free up 4789.

### My endpoints/IPs are leaking

There exist 2 currently known issues that can cause endpoints to leak.
1. The first [known issue](https://github.com/kubernetes/kubernetes/issues/68511) is a problem in Kubernetes version 1.11. Please avoid using Kubernetes version 1.11.0 - 1.11.2.
1. The second [known issue](https://github.com/docker/libnetwork/issues/1950) that can cause endpoints to leak is a concurrency problem in the storage of endpoints. To receive the fix, you must use Docker EE 18.09 or above.

### My pods cannot launch due to "network: failed to allocate for range" errors

This indicates that the IP address space on your node is used up. To clean up any [leaked endpoints](#my-endpointsips-are-leaking), please migrate any resources on impacted nodes & run the following commands:
```
c:\k\stop.ps1
Get-HNSEndpoint | Remove-HNSEndpoint
Remove-Item -Recurse c:\var
```

### My Windows node cannot access my services using the service IP

This is a known limitation of the current networking stack on Windows. Windows *pods* **are** able to access the service IP however.

### No network adapter is found when starting Kubelet

The Windows networking stack needs a virtual adapter for Kubernetes networking to work. If the following commands return no results (in an admin shell), HNS network creation &mdash; a necessary prerequisite for Kubelet to work &mdash; has failed:

```powershell
Get-HnsNetwork | ? Name -ieq "cbr0"
Get-HnsNetwork | ? Name -ieq "vxlan0"
Get-NetAdapter | ? Name -Like "vEthernet (Ethernet*"
```

Often it is worthwhile to modify the InterfaceName parameter of the start.ps1 script, in cases where the host's network adapter isn't "Ethernet". Otherwise, consult the output of the `start-kubelet.ps1` script to see if there are errors during virtual network creation.

### I am still seeing problems. What should I do?

There may be additional restrictions in place on your network or on hosts preventing certain types of communication between nodes. Ensure that:
  - you have properly configured your chosen network topology (`l2bridge` or `overlay`)
  - traffic that looks like it's coming from pods is allowed
  - HTTP traffic is allowed, if you are deploying web services
  - Packets from different protocols (ie ICMP vs. TCP/UDP) are not being dropped

>[!TIP]
> For additional self-help resources, there is also a Kubernetes networking troubleshooting guide for Windows [available here](https://techcommunity.microsoft.com/t5/Networking-Blog/Troubleshooting-Kubernetes-Networking-on-Windows-Part-1/ba-p/508648).

## Common Windows errors

### My Kubernetes pods are stuck at "ContainerCreating"

This issue can have many causes, but one of the most common is that the pause image was misconfigured. This is a high-level symptom of the next issue.

### When deploying, Docker containers keep restarting

Check that your pause image is compatible with your OS version. Kubernetes assumes that both the OS and the containers have matching OS version numbers. If you are using an experimental build of Windows, such as an Insider build, you will need to adjust the images accordingly. Please refer to the Microsoft's [Docker repository](https://hub.docker.com/u/microsoft/) for images.

## Common Kubernetes master errors

Debugging the Kubernetes master falls into three main categories (in order of likelihood):

  - Something is wrong with the Kubernetes system containers.
  - Something is wrong with the way `kubelet` is running.
  - Something is wrong with the system.

Run `kubectl get pods -n kube-system` to see the pods being created by Kubernetes; this may give some insight into which particular ones are crashing or not starting correctly. Then, run `docker ps -a` to see all of the raw containers that back these pods. Finally, run `docker logs [ID]` on the container(s) that are suspected to be causing the problem to see the raw output of the processes.

### Cannot connect to the API server at `https://[address]:[port]`

More often than not, this error indicates certificate problems. Ensure that you have generated the configuration file correctly, that the IP addresses in it match that of your host, and that you have copied it to the directory that is mounted by the API server.

Good places to find this configuration file are:
* `~/kube/kubelet/`
* `$HOME/.kube/config`
*  `/etc/kubernetes/admin.conf`

 otherwise, refer to the API server's manifest file to check the mount points.
