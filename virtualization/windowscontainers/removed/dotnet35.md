---
author: enderb-ms
redirect_url: https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples
---


# Create a .NET 3.5 Server Core Container Image

This guide details creating a Windows Server Core container that includes the .NET 3.5 framework. Before starting this exercise, you will need the Windows Server 2016 .iso file, or access the Windows Server 2016 media.

## Prepare Media

Before creating a .NET 3.5 enabled container image, the .NET 3.5 package needs to be staged for use within a container. For this example, the `Microsoft-windows-netfx3-ondemand-package.cab` file will be copied from the Windows Server 2016 media to the container host.

Create a directory on the container host named `dotnet3.5\source`.

```powershell
New-Item -ItemType Directory c:\dotnet3.5\source
```

Copy the `Microsoft-windows-netfx3-ondemand-package.cab` file into this directory. This file can be found under the sources\sxs folder of the Windows Server 2016 media.

```powershell
$file = "d:\sources\sxs\Microsoft-windows-netfx3-ondemand-package.cab"
Copy-Item -Path $file -Destination c:\dotnet3.5\source
```	
	
Alternatively, if your container host is running in a Hyper-V virtual machine, and was deployed with a quick start script, the following can be run. Note, this is run on the Hyper-V host and not the container host. 

```powershell
$vm = "<Container Host VM Name>"
$iso = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\") + "\WindowsServerTP4.iso"
Mount-DiskImage -ImagePath $iso
$ISOImage = Get-DiskImage -ImagePath $iso | Get-Volume
$ISODrive = "$([string]$iSOImage.DriveLetter):"
Get-VM -Name $vm | Enable-VMIntegrationService -Name "Guest Service Interface"
Copy-VMFile -Name $vm -SourcePath "$iSODrive\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab" -DestinationPath "c:\dotnet3.5\source\microsoft-windows-netfx3-ondemand-package.cab" -FileSource Host -CreateFullPath
Dismount-DiskImage -ImagePath $iso
```

A container image can now be created that will include the .NET 3.5 framework. This can be completed with either PowerShell or Docker. Examples for both are below.

## Create Image - PowerShell

To create a new image using PowerShell, a container will be created, modified with all desired changes, and then captured into a new image.

Create a new container form the Windows Server Core base image.

```powershell
New-Container -Name dotnet35 -ContainerImageName windowsservercore -SwitchName "Virtual Switch"
```

Create a shared folder with the new container. This will be used to make the .NET 3.5 cab file accessible inside of the new container.  Note, the container must be stopped when running the following command.

```powershell
Add-ContainerSharedFolder -ContainerName dotnet35 -SourcePath C:\dotnet3.5\source -DestinationPath c:\sxs
```

Start the container and run the following command to install .NET 3.5.

```powershell
Start-Container dotnet35
Invoke-Command -ContainerName dotnet35 -ScriptBlock {Add-WindowsFeature -Name NET-Framework-Core -Source c:\sxs} -RunAsAdministrator
```

When the installation has completed, stop the container.

```powershell
Stop-Container dotnet35
```

To create an image from this container, run the following on the container host.

```powershell
New-ContainerImage -ContainerName dotnet35 -Name dotnet35 -Publisher Demo -Version 1.0
```

Run `Get-ContainerImages` to see the new image. This image can now be used to run a container with the .NET 3.5 framework pre-installed.

```powershell
Get-ContainerImages
```

## Create Image - Docker
 
To create a new image using Docker, a dockerfile will be create with instructions on how to create the new image. This dockerfile will then be run, which will result in a new container image. Note, the following commands are run on the container host VM.

Create a dockerfile and open it in notepad.

```powershell
New-Item C:\dotnet3.5\dockerfile -Force
Notepad C:\dotnet3.5\dockerfile
```

Copy this text into the dockerfile and save it.

```powershell
FROM windowsservercore
ADD source /sxs
RUN powershell -Command "& {Add-WindowsFeature -Name NET-Framework-Core -Source c:\sxs}"
```

Run `docker build` which will consume the dockerfile and create the new container image.

```powershell
Docker build -t dotnet35 C:\dotnet3.5\
```

Run `docker images` to see the new image. This image can now be used to run a container with the .NET 3.5 framework pre-installed.

```powershell
docker images
```
