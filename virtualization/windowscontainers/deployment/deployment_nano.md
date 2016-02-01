# Container Host Deployment - Nano Server

**This is preliminary content and subject to change.** 

Deploying a Windows Container host has different steps depending on the operating system and the host system type (physical or virtual). The steps in this document are used to deploy a Windows Container host to Nano Server, on a physical or virtual system. To install a Windows Container host to Windows Server see [Container Host Deployment - Windows Server](./deployment.md).

For details on system requirements, see [Windows Container Host System Requirements](./system_requirements.md). 

PowerShell scripts are available to automate the deployment of a Windows Container host. 
- [Deploy a container host in a new Hyper-V Virtual Machine](../quick_start/container_setup.md).
- [Deploy a container host to an existing system](../quick_start/inplace_setup.md).


# Nano Server Host

The steps listed in this table can be used to deploy a container host to Nano Server. Included are the configurations necessary for both Windows Server and Hyper-V Containers.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment Action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Prepare Nano Server for Containers](#nano)</td>
<td>Prepare a Nano Server VHD with the container and Hyper-V capabilities.</td>
</tr>
<tr>
<td>[Create Virtual Switch](#vswitch)</td>
<td>Containers connect to a virtual switch for network connectivity.</td>
</tr>
<tr>
<td>[Configure NAT](#nat)</td>
<td>If a virtual switch is configured with Network Address Translation, NAT itself needs configuration.</td>
</tr>
<tr>
<td>[Install Container OS Images](#img)</td>
<td>OS images provide the base for container deployments.</td>
</tr>
<tr>
<td>[Install Docker](#docker)</td>
<td>Optional, however necessary in order to create and manage Windows containers with Docker. </td>
</tr>
</table>

These steps need to be taken if Hyper-V Containers will be used. Note, the steps marked with and * are only necessary if the container host is itself a Hyper-V virtual machine.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td width = "30%"><strong>Deployment Action</strong></td>
<td width = "70%"><strong>Details</strong></td>
</tr>
<tr>
<td>[Enable Hyper-V Role](#hypv) </td>
<td>Hyper-V is only required if Hyper-V Containers will be used.</td>
</tr>
<tr>
<td>[Enable Nested Virtualization *](#nest)</td>
<td>If the Container Host is itself a Hyper-V Virtual machine, Nested Virtualization needs to be enabled.</td>
</tr>
<tr>
<td>[Configure Virtual Processors *](#proc)</td>
<td>If the Container Host is itself a Hyper-V Virtual machine, at least two virtual processors will need to be configured.</td>
</tr>
<tr>
<td>[Disable Dynamic Memory *](#dyn)</td>
<td>If the Container Host is itself a Hyper-V Virtual machine, dynamic memory must be disabled.</td>
</tr>
<td>[Configure MAC Address Spoofing *](#mac)</td>
<td>If the container host is virtualized, MAC spoofing will need to be enabled.</td>
</tr>
</table>

## Deployment Steps

### <a name=nano></a> Prepare Nano Server

Deploying Nano Server involves creating a prepared virtual hard drive, which includes the Nano Server operating system, and additional feature packages. This guide quickly details preparing a Nano Server virtual hard drive, which can be used for Windows Containers. For more information on Nano Server, and to explore different Nano Server deployment options, see the [Nano Server Documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

Create a folder named `nano`.

```powershell
PS C:\> New-Item -ItemType Directory c:\nano
```

Locate the `NanoServerImageGenerator.psm1` and `Convert-WindowsImage.ps1` files from the Nano Server folder, on the Windows Server Media. Copy these to `c:\nano`.

```powershell
#Set path to Windows Server 2016 Media
PS C:\> $WindowsMedia = "C:\Users\Administrator\Desktop\TP4 Release Media"
	
PS C:\> Copy-Item $WindowsMedia\NanoServer\Convert-WindowsImage.ps1 c:\nano

PS C:\> Copy-Item $WindowsMedia\NanoServer\NanoServerImageGenerator.psm1 c:\nano
```
Run the following to create a Nano Server virtual hard drive. The `–Containers` parameter indicates that the container package is installed, and the `–Compute` parameter takes care of the Hyper-V package. Hyper-V is only required if using Hyper-V containers.

```powershell
PS C:\> Import-Module C:\nano\NanoServerImageGenerator.psm1

PS C:\> New-NanoServerImage -MediaPath $WindowsMedia -BasePath c:\nano -TargetPath C:\nano\NanoContainer.vhdx -MaxSize 10GB -GuestDrivers -ReverseForwarders -Compute -Containers
```
When completed, create a virtual machine from the `NanoContainer.vhdx` file. This virtual machine will be running the Nano Server OS, and optional packages.

### <a name=vswitch></a>Create Virtual Switch

Each container needs to be attached to a virtual switch in order to communicate over a network. A virtual switch is created with the `New-VMSwitch` command. Containers support a virtual switch with type `External` or `NAT`. For more information on Windows Container networking see [Container Networking](../management/container_networking.md).

This example creates a virtual switch with the name “Virtual Switch”, a type of NAT, and Nat Subnet of 172.16.0.0/12. 

```powershell
PS C:\> New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress "172.16.0.0/12"
```

### <a name=nat></a>Configure NAT

In addition to creating a virtual switch, if the switch type is NAT, a NAT object needs to be created. This is completed using the `New-NetNat` command. This example creates a NAT object, with the name `ContainerNat`, and an address prefix that matches the NAT subnet assigned to the container switch.

```powershell
PS C:\> New-NetNat -Name ContainerNat -InternalIPInterfaceAddressPrefix "172.16.0.0/12"
	
Name                             : ContainerNat
ExternalIPInterfaceAddressPrefix :
InternalIPInterfaceAddressPrefix : 172.16.0.0/12
IcmpQueryTimeout                 : 30
TcpEstablishedConnectionTimeout  : 1800
TcpTransientConnectionTimeout    : 120
TcpFilteringBehavior             : AddressDependentFiltering
UdpFilteringBehavior             : AddressDependentFiltering
UdpIdleSessionTimeout            : 120
UdpInboundRefresh                : False
Store                            : Local
Active                           : True
```

### <a name=img></a>Install OS Images

An OS image is used as the base to any Windows Server or Hyper-V container. The image is used to deploy a container, which can then be modified, and captured into a new container image. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system.

Container OS images can be found and installed using the ContainerProvider PowerShell module. Before using this module, it needs to be installed. The following commands can be used to install the module.

```powershell
PS C:\> Install-PackageProvider ContainerProvider -Force
```

Use `Find-ContainerImage` to return a list of images from PowerShell OneGet package manager. 

```powershell
PS C:\> Find-ContainerImage

Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...

```
**Note** - At this time, only the Nano Server OS Image is compatible with a Nano Server container host. To download and install the Nano Server base OS image, run the following.

```powershell
PS C:\> Install-ContainerImage -Name NanoServer -Version 10.0.10586.0

Downloaded in 0 hours, 0 minutes, 10 seconds.
```

Verify that the image is installed using the `Get-ContainerImage` command.

```powershell
PS C:\> Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
NanoServer        CN=Microsoft 10.0.10586.0 True
```  
For more information on Container image management see [Windows Container Images](../management/manage_images.md).
 
### <a name=docker></a>Install Docker

The Docker Daemon and command line interface are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker, follow the instructions in this article [Docker and Windows](./docker_windows.md).


## Hyper-V Container Host

### <a name=hypv></a>Enable the Hyper-V Role

On Nano Server this can be completed when creating the Nano Server image. See [Prepare Nano Server for Containers](#nano) for these instructions.

### <a name=nest></a>Configure Nested Virtualization

If the container host itself will be running on a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, nested virtualization needs to be enabled. This can be completed with the following PowerShell command.

**Note** - The virtual machines must be turned off when running this command.

```powershell
PS C:\> Set-VMProcessor -VMName <VM Name> -ExposeVirtualizationExtensions $true
```

### <a name=proc></a>Configure Virtual Processors

If the container host itself will be running on a Hyper-V virtual machine, and will also be hosting Hyper-V Containers, the virtual machine will require at least two processors. This can be configured through the settings of the virtual machine, or with the following command.

**Note** - The virtual machines must be turned off when running this command.

```poweshell
PS C:\> Set-VMProcessor –VMName <VM Name> -Count 2
``` 

### <a name=dyn></a>Disable Dynamic Memory

If the Container Host is itself a Hyper-V Virtual machine, dynamic memory must be disabled on the container host virtual machine. This can be configured through the settings of the virtual machine, or with the following command.

**Note** - The virtual machines must be turned off when running this command.

```poweshell
PS C:\> Set-VMMemory <VM Name> -DynamicMemoryEnabled $false
``` 

### <a name=mac></a>Configure MAC Address Spoofing

Finally, if the container host is running inside of a Hyper-V virtual machine, MAC spoofing must be enable. This allows each container to receive an IP Address. To enable MAC address spoofing, run the following command on the Hyper-V host. The VMName property will be the name of the container host.

```powershell
PS C:\> Get-VMNetworkAdapter -VMName <VM Name> | Set-VMNetworkAdapter -MacAddressSpoofing On
```