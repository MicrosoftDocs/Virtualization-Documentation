ms.ContentId: a7b0cbb8-05d4-4f43-b5e1-7f3d8d83cce1
title: Container Feature Deployment

# Windows Container Host Deployment and Configuration.

The Windows Container feature is only available in Windows Server 2016. The container role can be installed on Windows Server 2016, Windows Server 2016 Core and Nano Server. The Windows Container feature includes support for two different types of container, Windows Server Containers and Hyper-V Containers. This document will detail supported configurations and deployment steps. 

# Host and OS Image 

OS Images form the base of any Windows Container and are available as both Windows Server Core and Nano Server. At the Technical Preview Release 4, the following OS Image / Host Configurations are avlaiable. 

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
<td><center> OS Image</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Nano</center></td>
<td><center> Os Image</center></td>
<td><center>Nano OS Image</center></td>
<tr>
</table>
</center>

## Requirements for Windows Server Containers.

## Requirements for Hyper-V Containers.

## Prepare Windows for Containers

Preparing Windows Server 2016 TP4 for Windows Server and Hyper-V containers involves a few different steps. This document walks through performing these steps using PowerShell. The following steps will be completed:

- Install the container role.
- Install the Base OS Images for both Nano Server and Server Core.
- Create a virtual switch that will be used by the containers.
- Prepare the Docker daemon and client, this step only need to be completed if you will be using Docker to create and manage Windows containers.

## Install the Container Role

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
## Install the Base OS Images

A base OS image is used as the base image in any Windows Server or Hyper-V containers. The images are used to create a container, which can then be modified, and captured into a new container image. Base OS images have been created with both Windows Server Core and Nano Server as the underlying operating system. To install the base OS images, follow these steps:

Download the Base OS images from <> and copy them to a folder on your container host. You can also run the following PowerShell command to download the images and place them at the root of the container host:

```powershell
<insert commands>
```
Once the base OS images have been downloaded and copied to the container host, they need to be installed. This will require PowerShell. Run the following command to install the Windows Server Core base OS images:

```powershell
Install-ContainerOSImages –WimPath <> –Force
```
And the following command to install the Nano Server base OS image:

```powershell
Install-ContainerOSImages –WimPath <> –Force
```

You can verify that the images have been installed using the **Get-ContainerImage** command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10572.1001 True
WindowsServerCore CN=Microsoft 10.0.10572.1001 True
```  
 
## Create A Virtual Switch for the Containers

Each container will need to be attached to a virtual switch in order to communicate over a network. This exercise demonstrates this process using a virtual switch configured with network address translation enabled. For more information on container networking see [Windows Container Networking] (<>).
Create the virtual switch using the **New-VirtualSwitch** command.

```powershell
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12
```