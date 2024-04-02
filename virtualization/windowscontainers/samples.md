---
title: Windows containers solutions
description: Learn about popular projects and code samples using Windows containers.
author: sijuman
ms.date: 04/12/2023
ms.topic: overview
ms.author: sijuman
ms.assetid: 5c6f6350-f8d6-4426-b53d-9fb09c2bf267
---

# Windows Container solutions

Microsoft provides solutions for Windows containers using the latest Windows Server 2022 base images to help our consumers get started. This is a collection of samples around application frameworks, programming languages, databases, and infrastructure/continuous integration (CI) tools. These samples are provided as-is and with no warranties or guarantees made. Please feel free to contribute to additional samples or submit a PR to help improve the current repository.

## What are Windows containers?

Containers are a technology for packaging and running Windows and Linux applications across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for apps that need to rapidly adapt to changing demand.

All containers are created from container images. A container image is a bundle of files organized into a stack of layers that resides on your local machine or in a remote container registry. The container images used in the samples described in this topic are images based on Windows Server, Windows Server Core, and Nano server:

- Windows Server contains the full set of Windows APIs and system services.
- Windows Server Core is a smaller image that contains a subset of the Windows Server APIs, namely the full .NET framework. It also includes most, but not all, server roles (for example, Fax Server is not included).
- Nano Server is the smallest Windows Server image and includes support for the .NET Core APIs and some server roles.

The Windows base images used for the container samples are Windows Server 2022, which was released in August 2021. The samples help you get started using Windows containers, for example, one of the samples helps you install Python bits inside of a Windows container.

## Container solutions

Use the category tabs below to learn how to leverage Windows containers using the latest Windows Server base images in your app development. The provided samples fit into six categories and are updated to reflect recent version changes, as well as [Windows Server 2022 images](https://hub.docker.com/_/microsoft-windows-base-os-images).

> [!NOTE]
> You can also [use step-by-step deployment guides](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/main/windows-container-samples) to help you deploy an example solution. Each guide may also refer to a companion code sample.

<!-- start tab view -->
# [Application frameworks](#tab/Application-frameworks)

[aspnet](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/aspnet)

[iis](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis)

[iis-arr](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-arr)

[iis-https](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-https)

[iis-php](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-php)

[Django](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/Django)

[apache-http](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/apache-http)

[apache-http-php](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/apache-http-php)

[nginx](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/nginx)

# [Programming languages](#tab/Programming-languages)

[dotnet35](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/dotnet35)

[golang](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/golang)

[nodejs](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/nodejs)

[python](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/python)

[python-django](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/python-django)

[rails](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/rails)

[ruby](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/ruby)

[server-jre-8u51-windows-x64](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/server-jre-8u51-windows-x64)

# [Databases](#tab/Databases)

[mongodb](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/mongodb)

[mysql](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/mysql)

[redis](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/redis)

[sqlite](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/sqlite)

[sqlserver-express](https://github.com/microsoft/mssql-docker/tree/master/windows)

# [Infrastructure and CI tools](#tab/Infrastructure-and-CI-tools)

[PowerShellDSC_iis-10.0](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/PowerShellDSC_iis-10.0)

# [Just for fun](#tab/Just-for-run)

[MineCraft](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/MineCraft)

# [Other](#tab/Other)

[DirectX](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-container-samples/directx) (including GPU acceleration)

<!-- stop tab view -->







