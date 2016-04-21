---
author: neilpeterson
---

# Quick Start – configure a container host

**This is preliminary content and subject to change.** 

The Windows container feature is available on Windows Server 2016, Nano Server, and Windows 10 insider releases. A Windows container host can be deployed onto physical systems, on-prem virtual machines, and cloud hosted virtual machines. The steps to deploy a container host may vary by operating system, and system type. This document provides the details needed to quickly provision a Windows container host. This document also links through to more detailed instruction on manual deployments for all configuration types.

Use the navigation at the right hand side to select your desired deployment configuration.

## Azure Container Host 

Perhaps the quickest way to get a Windows container host up and running is in Azure. An Azure virtual machine can be deployed with the container role in one of several ways.

> Azure does not support Hyper-V containers.

### Azure Template

A sample template is available on GitHub that deploys and configures a Windows Container host in Azure. For more information, see [Windows Container Azure Template]( https://github.com/Azure/azure-quickstart-templates/tree/master/windows-server-containers-preview).

### Manual Configuration <!--1-->

To manually configure a Windows Container host in Azure, first deploy a virtual machine with Windows Server 2016 or Nano Server, and then follow the directions found in these articles.

[Windows Server Container Deployment Guide](../deployment/deployment.md).

[Nano Server Container Deployment Guide](../deployment/deployment_nano.md).

## Windows Server

### Scripted - New VM <!--1-->

To deploy a new Hyper-V virtual machine with the container role ready to go, download and run the New-ContainerHost.ps1 script.

```none
# Download configuration script

wget -uri https://aka.ms/tp5/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

# Run configuration script

powershell.exe -NoProfile c:\New-ContainerHost.ps1 -VMName testcont -WindowsImage ServerDatacenterCore –Hyperv
```
The script downloads and configures the Windows Container components. This process may take quite some time due to the large download. When finished, a new Virtual Machine is configured and ready with the Windows container role.

### Scripted - Existing System <!--1-->

To install and configure the container role on an existing system, download and run the Install-ContainerHost.ps1 script.

```none
# Download configuration script

wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1

# Run configuration script

powershell.exe -NoProfile C:\Install-ContainerHost.ps1 -HyperV
```

The script downloads and configure the Windows Container components. This process may take quite some time due to the large download. When finished, the system is configured and ready with the Windows container role.

### Manual Configuration <!--2-->

To manually configure the host, see the [Windows Server Container Deployment Guide](../deployment/deployment.md).

## Nano Server

### Scripted - New VM <!--2-->

To deploy a new virtual machine, with the container role ready to go, run the following commands on a Hyper-V host.

```none
# Download configuration script

wget -uri https://aka.ms/tp5/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

# Run configuration script

powershell.exe -NoProfile c:\New-ContainerHost.ps1 -VMName testcont -WindowsImage NanoServer –Hyperv
```

The script downloads and configures the Windows Container components. This process may take quite some time due to the large download. When finished, a new Virtual Machine is configured and ready with the Windows container role.

### Manual Configuration <!--3-->

To manually configure the host, see the [Nano Server Container Deployment Guide](../deployment/deployment_nano.md).

## Windows 10 Insiders Releases

A Windows 10 Insiders Releases physical or virtual system can be configured using multiple methods.

### Manual Configuration <!--4-->

To manually configure the host, see the [Windows 10 Container Deployment Guide](../deployment/deployment_windows10.md).

## Next Steps

[Docker on Windows Quick Start](./manage_docker.md)