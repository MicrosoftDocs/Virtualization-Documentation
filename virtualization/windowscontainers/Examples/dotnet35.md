# Create a .NET 3.5 Server Core Container Image

This guide details creating a Windows Server Core container that includes the .NET 3.5 framework. Before starting this exercise, you will need the Windows Server 2016 .iso file, or access the Windows Server 2016 media.

## Prepare Media

When deploying the .NET 3.5 Framework in Widows Server 2016, the `Microsoft-windows-netfx3-ondemand-package.cab` file is required. This file can be found under the `sources\sxs\` directory of the Windows Server 2016 media. 

Create a directory on the container host named `dotnet35`.

```powershell
New-Item -ItemType Directory c:\sources\sxs
```

Copy the `Microsoft-windows-netfx3-ondemand-package.cab` file into this directory. Replace the path seeen below, with the patch to the `Microsoft-windows-netfx3-ondemand-package.cab` file.

```powershell
$file = "d:\sources\sxs\Microsoft-windows-netfx3-ondemand-package.cab"
Copy-Item -Path $file -Destination c:\sources\sxs
```	
	
If your container host is running in a Hyper-V virtual machine, and was deployed with the provided quick start script, the following can be run, which will copy this file, to the container host, using a pre-existing copy of the Windows Server 2016 media.  

```powershell
$vm = "<Container Host VM Name>"
$iso = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\") + "\WindowsServerTP4.iso"
Mount-DiskImage -ImagePath $iso
$ISOImage = Get-DiskImage -ImagePath $iso | Get-Volume
$ISODrive = "$([string]$iSOImage.DriveLetter):"
Get-VM -Name $vm | Enable-VMIntegrationService -Name "Guest Service Interface"
Copy-VMFile -Name $vm -SourcePath "$iSODrive\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab" -DestinationPath "c:\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab" -FileSource Host -CreateFullPath
Dismount-DiskImage -ImagePath $iso
```

A container image can now be created, which will include the .NET 3.5 framework. This can be completed with either PowerShell or Docker. Examples for both are below.

## Create Image - PowerShell

With the .NET 3.5 cab file copied to the container host, a container can be created with a shared folder, which will make the file accessible from within the container itself.

```powershell
New-Container -Name dotnet35 -ContainerImageName windowsservercore -SwitchName “Virtual Switch”
```

Run the following to create a shared folder. Note, the container must be stopped when running the following command.

```powershell
Add-ContainerShareFolder -ContainerName dotnet35 -SourcePath c:\sources\sxs -DestinationPath c:\sources\sxs
```

Start the container and run the following command to install .NET 3.5.

```powershell
Start-Container dotnet35
Invoke-Command -ContainerName dotnet35 -ScriptBlock {Add-WindowsFeature -Name NET-Framework-Core -Source c:\sources\sxs } -RunAsAdministrator
```

This container now has the .NET 3.5 framework installed. To create an image from this container, run the following on the container host.

```powershell
New-ContainerImage -ContainerName dotnet35 -Name dotnet35 -Publisher Demo -Version 1.0
```

## Create Image - Docker
 
With the .NET 3.5 cab file copied to the container host, Docker can be used to create a container image, which will also include the .NET 3.5 Framework. Note, the following commands are run on the container host VM.

The creation of the container image will be automated using a dockerfile.

Create a dockerfile and open it in notepad.

```powershell
New-Item C:\dotnet35\dockerfile -Force
Notepad C:\dotnet35\dockerfile
```

Copy this text into the dockerfile and save it.

```powershell
FROM windowsservercore
ADD source /source/sxs
RUN powershell -Command "& { Add-WindowsFeature -Name NET-Framework-Core -Source c:\sources\sxs }"
```

This dockerfile can be used to create a container image that will have the .NET 3.5 framework installed.

```powershell
Docker build -t dotnet35 C:\dotnet35\
```

Run “docker images” to see the new image. This image can be used to run a container with the .NET 3.5 framework installed.

```powershell
Docker run -it dotnet35 cmd
```
