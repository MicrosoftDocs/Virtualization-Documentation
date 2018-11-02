---
title: Network Topologies
author: daschott
ms.author: daschott
ms.date: 08/24/2018
ms.topic: get-started-article
ms.prod: containers

description: Supported network topologies on Windows and Linux.
keywords: kubernetes, 1.12, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---
# Network Solutions #

Once you have [setup a Kubernetes master node](./creating-a-linux-master.md) you are ready to pick a networking solution. There are multiple ways to make the virtual [cluster subnet](./getting-started-kubernetes-windows.md#cluster-subnet-def) routable across nodes. Pick one of the following options for Kubernetes on Windows today:
  1. Use a third-party CNI plugin such as [Flannel](#flannel-in-host-gateway-mode) to setup routes for you.
  2. Configure a smart [top-of-rack (ToR) switch](#configuring-a-tor-switch) to route the subnet.

> [!tip]  
> There is a third networking solution on Windows which leverages Open vSwitch (OvS) and Open Virtual Network (OVN). Documenting this is out of scope for this document, but you can read [these instructions](https://kubernetes.io/docs/getting-started-guides/windows/#for-3-open-vswitch-ovs-open-virtual-network-ovn-with-overlay) to set it up.

## Flannel in host-gateway mode ##
One of the available options for Flannel networking is *host-gateway mode* (host-gw), which entails the configuration of static routes between pod subnets on all nodes.
> [!NOTE]  
> This is different to *overlay* networking mode in Flannel, which uses VXLAN encapsulation and is in development right now. Watch this space...

### Prepare Kubernetes master for Flannel ### 
Some minor preparation is recommended on the [Kubernetes master](./creating-a-linux-master.md) in our cluster. It is recommended to enable bridged IPv4 traffic to iptables chains when using Flannel. This can be done using the following command:

```bash
sudo sysctl net.bridge.bridge-nf-call-iptables=1
```

###  Download & configure Flannel ###
Download the most recent Flannel manifest:

```bash
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

There are two things you need to do to enable host-gw networking across both Windows/Linux.

In the `net-conf.json` section of your kube-flannel.yml, double-check that:
1. The type of network backend being used is set to `host-gw` instead of `vxlan`.
2. The cluster subnet (e.g. "10.244.0.0/16") is set as desired.

After applying the 2 steps, your `net-conf.json` should look as follows:
```json
net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "host-gw"
      }
    }
```

### Launch Flannel & validate ###
Launch Flannel using:

```bash
kubectl apply -f kube-flannel.yml
```

Next, since the Flannel pods are Linux-based, apply our Linux [NodeSelector](https://github.com/Microsoft/SDN/tree/master/Kubernetes/flannel/l2bridge/manifests/node-selector-patch.yml) patch to `kube-flannel-ds` DaemonSet to only target Linux (we will launch the Flannel "flanneld" host-agent process on Windows later when joining):

```
kubectl patch ds/kube-flannel-ds --patch "$(cat node-selector-patch.yml)" -n=kube-system
```

After a few minutes, you should see all the pods as running if the Flannel pod network was deployed.

```bash
kubectl get pods --all-namespaces
```

![text](media/kube-master.png)

The Flannel DaemonSet should also have the NodeSelector applied.

```bash
kubectl get ds -n kube-system
```

![text](media/kube-daemonset.png)
> [!tip]  
> Confused? Here is a complete [example kube-flannel.yml](https://github.com/Microsoft/SDN/blob/master/Kubernetes/flannel/l2bridge/manifests/kube-flannel-example.yml) For Flannel v0.9.1 with these 2 steps pre-applied for default cluster subnet `10.244.0.0/16`.

## Configuring a ToR switch ##
> [!NOTE]
> You can skip this section if you chose [Flannel as your networking solution](#flannel-in-host-gateway-mode).
Configuration of the ToR switch occurs outside of your actual nodes. For more details on this, please see [official Kubernetes docs](https://kubernetes.io/docs/getting-started-guides/windows/#upstream-l3-routing-topology).


## Next steps ## 
In this section, we covered how to pick a networking solution. Now you are ready for step 4:

> [!div class="nextstepaction"]
> [Joining Windows workers](./joining-windows-workers.md)