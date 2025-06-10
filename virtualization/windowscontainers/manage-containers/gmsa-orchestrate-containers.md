---
title: Orchestrate containers with a gMSA
description: How to orchestrate Windows containers with a group Managed Service Account (gMSA).
author: meaghanlewis
ms.author: mosagie
ms.date: 01/23/2025
ms.topic: how-to
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---

# Orchestrate containers with a gMSA

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019

In production environments, you'll often use a container orchestrator such as the hosted Kubernetes service, Azure Kubernetes Service (AKS), to deploy and manage your apps and cluster services. Each orchestrator has its own management paradigms and is responsible for accepting credential specs to give to the Windows container platform.

When you're orchestrating containers with Group Managed Service Accounts (gMSAs), make sure that:

> [!div class="checklist"]
> * All container hosts that can be scheduled to run containers with gMSAs are domain joined
> * The container hosts have access to retrieve the passwords for all gMSAs used by containers
> * The credential spec files are created and uploaded to the orchestrator or copied to every container host, depending on how the orchestrator prefers to handle them.
> * Container networks allow the containers to communicate with the Active Directory Domain Controllers to retrieve gMSA tickets

## Use gMSA with Kubernetes

You can use gMSA with AKS and also with AKS on Azure Stack HCI, which is the on-premises implementation of the AKS orchestrator. For more information about how to use gMSA with Kubernetes, see [Use gMSA on Azure Kubernetes Service in Windows Containers](./gmsa-aks-ps-module.md) and [Configure group Managed Service Account with AKS on Azure Stack HCI](/azure-stack/aks-hci/prepare-windows-nodes-gmsa).

To read about the latest industry information about this feature, see [Configure gMSA for Windows pods and containers](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa).

## Use gMSA with Service Fabric

Service Fabric supports running Windows containers with a gMSA when you specify the credential spec location in your application manifest. You'll need to create the credential spec file and place in the **CredentialSpecs** subdirectory of the Docker data directory on each host so that Service Fabric can locate it. You can run the **Get-CredentialSpec** cmdlet, part of the [CredentialSpec PowerShell module](https://aka.ms/credspec), to verify if your credential spec is in the correct location.

See [Quickstart: Deploy Windows containers to Service Fabric](/azure/service-fabric/service-fabric-quickstart-containers) and [Set up gMSA for Windows containers running on Service Fabric](/azure/service-fabric/service-fabric-setup-gmsa-for-windows-containers) for more information about how to configure your application.

## How to use gMSA with Docker Swarm

To use a gMSA with containers managed by Docker Swarm, run the [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/) command with the `--credential-spec` parameter:

```powershell
docker service create --credential-spec "file://contoso_webapp01.json" --hostname "WebApp01" <image name>
```

See the [Docker Swarm example](https://docs.docker.com/engine/reference/commandline/service_create/#provide-credential-specs-for-managed-service-accounts-windows-only) for more information about how to use credential specs with Docker services.

## Related content

In addition to orchestrating containers, you can also use gMSAs to:

- [Configure apps](gmsa-configure-app.md)
- [Run containers](gmsa-run-container.md)

If you run into any issues during setup, check our [troubleshooting guide](gmsa-troubleshooting.md) for possible solutions.
