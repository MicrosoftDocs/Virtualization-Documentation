---
title: Optimize Windows Dockerfiles
description: Optimize Dockerfiles for Windows containers.
author: vrapolinario
ms.author: roharwoo
ms.date: 01/23/2025
ms.topic: how-to
ms.assetid: bb2848ca-683e-4361-a750-0d1d14ec8031
---

# Optimize Windows Dockerfiles

There are many ways to optimize both the Docker build process and the resulting Docker images. This article explains how the Docker build process works and how to optimally create images for Windows containers.

## Image layers in Docker build

Before you can optimize your Docker build, you'll need to know how Docker build works. During the Docker build process, a Dockerfile is consumed, and each actionable instruction is run, one-by-one, in its own temporary container. The result is a new image layer for each actionable instruction.

For example, the following sample Dockerfile uses the `mcr.microsoft.com/windows/servercore:ltsc2019` base OS image, installs IIS, and then creates a simple website.

```dockerfile
# Sample Dockerfile

FROM mcr.microsoft.com/windows/servercore:ltsc2019
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

You might expect that this Dockerfile will produce an image with two layers, one for the container OS image, and a second that includes IIS and the website. However, the actual image has many layers, and each layer depends upon the one before it.

To make this clearer, let's run the `docker history` command against the image our sample Dockerfile made.

```dockerfile
docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
f4caf476e909        16 seconds ago       cmd /S /C REM (nop) CMD ["cmd"]                 41.84 kB
f0e017e5b088        21 seconds ago       cmd /S /C echo "Hello World - Dockerfile" > c   6.816 MB
88438e174b7c        About a minute ago   cmd /S /C dism /online /enable-feature /all /   162.7 MB
6801d964fda5        4 months ago                                                         0 B
```

The output shows us that this image has four layers: the base layer and three additional layers that are mapped to each instruction in the Dockerfile. The bottom layer (`6801d964fda5` in this example) represents the base OS image. One layer up is the IIS installation. The next layer includes the new website, and so on.

Dockerfiles can be written to minimize image layers, optimize build performance, and optimize accessibility through readability. Ultimately, there are many ways to complete the same image build task. Understanding how the Dockerfile's format affects build time and the image it creates improves the automation experience.

## Optimize image size

Depending on your space requirements, image size can be an important factor when building Docker container images. Container images are moved between registries and host, exported and imported, and ultimately consume space. This section will tell you how to minimize image size during the Docker build process for Windows containers.

For additional information about Dockerfile best practices, see [Best practices for writing Dockerfiles on Docker.com](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Group related actions

Because each `RUN` instruction creates a new layer in the container image, grouping actions into one `RUN` instruction can reduce the number of layers in a Dockerfile. While minimizing layers may not affect image size much, grouping related actions can, which will be seen in subsequent examples.

In this section, we'll compare two example Dockerfiles that do the same things. However, one Dockerfile has one instruction per action, while the other had its related actions grouped together.

The following ungrouped example Dockerfile downloads Python for Windows, installs it, and removes the downloaded setup file once installation is done. In this Dockerfile, each action is given its own `RUN` instruction.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell.exe -Command Invoke-WebRequest "https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe" -OutFile c:\python-3.5.1.exe
RUN powershell.exe -Command Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait
RUN powershell.exe -Command Remove-Item c:\python-3.5.1.exe -Force
```

The resulting image consists of three additional layers, one for each `RUN` instruction.

```dockerfile
docker history doc-example-1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a395ca26777f        15 seconds ago      cmd /S /C powershell.exe -Command Remove-Item   24.56 MB
6c137f466d28        28 seconds ago      cmd /S /C powershell.exe -Command Start-Proce   178.6 MB
957147160e8d        3 minutes ago       cmd /S /C powershell.exe -Command Invoke-WebR   125.7 MB
```

The second example is a Dockerfile that performs the exact same operation. However, all related actions have been grouped under a single `RUN` instruction. Each step in the `RUN` instruction is on a new line of the Dockerfile, while the '\\' character is used to line wrap.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

The resulting image has only one additional layer for the `RUN` instruction.

```dockerfile
docker history doc-example-2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
69e44f37c748        54 seconds ago      cmd /S /C powershell.exe -Command   $ErrorAct   216.3 MB
```

### Remove excess files

If there's a file in your Dockerfile, such as an installer, that you don't need after it's been used, you can remove it to reduce image size. This needs to occur in the same step in which the file was copied into the image layer. Doing so prevents the file from persisting in a lower-level image layer.

In the following example Dockerfile, the Python package is downloaded, executed, then removed. This is all completed in one `RUN` operation and results in a single image layer.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell.exe -Command \
  $ErrorActionPreference = 'Stop'; \
  Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
  Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
  Remove-Item c:\python-3.5.1.exe -Force
