---
title: Optimize Windows Dockerfiles
description: Optimize Dockerfiles for Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb2848ca-683e-4361-a750-0d1d14ec8031
---
# Optimize Windows Dockerfiles

**This is preliminary content and subject to change.** 

Several methods can be used to optimize both the Docker build process, and the resulting Docker images. This document details how the Docker build process operates, and demonstrates several tactics that can be used for optimal image create with Windows Containers.

## Docker Build

### Image Layers

Before examining Docker build optimization, it is important to understand how Docker build works. During the Docker build process, a Dockerfile is consumed, and each actionable instruction is run, one-by-one, in its own temporary container. The result is a new image layer for each actionable instruction. 

Take a look at the following Dockerfile. In this example, the `windowsservercore` base OS image is being used, IIS installed, and then a simple website created.

```none
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

From this Dockerfile, one might expect the resulting image to consist of two layers, one for the container OS image, and a second that includes IIS and the website, this however is not the case. The new image is constructed of many layers, each one dependent on the previous. To visualize this, the `docker history` command can be run against the new image. Doing so shows that the image consists of four layers, the base, and then three additional layers, one for each instruction in the Dockerfile.

```none
docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
f4caf476e909        16 seconds ago       cmd /S /C REM (nop) CMD ["cmd"]                 41.84 kB
f0e017e5b088        21 seconds ago       cmd /S /C echo "Hello World - Dockerfile" > c   6.816 MB
88438e174b7c        About a minute ago   cmd /S /C dism /online /enable-feature /all /   162.7 MB
6801d964fda5        4 months ago                                                         0 B
```

Each of these layers can be mapped to an instruction from the Dockerfile. The bottom layer (`6801d964fda5` in this example) represents the base OS image. One layer up, the IIS installation can be seen. The next layer includes the new website, and so on.

Dockerfiles can be written to minimize image layers, optimize build performance, and also optimize cosmetic things such as readability. Ultimately, there are many ways to complete the same image build task. Understanding how the format of a Dockerfile effects build time, and the resulting image, improves the automation experience. 

## Optimize Image Size

When building Docker container images, image size may be an important factor. Container images are moved between registries and host, exported and imported, and ultimately consume space. Several tactics can be used during the Docker build process to minimize image size. This section details some of these tactics specific to Windows Containers. 

For additional information on Dockerfile best practices, see [Best practices for writing Dockerfiles on Docker.com]( https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Group related actions

Because each `RUN` instruction creates a new layer in the container image, grouping actions into one `RUN` instruction can reduce the number of layers. While minimizing layers may not effect image size much, grouping related actions can, which will be seen in subsequent examples.

The following two examples demonstrate the same operation, which results in container images of identical capability, however the two Dockerfiles constructed differently. The resulting images are also compared.  

This first example downloads Python for Windows, installs it and cleans up by removing the downloaded setup file. Each of these actions are run in their own `RUN` instruction.

```none
FROM windowsservercore

RUN powershell.exe -Command Invoke-WebRequest "https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe" -OutFile c:\python-3.5.1.exe
RUN powershell.exe -Command Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait
RUN powershell.exe -Command Remove-Item c:\python-3.5.1.exe -Force
```

The resulting image consists of three additional layers, one for each `RUN` instruction.

```none
docker history doc-example-1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a395ca26777f        15 seconds ago      cmd /S /C powershell.exe -Command Remove-Item   24.56 MB
6c137f466d28        28 seconds ago      cmd /S /C powershell.exe -Command Start-Proce   178.6 MB
957147160e8d        3 minutes ago       cmd /S /C powershell.exe -Command Invoke-WebR   125.7 MB
```

To compare, here is the same operation, however all steps run with the same `RUN` instruction. Note that each step in the `RUN` instruction is on a new line of the Dockerfile, the '\' character is being used to line wrap. 

```none
FROM windowsservercore

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

The resulting image here consists of one additional layer for the `RUN` instruction.

```none
docker history doc-example-2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
69e44f37c748        54 seconds ago      cmd /S /C powershell.exe -Command   $ErrorAct   216.3 MB                
```

### Remove excess files

If a file, such as an installer, is not required after it has been used, remove the file to reduce image size. This needs to occur in the same step in which the file was copied into the image layer. Doing so prevents the file from persisting in a lower level image layer.

In this example, the Python package is downloaded, executed, and then the executable removed. This is all completed in one `RUN` operation and results in a single image layer.

```none
FROM windowsservercore

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

## Optimize Build Speed

### Multiple Lines

When optimizing for Docker build speed, it may be advantageous to separate operations into multiple individual instructions. Having multiple `RUN` operations increase caching effectiveness. Because individual layers are created for each `RUN` instruction, if an identical step has already been run in a different Docker Build operation, this cached operation (image layer) is re-used. The result is that Docker Build runtime is decreased.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one `RUN` instruction. If any of these actions are updated, all actions will re-run.

```none
FROM windowsservercore

RUN powershell -Command \
	
  # Download software ; \
    
  wget https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
  wget "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist.exe ; \
  wget -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	
  # Install Software ; \
    
  Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
  Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
  start-Process c:\vcredistexe -ArgumentList '/quiet' -Wait ; \
    
  # Remove unneeded files ; \
     
  Remove-Item c:\apache.zip -Force; \
  Remove-Item c:\vcredist.exe -Force
