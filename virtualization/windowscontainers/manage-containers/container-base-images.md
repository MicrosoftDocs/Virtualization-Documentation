---
title: Windows Container Base Image History
description: A list of Windows container images released with SHA256 layer hashes
keywords: docker, containers, hashes
author: patricklang
ms.date: 01/12/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 88e6e080-cf8f-41d8-a301-035959dc5ce0
---

# Container Base Images

## Supported base images

Windows containers are offered with four container base images: Windows Server Core, Nano Server, Windows, and IoT Core. Not all configurations support both OS images. This table details the supported configurations.

|Host operating system|Windows container|Hyper-V isolation|
|---------------------|-----------------|-----------------|
|Windows Server 2016 or Windows Server 2019 (Standard or Datacenter)|Server Core, Nano Server, Windows|Server Core, Nano Server, Windows|
|Nano Server|Nano Server|Server Core, Nano Server, Windows|
|Windows 10 Pro or Windows 10 Enterprise|Not available|Server Core, Nano Server, Windows|
|IoT Core|IoT Core|Not available|

> [!WARNING]  
> Starting with Windows Server version 1709, Nano Server is no longer available as a container host.

## Base image differences

How does one choose the right base image to build upon? While you are free to build with whatever you wish, these are the general guidelines for each image:

- [Windows Server Core](https://hub.docker.com/_/microsoft-windows-servercore): If your application needs the full .NET framework, this is the best image to use.
- [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver): For applications that only require .NET Core, Nano Server will provide a much slimmer image.
- [Windows](https://hub.docker.com/_/microsoft-windowsfamily-windows): You may find your application depends on a component or .dll that is missing in Server Core or Nano Server images, such as GDI libraries. This image carries the full dependency set of Windows.
- [IoT Core](https://hub.docker.com/_/microsoft-windows-iotcore): This image is purpose-built for [IoT applications](https://developer.microsoft.com/windows/iot). You should use this container image when targeting an IoT Core host.

For most users, Windows Server Core or Nano Server will be the most appropriate image to use. The following are things to keep in mind as you think about building on top of Nano Server:

- The servicing stack was removed
- .NET Core is not included (though you can use the [.NET Core Nano Server image](https://hub.docker.com/r/microsoft/dotnet/))
- PowerShell was removed
- WMI was removed
- Starting with Windows Server version 1709 applications run under a user context, so commands that require administrator privileges will fail. You can specify the container administrator account via the --user flag (such as docker run --user ContainerAdministrator) however in the future we intend to fully remove administrator accounts from NanoServer.

These are the biggest differences and not an exhaustive list. There are other components not called out which are absent as well. Keep in mind that you can always add layers on top of Nano Server as you see fit. For an example of this check out the [.NET Core Nano Server Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/2.1/sdk/nanoserver-1803/amd64/Dockerfile).
