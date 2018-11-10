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

# Windows and Linux Containers on Windows 10

The exercise will walk through creating and running both Windows and Linux containers on Windows 10. After completion, you will have:

1. Installed Docker for Windows
2. Run a simple Windows container
3. Run a simple Linux container using Linux Containers on Windows (LCOW)

This quick start is specific to Windows 10. Additional quick start documentation can be found in the table of contents on the left-hand side of this page.

***Hyper-V isolation:***
Windows Server Containers require Hyper-V isolation on Windows 10 in order to provide developers with the same kernel version and configuration that will be used in production, more about Hyper-V isolation can be found on the [About Windows container](../about/index.md) page.

**Prerequisites:**

- One physical computer system running Windows 10 Fall Creators Update (version 1709) or later (Professional or Enterprise) that [can run Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/hyper-v-requirements)

> If you're not looking to run LCOW in this tutorial, Windows containers will be able to run on Windows 10 Anniversary Update (version 1607) or later.

## 1. Install Docker for Windows

[Download Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows) and run the installer (You will be required to login. Create an account if you don't have one already). [Detailed installation instructions](https://docs.docker.com/docker-for-windows/install) are available in the Docker documentation.

> If you already have Docker installed, make sure you have version 18.02 or later to support LCOW. Check by running `docker -v` or checking *About Docker*.

> The 'experimental features' option in *Docker Settings > Daemon* must be activated to run LCOW containers.

## 2. Switch to Windows containers

After installation Docker for Windows defaults to running Linux containers. Switch to Windows containers using either the Docker tray-menu or by running the following command in a PowerShell prompt `& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon`.

![](./media/docker-for-win-switch.png)
> Note that Windows containers mode allows for LCOW containers in addition to Windows containers.

## 3. Install Base Container Images

Windows containers are built from base images. The following command will pull the Nano Server base image.

```
docker pull microsoft/nanoserver
```

Once the image is pulled, running `docker images` will return a list of installed images, in this case the Nano Server image.

```
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
microsoft/nanoserver   latest              105d76d0f40e        4 days ago          652 MB
```

> Please read the Windows Containers OS Image EULA which can be found here – [EULA](../images-eula.md).

## 4. Run Your First Windows Container

For this simple example a ‘Hello World’ container image will be created and deployed. For the best experience run these commands in an elevated Windows CMD shell or PowerShell.
> Windows PowerShell ISE does not work for interactive sessions with containers. Even though the container is running, it will appear to hang.

First, start a container with an interactive session from the `nanoserver` image. Once the container has started, you will be presented with a command shell from within the container.  

```
docker run -it microsoft/nanoserver cmd
```

Inside the container we will create a simple ‘Hello World’ script.

```
powershell.exe Add-Content C:\helloworld.ps1 'Write-Host "Hello World"'
```   

When completed, exit the container.

```
exit
```

You will now create a new container image from the modified container. To see a list of containers run the following and take note of the container id.

```
docker ps -a
```

Run the following command to create the new ‘HelloWorld’ image. Replace <containerid> with the id of your container.

```
docker commit <containerid> helloworld
```

When completed, you now have a custom image that contains the hello world script. This can be seen with the following command.

```
docker images
```

Finally, to run the container, use the `docker run` command.

```
docker run --rm helloworld powershell c:\helloworld.ps1
```

The outcome of the `docker run` command is that a Hyper-V container was created from the 'HelloWorld' image, a sample 'Hello World' script was then executed (output echoed to the shell), and then the container stopped and removed.
Subsequent Windows 10 and container quick starts will dig into creating and deploying applications in containers on Windows 10.

## Run Your First LCOW Container

For this example, a BusyBox container will be deployed. First, attempt to run a 'Hello World' BusyBox image.

```
docker run --rm busybox echo hello_world
```

Note that this returns an error when Docker attempts to pull the image. This occurs because Dockers requires a directive via the `--platform` flag to confirm that the image and host operating system are matched appropriately. Since the default platform in Windows container mode is Windows, add a `--platform linux` flag to pull and run the container.

```
docker run --rm --platform linux busybox echo hello_world
```

Once the image has been pulled with the platform indicated, the `--platform` flag is no longer necessary. Run the command without it to test this.

```
docker run --rm busybox echo hello_world
```

Run `docker images` to return a list of installed images. In this case, both the Windows and Linux images.

```
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
microsoft/nanoserver   latest              105d76d0f40e        4 days ago          652 MB
busybox                latest              59788edf1f3e        4 weeks ago         3.41MB
```

## Next Steps

Bonus: See Docker's corresponding [blog post](https://blog.docker.com/2018/02/docker-for-windows-18-02-with-windows-10-fall-creators-update/) on running LCOW

Continue to the next tutorial to see an example of [building a sample app](./building-sample-app.md)
