---
author: neilpeterson
---

# Quick Start – configure a container host

**This is preliminary content and subject to change.** 

The Windows container feature is available on Windows Server 2016 and Nano Server. A Windows container host can be deployed onto physical systems, on-prem virtual machines, and cloud hosted virtual machines. The steps to deploy a container host may vary by operating system, and system type. This document provides the details needed to quickly provision a Windows container host. This document also links through to more detailed instruction on manual deployments for all configuration types.

Use the navigation at the right hand side to select your desired deployment configuration.

## Windows Server

### Scripted - New VM <!--1-->

To deploy a new Hyper-V virtual machine with the container role ready to go, download and run the New-ContainerHost.ps1 script.

```none
# Download configuration script.

wget -uri https://aka.ms/tp5/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

# Run configuration script.
# Using the -hyperv parameter prepares the container host for Hyper-V containers. 
# This can be removed if Hyper-V containers will not be used.

powershell.exe -NoProfile -ExecutionPolicy Bypass c:\New-ContainerHost.ps1 -VMName MyContainerHost -WindowsImage ServerDatacenterCore –Hyperv

```
The script downloads and configures the Windows Container components. This process may take quite some time due to the large download. When finished, a new Virtual Machine is configured and ready with the Windows container role.

### Scripted - Existing System <!--1-->

To install and configure the container role on an existing system, download and run the Install-ContainerHost.ps1 script. If the existing system is a Hyper-V virtual machine and will be hosting Hyper-V containers, ensure that nested virtualization is enabled and configured. For more information see, [Nested Virtualization](https://msdn.microsoft.com/virtualization/hyperv_on_windows/windows_welcome).

```none
# Download configuration script.

wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1

# Run configuration script.
# Using the -hyperv parameter prepares the container host for Hyper-V containers. 
# This can be removed if Hyper-V containers will not be used.

powershell.exe -NoProfile -ExecutionPolicy Bypass C:\Install-ContainerHost.ps1 -HyperV
```

The script downloads and configure the Windows Container components. This process may take quite some time due to the large download. When finished, the system is configured and ready with the Windows container role.

> Once the script has started, the system will be rebooted. After the reboot the script will continue. It is safe to log back into the system; the script progress will be displayed.

### Manual Configuration <!--2-->

To manually configure the host, see the [Windows Server Container Deployment Guide](../deployment/deployment.md).

## Nano Server

### Scripted - New VM <!--2-->

To deploy a new virtual machine, with the container role ready to go, run the following commands on a Hyper-V host.

```none
# Download configuration script.

wget -uri https://aka.ms/tp5/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

# Run configuration script.
# Using the -hyperv parameter prepares the container host for Hyper-V containers. 
# This can be removed if Hyper-V containers will not be used.

powershell.exe -NoProfile c:\New-ContainerHost.ps1 -VMName vmname -WindowsImage NanoServer –Hyperv
```

The script downloads and configures the Windows Container components. This process may take quite some time due to the large download. When finished, a new Virtual Machine is configured and ready with the Windows container role.

### Scripted - Existing System <!--2-->

To install and configure the container role on an existing system, download and run the Install-ContainerHost.ps1 script. If the existing system is a Hyper-V virtual machine and will be hosting Hyper-V containers, ensure that nested virtualization is enabled and configured. For more information see, [Nested Virtualization]( https://msdn.microsoft.com/virtualization/hyperv_on_windows/windows_welcome).

> Nano Server does not support the wget command. Download the script on a separate system and copy it to the Nano Server system

```none
# Download configuration script

wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1

# Run configuration script.
# Using the -hyperv parameter prepares the container host for Hyper-V containers. 
# This can be removed if Hyper-V containers will not be used.

powershell.exe -NoProfile -ExecutionPolicy Bypass C:\Install-ContainerHost.ps1 -HyperV
```

The script downloads and configure the Windows Container components. This process may take quite some time due to the large download. When finished, the system is configured and ready with the Windows container role.

### Manual Configuration <!--3-->

To manually configure the host, see the [Nano Server Container Deployment Guide](../deployment/deployment_nano.md).

## Azure

### Scripted - Existing System <!--3-->

Deploy a Windows Server 2016 or Nano Server virtual machine from the Azure Gallery, and then run then download and run the ‘install-containerhost.ps1’ script on the virtual machine. Note – Azure does not support nested virtualization and cannot support Hyper-V containers.

```none
# Download configuration script

wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1

# Run configuration script

powershell.exe -NoProfile C:\Install-ContainerHost.ps1
```

### Manual Configuration <!--1-->

To manually configure a Windows Container host in Azure, first deploy a virtual machine with Windows Server 2016 or Nano Server, and then follow the directions found in these articles.

[Windows Server Container Deployment Guide](../deployment/deployment.md)

[Nano Server Container Deployment Guide](../deployment/deployment_nano.md)

## Next Steps

[Docker on Windows Quick Start](./manage_docker.md)
