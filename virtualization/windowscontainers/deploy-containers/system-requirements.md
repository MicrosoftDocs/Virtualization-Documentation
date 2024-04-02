---
title: Windows container requirements
description: Learn about Windows container requirements.
author: vrapolinario
ms.author: viniap
ms.date: 03/31/2023
ms.topic: conceptual
ms.assetid: 3c3d4c69-503d-40e8-973b-ecc4e1f523ed
---
# Windows container requirements

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016; Azure Stack HCI, versions 21H2 and 20H2

This guide lists the requirements for a Windows container host.

## Operating system requirements

- The Windows container feature is available on Windows Server 2022, Windows Server 2019, Windows Server 2016, Windows 10 Professional and Enterprise Editions (version 1607 and later), and Windows 11 Pro and Enterprise.
- The Hyper-V role must be installed before running Hyper-V isolation.
- Windows Server Container hosts must have Windows installed to c:\. This restriction does not apply if only Hyper-V isolated containers will be deployed.

## Virtualized container hosts

If you're running a Windows container host from a Hyper-V virtual machine, and also hosting Hyper-V isolation, you need to enable nested virtualization. Nested virtualization has the following requirements:

- At least 4 GB RAM available for the virtualized Hyper-V host.
- Windows Server 2022, Windows Server 2019, Windows Server 2016, Windows 10, or Windows 11 on the host system; and Windows Server (Desktop Experience or Server Core) on the virtual machine.
- A processor with Intel VT-x (this feature is currently available for Intel and AMD processors).
- The container host VM also needs at least two virtual processors.

### Memory requirements

You can configure restrictions on available memory for containers through [resource controls](../manage-containers/resource-controls.md) or by overloading a container host. The minimum amount of memory required to launch a container and run basic commands (`ipconfig`, `dir`, and so on) are listed below.

> [!NOTE]
> These values don't take into account resource sharing between containers or requirements from the application running in the container. For example, a host with 512 MB of free memory can run multiple Server Core containers under Hyper-V isolation because those containers share resources.

#### Windows Server 2016

| Base image  | Windows Server container | Hyper-V isolation    |
| ----------- | ------------------------ | -------------------- |
| Nano Server | 40 MB                     | 130 MB + 1 GB Pagefile |
| Server Core | 50 MB                     | 325 MB + 1 GB Pagefile |

## See also

[Support policy for Windows containers and Docker in on-premises scenarios](https://support.microsoft.com/help/4489234/support-policy-for-windows-containers-and-docker-on-premises)
