# Container Requirements and Deployment

The Windows Container feature is on only available with Windows Server 2016 (Full, Core, and Nano Server). Within the Windows Container feature is two different container types, each with slightly different behavior and requirements. The two container types are:

- Windows Server Containers –provide application isolation through namespace and process isolation.
- Hyper-V Containers – provide application isolation through hosting the container in a super optimized virtual machine. Hyper-V Containers require Hyper-V to be installed on the containers host.

Both container types use a container OS Image during container deployment. A Base OS Image provides the foundational container configuration. At the time of Windows Server Technical Preview 4, two base OD images are available, Windows Server Core and Nano Server. Also at the TP4 release there are limitations between container host, container type, and OS Image compatibility. The following table describes the supported configuiration.

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


## Container Deployment Checklist

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:90%" cellpadding="8" cellspacing="3">
<tr valign="top">
<td width="200"><center>**Action**</center></td>
<td><center>**Information**</center></td>
<tr>

<tr valign="top">
<td><center>Install Container Feature</center></td>
<td>The container feature needs to be installed in order to create and manage containers. This feature also installs the container PowerShell module.<br /><br />
<ul><li>[Windows Server](#role) - install container role on Windows Server and Window Server Core.</li>
<li>[Nano Server](#nano) - prepare a Nano Server image with the container feature.</li>
<ul>
</td>
<tr>

<tr valign="top">
<td><center>Configure Hyper-V Role</center></td>
<td>The Hyper-V role is required if the container host will be running Hyper-V container.<br /><br />
<ul><li>[Enable Nested Virtualization](#nest) – if the container host is running on a Hyper-V virtual machine.</li>
<li>[Install Hyper-V Role](#hypv) - on Windows Serever and Windows Server Core.</li>
<li>[Nano Server](#nano) - Hyper-V is installed when creating the Nano Server Image.</li>
</ul>
</td>
<tr>
	
<tr valign="top">
<td><center>Install OS Images</center></td>
<td>OS images provide the base for all Windows Containers. OS images have been created with both Windows Server Core and Nano Server. The installation of OS images is identical for Windows Server and Nano Server.<br /><br />
<ul><li>[Install OS Images](#img)</li><ul>
</td>
<tr>

<tr valign="top">
<td><center>Configure Networking</center></td>
<td>The following networking items are required for Windows Containers.<br /><br />
<ul><li>[Create Virtual Switch](#vswitch) - Each container is connected to a virtual switch for all network communication. The virtual switch is configured as either external or NAT.
<li>[Configure Network Address Translation (NAT)](#nat) - If a virtual switch has been configured as type NAT, a NAT object will need to be created.
<li>[Enable MAC Spoofing](#mac) – if the container host is a Hyper-V virtual machine, MAC spoofing will need to be enabled.
</ul>
</td>
<tr>

<tr valign="top">
<td><center>Install Docker</center></td>
<td>The Docker daemon and CLI will need to be installed if Docker will be used as the container management tool.<br /><br />
<ul><li>[Install Docker](#docker)</li></ul>
</td>
<tr>

</table>

### <a name=role></a>Install Container Feature

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

### Configure Hyper-V

Two scenarios need to be considered in regard to Hyper-V and Windows Containers.

- The container host will be hosting Hyper-V containers.
- The container host itself is a Hyper-V virtual machine.

If Hyper-V containers will be hosted on the container host, the Hyper-V role will need to be installed. This can be completed on Windows Server 2016 or Windows Server 2016 Core using the following PowerShell command. For Nano Server Configuration, see [Prepare Nano Server](#nano).

```powershell
Install-WindowsFeature hyper-v
```

<a name=nest></a>If the container host itself is a Hyper-V virtual machine, and will also be hosting Hyper-V containers, nested virtualization will need to be enabled before the Hyper-V role can be installed. This can be completed with the following PowerShell Command.

> The virtual machines must be turned off when running this command.

```powershell
Set-VMProcessor -VMName <container host vm> -ExposeVirtualizationExtensions $true
```

### <a name=img></a>Install OS Images

An OS image is used as the base to any Windows Server or Hyper-V container. The image is used to deploy a container, which can then be modified, and captured into a new container image. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system. To install the base OS images, follow these steps:

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

### <a name=docker></a>Install Docker

The Docker Daemon and CLI are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker follow the instructions in this article [Docker and Windows](./docker_windows.md).
