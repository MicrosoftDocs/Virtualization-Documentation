---
author: neilpeterson
---

# Container Host Deployment - Windows Server

**This is preliminary content and subject to change.** 

Deploying a Windows container host has different steps depending on the operating system and the host system type (physical or virtual). This document details deploying a Windows container host to either Windows Server 2016 or Windows Server Core 2016 on a physical or virtual system.

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
<td>[Install base OS images](#img)</td>
<td>Base OS images provide the base for container deployments.</td>
</tr>
<tr>
<td>[Install Docker](#docker)</td>
<td>Follow these steps to install and configure the Docker on Windows.</td>
</tr>
</table>

<br />

These steps need to be taken if Hyper-V containers will be used. Note, the steps marked with and * are only necessary if the container host will be virtualized.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment Action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Configure nested virtualization *](#nest)</td>
<td>If the container host is virtualized, Nested Virtualization needs to be configured.</td>
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
<td>The Hyper-V role is only required if Hyper-V containers will be deployed.</td>
</tr>
</table>

## Deployment steps

### <a name=role></a>Install container feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the role using PowerShell, run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature containers
```
The system needs to be rebooted when the container role installation has completed.

```none
shutdown /r /t 0
```

### <a name=img></a>Install OS images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are avaliable with both Windows Server Core and Nano Server as the underlying operating system, and can be installed using the Container Provider PowerShell module. 

The following command can be used to install the Container Provider PowerShell module.

```none
Install-PackageProvider ContainerImage -Force
```

Use `Find-ContainerImage` to return a list of images.
```none
Find-ContainerImage
```

Which will output something similar to this.

```none
Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...

```
To download and install the Nano Server base OS image, run the following.

```none
Install-ContainerImage -Name NanoServer
```

Likewise, this command downloads and installs the Windows Server Core base OS image.

```none
Install-ContainerImage -Name WindowsServerCore
```

For more information on Container image management see [Windows container images](../management/manage_images.md).
 
### <a name=docker></a>Install Docker

A script has been created to install and configure the Docker service. Run the following commands to download the script

```none
Invoke-WebRequest https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/container-docs-development/windows-server-container-tools/Update-ContainerHost/Update-ContainerHost.ps1 -OutFile Update-ContainerHost.ps1
```
Run the script to install the Docker service.

```none
.\Update-ContainerHost.ps1
```
For manual installation and configuration steps, see [Docker and Windows](./docker_windows.md).

## Hyper-V container host

### <a name=nest></a>Configure nested virtualization

If the container host will be virtualized, the Hyper-V virtual processor will need to be configured for nested virtualization. This includes configuring the virtual machine with at least two virtual processors and enabling the nested virtualization extension. This can be completed with the following command.

**Note** - The virtual machines must be turned off when running this command.

```none
Set-VMProcessor -VMName <VM Name> -ExposeVirtualizationExtensions $true -Count 2
```

### <a name=dyn></a>Disable dynamic memory

If the container host will be virtualized, dynamic memory must be disabled on the container host virtual machine. This can be configured through the settings of the virtual machine, or with the following command.

**Note** - The virtual machine must be turned off when running this command.

```none
Set-VMMemory <VM Name> -DynamicMemoryEnabled $false
``` 

### <a name=mac></a>MAC address spoofing

Finally, if the container host is running inside of a Hyper-V virtual machine, MAC spoofing must be enable. This allows each container to receive an IP Address. To enable MAC address spoofing, run the following command on the Hyper-V host. The VMName property will be the name of the container host.

```none
Get-VMNetworkAdapter -VMName <VM Name> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### <a name=hypv></a>Enable the Hyper-V role

If Hyper-V containers will be deployed, the Hyper-V role needs to be enabled on the container host. The Hyper-V role can be installed on Windows Server 2016, or Windows Server 2016 Core using the `Install-WindowsFeature` command.

```none
Install-WindowsFeature hyper-v
```

