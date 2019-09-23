---
title: Windows Container Requirements
description: Windows Container Requirements.
keywords: metadata, containers
author: taylorb-microsoft
ms.date: 09/26/2016
ms.topic: deployment-article
ms.prod: windows-containers
ms.assetid: 3c3d4c69-503d-40e8-973b-ecc4e1f523ed
---
# Windows container requirements

This guide lists the requirements for a Windows container Host.

## OS requirements

- The Windows container feature is only available on Windows Server 2016 (Core and with Desktop Experience), Windows 10 Professional and Enterprise (Anniversary Edition) and later.
- The Hyper-V role must be installed before running Hyper-V isolation
- Windows Server Container hosts must have Windows installed to c:\. This restriction does not apply if only Hyper-V isolated containers will be deployed.

## Virtualized container hosts

If a Windows container host will be run from a Hyper-V virtual machine, and will also be hosting Hyper-V isolation, nested virtualization will need to be enabled. Nested virtualization has the following requirements:

- At least 4 GB RAM available for the virtualized Hyper-V host.
- Windows Server 2019, Windows Server version 1803, Windows Server version 1709, Windows Server 2016, or Windows 10 on the host system, and Windows Server (Full, Core) in the virtual machine.
- A processor with Intel VT-x (this feature is currently only available for Intel processors).
- The container host VM will also need at least two virtual processors.

### Memory requirements

Restrictions on available memory to containers can be configured though [resource controls](https://docs.microsoft.com/virtualization/windowscontainers/manage-containers/resource-controls) or by overloading a container host.  The minimum amount of memory required to launch a container and run basic commands (ipconfig, dir, and so on) are listed below.

>[!NOTE]
>These values don't take into account resource sharing between containers or requirements from the application running in the container.  For example a host with 512MB of free memory can run multiple Server Core containers under Hyper-V isolation because those containers share resources.

#### Windows Server 2016

| Base image  | Windows Server container | Hyper-V isolation    |
| ----------- | ------------------------ | -------------------- |
| Nano Server | 40 MB                     | 130 MB + 1 GB Pagefile |
| Server Core | 50 MB                     | 325 MB + 1 GB Pagefile |

#### Windows Server version 1709

| Base image  | Windows Server container | Hyper-V isolation    |
| ----------- | ------------------------ | -------------------- |
| Nano Server | 30 MB                     | 110 MB + 1 GB Pagefile |
| Server Core | 45 MB                     | 360 MB + 1 GB Pagefile |
