---
title: Container Deployment Quick Start - Images
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05//2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 479e05b1-2642-47c7-9db4-d2a23592d29f
---

# Container Images - Quick Start

**This is preliminary content and subject to change.** 

Container images are used to deploy containers. These images can include an operating system, applications, and all application dependencies. For instance, you may develop a container image that has been pre-configured with Nano Server, IIS, and an application running in IIS. This container image can then be stored in a container registry for later use, deployed on any Windows container host (on-prem, cloud, or even to a container service), and also used as the base for a new container image.

There are two types of container images:

**Base OS Images** – these are provided by Microsoft and include the core OS components. 

**Container Images** – a custom container image that is derived from a Base OS image.

## Base OS images

### Install Images

Container OS images can be found and installed using the ContainerImage PowerShell module. Before using this module, it will need to be installed. The following command can be used to install the module. For more information on using the Container Image OneGet PowerShell module see, [Container Image Provider](https://github.com/PowerShell/ContainerProvider). 

```none
Install-PackageProvider ContainerImage -Force
```

Once installed, a list of Base OS images can be returned using `Find-ContainerImage`.

```none
Find-ContainerImage

Name                 Version          Source           Summary
----                 -------          ------           -------
NanoServer           10.0.14300.1010  ContainerImag... Container OS Image of Windows Server 2016 Technical...
WindowsServerCore    10.0.14300.1000  ContainerImag... Container OS Image of Windows Server 2016 Technical...
```

To download and install the Nano Server base OS image, run the following. The `-version` parameter is optional. Without a base OS image version specified, the latest version will be installed.

```none
Install-ContainerImage -Name NanoServer -Version 10.0.14300.1010
```

Likewise, this command will download and install the Windows Server Core base OS image. The `-version` parameter is optional. Without a base OS image version specified, the latest version will be installed.

```none
Install-ContainerImage -Name WindowsServerCore -Version 10.0.14300.1000
```

Verify that the images have been installed using the `docker images` command. 

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     40356b90dc80        2 weeks ago         793.3 MB
windowsservercore   10.0.14304.1000     7837d9445187        2 weeks ago         9.176 GB
```  

> If the Base OS image is downloaded, but is not shown when running `docker images`, restart the Docker service using the services control panel applet or the command 'sc docker stop' and then 'sc docker start'

### Tag images

After installing the Windows Server Core or Nano Server Base OS images, these will need to be tagged with a version of ‘latest’. To do so, use the `docker tag` command. 

For more information on `docker tag` see [Tag, push, and pull you images on docker.com](https://docs.docker.com/mac/step_six/). 

```none
docker tag <image id> windowsservercore:latest
```

When tagged, the output of `docker images` will show two versions of the same image, one with a tag of the image version, and a second with a tag of 'latest'. The image can now be referenced by name.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     df03a4b28c50        2 days ago          783.2 MB
windowsservercore   10.0.14300.1000     290ab6758cec        2 days ago          9.148 GB
windowsservercore   latest              290ab6758cec        2 days ago          9.148 GB
```

## Next Steps

[Windows Server Containers - Quick Start](./manage_docker.md)  
[Hyper-V Containers - Quick Start](./manage_docker_hyperv.md)

