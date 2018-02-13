---
title: Troubleshooting Kubernetes
author: gkudra-msft
ms.author: gekudray
ms.date: 11/16/2017
ms.topic: troubleshooting
ms.prod: containers

description: Solutions for common issues when deploying Kubernetes and joining Windows nodes.
keywords: kubernetes, 1.9, linux, compile
---

# Troubleshooting Kubernetes #
This page walks through several common issues with Kubernetes setup, networking, and deployments.

> [!tip]
> Suggest an FAQ item by raising a PR to [our documentation repository](https://github.com/MicrosoftDocs/Virtualization-Documentation/).


## Common Deployment Errors ##
Debugging the Kubernetes master falls into three main categories (in order of likelihood):

  - Something is wrong with the Kubernetes system containers.
  - Something is wrong with the way `kubelet` is running.
  - Something is wrong with the system.


Run `kubectl get pods -n kube-system` to see the pods being created by Kubernetes; this may give some insight into which particular ones are crashing or not starting correctly. Then, run `docker ps -a` to see all of the raw containers that back these pods. Finally, run `docker logs [ID]` on the container(s) that are suspected to be causing the problem to see the raw output of the processes.


### _"Permission Denied"_ Errors ###
Ensure that scripts have executable permissions:

```bash
chmod +x [script name]
```

Additionally, certain scripts must be run with super-user privileges (like `kubelet`), and should be prefixed with `sudo`.


### Cannot connect to the API server at `https://[address]:[port]` ###
More often than not, this error indicates certificate problems. Ensure that you have generated the configuration file correctly, that the IP addresses in it match that of your host, and that you have copied it to the directory that is mounted by the API server.

If following [our instructions](./creating-a-linux-master), this will be in `~/kube/kubelet/`; otherwise, refer to the API server's manifest file to check the mount points.


## Common Networking Errors ##
There may be additional restrictions in place on your network or on hosts preventing certain types of communication between nodes. Ensure that:

  - you have properly configured your network topology
  - traffic that looks like it's coming from pods is allowed
  - HTTP traffic is allowed, if you are deploying web services
  - ICMP packets are not being dropped


<!-- ### My Linux node cannot ping my Windows pods ### -->

## Common Windows Errors ##

### Pods stop resolving DNS queries successfully after some time alive ###
This is a known issue in the networking stack that affects some setups; it is being fast-tracked through Windows servicing.


### My Kubernetes pods are stuck at "ContainerCreating" ###
This issue can have many causes, but one of the most common is that the pause image was misconfigured. This is a high-level symptom of the next issue.


### When deploying, Docker containers keep restarting ###
Check that your pause image is compatible with your OS version. The [instructions](./getting-started-kubernetes-windows.md) assume that both the OS and the containers are version 1709. If you have a later version of Windows, such as an Insider build, you will need to adjust the images accordingly. Please refer to the Microsoft's [Docker repository](https://hub.docker.com/u/microsoft/) for images. Regardless, both the pause image Dockerfile and the sample service will expect the image to be tagged as `microsoft/windowsservercore:latest`.


### My Windows pods cannot access the Linux master, or vice-versa ###
If you are using a Hyper-V virtual machine, ensure that MAC spoofing is enabled on the network adapter(s).


### My Windows node cannot access my services using the service IP ###
This is a known limitation of the current networking stack on Windows. Only pods can refer to the service IP.


### No network adapter is found when starting Kubelet ###
The Windows networking stack needs a virtual adapter for Kubernetes networking to work. If the following commands return no results (in an admin shell), virtual network creation &mdash; a necessary prerequisite for Kubelet to work &mdash; has failed:

```powershell
Get-HnsNetwork | ? Name -ieq "l2bridge"
Get-NetAdapter | ? Name -Like "vEthernet (Ethernet*"
```

Consult the output of the `start-kubelet.ps1` script to see if there are errors during virtual network creation.

