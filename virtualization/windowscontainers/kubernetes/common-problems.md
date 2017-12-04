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


## Common Deployment Errors ##
Debugging the Kubernetes master falls into three main categories (in order of likelihood):

  - Something is wrong with the Kubernetes system containers.
  - Something is wrong with the way `kubelet` is running.
  - Something is wrong with the system.


Run `kubectl get pods -n kube-system` to see the pods being created by Kubernetes; this may give some insight into which particular ones are crashing or not starting correctly. Then, run `docker ps -a` to see all of the raw containers that back these pods. Finally, run `docker logs [ID]` on the container(s) that are suspected to be causing the problem to see the raw output of the processes.


### _"Permission Denied"_ Errors ###
Ensure that scripts have executable permissions:

    chmod +x [script name]

Additionally, certain scripts must be run with administrator privileges (like `kubelet`), and should be prefixed with `sudo`.


### Cannot connect to the API server at `https://[address]:[port]` ###
More often than not, this error indicates certificate problems. Ensure that you have generated the configuration file correctly, that the IP addresses in it match that of your host, and that you have copied it to the directory that is mounted by the API server.

If following [our instructions](./creating-a-linux-master), this will be in `~/kube/kubelet/`; otherwise, refer to the API server's manifest file to check the mount points.


## Common Networking Errors ##
There may be additional restrictions in place on your network or on hosts preventing certain types of communication between nodes. Ensure that:

  - traffic that looks like it's coming from pods is allowed
  - HTTP traffic is allowed, if you are deploying web services
  - ICMP packets are not being dropped


<!-- ### My Linux node cannot ping my Windows pods ### -->

## Common Windows Errors ##

### My Windows node cannot access my services using the service IP. ###
This is a known limitation of the current networking stack on Windows.
