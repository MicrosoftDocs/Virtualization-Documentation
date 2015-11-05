# Windows Container Host Deployment and Configuration.

The Windows Container feature is only available in Windows Server 2016. The container role can be installed on Windows Server 2016, Windows Server 2016 Core and Nano Server. The Windows Container feature includes support for two different types of container, Windows Server Containers and Hyper-V Containers. This document will detail supported configurations and deployment steps. 

## Windows Container Deployment

The Windows Container feature is only available in Windows Server 2016. The container feature can be installed on Windows Server 2016, Windows Server 2016 Core and Nano Server. The Container feature includes support for two different types of containers, Windows Server Containers and Hyper-V Containers, both of which have slightly different configuation requirements. This document will detail configuration requirements, deployment, and configuration of the Windows Containers feature.

### Host and Image Support
 
 The Windows Server Technical Preview 4 supports the following Host and Base OS configurations. 

<center>
<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:80%" cellpadding="15" cellspacing="3">
<tr valign="top">
<td><center>**Host Operating System**</center></td>
<td><center>**Windows Server Container**</center></td>
<td><center>**Hyper-V Contianer**</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016</center></td>
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
</center>

## Deploy Contianer Host Windows Server and Server Core

### Install the Container Role

The container role can be installed using Windows Server Manage (Full server only) or PowerShell (Full and Core), and using a nano package on Nano Server.  

To install the role using PowerShell run the following command in a PowerShell session.
```powershell
Install-WindowsFeature containers
```
The system will need to be rebooted when the container role installation has completed.

Use the **Get-ContainerHost** command to verify that the container role has successfully been installed:

```powershell
PS C:\> Get-ContainerHost
Name            ContainerImageRepositoryLocation
----            --------------------------------
WIN-LJGU7HD7TEP C:\ProgramData\Microsoft\Windows\Hyper-V\Container Image Store
```
### Install OS Images

An OS image is used as the base to any Windows Server or Hyper-V containers. The image is used to deploy a container, which can then be modified, and captured into a new container image. OS images have been created with both Windows Server Core and Nano Server as the underlying operating system. To install the base OS images, follow these steps:

Return a list of images from PowerShell OneGet package manager:
```powershell
Find-ContainerImage
```

Download and install an OS image from the PowerShell OneGet package manager.

```powershell
Install-ContainerImage -Name ImageName
```

You can verify that the images have been installed using the **Get-ContainerImage** command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10572.1001 True
WindowsServerCore CN=Microsoft 10.0.10572.1001 True
```  
For more information on Container image management see [Windows Container Images](./manage_images.md).
 
### Create Virtual Switch

Each container will need to be attached to a virtual switch in order to communicate over a network. This exercise demonstrates this process using a virtual switch configured with network address translation enabled. For more information on container networking see [Windows Container Networking] (<>).
Create the virtual switch using the **New-VirtualSwitch** command.

```powershell
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12
```

### Install Docker in Windows

The Docker Daemon and CLI are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker follow the instructions in this article [Docker and Windows](./docker_windows.md).

## Deploy Contianer Host Nano Server

### Create Contianer Ready VHD

### Install OS Image

### Create Virtual Switch

### Install Docker in Nano Server 
