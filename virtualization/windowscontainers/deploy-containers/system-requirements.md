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

This guides list the requirements for a Windows container Host.

## OS Requirements

- The Windows container feature is only available on Windows Server 2016 (Core and with Desktop Experience), Windows 10 Professional and Enterprise (Anniversary Edition) and later.
- The Hyper-V role must be installed before running Hyper-V Containers
- Windows Server Container hosts must have Windows installed to c:\. This restriction does not apply if only Hyper-V Containers will be deployed.

## Virtualized Container Hosts

If a Windows container host will be run from a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, nested virtualization will need to be enabled. Nested virtualization has the following requirements:

- At least 4 GB RAM available for the virtualized Hyper-V host.
- Windows Server 2019, Windows Server version 1803, Windows Server version 1709, Windows Server 2016, or Windows 10 on the host system, and Windows Server (Full, Core) in the virtual machine.
- A processor with Intel VT-x (this feature is currently only available for Intel processors).
- The container host VM will also need at least 2 virtual processors.

## Supported Base Images

Windows Containers are offered with two container base images, Windows Server Core and Nano Server. Not all configurations support both OS images. This table details the supported configurations.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:75%" cellpadding="5" cellspacing="5">
<thead>
<tr valign="top">
<th><center>Host Operating System</center></th>
<th><center>Windows Server Container</center></th>
<th><center>Hyper-V Container</center></th>
</tr>
</thead>
<tbody>
<tr valign="top">
<td><center>Windows Server 2016 / 2019 (Standard or Datacenter)</center></td>
<td><center>Server Core / Nano Server</center></td>
<td><center>Server Core / Nano Server</center></td>
</tr>
<tr valign="top">
<td><center>Nano Server<a href="#warn-1">*</a></center></td>
<td><center> Nano Server</center></td>
<td><center>Server Core / Nano Server</center></td>
</tr>
<tr valign="top">
<td><center>Windows 10 Pro / Enterprise</center></td>
<td><center>Not Available</center></td>
<td><center>Server Core / Nano Server</center></td>
</tr>
</tbody>
</table>

> [!Warning]  
> <span id="warn-1">Starting with Windows Server version 1709 Nano Server is no longer available as a container host.</span>


### Memory requirements
Restrictions on available memory to containers can be configured though [resource controls](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/resource-controls) or by overloading a container host.  The minimum amount of memory required to launch a container and run basic commands (ipconfig, dir, etc...) are listed below.  __Please note that these values do not take into account resource sharing between containers or requirements from the application running in the container.  For example a host with 512MB of free memory can run multiple Server Core containers under Hyper-V isolation because those containers share resources.__

#### Windows Server 2016
| Base Image  | Windows Server Container | Hyper-V Isolation    |
| ----------- | ------------------------ | -------------------- |
| Nano Server | 40MB                     | 130MB + 1GB Pagefile |
| Server Core | 50MB                     | 325MB + 1GB Pagefile |

#### Windows Server version 1709
| Base Image  | Windows Server Container | Hyper-V Isolation    |
| ----------- | ------------------------ | -------------------- |
| Nano Server | 30MB                     | 110MB + 1GB Pagefile |
| Server Core | 45MB                     | 360MB + 1GB Pagefile |


### Nano Server vs. Windows Server Core

How does one choose between Windows Server Core and Nano Server? While you are free to build with whatever you wish, if you find that your application needs full compatibility with the .NET Framework, then you should use [Windows Server Core](https://hub.docker.com/r/microsoft/windowsservercore/). On the other side of the coin, if your application is built for the cloud and uses .NET Core, then you should use [Nano Server](https://hub.docker.com/r/microsoft/nanoserver/). This is because Nano Server was built with the intention of having as small a footprint as possible therefore several nonessential libraries were removed. This is good to keep in mind as you think about building on top of Nano Server:

- The servicing stack was removed
- .NET Core is not included (though you can use the [.NET Core Nano Server image](https://hub.docker.com/r/microsoft/dotnet/))
- PowerShell was removed
- WMI was removed
- Starting with Windows Server version 1709 applications run under a user context, so commands that require administrator privileges will fail. You can specify the container administrator account via the --user flag (i.e. docker run --user ContainerAdministrator) however in the future we intend to fully remove administrator accounts from NanoServer.

These are the biggest differences and not an exhaustive list. There are other components not called out which are absent as well. Keep in mind that you can always add layers on top of Nano Server as you see fit. For an example of this check out the [.NET Core Nano Server Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/2.1/sdk/nanoserver-1803/amd64/Dockerfile).

