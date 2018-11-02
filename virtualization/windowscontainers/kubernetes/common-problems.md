---
title: Troubleshooting Kubernetes
author: gkudra-msft
ms.author: gekudray
ms.date: 08/24/2018
ms.topic: troubleshooting
ms.prod: containers

description: Solutions for common issues when deploying Kubernetes and joining Windows nodes.
keywords: kubernetes, 1.12, linux, compile
---

# Troubleshooting Kubernetes #
This page walks through several common issues with Kubernetes setup, networking, and deployments.

> [!tip]
> Suggest an FAQ item by raising a PR to [our documentation repository](https://github.com/MicrosoftDocs/Virtualization-Documentation/).

This page is subdivided into the following categories:
1. [General questions](#general-questions)
2. [Common networking errors](#common-networking-errors)
3. [Common Windows errors](#common-windows-errors)
4. [Common Kubernetes master errors](#common-kubernetes-master-errors)

## General questions ##

### How do I know start.ps1 on Windows completed successfully? ###
You should see kubelet, kube-proxy, and (if you chose Flannel as your networking solution) flanneld host-agent processes running on your node, with running logs being displayed in separate PoSh windows. In addition to this, your Windows node should be listed as “Ready” in your Kubernetes cluster.

### Can I configure to run all of this in the background instead of PoSh windows? ###
Starting with Kubernetes version 1.11, kubelet & kube-proxy can be run as native [Windows Services](https://kubernetes.io/docs/getting-started-guides/windows/#kubelet-and-kube-proxy-can-now-run-as-windows-services). You can also always use alternative service managers like [nssm.exe](https://nssm.cc/) to always run these processes (flanneld, kubelet & kube-proxy) in the background for you.


## Common networking errors ##

### My Windows pods do not have network connectivity ###
If you are using any virtual machines, ensure that MAC spoofing is enabled on all the VM network adapter(s). See [anti-spoofing protection](./getting-started-kubernetes-windows.md#disable-anti-spoofing-protection) for more details.


### My Windows pods cannot ping external resources ###
Windows pods do not have outbound rules programmed for the ICMP protocol today. However, TCP/UDP is supported. When trying to demonstrate connectivity to resources outside of the cluster, please substitute `ping <IP>` with corresponding `curl <IP>` commands.

If you are still facing problems, most likely your network configuration in [cni.conf](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/l2bridge/cni/config/cni.conf) deserves some extra attention. You can always edit this static file, the configuration will be applied to any newly created Kubernetes resources.

Why?
One of the Kubernetes networking requirements (see [Kubernetes model](https://kubernetes.io/docs/concepts/cluster-administration/networking/)) is for cluster communication to occur without NAT internally. To honor this requirement, we have an [ExceptionList](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/l2bridge/cni/config/cni.conf#L20) for all the communication where we do not want outbound NAT to occur. However, this also means that you need to exclude the external IP you are trying to query from the ExceptionList. Only then will the traffic originating from your Windows pods be SNAT’ed correctly to receive a response from the outside world. In this regard, your ExceptionList in `cni.conf` should look as follows:
```
				"ExceptionList": [
					"10.244.0.0/16",  # Cluster subnet
					"10.96.0.0/12",   # Service subnet
					"10.127.130.0/24" # Management (host) subnet
				]
```

### After launching start.ps1, Flanneld is stuck in "Waiting for the Network to be created" ###
There are numerous reports of this issue which are being investigated; most likely it is a timing issue for when the management IP of the flannel network is set. A workaround is to simply relaunch start.ps1 or relaunch it manually as follows:
```
PS C:> [Environment]::SetEnvironmentVariable("NODE_NAME", "<Windows_Worker_Hostname>")
PS C:> C:\flannel\flanneld.exe --kubeconfig-file=c:\k\config --iface=<Windows_Worker_Node_IP> --ip-masq=1 --kube-subnet-mgr=1
```

There is also a [PR](https://github.com/coreos/flannel/pull/1042) that addresses this issue under review currently.

### My Windows pods cannot launch because of missing /run/flannel/subnet.env ###
This indicates that Flannel didn't launch correctly. You can either try to restart flanneld.exe or you can copy the files over manually from `/run/flannel/subnet.env`  on the Kubernetes master to `C:\run\flannel\subnet.env` on the Windows worker node and modify the `FLANNEL_SUBNET` row to a different number. For example, if node subnet 10.244.4.1/24 is desired:
```
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.4.1/24
FLANNEL_MTU=1500
FLANNEL_IPMASQ=true
```

### My endpoints/IPs are leaking ###
There exist 2 currently known issues that can cause endpoints to leak. 
1.  The first [known issue](https://github.com/kubernetes/kubernetes/issues/68511) is a problem in Kubernetes version 1.11. Please avoid using Kubernetes version 1.11.0 - 1.11.2.
2. The second [known issue](https://github.com/docker/libnetwork/issues/1950) that can cause endpoints to leak is a concurrency problem in the storage of endpoints. To receive the fix, you must use Docker EE 18.09 or above.

### My pods cannot launch due to "network: failed to allocate for range" errors ###
This indicates that the IP address space on your node is used up. To clean up any [leaked endpoints](#my-endpointsips-are-leaking), please migrate any resources on impacted nodes & run the following commands:
```
c:\k\stop.ps1
Get-HNSEndpoint | Remove-HNSEndpoint
Remove-Item -Recurse c:\var
```

### My Windows node cannot access my services using the service IP ###
This is a known limitation of the current networking stack on Windows. Windows *pods* **are** able to access the service IP however.

### No network adapter is found when starting Kubelet ###
The Windows networking stack needs a virtual adapter for Kubernetes networking to work. If the following commands return no results (in an admin shell), virtual network creation &mdash; a necessary prerequisite for Kubelet to work &mdash; has failed:

```powershell
Get-HnsNetwork | ? Name -ieq "cbr0"
Get-NetAdapter | ? Name -Like "vEthernet (Ethernet*"
```

Consult the output of the `start-kubelet.ps1` script to see if there are errors during virtual network creation.

### Pods stop resolving DNS queries successfully after some time alive ###
There is a known DNS caching issue in the networking stack of Windows Server, version 1803 and below that may sometimes cause DNS requests to fail. To work around this issue, you can set the max TTL cache values to zero using the following registry keys:

```Dockerfile
FROM microsoft/windowsservercore:<your-build>
SHELL ["powershell', "-Command", "$ErrorActionPreference = 'Stop';"]
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxCacheTtl -Value 0 -Type DWord 
New-ItemPropery -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name MaxNegativeCacheTtl -Value 0 -Type DWord
```

### I am still seeing problems. What should I do? ### 
There may be additional restrictions in place on your network or on hosts preventing certain types of 
communication between nodes. Ensure that:
  - you have properly configured your chosen [network topology](./network-topologies.md)
  - traffic that looks like it's coming from pods is allowed
  - HTTP traffic is allowed, if you are deploying web services
  - Packets from different protocols (ie ICMP vs. TCP/UDP) are not being dropped


## Common Windows errors ##

### My Kubernetes pods are stuck at "ContainerCreating" ###
This issue can have many causes, but one of the most common is that the pause image was misconfigured. This is a high-level symptom of the next issue.


### When deploying, Docker containers keep restarting ###
Check that your pause image is compatible with your OS version. The [instructions](./deploying-resources.md) assume that both the OS and the containers are version 1803. If you have a later version of Windows, such as an Insider build, you will need to adjust the images accordingly. Please refer to the Microsoft's [Docker repository](https://hub.docker.com/u/microsoft/) for images. Regardless, both the pause image Dockerfile and the sample service will expect the image to be tagged as `:latest`.


## Common Kubernetes master errors ##
Debugging the Kubernetes master falls into three main categories (in order of likelihood):

  - Something is wrong with the Kubernetes system containers.
  - Something is wrong with the way `kubelet` is running.
  - Something is wrong with the system.

Run `kubectl get pods -n kube-system` to see the pods being created by Kubernetes; this may give some insight into which particular ones are crashing or not starting correctly. Then, run `docker ps -a` to see all of the raw containers that back these pods. Finally, run `docker logs [ID]` on the container(s) that are suspected to be causing the problem to see the raw output of the processes.


### Cannot connect to the API server at `https://[address]:[port]` ###
More often than not, this error indicates certificate problems. Ensure that you have generated the configuration file correctly, that the IP addresses in it match that of your host, and that you have copied it to the directory that is mounted by the API server.

If following [our instructions](./creating-a-linux-master.md), good places to find this is:   
* `~/kube/kubelet/`
* `$HOME/.kube/config`
*  `/etc/kubernetes/admin.conf`

 otherwise, refer to the API server's manifest file to check the mount points.