---
title: Windows and Linux Containers on Windows 10
description: Container deployment quick start
keywords: docker, containers, LCOW
author: taylorb-microsoft
ms.date: 11/8/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Windows Containers on Windows 10

> [!div class="op_single_selector"]
> - [Linux Containers on Windows](quick-start-windows-10-linux.md)
> - [Windows containers on Windows](quick-start-windows-10.md)

The exercise will walk through creating and running Windows containers on Windows 10.

In this quick start you will accomplish:

1. Installing Docker for Windows
2. Running a simple Windows container

This quick start is specific to Windows 10. Additional quick start documentation can be found in the table of contents on the left-hand side of this page.

## Prerequisites
Please make sure you meet the following requirements:
- One physical computer system running Windows 10 Professional or Enterprise with Anniversary Update (version 1607) or later. 
- Make sure [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) is enabled.

***Hyper-V isolation:***
Windows Server Containers require Hyper-V isolation on Windows 10 in order to provide developers with the same kernel version and configuration that will be used in production, more about Hyper-V isolation can be found on the [About Windows container](../about/index.md) page.

> [!NOTE]
> In the release of Windows October Update 2018, we no longer disallow users from running a Windows container in process-isolation mode on Windows 10 Enterprise or Professional for dev/test purposes. See the [FAQ](../about/faq.md) to learn more.

## Install Docker for Windows

Download [Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows) and run the installer (You will be required to login. Create an account if you don't have one already). [Detailed installation instructions](https://docs.docker.com/docker-for-windows/install) are available in the Docker documentation.

## Switch to Windows containers

After installation Docker for Windows defaults to running Linux containers. Switch to Windows containers using either the Docker tray-menu or by running the following command in a PowerShell prompt:

```console
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
```

![](./media/docker-for-win-switch.png)

## Install Base Container Images

Windows containers are built from base images. The following command will pull the Nano Server base image.

```console
docker pull mcr.microsoft.com/windows/nanoserver:1809
```

Once the image is pulled, running `docker images` will return a list of installed images, in this case the Nano Server image.

```console
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
microsoft/nanoserver   latest              105d76d0f40e        4 days ago          652 MB
```

> [!IMPORTANT]
> Please read the Windows containers OS image [EULA](../images-eula.md).

## Run Your First Windows Container

For this simple example, a ‘Hello World’ container image will be created and deployed. For the best experience run these commands in an elevated Windows CMD shell or PowerShell.

> Windows PowerShell ISE does not work for interactive sessions with containers. Even though the container is running, it will appear to hang.

First, start a container with an interactive session from the `nanoserver` image. Once the container has started, you will be presented with a command shell from within the container.  

```console
docker run -it mcr.microsoft.com/windows/nanoserver:1809 cmd.exe
```

Inside the container we will create a simple ‘Hello World’ text file.

```cmd
echo "Hello World!" > Hello.txt
```   

When completed, exit the container.

```cmd
exit
```

You will now create a new container image from the modified container. To see a list of containers run the following and take note of the container id.

```console
docker ps -a
```

Run the following command to create the new ‘HelloWorld’ image. Replace <containerid> with the id of your container.

```console
docker commit <containerid> helloworld
```

When completed, you now have a custom image that contains the hello world script. This can be seen with the following command.

```console
docker images
```

Finally, to run the container, use the `docker run` command.

```console
docker run --rm helloworld cmd.exe /s /c type Hello.txt
```

The outcome of the `docker run` command is that a container running under Hyper-V isolation was created from the 'HelloWorld' image, an instance of cmd was started in the container and executed a reading of our file (output echoed to the shell), and then the container stopped and removed.

## Next Steps

> [!div class="nextstepaction"]
> [Learn how to build a sample app](./building-sample-app.md)