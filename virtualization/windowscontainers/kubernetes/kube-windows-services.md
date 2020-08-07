---
title: Running Kubernetes as a Windows Service
author: daschott
ms.author: daschott
ms.date: 02/12/2019
ms.topic: how-to

description: How to run Kubernetes components as Windows services.
keywords: kubernetes, 1.14, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5c18
---

# Kubernetes Components as Windows Services

Some users may wish to configure processes such as flanneld.exe, kubelet.exe, kube-proxy.exe or others to run as Windows services. This brings additional fault-tolerance benefits such as the processes automatically restarting upon an unexpected process or node crash.


## Prerequisites
1. You have downloaded [nssm.exe](https://nssm.cc/download) into the `c:\k` directory
2. You have joined the node to your cluster and run the [install.ps1](https://github.com/Microsoft/SDN/tree/master/Kubernetes/flannel/install.ps1) or [start.ps1](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/start.ps1) script on your node previously

## Registering Windows services
You can run [a sample script](https://github.com/Microsoft/SDN/tree/master/Kubernetes/flannel/register-svc.ps1) which uses nssm.exe that will register `kubelet`, `kube-proxy`, and `flanneld.exe` to run as Windows services in the background:

```
C:\k\register-svc.ps1 -NetworkMode <Network mode> -ManagementIP <Windows Node IP> -ClusterCIDR <Cluster subnet> -KubeDnsServiceIP <Kube-dns Service IP> -LogDir <Directory to place logs>
```

# [ManagementIP](#tab/ManagementIP)
The IP address assigned to the Windows node. You can use `ipconfig` to find this.

|  |  |
|---------|---------|
|Parameter     | `-ManagementIP`        |
|Default Value    | n.A.        |


# [NetworkMode](#tab/NetworkMode)
The network mode `l2bridge` (flannel host-gw) or `overlay` (flannel vxlan) chosen as a [network solution](./network-topologies.md).

> [!Important]
> `overlay` networking mode (flannel vxlan) requires Kubernetes v1.14 binaries or above.

|  |  |
|---------|---------|
|Parameter     | `-NetworkMode`        |
|Default Value    | `l2bridge`        |


# [ClusterCIDR](#tab/ClusterCIDR)
The [cluster subnet range](./getting-started-kubernetes-windows.md#cluster-subnet-def).

|  |  |
|---------|---------|
|Parameter     | `-ClusterCIDR`        |
|Default Value    | `10.244.0.0/16`        |


# [KubeDnsServiceIP](#tab/KubeDnsServiceIP)
The [Kubernetes DNS service IP](./getting-started-kubernetes-windows.md#kube-dns-def).

|  |  |
|---------|---------|
|Parameter     | `-KubeDnsServiceIP`        |
|Default Value    | `10.96.0.10`        |


# [LogDir](#tab/LogDir)
The directory where kubelet and kube-proxy logs are redirected into their respective output files.

|  |  |
|---------|---------|
|Parameter     | `-LogDir`        |
|Default Value    | `C:\k`        |

---


> [!TIP]
> Should something go wrong, please consult the [troubleshooting section](./common-problems.md#i-have-problems-running-kubernetes-processes-as-windows-services)

## Manual Approach
Should the [above referenced script](#registering-windows-services) not work for you, this section provides some *sample commands* which can be used to register these services manually step-by-step.

> [!TIP]
> See [Kubelet and kube-proxy can now run as Windows services](https://kubernetes.io/docs/getting-started-guides/windows/#kubelet-and-kube-proxy-can-now-run-as-windows-services) for more details on how to configure `kubelet` and `kube-proxy` to run as native Windows services via `sc`.

### Register flanneld.exe
```
nssm install flanneld C:\flannel\flanneld.exe
nssm set flanneld AppParameters --kubeconfig-file=c:\k\config --iface=<ManagementIP> --ip-masq=1 --kube-subnet-mgr=1
nssm set flanneld AppEnvironmentExtra NODE_NAME=<hostname>
nssm set flanneld AppDirectory C:\flannel
nssm start flanneld
```

### Register kubelet.exe
```
nssm install kubelet C:\k\kubelet.exe
nssm set kubelet AppParameters --hostname-override=<hostname> --v=6 --pod-infra-container-image=kubeletwin/pause --resolv-conf="" --allow-privileged=true --enable-debugging-handlers --cluster-dns=<DNS-service-IP> --cluster-domain=cluster.local --kubeconfig=c:\k\config --hairpin-mode=promiscuous-bridge --image-pull-progress-deadline=20m --cgroups-per-qos=false  --log-dir=<log directory> --logtostderr=false --enforce-node-allocatable="" --network-plugin=cni --cni-bin-dir=c:\k\cni --cni-conf-dir=c:\k\cni\config
nssm set kubelet AppDirectory C:\k
nssm start kubelet
```

### Register kube-proxy.exe (l2bridge / host-gw)
```
nssm install kube-proxy C:\k\kube-proxy.exe
nssm set kube-proxy AppDirectory c:\k
nssm set kube-proxy AppParameters --v=4 --proxy-mode=kernelspace --hostname-override=<hostname>--kubeconfig=c:\k\config --enable-dsr=false --log-dir=<log directory> --logtostderr=false
nssm.exe set kube-proxy AppEnvironmentExtra KUBE_NETWORK=cbr0
nssm set kube-proxy DependOnService kubelet
nssm start kube-proxy
```

### Register kube-proxy.exe (overlay / vxlan)
```
PS C:\k> nssm install kube-proxy C:\k\kube-proxy.exe
PS C:\k> nssm set kube-proxy AppDirectory c:\k
PS C:\k> nssm set kube-proxy AppParameters --v=4 --proxy-mode=kernelspace --feature-gates="WinOverlay=true" --hostname-override=<hostname> --kubeconfig=c:\k\config --network-name=vxlan0 --source-vip=<source-vip> --enable-dsr=false --log-dir=<log directory> --logtostderr=false
nssm set kube-proxy DependOnService kubelet
nssm start kube-proxy
```