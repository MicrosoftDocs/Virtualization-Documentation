# Deploy a Container Host

The Windows Container feature is only available with Windows Server 2016 (Full, Core, and Nano Server). Within the Windows Container feature is two different container types, each with slightly different behavior and sets of requirements. This document steps through the deployment of a container host and will detail the configurations needed for both container types.

> This is preliminary content and subject to change.

## OS Image Configuration

Before deploying a container host, it is important to understand the supported configurations between container host OS, container OS images, and container runtime. The following table details the supported configurations.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:75%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td><center>**Host Operating System**</center></td>
<td><center>**Windows Server Container**</center></td>
<td><center>**Hyper-V Contianer**</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Full UI</center></td>
<td><center>Core OS Image</center></td>
<td><center>Nano OS Image</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Core</center></td>
<td><center>Core OS Image</center></td>
<td><center> Nano OS Image</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Nano</center></td>
<td><center> Nano OS Image</center></td>
<td><center>Nano OS Image</center></td>
<tr>
</table>

## Container Host Deployment

Use the following sections to help you deploy a Windows Container Host.

**Install the Container feature:**

- [Install the container feature on Windows Server 2016 or Windows Server 2016 Core](#role).
- [Install the container feature on Nano Server](#nano).

**Configure the container host for Hyper-V Containers:**

- [Enable the Hyper-V Role in Windows Server 2016 or Windows Server 2016 Core](#hypv).
- [Enable the Hyper-V Role in Nano Server](#nano).

**Configure Networking in both Windows Server and Nano Server:**

- [Create Virtual Switch](#vswitch).
- [Configure Network Address Translation](#nat).
- [Configure MAC Address Spoofing](#mac).

**Configure Host for Container Operations:**

- [Install Container OS Images in both Windows Server and Nano Server.](#img)
- [Install Docker in both Windows Server and Nano Server.](#docker)


### <a name=role></a>Install Container Feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the role using PowerShell, run the following command in an elevated PowerShell session.

```powershell
Install-WindowsFeature containers
```
The system needs to be rebooted when the container role installation has completed.

```powershell
shutdown /r 
```

After the system has rebooted, use the `Get-ContainerHost` command to verify that the container role has successfully been installed:

```powershell
Get-ContainerHost

Name            ContainerImageRepositoryLocation
----            --------------------------------
WIN-LJGU7HD7TEP C:\ProgramData\Microsoft\Windows\Hyper-V\Container Image Store
```

### <a name=nano></a> Prepare Nano Server

Deploying Nano Server involves creating a prepared virtual hard drive, which includes the Nano Server operating system, and additional feature packages. This guide quickly details preparing a Nano Server virtual hard drive, which can be used for Windows Containers.

For more information on Nano Server, and to explore different Nano Server deployment options, see the [Nano Server Documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

Create a folder named `nano`.

```powershell
New-Item -ItemType Directory c:\nano
```

Locate the `NanoServerImageGenerator.psm1` and `Convert-WindowsImage.ps1` files from the Nano Server folder, on the Windows Server Media. Copy these to `c:\nano`.

```powershell
#Set path to Windows Server 2016 Media
$WindowsMedia = "C:\Users\Administrator\Desktop\TP4 Release Media"
	
Copy-Item $WindowsMedia\NanoServer\Convert-WindowsImage.ps1 c:\nano
Copy-Item $WindowsMedia\NanoServer\NanoServerImageGenerator.psm1 c:\nano
```
Run the following to create a Nano Server virtual hard drive. The `–Containers` parameter indicates that the container package will be installed, and the `–Compute` parameter takes care of the Hyper-V package. Hyper-V is only required if Hyper-V containers will be created.

```powershell
Import-Module C:\nano\NanoServerImageGenerator.psm1
New-NanoServerImage -MediaPath $WindowsMedia -BasePath c:\nano -TargetPath C:\nano\NanoContainer.vhdx -MaxSize 10GB -GuestDrivers -ReverseForwarders -Compute -Containers
```
When completed, create a virtual machine from the `NanoContainer.vhdx` file. This virtual machine will be running the Nano Server OS, with optional packages.

### <a name=hypv></a>Configure Hyper-V

Two scenarios need to be considered in regard to Hyper-V and Windows Containers.

- The container host will be hosting Hyper-V containers.
- The container host itself is a Hyper-V virtual machine.

If Hyper-V containers will be used, the Hyper-V role needs to be installed. This can be completed on Windows Server 2016 or Windows Server 2016 Core using the following PowerShell command. For Nano Server Configuration, see [Prepare Nano Server](#nano).

```powershell
Install-WindowsFeature hyper-v
```

If the container host itself is a Hyper-V virtual machine, and will be running Hyper-V containers, nested virtualization needs to be enabled. This can be completed with the following PowerShell Command.

> The virtual machines must be turned off when running this command.

```powershell
Set-VMProcessor -VMName <container host vm> -ExposeVirtualizationExtensions $true
```

### Configure Networking

<a name=vswitch></a>Each container needs to be attached to a virtual switch in order to communicate over a network. A virtual switch is created with the `New-VMSwitch` command. Containers support a virtual switch with type `External` or `NAT`.

This example creates a virtual switch with the name “Virtual Switch”, a type of NAT, and Nat Subnet of 172.16.0.0/12. 

```powershell
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12
```

<a name=nat></a>In addition to creating the virtual switch, if the switch type is NAT, a NAT object needs to be created. This is completed using the `New-NetNat` command. This example creates a NAT object, with the name `ContainerNat`, and an address prefix that matches the NAT subnet assigned to the container switch.

```powershell
New-NetNat -Name ContainerNat -InternalIPInterfaceAddressPrefix "172.16.0.0/12"
	
#output

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

<a name=mac></a>Finally, if the container host is running inside of a Hyper-V virtual machine, MAC spoofing must be enable. This allows each container to receive an IP Address. To enable MAC address spoofing, run the following command on the Hyper-V host. The VMName property will be the name of the container host.

```powershell
Get-VMNetworkAdapter -VMName <contianer host vm> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### <a name=img></a>Install OS Images

An OS image is used as the base to any Windows Server or Hyper-V container. The image is used to deploy a container, which can then be modified, and captured into a new container image. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system.

Container OS images can be found and installed using the ContainerProvider PowerShell module. Before using this module, it needs to be installed. The following commands can be used to install the module.

```powershell
Invoke-RestMethod 'https://go.microsoft.com/fwlink/?LinkID=627338&clcid=0x409'
Install-PackageProvider NuGet -Force
Register-PSRepository -name psgetint -SourceLocation http://psget/psgallery/api/v2 
Install-PackageProvider ContainerProvider -Force
```

Return a list of images from PowerShell OneGet package manager:
```powershell
Find-ContainerImage

#output

Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.8            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10586.7            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10585.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10584.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10583.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10582.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10581.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10580.0            Container OS Image of Windows Server 2016 Techn...
NanoServer           10.0.10579.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.8            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.7            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10585.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10584.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10583.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10582.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10581.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10580.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10579.0            Container OS Image of Windows Server 2016 Techn...
```

To download and install the Nano Server base OS image, run the following.

```powershell
Install-ContainerImage -Name NanoServer -Version 10.0.10586.8
Downloaded in 0 hours, 0 minutes, 10 seconds.
```

Likewise, this command downloads and installs the Windows Server Core base OS image.

```powershell
Install-ContainerImage -Name WindowsServerCore -Version 10.0.10586.8
Downloaded in 0 hours, 2 minutes, 28 seconds.
```

Verify that the images have been installed using the `Get-ContainerImage` command.

```powershell
Get-ContainerImage

#output

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
NanoServer        CN=Microsoft 10.0.10586.8 True
WindowsServerCore CN=Microsoft 10.0.10586.8 True
```  
For more information on Container image management see [Windows Container Images](../management/manage_images.md).
 
### <a name=docker></a>Install Docker

The Docker Daemon and command line interface are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker, follow the instructions in this article [Docker and Windows](./docker_windows.md).
