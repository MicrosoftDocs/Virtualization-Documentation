---
title: Kubernetes on Windows
author: daschott
ms.author: daschott
ms.date: 08/13/2020
ms.topic: overview
description: Getting started with Kubernetes on Windows.
keywords: kubernetes, windows, getting started
ms.assetid: 3b05d2c2-4b9b-42b4-a61b-702df35f5b17
---
# Kubernetes on Windows

> [!TIP]
> Curious to find out which Kubernetes features are supported on Windows today? Please see [officially supported features](https://kubernetes.io/docs/setup/production-environment/windows/intro-windows-in-kubernetes/#supported-functionality-and-limitations) and the [Kubernetes on Windows roadmap](https://github.com/orgs/kubernetes/projects/8) for more details.

This page serves as an overview for getting started with Kubernetes on Windows.


### Try out Kubernetes on Windows

See [deploying Kubernetes on Windows](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/adding-windows-nodes/) for instructions on how to manually install Kubernetes on Windows in the environment of your choice.


### Scheduling Windows containers

See [scheduling Windows containers in Kubernetes](https://kubernetes.io/docs/setup/production-environment/windows/user-guide-windows-containers/) for best practices and recommendations on scheduling Windows containers in Kubernetes.


### Deploying Kubernetes on Windows in Azure

The [Windows containers on Azure Kubernetes Service](/azure/aks/windows-container-cli) guide makes this easy. If you are looking to deploy and manage all the Kubernetes components yourself, see our [step-by-step walkthrough](https://github.com/Azure/aks-engine/blob/master/docs/topics/windows.md) using the open-source `AKS-Engine` tool.

### Troubleshooting
Please see [Troubleshooting Kubernetes](./common-problems.md) for a suggested list of workarounds and solutions to known issues.
>[!TIP]
> For additional self-help resources, there is also a Kubernetes networking troubleshooting guide for Windows [available here](https://techcommunity.microsoft.com/t5/Networking-Blog/Troubleshooting-Kubernetes-Networking-on-Windows-Part-1/ba-p/508648).