## Container Host Requirements

The Windows Container feature is only available in Windows Server 2016. The container feature can be installed on Windows Server 2016, Windows Server 2016 Core, and Nano Server. The Container feature includes support for two different types of containers, Windows Server Containers and Hyper-V Containers, both of which have slightly different configuation requirements. This document will detail configuration requirements, deployment, and configuration of the Windows Containers feature.

### Host and Image Support
 
Windows Containers use an OS image as the base for any container. Two OS images are available, Windows Server Core and Nano Server. Windows Server Technical Preview 4 supports the following configuration between container host OS, container type, and OS image. For example, based on the below chart, if the container feature is enabled on a Windows Server 2016 OS with full UI, Windows Server Containers can be created with the Windows Core OS image, and Hyper-V container with the Nano Server OS image.


<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:90%" cellpadding="5" cellspacing="5">
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


# Container Deployment Checklist

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:90%" cellpadding="5" cellspacing="3">
<tr valign="top">
<td width="200"><center>**Action**</center></td>
<td><center>**Information**</center></td>
<tr>

<tr valign="top">
<td>[Install Container Role](#role)</td>
<td>Enables the container feature and installs the container PowerShell module. If deploying the host to Nano Server, see the [Preparing Nano Server](#nano).</td>
<tr>
	
<tr valign="top">
<td>[Install Hyper-V Role](#hypv)</center></td>
<td>Install the Hyper-V Role if the container host will be running Hyper-V containers. If deploying the host to Nano Server, see the [Preparing Nano Server](#nano).</td>
<tr>
	
<tr valign="top">
<td>[Prepare Nano Server](#nano)</td>
<td>If deploying the container host to Nano Server a Nano server image will be prepared with the Hyper-V role and Container feature.</td>
<tr>

<tr valign="top">
<td>[Install OS Images](#img)</td>
<td>Installs OS images which are used as the base for each Windows Container.</td>
<tr>

<tr valign="top">
<td>[Create Virtual Switch](#vswitch)</td>
<td>Each container is connected to a virtual switch for all network communication. The virtual switch is configured as either external or NAT.</td>
<tr>

<tr valign="top">
<td>[Configure NAT](#nat)</td>
<td>If a virtual switch has been configured as type NAT, a NAT object will need to be created.</td>
<tr>

<tr valign="top">
<td>[Enable MAC Spoofing](#mac)</td>
<td>If the container host is running on a Hyper-V virtual machine, enable MAC spoofing on the virtual machines network adapter.</td>
<tr>

<tr valign="top">
<td>[Enable Nested Virtualization](#nest)</td>
<td>If the container host is running on a Hyper-V virtual machine and will also be hosting Hyper-V containers, nested virtualization will need to be enabled.</td>
<tr>

</table>

### <a name=role></a>Install Container Role

The container feature can be installed using Windows Server Manager or PowerShell on Windows Server 2016 with full UI, and PowerShell on Windows Server Core.

To install the role using PowerShell run the following command in an elevated PowerShell session.

```powershell
Install-WindowsFeature containers
```
The system will need to be rebooted when the container role installation has completed.

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

Deploying Nano Server may involve creating a Nano Server ready virtual hard drive which has been prepared with additional feature packages. This guide will quickly detail preparing a Nano Server virtual hard drive, which can be used to create a Container Host.

For more information on Nano Server, and to explore different Nano Server deployment options, see the [Nano Server Documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

Create a folder `c:\nano`.

```powershell
New-Item -ItemType Directory c:\nano
```

Locate the `NanoServerImageGenerator.psm1` and `Convert-WindowsImage.ps1` files from the Nano Server folder, on the Windows Server Media, and copy these to `c:\nano`.

```powershell
Copy-Item "C:\WinServerFolder\NanoServer\Convert-WindowsImage.ps1" c:\nano
Copy-Item "C:\WinServerFolder\NanoServer\NanoServerImageGenerator.ps1" c:\nano
```
Run the following to create a Nano Server virtual hard drive. The `–Containers` parameter indicates that the Container package will be installed, and the –Compute parameter takes care of the Hyper-V package. Hyper-V is only required if Hyper-V container will be created.

```powershell
Import-Module C:\nano\NanoServerImageGenerator.psm1
New-NanoServerImage -MediaPath <insert server media path> -BasePath c:\nano -TargetPath C:\nano\NanoContainer.vhdx -MaxSize 10GB -GuestDrivers -ReverseForwarders -Compute -Containers
```
When completed, create a virtual machine from the NanoContainer.vhdx file.

### Install OS Images

<a name=img></a>An OS image is used as the base to any Windows Server or Hyper-V container. The image is used to deploy a container, which can then be modified, and captured into a new container image. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system. To install the base OS images, follow these steps:

Return a list of images from PowerShell OneGet package manager:
```powershell
Find-ContainerImage
```

Download and install an OS image from the PowerShell OneGet package manager.

```powershell
Install-ContainerImage -Name ImageName
```

Verify that the images have been installed using the `Get-ContainerImage` command.

```powershell
Get-ContainerImage

Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10572.1001 True
WindowsServerCore CN=Microsoft 10.0.10572.1001 True
```  
For more information on Container image management see [Windows Container Images](../management/manage_images.md).
 
### Configure Networking

<a name=vswitch></a>Each container will need to be attached to a virtual switch in order to communicate over a network. A virtual switch is created with the `New-VMSwitch` command. Containers support a virtual switch with tpye `External` or type `NAT`. For more information on container networking see [Windows Container Networking](../management/container_networking.md).

This example creates a virtual switch with the name “Virtual Switch”, a type of NAT, and Nat Subnet of 172.16.0.0/12. 

```powershell
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12
```

<a name=nat></a>In addition to creating the virtual switch, if the switch type is NAT, a NAT object will need to be created. This is completed using the `New-NetNat` command. The NAT object will be used when configuring NAT port mappings.

```powershell
New-NetNat -Name ContainerNat -InternalIPInterfaceAddressPrefix "172.16.0.0/12"


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

<a name=mac></a>Finally, if the container host is running inside of a Hyper-V virtual machine, MAC spoofing must be enable in order for the container to receive an IP Address. To enable MAC spoofing run the following command on the Hyper-V host that is running the Windows Server Container Host.

```powershell
Get-VMNetworkAdapter -VMName <contianer host vm> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### Hyper-V Containers

If Hyper-V containers will be created, the following items will be required.

<a name=hypv></a>Enable the Hyper-V Role. The server will need to be rebooted after Hypre-V has been installed.

```powershell
Install-WindowsFeature hyper-v
```
<a name=nest></a>If the container host is running in a Hyper-V virtual machine, and will be hosting Hyper-V containers, nested virtualization will need to be enabled. Run the following command from the Hyper-V host.

> The virtual machines must be turned off when running this command.

```powershell
Set-VMProcessor -VMName <container host vm> -ExposeVirtualizationExtensions $true
```

### Install Docker

The Docker Daemon and CLI are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker follow the instructions in this article [Docker and Windows](./docker_windows.md).
