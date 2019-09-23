---
title: Windows and Linux Containers on Windows 10
description: Container deployment quick start
keywords: docker, containers, LCOW
author: cwilhit
ms.date: 09/11/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Get Started: Run Your First Container

In the [previous segment](./set-up-environment.md), we configured our environment for running containers. This exercise shows how to pull a container image and run it.

## Install Container Base Image

All containers are instantiated from `container images`. Microsoft offers several "starter" images (called `base images`) to choose from. The following command will pull the Nano Server base image.

```console
docker pull mcr.microsoft.com/windows/nanoserver:1809
```

> [!TIP]
> If you see an error message that says `no matching manifest for unknown in the manifest list entries`, make sure Docker is not configured to run Linux containers.

After the image is pulled, you can verify it's existence on your machine by querying your local docker image repository. Running the command `docker images` returns a list of installed images--in this case the Nano Server image.

```console
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
microsoft/nanoserver   latest              105d76d0f40e        4 days ago          652 MB
```

> [!IMPORTANT]
> Please read the Windows containers OS image [EULA](../images-eula.md).

## Run Your First Windows Container

For this simple example, a ‘Hello World’ container image will be created and deployed. For the best experience, run these commands in an elevated Windows CMD shell or PowerShell.

> Windows PowerShell ISE does not work for interactive sessions with containers. Even though the container is running, it will appear to hang.

First, start a container with an interactive session from the `nanoserver` image. Once the container is started, you will be presented with a command shell from within the container.  

```console
docker run -it mcr.microsoft.com/windows/nanoserver:1809 cmd.exe
```

Inside the container, we will create a simple ‘Hello World’ text file.

```cmd
echo "Hello World!" > Hello.txt
```   

When completed, exit the container.

```cmd
exit
```

Create a new container image from the modified container. To see a list of containers that are running or have exited, run the following and take note of the container id.

```console
docker ps -a
```

Run the following command to create the new ‘HelloWorld’ image. Replace `<containerid>` with the id of your container.

```console
docker commit <containerid> helloworld
```

When completed, you now have a custom image that contains the hello world script. This can be seen with the following command.

```console
docker images
```

Finally, run the container by using the `docker run` command.

```console
docker run --rm helloworld cmd.exe /s /c type Hello.txt
```

The result of the `docker run` command is that a container was created from the 'HelloWorld' image, an instance of cmd was started in the container and executed a reading of our file (output echoed to the shell), and then the container stopped and removed.

## Next Steps

> [!div class="nextstepaction"]
> [Learn how to containerize a sample app](./building-sample-app.md)
