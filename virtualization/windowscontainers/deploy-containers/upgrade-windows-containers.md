---
title: Upgrade a Windows container to a new build version
description: Learn about concepts for upgrading a Windows container to a newer build version.
author: v-susbo
ms.author: mabrigg
ms.topic: how-to
ms.date: 09/01/2021
---

# Upgrade containers to a new version of the Windows operating system

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

This topic describes how to upgrade Windows containers to a new Windows or Windows Server operating system version. There are two steps for upgrading containers:

1. Upgrade the container host to the new operating system version.
1. Create new container instances using the new operating system version.

> [!NOTE]
> If you just need to _update_ (or patch) your current Windows base OS container image, see [update your containers](../deploy-containers/update-containers.md) to pull the latest patch image for your containers.

## Upgrade the container host

To upgrade the container host to a newer Windows or Windows Server version, you can either perform an in-place upgrade or a clean installation. Since the container host and the Windows containers share a single kernel, you should make sure the container's base image OS version [matches that of the host](./version-compatibility.md#matching-container-host-version-with-container-image-versions). However, you can still have a newer version of the container host with an older base image with [Hyper-V isolation](../manage-containers/hyperv-container.md#hyper-v-isolation). In Windows Server 2022, you can implement this scenario with process isolation (in preview).

## Create new container instances using the new OS version

To create the new container instances, you need to:

- Pull the container base image
- Edit the Dockerfile to point to the new base image
- Build and run the new app image
- Tag and push the image to your registry

### Pull the container base image

After you have pulled the new Windows OS version on the container host, follow the steps below to upgrade the base image:

1. Select the [container base image](../manage-containers/container-base-images.md) you want to upgrade to.

2. Open a PowerShell session as an administrator and, depending on the OS version you chose, run the [docker pull](https://docs.docker.com/engine/reference/commandline/pull/) command to pull an image:

   ```powershell
   PS C:\> docker pull mcr.microsoft.com/windows/servercore:ltsc2022
   ```

   This example pulls the Server Core version 20H2 base image.

3. When the image is finished downloading, you can verify that the new image has been pulled by running the [docker images](https://docs.docker.com/engine/reference/commandline/images/) command to return a list of pulled images:

   ```powershell
   docker images
   ```

### Edit the Dockerfile to point to the new base image

Next, you want to create and start new container instances using the new base image you pulled. To automate this process, edit the Dockerfile to redirect it to the new image.

> [!NOTE]
> If you want to upgrade the image for any container that's currently running, you'll need to stop the containers using [docker stop](https://docs.docker.com/engine/reference/commandline/stop/) and then run [docker rm](https://docs.docker.com/engine/reference/commandline/rm/) to remove the containers.

Open the Dockerfile in a text editor and make the updates. In the following example, the Dockerfile is updated to Server Core 20H2 with the IIS application.

```dockerfile
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 AS build-env
WORKDIR /app

COPY *.csproj ./
RUN PowerShell Install-WindowsFeature NET-Framework-45-ASPNET

FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["ServiceMonitor.exe", "w3svc"]
```

### Build and run the new app image

Once the Dockerfile is updated, you need to build and run the app image.

1. Use [docker build](https://docs.docker.com/engine/reference/commandline/build/) to build your image as shown below:

   ```powershell
   docker build -t iss .
   ```

2. To run the newly built container, run the [docker run](https://docs.docker.com/engine/reference/commandline/run/) command:

   ```powershell
   docker run -d -p 8080:80 --name iss-app iss
   ```

### Tag and push the image to your registry

To allow other hosts to reuse the new image, you should tag and then push the container image to your registry.

1. Use [docker tag](https://docs.docker.com/engine/reference/commandline/tag/) to tag the image as follows:

   ```powershell
   docker tag mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 <login-server>/iss
   ```

2. Use [docker push](https://docs.docker.com/engine/reference/commandline/push/) to push the image to the container registry as follows:

   ```powershell
   docker push <login-server> iss
   ```

## Upgrade containers using an orchestrator

You can also redeploy your Windows containers using an orchestrator, such as Azure Kubernetes Service and AKS on Azure Stack HCI. The orchestrator provides powerful automation for doing this at scale. For details, see [Tutorial: Update an application in Azure Kubernetes Service](/azure/aks/tutorial-kubernetes-app-update?tabs=azure-cli) or [Tutorial: Update an application in Azure Kubernetes Service on Azure Stack HCI](/azure-stack/aks-hci/tutorial-kubernetes-app-update).
