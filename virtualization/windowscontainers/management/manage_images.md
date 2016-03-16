---
author: neilpeterson
---

# Container Images

**This is preliminary content and subject to change.** 

Container images are used to deploy containers. These images can include an operating system, applications, and all application dependencies. For instance, you may develop a container image that has been pre-configured with Nano Server, IIS, and an application running in IIS. This container image can then be stored in a container registry for later use, deployed on any Windows Container host (on-prem, cloud, or even to a container service), and also used as the base for a new container image.

There are two types of container images:

- **Base OS Images** – these are provided by Microsoft and include the core OS components. 
- **Container Images** – a custom container image that is derived from a Base OS image.

This document details installing and managing base OS images for both PowerShell and Docker.

## Base OS Images

### Install Image

Container OS images can be found and installed for both PowerShell and Docker management using the ContainerProvider PowerShell module. Before using this module, it will need to be installed. The following command can be used to install the module.

```powershell
PS C:\> Install-PackageProvider ContainerProvider -Force
```

Once installed, a list of Base OS images can be returned using `Find-ContainerImage`.

```powershell
PS C:\> Find-ContainerImage

Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
```

To download and install the Nano Server base OS image, run the following. The `-version` parameter is optional. Without a base OS image version specified, the latest version will be installed.

```powershell
PS C:\> Install-ContainerImage -Name NanoServer -Version 10.0.10586.0

Downloaded in 0 hours, 0 minutes, 10 seconds.
```

Likewise, this command will download and install the Windows Server Core base OS image. The `-version` parameter is optional. Without a base OS image version specified, the latest version will be installed.

> **Issue** Save-ContainerImage and Install-ContainerImage cmdlets may fail to work with a WindowsServerCore container image in a PowerShell remoting session. **Workaround:** Logon to the machine using Remote Desktop and use Save-ContainerImage cmdlet directly.

```powershell
PS C:\> Install-ContainerImage -Name WindowsServerCore -Version 10.0.10586.0

Downloaded in 0 hours, 2 minutes, 28 seconds.
```

Verify that the images have been installed using the `Get-ContainerImage` command.

```powershell
PS C:\> Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
NanoServer        CN=Microsoft 10.0.10586.0 True
WindowsServerCore CN=Microsoft 10.0.10586.0 True
```  

### Offline Installation

Base OS images can also be installed without an internet connection. To do so, the images will be downloaded on a computer with an internet connection, copied to the target system, and then imported using the `Install-ContainerOSImages` command.

Before downloading the Base OS image, prepare the system with the container image provider by running the following command.

```powershell
PS C:\> Install-PackageProvider ContainerProvider -Force
```

Return a list of images from PowerShell OneGet package manager:

```powershell
PS C:\> Find-ContainerImage

Name                 Version                 Description
----                 -------                 -----------
NanoServer           10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
WindowsServerCore    10.0.10586.0            Container OS Image of Windows Server 2016 Techn...
```

To download an image, use the `Save-ContainerImage` command.

```powershell
PS C:\> Save-ContainerImage -Name NanoServer -Destination c:\container-image\NanoServer.wim
```

The downloaded container image can now be copied to a different container host, and installed using the `Install-ContainerOSImage` command.

```powershell
Install-ContainerOSImage -WimPath C:\container-image\NanoServer.wim -Force
```

### Tag Images

When running a Docker command such as `docker run`, the Docker engine by default searches for an image with a version of ‘latest’. The Windows Server Core and Nano Server base OS images will need to be given this tag. To do so, use the `docker tag command`. 

