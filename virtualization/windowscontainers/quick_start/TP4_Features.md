## TP4 Feature Quick Start

This quick start will introduce the following items:
- Hyper-V Container
- Container with Nano Server Base OS Image
- Shared Folder
- Container Resource Constraint

To completed this TP4 Quick Start, you need a physical or virtual system running Windows Server 2016 TP4 (Full UI, Core, or Nano), and the system must meet the nested virtualization requirements for Hyper-V containers.

<Insert link for configuration guide>

<Insert link for Hyper-V requirements>

## Create Hyper-V Container

At the time of TP4 Hyper-V containers must use a Nano Server Core OS Image. To validate that the Nano Server Core OS image has been installed on the Container Host, use the **Get-ContainerImage** command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10586.1000 True
WindowsServerCore CN=Microsoft 10.0.10586.1000 True
```

To create a Hyper-V container use the **New-Container** command specifying a Runtime of HyperV.

```powershell
PS C:\> $con = New-Container -Name HYPV -ContainerImageName NanoServer -SwitchName "Virtual Switch" -RuntimeType HyperV
```

When the container has been created, do not start it.

For more information on managing Windows Containers, see the Managing Containers Technical Guide - <>

## Create a Shared Folder

Create a folder at the root of your container named ‘shared’.
```powershell
PS C:\> New-Item -Type Directory c:\share
```

Windows Container Shared Folders provide a way of sharing data between both the container host and container and between containers themselves. We will use a shared folder during this exercise to copy files into a container which will be used to configure an application.

Use the **Add-ContainerSharedFolder** command to create a shared folder.

> The container must be in a stopped stated when creating the shared folder.

```powershell
PS C:\> Add-ContainerSharedFolder -Container $con -SourcePath c:\share -DestinationPath c:\share
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
HYPV          c:\share   c:\share        ReadWrite
```

When the shared folder has been created, start the container.
```powershell
Start-Container $con
```
Create a PowerShell remote session with the container using the **Enter-PSSession** command.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```
When in the remote session, notice that a directory has been created ‘c:\share’, and that you can now copy files into the c:\share directory of the host and access them in the container.


For more information on Shared Folder, see the Shred Folders Technical Guide <>

## Install IIS in the Container

Because your container is running a Windows Server Nano OS Image, to install IIS we will need to use IIS packages for Nano Server.

The IIS packages can be found on the Windows Sever Installation media under the NanoServer\Packages directory.

```powershell
D:\NanoServer\Packages
```
Copy the Microsoft-NanoServer-IIS-Package.cab from NanoServer\Packages to c:\source on your container host. Next copy NanoServer\Packages\en-us\Microsoft-NanoServer-IIS-Package.cab to c:\source\en-us on your container host.

Alternatively, use this script to complete this for you. Replace the **mediaPath** value with that of the Windows Server Media

```powershell
<insert script>
```
