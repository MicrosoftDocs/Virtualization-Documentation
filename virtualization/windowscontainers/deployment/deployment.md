---
author: neilpeterson
---

# Container Host Deployment - Windows Server

**This is preliminary content and subject to change.** 

Deploying a Windows Container host has different steps depending on the operating system and the host system type (physical or virtual). The steps in this document are used to deploy a Windows Container host to either Windows Server 2016 or Windows Server Core 2016, on a physical or virtual system. To install a Windows Container host to Nano Server see [Container Host Deployment - Nano Server](./deployment_nano.md).

For details on system requirements, see [Windows Container Host System Requirements](./system_requirements.md). 

PowerShell scripts are also available to automate the deployment of a Windows Container host. 
- [Deploy a container host in a new Hyper-V Virtual Machine](../quick_start/container_setup.md).
- [Deploy a container host to an existing system](../quick_start/inplace_setup.md).

# Windows Server host

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Install the container feature](#role)</td>
<td>The container feature enables use of Windows Server and Hyper-V containers.</td>
</tr>
<tr>
<td>[Install container OS images](#img)</td>
<td>OS images provide the base for container deployments.</td>
</tr>
<tr>
<td>[Install Docker](#docker)</td>
<td>Follow these steps to install and configure the Docker engine on Windows.</td>
</tr>
</table>
<br />
These steps need to be taken if Hyper-V Containers will be used. Note, the steps marked with and * are only necessary if the container host is itself a Hyper-V virtual machine.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment Action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Enable nested virtualization *](#nest)</td>
<td>If the container host is virtualized, Nested Virtualization needs to be enabled.</td>
</tr>
<tr>
<td>[Configure virtual processors *](#proc)</td>
<td>If the container host is virtualized, at least two virtual processors will need to be configured.</td>
</tr>
<tr>
<td>[Disable dynamic memory *](#dyn)</td>
<td>If the container host is virtualized, dynamic memory must be disabled.</td>
</tr>
<tr>
<td>[Configure MAC address spoofing *](#mac)</td>
<td>If the container host is virtualized, MAC spoofing will need to be enabled.</td>
</tr>
<tr>
<td>[Enable Hyper-V role](#hypv) </td>
<td>Hyper-V is only required if Hyper-V Containers will be used.</td>
</tr>
</table>

## Deployment steps

### <a name=role></a>Install container feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the role using PowerShell, run the following command in an elevated PowerShell session.

```powershell
Install-WindowsFeature containers
```
The system needs to be rebooted when the container role installation has completed.

```powershell
shutdown /r /t 0
```

### <a name=img></a>Install OS images

An OS image is used as the base to any Windows Server or Hyper-V container. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system, and can be installed using the Container Provider PowerShell module. 

The following command can be used to install the Container Provider PowerShell module.

```powershell
PS C:\> Install-PackageProvider ContainerProvider -Force
```

Use `Find-ContainerImage` to return a list of images.
```powershell
Find-ContainerImage
```

Which will output something similar to this.

```
Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...

```
To download and install the Nano Server base OS image, run the following.

```powershell
Install-ContainerImage -Name NanoServer
```

Likewise, this command downloads and installs the Windows Server Core base OS image.

```powershell
PS C:\> Install-ContainerImage -Name WindowsServerCore
```

For more information on Container image management see [Windows Container Images](../management/manage_images.md).
 
### <a name=docker></a>Install Docker

The Docker Engine is not shipped with Windows, and not installed with the Windows Container feature. To install Docker, follow the instructions in this article [Docker and Windows](./docker_windows.md).


## Hyper-V container host

### <a name=nest></a>Nested virtualization

If the container host itself will be running on a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, nested virtualization needs to be enabled. This can be completed with the following PowerShell command.

**Note** - The virtual machines must be turned off when running this command.

```powershell
Set-VMProcessor -VMName <VM Name> -ExposeVirtualizationExtensions $true
```

### <a name=proc></a>Configure virtual processors

If the container host itself will be running on a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, the virtual machine will require at least two processors. This can be configured through the settings of the virtual machine, or with the following command.

**Note** - The virtual machines must be turned off when running this command.

```powershell
Set-VMProcessor -VMName <VM Name> -Count 2
``` 

### <a name=dyn></a>Disable dynamic memory

If the Container host is itself a Hyper-V virtual machine, dynamic memory must be disabled on the container host virtual machine. This can be configured through the settings of the virtual machine, or with the following command.

**Note** - The virtual machine must be turned off when running this command.

```powershell
Set-VMMemory <VM Name> -DynamicMemoryEnabled $false
``` 

### <a name=mac></a>MAC address spoofing

Finally, if the container host is running inside of a Hyper-V virtual machine, MAC spoofing must be enable. This allows each container to receive an IP Address. To enable MAC address spoofing, run the following command on the Hyper-V host. The VMName property will be the name of the container host.

```powershell
Get-VMNetworkAdapter -VMName <VM Name> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### <a name=hypv></a>Enable the Hyper-V role

If Hyper-V Containers will be deployed, the Hyper-V role needs to be enabled on the container host. The Hyper-V role can be installed on Windows Server 2016 or Windows Server 2016 Core using the `Install-WindowsFeature` command. If the container host is itself a Hyper-V virtual machine, nested virtualization will need to be enabled first. To do so see [Configure Nested Virtualization]( #nest).

```powershell
Install-WindowsFeature hyper-v
```

