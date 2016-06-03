---
author: neilpeterson
---

# Container host deployment - Nano Server

**This is preliminary content and subject to change.** 

Deploying a Windows container host has different steps, depending on the operating system and the host system type (physical or virtual). The steps in this document are used to deploy a Windows Container host to Nano Server on a physical or virtual system.

# Nano server host

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment Action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Prepare Nano Server for containers](#nano)</td>
<td>Prepare a Nano Server VHD with the container and Hyper-V capabilities.</td>
</tr>
<tr>
<td>[Install container OS images](#img)</td>
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
<td>[Enable Hyper-V role](#hypv) </td>
<td>Hyper-V is only required if Hyper-V containers will be deployed.</td>
</tr>
<tr>
<td>[Configure nested virtualization *](#nest)</td>
<td>If the container host is virtualized, Nested Virtualization needs to be configured.</td>
</tr>
</table>

## Deployment steps

### <a name=nano></a> Deploy Nano Server

Deploying Nano Server involves creating a prepared virtual hard drive, which includes the Nano Server operating system and additional feature packages. This guide quickly details preparing a Nano Server virtual hard drive, which can be used for Windows containers. For more information on Nano Server and to explore different Nano Server deployment options, see the [Nano Server documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

Create a folder named `nano`.

```none
New-Item -ItemType Directory c:\nano
```

Locate the `NanoServerImageGenerator.psm1` and `Convert-WindowsImage.ps1` files on the Windows Server Media. Copy these to `c:\nano`.

```none
# Set path to Windows Server 2016 Media

$WindowsMedia = "C:\TP5Media"

# Copy Files
	
Copy-Item $WindowsMedia\NanoServer\NanoServerImageGenerator\Convert-WindowsImage.ps1 c:\nano
Copy-Item $WindowsMedia\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1 c:\nano
```
Run the following to create a Nano Server virtual hard drive. The `-Containers` parameter indicates that the container package is installed and the `-Compute` parameter takes care of the Hyper-V package. Hyper-V is only required if using Hyper-V containers.

```none
# Set path to Windows Server 2016 Media

$WindowsMedia = "C:\TP5Media"

# Create Nano Server Image

Import-Module C:\nano\NanoServerImageGenerator.psm1
New-NanoServerImage -MediaPath $WindowsMedia -BasePath c:\nano -TargetPath c:\nano\nanocontainer.vhdx -MaxSize 10GB -Compute -Containers -DeploymentType Guest -Edition Datacenter
```
When completed, create a virtual machine from the `NanoContainer.vhdx` file. For more information on this process, see [Deploy a Windows virtual machine in Hyper-V]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_create_vm).

When the virtual machine is ready, create a remote connection with Nano Server operating system. For more information on this operation, see [Using Windows PowerShell remoting in Getting Started with Nano Server]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

### <a name=img></a>Install OS images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are available with both Windows Server Core and Nano Server as the underlying operating system and can be installed using the container Provider PowerShell module. 

The following command can be used to install the Container Image PowerShell module.

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

To download and install the Nano Server base OS image, run the following:

```none
Install-ContainerImage -Name NanoServer
```

**Note** - At this time, only the Nano Server OS Image is compatible with a Nano Server container host.

For more information on container image management, see [Windows container images](../management/manage_images.md).
 
### <a name=docker></a>Install Docker

The Docker Engine is not shipped with Windows and not installed with the Windows container feature. To install Docker, follow the instructions in this [Docker and Windows](./docker_windows.md).

## Hyper-V container host

### <a name=hypv></a>Enable the Hyper-V Role

Hyper-V can be enabled when creating the Nano Server virtual hard drive, see [Prepare Nano Server for containers](#nano) for these instructions.

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

$enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On
```
