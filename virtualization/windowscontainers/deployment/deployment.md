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

Verify that the images have been installed using the **Get-ContainerImage** command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10572.1001 True
WindowsServerCore CN=Microsoft 10.0.10572.1001 True
```  
For more information on Container image management see [Windows Container Images](../management/manage_images.md).
 
### Create Virtual Switch

Each container will need to be attached to a virtual switch in order to communicate over a network. This exercise demonstrates this process using a virtual switch configured with network address translation enabled. For more information on container networking see [Windows Container Networking] (<>).
Create the virtual switch using the **New-VirtualSwitch** command.

```powershell
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12
```

### Install Docker in Windows

The Docker Daemon and CLI are not shipped with Windows, and not installed with the Windows Container feature. Docker is not a requirement for working with Windows containers. If you would like to install Docker follow the instructions in this article [Docker and Windows](./docker_windows.md).

## Deploy Contianer Host Nano Server

Deploying Nano Server may involve creating a Nano Server ready virtual hard drive which has been prepared with additional feature packages. This guide will detail quickly preparing a Nano Server VHDX that can be used to create a Windows Container ready virtual machine running Nano Server.
For more information on Nano Server and to explore different Nano Server deployment options see the [Nano Server Documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

### Create Contianer Ready VHD

Create a folder **c:\nano**.
```powershell
New-Item -ItemType Directory c:\nano
```

Locate the **NanoServerImageGenerator.psm1** and **Convert-WindowsImage.ps1** files from the Nano Server folder on the Windows Server Media and copy these to c:\nano.

```powershell
Copy-Item "C:\WinServerFolder\NanoServer\Convert-WindowsImage.ps1" c:\nano
Copy-Item "C:\WinServerFolder\NanoServer\NanoServerImageGenerator.ps1" c:\nano
```
Run the following to create a Hyper-V and Container ready Nano Server virtual hard drive. Note – Hyper-V is only a requirement if you will be creating Hyper-V containers.

```powershell
Import-Module C:\nano\NanoServerImageGenerator.psm1
New-NanoServerImage -MediaPath "C:\WinServerFolder" -BasePath c:\nano -TargetPath C:\nano\NanoContainer.vhdx -MaxSize 10GB -GuestDrivers -ReverseForwarders -Compute -Containers
```
When completed create a virtual machine from the NanoContainer.vhdx file. This virtual machine will be ready to go with the Containers feature.

### Install OS Image

You will need to install a Container OS Image onto the Nano Server container host in order to create containers. Because Nano Server does not allow local logon, a remote PS Session will be created with the Nano Server Container Host. This document will quickly detail creating the remote session, more details can be found at the [Nano Server Documentation]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

Run the following commands to create a remote PowerShell session with the Nano server. You will be prompted for the Administrator password.

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts "<IP address of Nano Server>" -Force
Enter-PSSession -ComputerName <IP address of Nano Server> -Credential ~\Administrator
```

Return a list of images from PowerShell OneGet package manager:
```powershell
Find-ContainerImage
```
Download and install an OS image from the PowerShell OneGet package manager. NOTE - At the time of TP4 only a Nano Server OS image is supported on a Nano Server host, you will not need to install the Windows Server Core OS image.

```powershell
Install-ContainerImage -Name ImageName
```

Verify that the images have been installed using the **Get-ContainerImage** command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10572.1001 True
```  

### Create Virtual Switch

In the remote PowerShell session with the Nano Server, create a virtual switch that will be used by the containers. This example creates a virtual switch with a type of NAT and a NAT subnet of 172.16.0.0. For more information on container network see [Manage Container Networking](../management/container_networking.md).

```powershell
New-VMSwitch -Name NAT -SwitchType NAT -NATSubnetAddress "172.16.0.0/12"
```

### Install Docker in Nano Server 

