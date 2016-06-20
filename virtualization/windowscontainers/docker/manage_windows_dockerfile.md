---
title: Dockerfile and Windows Containers
description: Create Dockerfiles for Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 75fed138-9239-4da9-bce4-4f2e2ad469a1
---

# Dockerfile on Windows

**This is preliminary content and subject to change.** 

The Docker engine includes tools for automating the creation of container images. While container images can be created manually using the `docker commit` command, adopting an automated image creation process provides many benefits including:

- Storing container images as code.
- Rapid and precise recreation of container images for maintenance and upgrade purposes.
- Continuous integration between container images and the development cycle.

The Docker components that drive this automation are the Dockerfile, and the `docker build` command.

- **Dockerfile** – a text file containing the instruction needed to create a new container image. These instructions include identification of an existing image to be used as a base, commands to be run during the image creation process, and a command that will run when new instances of the container image are deployed.
- **Docker build** - the Docker engine command that consumes a Dockerfile, and triggers the image creation process.

This document will introduce using a Dockerfile with Windows containers, discuss syntax, and detail commonly used Dockerfile instructions. 

Throughout this document, the concept of container images and container image layers will be discussed. For more information on images and image layering see [Manage Windows Container Images](../management/manage_images.md). 

For a complete look at Dockerfiles, see the [Dockerfile reference at docker.com]( https://docs.docker.com/engine/reference/builder/).

## Dockerfile Introduction

### Basic Syntax

In its most basic form, a Dockerfile can be very simple. The following example creates a new image, which includes IIS, and a ‘hello world’ site. This example includes comments (indicated with a `#`), that explain each step. Subsequent sections of this article will go into more detail on Dockerfile syntax rules, and Dockerfile instructions.

```none
# Sample Dockerfile

# Indicates that the windowsservercore image will be used as the base image.
FROM windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER jshelton@contoso.com

# Uses dism.exe to install the IIS role.
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart

# Creates an html file and adds content to this file.
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html

# Sets a command or process that will run each time a container is run from the new image.
CMD [ "cmd" ]
```

For additional examples of Dockerfiles for Windows, see the [Dockerfile for Windows Repository] (https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples).

## Instructions

Dockerfile instructions provide the Docker Engine with the steps needed to create a container image. These instructions are performed in order, and one-by-one. Here are the details for some basic Dockerfile instructions. For a complete list of Dockerfile instructions, see [Dockerfile Reference on Docker.com] (https://docs.docker.com/engine/reference/builder/).

### FROM

The `FROM` instruction, sets the container image that will be used during the new image creation process. For instance, when using the instruction `FROM windowsservercore`, the resulting image is derived from, and has a dependency on, the Windows Server Core base OS image. If the specified image is not present on the system where the Docker build process is being run, the Docker engine will attempt to download the image from a public or private image registry.

**Format**

The FROM instruction takes a format of: 

```
FROM <image>
```

**Example**

```
FROM windowsservercore
```

For detailed information on the FROM instruction, see the [FROM Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#from). 

### RUN

The `RUN` instruction specifies commands to be run, and captured into the new container image. These commands can include items such as installing software, creating files and directories, and creating environment configuration.

**Format**

The RUN instruction takes a format of: 

```none
# exec form

RUN ["<executable", "<param 1>", "<param 2>"

# shell form

RUN <command>
```

The difference between the exec and shell form, is in how the `RUN` instruction is executed. When using the exec form, the specified program is run explicitly. 

The following example used the exec form.

```none
FROM windowsservercore

RUN ["powershell", "New-Item", "c:/test"]
```

Examining the resulting image, the command that was run is `powershell new-item c:/test`.

```none
docker history doc-exe-method

IMAGE               CREATED             CREATED BY                    SIZE                COMMENT
b3452b13e472        2 minutes ago       powershell New-Item c:/test   30.76 MB
```

To contrast, the following example runs the same operation, however using the shell form.

```none
FROM windowsservercore

RUN powershell new-item c:\test
```

Which results in a run instruction of `cmd /S /C powershell new-item c:\test`. 

```none
docker history doc-shell-method

IMAGE               CREATED             CREATED BY                              SIZE                COMMENT
062a543374fc        19 seconds ago      cmd /S /C powershell new-item c:\test   30.76 MB
```

**Windows Considerations**
 
On Windows, when using the `RUN` instruction with the exec format, backslashes must be escaped.

```none
RUN ["powershell", "New-Item", "c:\\test"]
```

**Examples**

This example uses DISM to install IIS in the container image.
```none
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart
```

This example installs the Visual Studio redistributable package.
```none
RUN powershell.exe -Command c:\vcredist_x86.exe /quiet
``` 

For detailed information on the RUN instruction, see the [RUN Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#run). 

### COPY

The `COPY` instruction copies files and directories to the filesystem of the container. The files and directories need to be in a path relative to the Dockerfile.

**Format**

The `COPY` instruction takes a format of: 

```none
COPY <source> <destination>
``` 

If either source or destination include whitespace, enclose the path in square brackets and double quotes.
 
```none
COPY ["<source>" "<destination>"]
```

**Windows Considerations**
 
On Windows, the destination format must use forward slashes. For example, these are valid `COPY` instructions.

```none
COPY test1.txt /temp/
COPY test1.txt c:/temp/
```

However, the following will not work.

```none
COPY test1.txt c:\temp\
```

**Examples**

This example adds the contents of the source directory, to a directory named `sqllite` in the container image.
```none
COPY source /sqlite/
```

This example will add all files that begin with config, to the `c:\temp` directory of the container image.
```none
COPY config* c:/temp/
```

For detailed information on the `COPY` instruction, see the [COPY Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#copy).

### ADD

The ADD instruction is very much like the COPY instruction; however, it includes additional capabilities. In addition to copying files from the host into the container image, the `ADD` instruction can also copy files from a remote location with a URL specification.

**Format**

The `ADD` instruction takes a format of: 

```none
ADD <source> <destination>
``` 

If either source or destination include whitespace, enclose the path in square brackets and double quotes.
 
```none
ADD ["<source>" "<destination>"]
```

**Windows Considerations**
 
On Windows, the destination format must use forward slashes. For example, these are valid `ADD` instructions.

```none
ADD test1.txt /temp/
ADD test1.txt c:/temp/
```

However, the following will not work.

```none
ADD test1.txt c:\temp\
```

Additionally, on Linux the `ADD` instruction will expand compressed packages on copy. This functionality is not available in Windows.

**Examples**

This example adds the contents of the source directory, to a directory named `sqllite` in the container image.
```none
ADD source /sqlite/
```

This example will add all files that begin with config, to the `c:\temp` directory of the container image.
```none
ADD config* c:/temp/
```

This example will download Python for Windows into the `c:\temp` directory of the container image.
```none
ADD https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe /temp/python-3.5.1.exe
```

For detailed information on the `ADD` instruction, see the [ADD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#add). 

### WORKDIR

The `WORKDIR` instruction, sets a working directory for other Dockerfile instructions, such as `RUN`, `CMD`, and also the working directory for running instances of the container image.

**Format**

The `WORKDIR` instruction takes a format of: 

```none
WORKDIR <path to working directory>
``` 

**Windows Considerations**

On Windows, if the working directory includes a backslash, it must be escaped.

```none
WORKDIR c:\\windows
```

**Examples**

```none
WORKDIR c:\\Apache24\\bin
```

For detailed information on the `WORKDIR` instruction, see the [WORKDIR Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#workdir). 

### CMD

The `CMD` instruction, sets the default command to be run when deploying an instance of the container image. For instance, if the container will be hosting an NGINX web server, the `CMD` might include instructions to start the web server, such as `nginx.exe`. If multiple `CMD` instructions are specified in a Dockerfile, only the last is evaluated.

**Format**

The `CMD` instruction takes a format of: 

```none
# exec form

CMD ["<executable", "<param>"]

# shell form

CMD <command>
```

**Windows Considerations**

On Windows, file paths specified in the `CMD` instruction must use forward slashes or have escaped backslashes `\\`. For example, these are valid `CMD` instructions.

```none
# exec form

CMD ["c:\\Apache24\\bin\\httpd.exe", "-w"]

# shell form

CMD c:\\Apache24\\bin\\httpd.exe -w
```
However, the following will not work.

```none
CMD c:\Apache24\bin\httpd.exe -w
```

For detailed information on the `CMD` instruction, see the [CMD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#cmd). 

## PowerShell in Dockerfile

### PowerShell Commands

Powershell commands can be run in a Dockerfile using the `RUN` operation. 

```none
FROM windowsservercore

RUN powershell -command Expand-Archive -Path c:\apache.zip -DestinationPath c:\
```

### REST Calls

PowerShell, and the `Invoke-WebRequest` command, can be useful when gathering information or files from a web service. For instance, if building an image that includes Python, the following example could be used.

```none
FROM windowsservercore

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

> Invoke-WebRequest is not currently supported in Nano Server

Another option for using PowerShell to download files during the image creation process is to use the .Net WebClient library. This can increase download performance. The following example downloads the Python software, using the WebClient library.

```none
FROM windowsservercore

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  (New-Object System.Net.WebClient).DownloadFile('https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe','c:\python-3.5.1.exe') ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

> WebClient is not currently supported in Nano Server

### PowerShell Scripts

In some cases, it may be helpful to copy a script into the containers being used during the image creation process, and then run from within the container. Note - this will limit any image layer caching, and decrease readability of the Dockerfile.

This example copies a script from the build machine into the container using the `ADD` instruction. This script is then run using the RUN instruction.

```
FROM windowsservercore
ADD script.ps1 /windows/temp/script.ps1
RUN powershell.exe -executionpolicy bypass c:\windows\temp\script.ps1
```

## Docker Build 

Once a Dockerfile has been created and saved to disk, `docker build` can be run to create the new image. The `docker build` command takes several optional parameters and a path to the Dockerfile. For complete documentation on Docker Build, including a list of all build options, see [build Reference on Docker.com](https://docs.docker.com/engine/reference/commandline/build/#build).

```none
Docker build [OPTIONS] PATH
```
For example, the following command will create an image named ‘iis’.

```none
docker build -t iis .
```

When the build process has been initiated, the output will indicate status, and return any thrown errors.

```none
C:\> docker build -t iis .

Sending build context to Docker daemon 2.048 kB
Step 1 : FROM windowsservercore
 ---> 6801d964fda5

Step 2 : RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
 ---> Running in ae8759fb47db

Deployment Image Servicing and Management tool
Version: 10.0.10586.0

Image Version: 10.0.10586.0

Enabling feature(s)
The operation completed successfully.

 ---> 4cd675d35444
Removing intermediate container ae8759fb47db

Step 3 : RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
 ---> Running in 9a26b8bcaa3a
 ---> e2aafdfbe392
Removing intermediate container 9a26b8bcaa3a

Successfully built e2aafdfbe392
```

The result is a new container image, in this example named 'iis'.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
iis                 latest              e2aafdfbe392        About a minute ago   207.8 MB
windowsservercore   latest              6801d964fda5        4 months ago         0 B
```

## Further Reading & References

[Optimize Dockerfiles and Docker build for Windows] (./optimize_windows_dockerfile.md)

[Dockerfile Reference on Docker.com](https://docs.docker.com/engine/reference/builder/)
