---
title: Lift and shift to containers
description: Learn how to migrate existing applications to containers
keywords: containers, migrate
author: IngridAtMicrosoft
ms.author: inhenkel
ms.date: 09/01/2021
ms.topic: quickstart
---  

# Lift and shift to containers

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

This topic provides guidance for modernizing traditional and legacy apps by lifting and shifting them to containers. You'll learn how to identify the types of apps that are appropriate for containers and then learn how to lift and shift them with minimal change to your code. Some traditional Windows Server applications that are currently running on physical machines or VMs can be easily moved to containers.

To view a roadmap of planned and currently available features, see the [Windows Server containers roadmap](https://github.com/microsoft/Windows-Containers/projects/1).

## Benefits of using containers

Since containers are a way to isolate an application into its own package where it's not affected by apps or processes that exist outside of the container, it's easy to see how this lowers costs and provides portability and control.
Using containers to build apps offers a significant increase in agility for building and running any application, across any infrastructure. With containers, you can take any app from development to production with little or no code change, thanks to Docker integration across Microsoft developer tools, operating systems. To see a complete list of benefits for using containers, see [Deploy existing .NET apps as Windows containers](/dotnet/architecture/modernize-with-azure-containers/modernize-existing-apps-to-cloud-optimized/deploy-existing-net-apps-as-windows-containers).

## Supported applications for containers

Review the following table before choosing the app you want to containerize:

| Application | Considerations |
|-------------|----------------|
| Web apps | Web-based apps are good candidates to containerize. For legacy apps built with ASP.NET, the best image to use is the ASP.NET image provisioned for .NET 3.5, which can also run ASP.NET 2.0 and 1.X apps. |
| Windows Communication Foundation (WCF) services | These service-oriented apps built with WCF are often hosted on IIS but can be hosted inside other apps and services, such as another web app or Windows service. |
| Windows services | These apps run as background services in Windows and can be containerized. However, since the services run in the background, you need to create a foreground process to keep the container running. |
|  Console applications | These are apps that are run from the command line and are good candidates for containers. |

You should also review a list of [apps not supported for containers](#applications-not-supported-by-containers).

## Lift and shift Windows applications

### Plan how to lift and shift legacy applications

Use the following steps to plan how you will move traditional and legacy apps to containers.

1. Determine the Windows operating system base image you need: either [Windows Server Core](https://hub.docker.com/_/microsoft-windows-servercore) or [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver).
2. Determine the type of container, for example, whether it should be process-isolated or hypervisor-isolated. For more information, see [Isolation Modes](../manage-containers/hyperv-container.md). Currently, AKS and Azure Kubernetes Service on Azure Stack HCI support only process-isolated containers, and Windows Server 2019 Datacenter and Windows Server 2022 Datacenter are the only container host operating systems supported. In a future release, both AKS and Azure Kubernetes Service on Azure Stack HCI will support hypervisor-isolated containers.
3. Configure security for your container(s). To configure a Windows container to run with a group Managed Service Account (gMSA), see [Create gMSAs for Windows containers](../manage-containers/manage-serviceaccounts.md).
4. Containerize the app. Before you can do this, you need to [install the **Containers** extension](../wac-tooling/wac-extension.md) in Windows Admin Center. Then, you can use Windows Admin Center to [create new Container images](../wac-tooling/wac-images.md) and [run](../wac-tooling/wac-containers.md) them.
5. Push the legacy app by [creating the container registry](/azure/container-registry/container-registry-get-started-powershell) and [uploading the image](/azure/container-registry/container-registry-get-started-powershell#push-image-to-registry) to the registry.
6. Deploy to a Windows-supported Kubernetes environment. You can deploy to either [Azure Kubernetes Service](/azure/aks/) or Azure Kubernetes Service on Azure Stack HCI using [Windows Admin Center](/azure-stack/aks-hci/setup) or [PowerShell](/azure-stack/aks-hci/setup-powershell).

To help you decide which applications to lift and shift and develop a plan for how to do this, review the following flowchart:

![Graphic showing a flowchart on how to lift and shift Windows apps.](./media/DecisionTreeflowchartv2.jpg#lightbox)

## Applications not supported by containers

As of August 2021, the following applications are not supported for Windows containers:

- MSMQ is supported for all scenarios except those that require AD DS authentication. To learn more about supported scenarios for using Microsoft Message Queuing (MSMQ) and Windows containers, see the [MSMQ and Windows Containers](https://techcommunity.microsoft.com/t5/containers/msmq-and-windows-containers/ba-p/1981414) Microsoft Tech Community article. To review additional information, see the [Windows Server discussion forum](https://windowsserver.uservoice.com/forums/304624-containers/suggestions/15719031-create-base-container-image-with-msmq-server) and the [Microsoft Developer Network forum](https://social.msdn.microsoft.com/Forums/bce99a7d-aa60-44fa-a348-450855650810/msmqserver-is-it-supported?forum=windowscontainers). 
- Microsoft Distributed Transaction Coordinator (MSDTC) is supported in limited scenarios.
  - When creating the container, be sure to pass the -name parameter to the docker run command. If using gMSA, the container name must match the gMSA name.
  - Containers must be able to resolve each other using NETBIOS name. This can be accomplished by adding the name and IP address of containers to each other's HOSTS file. 
  - The UUID for MSDTC must be unique. You can determine the UUID using the Get-DTC PowerShell cmdlet. If the UUIDs are not unique, you can resolve this by uninstalling and then reinstalling MSDTC on the containers.
  - For more information, see the [GitHub issues](https://github.com/MicrosoftDocs/Virtualization-Documentation/issues/494) page.
- Microsoft Office currently does not support containers.
- Client apps with a visual user interface are not supported.  
- Windows infrastructure roles are not supported. This includes DNS, DHCP, DC, NTP, print services, file server, and identity and access management (IAM).  
  
Use the Windows Containers [GitHub repo](https://github.com/microsoft/Windows-Containers/issues) to review additional information on unsupported scenarios and requests from the community.