For more information on `docker tag` see [Tag, push, and pull you images on docker.com](https://docs.docker.com/mac/step_six/). 

```powershell
PS C:\> docker tag <image id> windowsservercore:latest
```

When tagged, the output of `docker images` will show two versions of the same image, one with a tag of the image version, and a second with a tag of 'latest'. The image can now be referenced by name.

```powershell
PS C:\> docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14289.1000     df03a4b28c50        2 days ago          783.2 MB
windowsservercore   10.0.14289.1000     290ab6758cec        2 days ago          9.148 GB
windowsservercore   latest              290ab6758cec        2 days ago          9.148 GB
```

### Uninstall OS Image

Container OS images can be uninstalled using the `Uninstall-ContainerOSImage` command. The following example will uninstall the NanoServer OS Image.

```powershell
Get-ContainerImage -Name NanoServer | Uninstall-ContainerOSImage
```

## Container Images PowerShell

### List Images <!--1-->

Run `Get-ContainerImage` to return a list of images on the container host. The container image type is differentiated when with the `IsOSImage` property.

```powershell
PS C:\> Get-ContainerImage

Name              		Publisher    	Version      	IsOSImage
----              		---------    	-------      	---------
NanoServer        		CN=Microsoft 	10.0.10586.0 	True
WindowsServerCore 		CN=Microsoft 	10.0.10586.0 	True
WindowsServerCoreIIS 	CN=Demo   		1.0.0.0 		False

```

### Create New Image <!--1-->

A new container image can be created from any existing container. To do so, use the `New-ContainerImage` command.

```powershell
PS C:\> New-ContainerImage -Container $container -Publisher Demo -Name DemoImage -Version 1.0
```

### Remove Image <!--1-->

Container images cannot be removed if any container, even in a stopped state, has a dependency on the image.

Remove a single image with PowerShell. 

```powershell
PS C:\> Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```

### Image Dependency <!--1-->

When a new image is created, it becomes dependent on the image that it was created from. This dependency can be seen using the `Get-ContainerImage` command. If a parent image is not listed, this indicates that the image is a Base OS image.

```powershell
PS C:\> Get-ContainerImage | select Name, ParentImage

Name              ParentImage
----              -----------
NanoServerIIS     ContainerImage (Name = 'NanoServer') [Publisher = 'CN=Microsoft', Version = '10.0.10586.0']
NanoServer
WindowsServerCore
```

### Move Image Repository 

When a new container image is created using the `New-ContainerImage` command, this image is stored in the default location 'C:\ProgramData\Microsoft\Windows\Hyper-V\Container Image Store'. This repository can be moved using the `Move-ContainerImageRepository` command. For example, the following would create a new container image repository at the location of 'c:\container-images'.

```powershell
Move-ContainerImageRepository -Path c:\container-images
```
> The path used with `Move-ContainerImageRepository` command must not already exist when running the command.

## Container Images Docker

### List Images <!--2-->

```powershell
C:\> docker images

REPOSITORY             TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
windowsservercoreiis   latest              ca40b33453f8        About a minute ago   44.88 MB
windowsservercore      10.0.10586.0        6801d964fda5        2 weeks ago          0 B
nanoserver             10.0.10586.0        8572198a60f1        2 weeks ago          0 B
```

### Create New Image <!--2-->

A new container image can be created from any existing container. To do so, use the `docker commit` command. The following example creates a new container image with the name ‘windowsservercoreiis’.

```powershell
C:\> docker commit 475059caef8f windowsservercoreiis

ca40b33453f803bb2a5737d4d5dd2f887d2b2ad06b55ca681a96de8432b5999d
```

### Remove Image <!--2-->

Container images cannot be removed if any container, even in a stopped state, has a dependency on the image.

When removing an image with docker, the images can be referenced by image name or id.

```powershell
C:\> docker rmi windowsservercoreiis

Untagged: windowsservercoreiis:latest
Deleted: ca40b33453f803bb2a5737d4d5dd2f887d2b2ad06b55ca681a96de8432b5999d
```

### Docker Hub

The Docker Hub registry contains pre-built images which can be downloaded onto a container host. Once these images have been downloaded, they can be used as the base for Windows Container Applications.

To see a list of images available from Docker Hub use the `docker search` command. Note – the Windows Serve Core or Nano Server base OS images will need to be installed before pulling these dependent container images from Docker Hub.

> The images that start with "nano-" have a dependency on the Nano Server Base OS Image.

```powershell
C:\> docker search *

NAME                    DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
microsoft/aspnet        ASP.NET 5 framework installed in a Windows...   1         [OK]       [OK]
microsoft/django        Django installed in a Windows Server Core ...   1                    [OK]
microsoft/dotnet35      .NET 3.5 Runtime installed in a Windows Se...   1         [OK]       [OK]
microsoft/golang        Go Programming Language installed in a Win...   1                    [OK]
microsoft/httpd         Apache httpd installed in a Windows Server...   1                    [OK]
microsoft/iis           Internet Information Services (IIS) instal...   1         [OK]       [OK]
microsoft/mongodb       MongoDB installed in a Windows Server Core...   1                    [OK]
microsoft/mysql         MySQL installed in a Windows Server Core b...   1                    [OK]
microsoft/nginx         Nginx installed in a Windows Server Core b...   1                    [OK]
microsoft/node          Node installed in a Windows Server Core ba...   1                    [OK]
microsoft/php           PHP running on Internet Information Servic...   1                    [OK]
microsoft/python        Python installed in a Windows Server Core ...   1                    [OK]
microsoft/rails         Ruby on Rails installed in a Windows Serve...   1                    [OK]
microsoft/redis         Redis installed in a Windows Server Core b...   1                    [OK]
microsoft/ruby          Ruby installed in a Windows Server Core ba...   1                    [OK]
microsoft/sqlite        SQLite installed in a Windows Server Core ...   1                    [OK]
microsoft/nano-golang   Go Programming Language installed in a Nan...   1                    [OK]
microsoft/nano-httpd    Apache httpd installed in a Nano Server ba...   1                    [OK]
microsoft/nano-iis      Internet Information Services (IIS) instal...   1         [OK]       [OK]
microsoft/nano-mysql    MySQL installed in a Nano Server based con...   1                    [OK]
microsoft/nano-nginx    Nginx installed in a Nano Server based con...   1                    [OK]
microsoft/nano-node     Node installed in a Nano Server based cont...   1                    [OK]
microsoft/nano-python   Python installed in a Nano Server based co...   1                    [OK]
microsoft/nano-rails    Ruby on Rails installed in a Nano Server b...   1                    [OK]
microsoft/nano-redis    Redis installed in a Nano Server based con...   1                    [OK]
microsoft/nano-ruby     Ruby installed in a Nano Server based cont...   1                    [OK]
```

To download an image from Docker Hub, use `docker pull`.

```powershell
C:\> docker pull microsoft/aspnet

Using default tag: latest
latest: Pulling from microsoft/aspnet
f9e8a4cc8f6c: Pull complete

b71a5b8be5a2: Download complete
```

The image will now be visible when running `docker images`.

```powershell
C:\> docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
microsoft/aspnet    latest              b3842ee505e5        5 hours ago         101.7 MB
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
```

### Image Dependency <!--2-->

To see image dependencies with Docker, the `docker history` command can be used.

```powershell
C:\> docker history windowsservercoreiis

IMAGE               CREATED             CREATED BY          SIZE                COMMENT
2236b49aaaef        3 minutes ago       cmd                 171.2 MB
6801d964fda5        2 weeks ago                             0 B
```