```

## Optimize build speed

### Multiple lines

You can split operations into multiple individual instructions to optimize Docker build speed. Multiple `RUN` operations increase caching effectiveness because individual layers are created for each `RUN` instruction. If an identical instruction was already run in a different Docker Build operation, this cached operation (image layer) is reused, resulting in decreased Docker build runtime.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then cleaned up by removing files that are no longer needed. This is all done with a single `RUN` instruction. If any of these actions are updated, all actions will rerun.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command \

  # Download software ; \

  wget https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
  wget "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist.exe ; \
  wget -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \

  # Install Software ; \

  Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
  Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
  Start-Process c:\vcredist.exe -ArgumentList '/quiet' -Wait ; \

  # Remove unneeded files ; \

  Remove-Item c:\apache.zip -Force; \
  Remove-Item c:\vcredist.exe -Force; \
  Remove-Item c:\php.zip
```

The resulting image has two layers, one for the base OS image, and one that contains all operations from the single `RUN` instruction.

```dockerfile
docker history doc-sample-1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
9bdf3a21fd41        8 minutes ago       cmd /S /C powershell -Command     Invoke-WebR   205.8 MB
6801d964fda5        5 months ago                                                        0 B
```

By comparison, here are the same actions split into three `RUN` instructions. In this case, each `RUN` instruction is cached in a container image layer, and only those that have changed need to be rerun on subsequent Dockerfile builds.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    wget https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
    Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    Remove-Item c:\apache.zip -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    wget "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist.exe ; \
    Start-Process c:\vcredist.exe -ArgumentList '/quiet' -Wait ; \
    Remove-Item c:\vcredist.exe -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    wget http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
    Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
    Remove-Item c:\php.zip -Force
```

The resulting image consists of four layers; one layer for the base OS image and each of the three `RUN` instructions. Because each `RUN` instruction ran in its own layer, any subsequent runs of this Dockerfile or identical set of instructions in a different Dockerfile will use cached image layers, reducing build time.

```dockerfile
docker history doc-sample-2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
ddf43b1f3751        6 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   127.2 MB
d43abb81204a        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   66.46 MB
7a21073861a1        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   115.8 MB
6801d964fda5        5 months ago
```

How you order the instructions is important when working with image caches, as you'll see in the next section.

### Ordering instructions

A Dockerfile is processed from top to the bottom, each Instruction compared against cached layers. When an instruction is found without a cached layer, this instruction and all subsequent instructions are processed in new container image layers. Because of this, the order in which instructions are placed is important. Place instructions that will remain constant towards the top of the Dockerfile. Place instructions that may change towards the bottom of the Dockerfile. Doing so reduces the likelihood of negating existing cache.

The following examples show how Dockerfile instruction ordering can affect caching effectiveness. This simple example Dockerfile has four numbered folders.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-3
RUN mkdir test-4
```

The resulting image has five layers, one for the base OS image and each of the `RUN` instructions.

```dockerfile
docker history doc-sample-1

IMAGE               CREATED              CREATED BY               SIZE                COMMENT
afba1a3def0a        38 seconds ago       cmd /S /C mkdir test-4   42.46 MB
86f1fe772d5c        49 seconds ago       cmd /S /C mkdir test-3   42.35 MB
68fda53ce682        About a minute ago   cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        About a minute ago   cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                  0 B
```

This next Dockerfile has now been slightly modified, with the third `RUN` instruction changed to a new file. When Docker build is run against this Dockerfile, the first three instructions, which are identical to those in the last example, use the cached image layers. However, because the changed `RUN` instruction isn't cached, a new layer is created for the changed instruction and all subsequent instructions.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-5
RUN mkdir test-4
```

When you compare the image IDs of the new image to that in this section's first example, you'll notice that the first three layers from bottom to top are shared, but the fourth and fifth are unique.

```dockerfile
docker history doc-sample-2

IMAGE               CREATED             CREATED BY               SIZE                COMMENT
c92cc95632fb        28 seconds ago      cmd /S /C mkdir test-4   5.644 MB
2f05e6f5c523        37 seconds ago      cmd /S /C mkdir test-5   5.01 MB
68fda53ce682        3 minutes ago       cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        4 minutes ago       cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                 0 B
```

## Cosmetic optimization

### Instruction case

Dockerfile instructions are not case-sensitive, but the convention is to use upper case. This improves readability by differentiating between the Instruction call and instruction operation. The following two examples compare an uncapitalized and capitalized Dockerfile.

The following is an uncapitalized Dockerfile:

```dockerfile
# Sample Dockerfile

from mcr.microsoft.com/windows/servercore:ltsc2019
run dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
run echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
cmd [ "cmd" ]
```

The following is the same Dockerfile using upper-case:

```dockerfile
# Sample Dockerfile

FROM mcr.microsoft.com/windows/servercore:ltsc2019
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

### Line wrapping

Long and complex operations can be separated onto multiple lines by the backslash `\` character. The following Dockerfile installs the Visual Studio Redistributable package, removes the installer files, and then creates a configuration file. These three operations are all specified on one line.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command c:\vcredist_x86.exe /quiet ; Remove-Item c:\vcredist_x86.exe -Force ; New-Item c:\config.ini
```

The command can be broken up with backslashes so that each operation from the one `RUN` instruction is specified on its own line.

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; \
    Remove-Item c:\vcredist_x86.exe -Force ; \
    New-Item c:\config.ini
```

## Further reading and references

[Dockerfile on Windows](manage-windows-dockerfile.md)

[Best practices for writing Dockerfiles on Docker.com](https://docs.docker.com/engine/reference/builder/)
