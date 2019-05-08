---
title: Joining Linux nodes
author: daschott
ms.author: daschott
ms.date: 11/02/2018
ms.topic: get-started-article
ms.prod: containers

description: Deploying Kubernetes resoureces on a mixed-OS Kubernetes cluster.
keywords: kubernetes, 1.13, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---
# Deploying Kubernetes Resources #
Assuming you have a Kubernetes cluster consisting of at least 1 master and 1 worker, you are ready to deploy Kubernetes resources.
> [!TIP] 
> Curious what Kubernetes resources are supported today on Windows? Please see [officially supported features](https://kubernetes.io/docs/getting-started-guides/windows/#supported-features) and [Kubernetes on Windows roadmap](https://trello.com/b/rjTqrwjl/windows-k8s-roadmap) for more details.


## Running a sample service ##
You'll be deploying a very simple [PowerShell-based web service](https://github.com/Microsoft/SDN/blob/master/Kubernetes/WebServer.yaml) to ensure you joined the cluster successfully and our network is properly configured.

Before doing so, it is always a good idea to make sure all our nodes are healthy.
```bash
kubectl get nodes
```

If everything looks good, you can download and run the following service:
> [!Important] 
> Before `kubectl apply`, make sure to double-check/modify the `microsoft/windowsservercore` image in the sample file to [a container image that is runnable by your nodes](https://docs.microsoft.com/virtualization/windowscontainers/deploy-containers/version-compatibility#choosing-container-os-versions)!

```bash
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/flannel/l2bridge/manifests/simpleweb.yml -O win-webserver.yaml
kubectl apply -f win-webserver.yaml
watch kubectl get pods -o wide
```

This creates a deployment and a service. The last watch command queries the pods indefinitely to track their status; simply press `Ctrl+C` to exit the `watch` command when done observing.

If all went well, it is possible to:

  - see 2 containers per pod under `docker ps` command on the Windows node
  - see 2 pods under a `kubectl get pods` command from the Linux master
  - `curl` on the *pod* IPs on port 80 from the Linux master gets a web server response; this demonstrates proper node to pod communication across the network.
  - ping *between pods* (including across hosts, if you have more than one Windows node) via `docker exec`; this demonstrates proper pod-to-pod communication
  - `curl` the virtual *service IP* (seen under `kubectl get services`) from the Linux master and from individual pods; this demonstrates proper service to pod communication.
  - `curl` the *service name* with the Kubernetes [default DNS suffix](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services), demonstrating proper service discovery.
  - `curl` the *NodePort* from the Linux master or machines outside of the cluster; this demonstrates inbound connectivity.
  - `curl` external IPs from inside the pod; this demonstrates outbound connectivity.

> [!Note]  
> Windows *container hosts* will **not** be able to access the service IP from services scheduled on them. This is a [known platform limitation](./common-problems.md#my-windows-node-cannot-access-my-services-using-the-service-ip) that will be improved in future versions to Windows Server. Windows *pods* **are** able to access the service IP however.

### Port mapping ### 
It is also possible to access services hosted in pods through their respective nodes by mapping a port on the node. There is [another sample YAML available](https://github.com/Microsoft/SDN/blob/master/Kubernetes/PortMapping.yaml) with a mapping of port 4444 on the node to port 80 on the pod to demonstrate this feature. To deploy it, follow the same steps as before:

```bash
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/PortMapping.yaml -O win-webserver-port-mapped.yaml
kubectl apply -f win-webserver-port-mapped.yaml
watch kubectl get pods -o wide
```

It should now be possible to `curl` on the *node* IP on port 4444 and receive a web server response. Keep in mind that this limits scaling to a single pod per node since it must enforce a one-to-one mapping.


## Next steps ##
In this section, we covered how to schedule Kubernetes resources on Windows nodes. This concludes the guide. If there were any problems, please review the troubleshooting section:

> [!div class="nextstepaction"]
> [Troubleshooting](./common-problems.md)

Otherwise, you may also be interested in running Kubernetes components as Windows services:
> [!div class="nextstepaction"]
> [Windows Services](./kube-windows-services.md)