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

### <a name=img></a>Install OS images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are available with both Windows Server Core and Nano Server as the underlying operating system, and can be installed using the Container Image PowerShell module. 

The following command can be used to install the Container Provider PowerShell module.

```none
Install-PackageProvider ContainerImage -Force
```

Once installed, a list of Base OS images can be returned using `Find-ContainerImage`.

```none
Find-ContainerImage

Name                           Version          Source           Summary
----                           -------          ------           -------
NanoServer                     10.0.14300.1010  ContainerImag... Container OS Image of Windows Server 2016 Technical...
WindowsServerCore              10.0.14300.1000  ContainerImag... Container OS Image of Windows Server 2016 Technical...
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
Invoke-WebRequest https://aka.ms/tp5/Update-Container-Host -OutFile update-containerhost.ps1
```
Run the script to install the Docker service.

```none
.\update-containerhost.ps1
```

For manual installation and configuration steps, see [Docker and Windows](./docker_windows.md).

## Hyper-V container host

### <a name=nest></a>Nested virtualization

Nested virtualization allows the Hyper-V role to function inside of a Hyper-V virtual machine. This is required if the container host is virtualized and also running Hyper-V containers. Several steps need to be completed for a nested virtualization configuration including configuring the virtual processor, turning off dynamic memory, and enabling MAC spoofing. For more information on nested virtualization, see [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

The following script will configure nested virtualization for the container host. This script is run on the Hyper-V machine that is hosting the container host virtual machine. Ensure that the container host virtual machine is turned off when running this script.

```none
#replace with the virtual machine name
$vm = "<virtual-machine>"

#configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

#disable dynamic memory
Set-VMMemory $vm -DynamicMemoryEnabled $false

#enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### <a name=hypv></a>Enable the Hyper-V role

If Hyper-V containers will be deployed, the Hyper-V role needs to be enabled on the container host. The Hyper-V role can be installed on Windows Server 2016, or Windows Server 2016 Core using the `Install-WindowsFeature` command.

```none
Install-WindowsFeature hyper-v
```

