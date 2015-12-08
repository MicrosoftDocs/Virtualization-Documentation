# How to install the .NET 3.5 framework in a container using a Server Core base image

This guide assumes that your container host is in a VM in your physical machine, and that you used the script we provided to set up your container host in a new VM. This is important because the PowerShell commands here will reference the WindowsTP4.iso file that was placed in your Virtual Hard Disk Path. If this is not true for you, you will just need to change the value of “$iso” so that it points to where you have the TP4 iso.
First, you will need to mount the WindowsTP4.iso file, in order to exact the .NET 3.5 cabinet file:

```powershell
$iso = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\") + "\WindowsServerTP4.iso"
Mount-DiskImage -ImagePath $Iso
$ISOImage = Get-DiskImage -ImagePath $iso | Get-Volume
$ISODrive = "$([string]$iSOImage.DriveLetter):"
```

Now, you’ll need to input the name of your container host VM into the $vm variable. These commands will enable the Guest Service Interface in that VM, which will allow us to copy the .NET 3.5 cab file from the mounted ISO to the VM:

```powershell
$vm = <name of your container host VM>
Get-VM -Name $vm | Enable-VMIntegrationService -Name "Guest Service Interface"
Copy-VMFile -Name $vm -SourcePath "$iSODrive\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab" -DestinationPath "C:\dotnet3.5\source\microsoft-windows-netfx3-ondemand-package.cab" -FileSource Host -CreateFullPath
```

You can do the rest through PowerShell or through Docker. This guide shows how to it both ways:


## PowerShell:

After the cab file is in the VM, you will now create a new container, and create a shared folder so the container can see the cab file:

```powershell
New-Container -Name dotnet35 -ContainerImageName windowsservercore -SwitchName “Virtual Switch”
```

Note: the container must not be running for the following command

```powershell
Add-ContainerShareFolder -ContainerName dotnet35 -SourcePath C:\dotnet3.5\source -DestinationPath C:\b\sxs
```

Now we can start the container and run the command to install .NET 3.5:

```powershell
Start-Container dotnet35
Invoke-Command -ContainerName dotnet35 -ScriptBlock {Add-WindowsFeature -Name NET-Framework-Core -Source C:\b\sxs } -RunAsAdministrator
```

You can now have a container with the .NET 3.5 framework installed. To create an image from this container, do:

```powershell
New-ContainerImage -ContainerName dotnet35 -Name dotnet35 -Publisher Demo -Version 1.0
```

## Docker:
 
After the cab file is in the VM, now you will need to go to your container host VM and create a dockerfile. Note that these PowerShell commands are done in the container host VM:

```powershell
New-Item C:\dotnet3.5\dockerfile -Force
Notepad C:\dotnet3.5\dockerfile
```

Now, copy this text into the dockerfile and save it:

```powershell
FROM windowsservercore
ADD source /b/sxs
RUN powershell -Command "& { Add-WindowsFeature -Name NET-Framework-Core -Source C:\b\sxs }"
```

You can now use this dockerfile to create a container image that will have the .NET 3.5 framework installed:

```powershell
Docker build -t dotnet35 C:\dotnet3.5\sources\
```

If you do “docker images” you will now see your new image. You can then use this image to start a container with the .NET 3.5 framework installed:

```powershell
Docker run -it dotnet35 cmd
```