```

The resulting image consists of two layers, one for the base OS image, and the second that contains all operations from the single `RUN` instruction.

```none
docker history doc-sample-1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
9bdf3a21fd41        8 minutes ago       cmd /S /C powershell -Command     Invoke-WebR   205.8 MB
6801d964fda5        5 months ago                                                        0 B
```

To contrast, here are the same actions broken down into three `RUN` instructions. In this case, each `RUN` instruction is cached in a container image layer, and only those that have changed, need to be re-run on subsequent Dockerfile builds.

```none
FROM windowsservercore

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	wget https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	wget "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist.exe ; \
	start-Process c:\vcredist.exe -ArgumentList '/quiet' -Wait ; \
	Remove-Item c:\vcredist.exe -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	wget http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
	Remove-Item c:\php.zip -Force
```

The resulting image consists of four layers, one for the base OS image, and then one for each `RUN` instruction. Because each `RUN` instruction has been run in its own layer, any subsequent runs of this Dockerfile or identical set of instructions in a different Dockerfile, will use cached image layer, thus reducing build time. Instruction ordering is important when working with image cache, for more details, see the next section of this document.

```none
docker history doc-sample-2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
ddf43b1f3751        6 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   127.2 MB
d43abb81204a        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   66.46 MB
7a21073861a1        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   115.8 MB
6801d964fda5        5 months ago
```

### Ordering Instructions

A Dockerfile is processed from top to the bottom, each Instruction compared against cached layers. When an instruction is found without a cached layer, this instruction and all subsequent instructions are processed in new container image layers. Because of this, the order in which instructions are placed is important. Place instructions that will remain constant towards the top of the Dockerfile. Place instructions that may change towards the bottom of the Dockerfile. Doing so reduces the likelihood of negating existing cache.

The intention of this example is to demonstrated how Dockerfile instruction ordering can effect caching effectiveness. In this simple Dockerfile, four numbered folders are created.  

```none
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-3
RUN mkdir test-4
```
The resulting image has five layers, one for the base OS image, and one for each of the `RUN` instructions.

```none
docker history doc-sample-1

IMAGE               CREATED              CREATED BY               SIZE                COMMENT
afba1a3def0a        38 seconds ago       cmd /S /C mkdir test-4   42.46 MB
86f1fe772d5c        49 seconds ago       cmd /S /C mkdir test-3   42.35 MB
68fda53ce682        About a minute ago   cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        About a minute ago   cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                  0 B    
```

The docker file has now been slightly modified. Notice that the third `RUN` instruction has changed. When Docker build is run against this Dockerfile, the first three instructions, which are identical to those in the last example, use the cached image layers. However, because the changed `RUN` instruction has not been cached, a new layer is created for itself and all subsequent instructions.

```none
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-5
RUN mkdir test-4
```

Comparing Image ID’s of the new image, to that in the last example, you will see that the first three layers (bottom to the top) are shared, however the fourth and fifth are unique.

```none
docker history doc-sample-2

IMAGE               CREATED             CREATED BY               SIZE                COMMENT
c92cc95632fb        28 seconds ago      cmd /S /C mkdir test-4   5.644 MB
2f05e6f5c523        37 seconds ago      cmd /S /C mkdir test-5   5.01 MB
68fda53ce682        3 minutes ago       cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        4 minutes ago       cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                 0 B
```

## Cosmetic Optimization

### Instruction Case

Dockerfile instructions are not case sensitive, however convention is to use upper case. This improves readability by differentiating between Instruction call, and instruction operation. The below two examples demonstrate this concept. 

Lower case:
```none
# Sample Dockerfile

from windowsservercore
run dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
run echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
cmd [ "cmd" ]
```
Upper case: 
```none
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

### Line Wrapping

Long and complex operations can be separated onto multiple line using the backslash `\` character. The following Dockerfile installs the Visual Studio Redistributable package, removes the installer files, and then creates a configuration file. These three operations are all specified on one line.

```none
FROM windowsservercore

RUN powershell -Command c:\vcredist_x86.exe /quiet ; Remove-Item c:\vcredist_x86.exe -Force ; New-Item c:\config.ini
```
The command can be re-written so that each operation from the one `RUN` instruction is specified on its own line. 

```none
FROM windowsservercore

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; \
	Remove-Item c:\vcredist_x86.exe -Force ; \
	New-Item c:\config.ini
```

### Escape Characters

The backslash `\` character for line wrapping can be confusing in a Dockerfile for a Windows image, where it is used as the path separator. You can specify an alternatve escape character with the `escape` parser directive at the top of the Dockerfile. Replacing the backslash `\` character with the backtick `` ` `` permits line wrapping in standard Powershell format.

```none
# escape=`

FROM windowsservercore

RUN powershell -Command `
	$ErrorActionPreference = 'Stop'; `
	start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; `
	Remove-Item c:\vcredist_x86.exe -Force ; `
	New-Item c:\config.ini
```

## Further Reading & References

[Dockerfile on Windows] (./manage_windows_dockerfile.md)

[Best practices for writing Dockerfiles on Docker.com](https://docs.docker.com/engine/reference/builder/)
