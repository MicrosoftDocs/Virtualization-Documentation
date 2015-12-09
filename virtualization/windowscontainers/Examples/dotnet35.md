# Create a .NET 3.5 Server Core Container Image

This guide details creating a Windows Server Core container image that includes the .NET 3.5 framework. Before starting this exercise, you will need the Windows Server 2016 .iso file, or access the Windows Server 2016 media.

## Prepare Media

When deploying .NET 3.5 Framework in Widows Server 2016, the `Microsoft-windows-netfx3-ondemand-package.cab` file is required. This file can be found under the `sources\sxs\` directory of the Windows Server 2016 media. 

Create a directory on the container host named `dotnet35`.

```powershell
New-Item -ItemType Directory c:\dotnet35
```

Copy the `Microsoft-windows-netfx3-ondemand-package.cab` file into this directory. Replace the path below, with the patch to the `Microsoft-windows-netfx3-ondemand-package.cab` file.

```powershell
$file = "d:\sources\sxs\Microsoft-windows-netfx3-ondemand-package.cab"
Copy-Item -Path $file -Destination c:\dotnet35
```	
	
If your container host is running in a Hyper-V virtual machine and was deployed with the provided quick start script, the following script will complete this process.

```powershell
$vm = "<Container Host VM Name>"
$iso = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\") + "\WindowsServerTP4.iso"
Mount-DiskImage -ImagePath $iso
$ISOImage = Get-DiskImage -ImagePath $iso | Get-Volume
$ISODrive = "$([string]$iSOImage.DriveLetter):"
Get-VM -Name $vm | Enable-VMIntegrationService -Name "Guest Service Interface"
Copy-VMFile -Name $vm -SourcePath "$iSODrive\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab" -DestinationPath "C:\dotnet3.5\source\microsoft-windows-netfx3-ondemand-package.cab" -FileSource Host -CreateFullPath
Dismount-DiskImage -ImagePath $iso
```

A container image can now be created that will include the .NET 3.5 framework. This can be completed with either PowerShell or Docker. Examples for both are below.

## Create Image - PowerShell

Has been copied to the virtual machine, a container can be created with a shared folder, which will make the file accessible from within the container itself.

```powershell
New-Container -Name dotnet35 -ContainerImageName windowsservercore -SwitchName “Virtual Switch”
```

Run the following to create a shared folder. Note, the container must be stopped when running the following command.

```powershell
Add-ContainerShareFolder -ContainerName dotnet35 -SourcePath C:\dotnet3.5\source -DestinationPath C:\b\sxs
```

Start the container and run the following command to install .NET 3.5.

```powershell
Start-Container dotnet35
Invoke-Command -ContainerName dotnet35 -ScriptBlock {Add-WindowsFeature -Name NET-Framework-Core -Source C:\b\sxs } -RunAsAdministrator
```

This container now has the .NET 3.5 framework installed. To create an image from this container, run the following on the container host.

```powershell
New-ContainerImage -ContainerName dotnet35 -Name dotnet35 -Publisher Demo -Version 1.0
```

## Create Image - Docker
 
After the cab file is in the VM, now you will need to go to your container host VM and create a dockerfile. Note that these PowerShell commands are done in the container host VM:

```powershell
New-Item C:\dotnet3.5\dockerfile -Force
Notepad C:\dotnet3.5\dockerfile
```

Copy this text into the dockerfile and save it.

```powershell
FROM windowsservercore
ADD source /b/sxs
RUN powershell -Command "& { Add-WindowsFeature -Name NET-Framework-Core -Source C:\b\sxs }"
```

This dockerfile can be used to create a container image that will have the .NET 3.5 framework installed.

```powershell
Docker build -t dotnet35 C:\dotnet3.5\sources\
```

Run “docker images” to see the new image. This image can be used to run a container with the .NET 3.5 framework installed.

```powershell
Docker run -it dotnet35 cmd
```
