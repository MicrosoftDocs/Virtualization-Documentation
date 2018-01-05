---
title: Windows Container Requirements
description: Windows Container Requirements.
keywords: metadata, containers
author: enderb-ms
ms.date: 09/26/2016
ms.topic: deployment-article
ms.prod: windows-containers
ms.assetid: 3c3d4c69-503d-40e8-973b-ecc4e1f523ed
---

# Windows container requirements

This guides list the requirements for a Windows container Host.

## OS Requirements

- The Windows container feature is only available on Windows Server build 1709, Windows Server 2016 (Core and with Desktop Experience) and Windows 10 Professional and Enterprise (Anniversary Edition).
- The Hyper-V role must be installed before running Hyper-V Containers
- Windows Server Container hosts must have Windows installed to c:\. This restriction does not apply if only Hyper-V Containers will be deployed.

## Virtualized Container Hosts

If a Windows container host will be run from a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, nested virtualization will need to be enabled. Nested virtualization has the following requirements:

- At least 4 GB RAM available for the virtualized Hyper-V host.
- Windows Server build 1709, Windows Server 2016, or Windows 10 on the host system, and Windows Server (Full, Core) in the virtual machine.
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
<td><center>Windows Server 2016 (Standard or Datacenter)</center></td>
<td><center>Server Core / Nano Server</center></td>
<td><center>Server Core / Nano Server</center></td>
</tr>
<tr valign="top">
<td><center>Nano Server*</center></td>
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
* Starting with Windows Server version 1709 Nano Server is no long avilable as a container host.

### Memory requirments
Restrictions on available memory to containers can be configured though [resource controls](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/resource-controls) or by overloading a container host.  The minimum amount of memory required to launch a container and run basic commands (ipconfig, dir, etc...) are listed below.  __Please note that these values do not take into account resource sharing between containers or requirments from the application running in the container.  For example a host with 512MB of free memory can run multiple Server Core containers under Hyper-V isolation because those containers share resources.__

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

These are the biggest differences and not an exhaustive list. There are other components not called out which are absent as well. Keep in mind that you can always add layers on top of Nano Server as you see fit. For an example of this check out the [.NET Core Nano Server Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/2.0/sdk/nanoserver/amd64/Dockerfile).

## Matching Container Host Version with Container Image Versions
### Windows Server Containers
Because Windows Server Containers and the underlying host share a single kernel, the container’s base image must match that of the host.  If the versions are different the container may start, but full functionally cannot be guaranteed. The Windows operating system has 4 levels of versioning, Major, Minor, Build and Revision – for example 10.0.14393.103. The build number (i.e. 14393) only changes when new versions of the OS are published, such as version 1709, 1803, fall creators update etc... The revision number (i.e. 103) is updated as Windows updates are applied.
#### Build Number (new release of Windows)
Windows Server Containers are blocked from starting when the build number between the container host and the container image are different - for example 10.0.14393.* (Windows Server 2016) and 10.0.16299.* (Windows Server version 1709).  
#### Revision Number (patching)
Windows Server Containers are _not_ blocked from starting when the revision number between the container host and the container image are different for example 10.0.14393.1914 (Windows Server 2016 with KB4051033 applied) and 10.0.14393.1944 (Windows Server 2016 with KB4053579 applied).  
For Windows Server 2016 based hosts/images – the container image’s revision must match the host to be in a supported configuration.  Starting with Windows Server version 1709, this is no longer applicable, and the host and container image need not have matching revisions.  It is as always recommended to keep your systems up-to-date with the latest patches and updates.
#### Practical Application
Example 1:  Container host is running Windows Server 2016 with KB4041691 applied.  Any Windows Server container deployed to this host must be based on the 10.0.14393.1770 container base images.  If KB4053579 is applied to the host the container images must be updated at the same time to remain supported.
Example 2:  Container host is running Windows Server version 1709 with KB4043961 applied.  Any Windows Server container deployed to this host must be based on a Windows Server version 1709 (10.0.16299) container base image but need not match the host KB.  If KB4054517 is applied to the host the container images do not need to be updated, though should be in order to fully address any security issues.
#### Querying version
Method 1:
Introduced in version 1709 the cmd prompt and ver command now return the revision details.
```
Microsoft Windows [Version 10.0.16299.125]
(c) 2017 Microsoft Corporation. All rights reserved.

C:\>ver

Microsoft Windows [Version 10.0.16299.125] 
```
Method 2:
Query the following registry key: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion
For example:
```
C:\>reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx
```
Or
```
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\').BuildLabEx
14393.321.amd64fre.rs1_release_inmarket.161004-2338
```

To check what version your base image is using you can review the tags on the Docker hub or the image hash table provided in the image description.  The [Windows 10 Update History](https://support.microsoft.com/en-us/help/12387/windows-10-update-history) page lists when each build and revision was released.

### Hyper-V Isolation for Containers
Windows containers can be run with or without Hyper-V isolation.  Hyper-V isolation creates a secure boundary around the container with an optimized VM.  Unlike standard Windows containers, which share the kernel between containers and the host, each Hyper-V isolated container has its own instance of the Windows kernel.  Because of this you can have different OS versions in the container host and image (see compatibility matrix below).  

To run a container with Hyper-V isolation, simply add the tag "--isolation=hyperv" to your docker run command.

### Compatibility Matrix
Windows Server builds after 2016 GA (10.0.14393.206) can run the Windows Server 2016 GA images of both Windows Server Core or Nano Server in a supported configuration regardless of the revision number.
A Windows Server version 1709 host can also run Windows Server 2016 based containers, however the inverse is not supported.

It is important to understand that in order to have the full functionality, reliability and security assurances provided with Windows updates you should maintain the latest versions on all systems.  
