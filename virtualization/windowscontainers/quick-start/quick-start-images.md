---
title: Container Deployment Quick Start - Images
description: Container deployment quick start
keywords: docker, containers
author: cwilhit
ms.date: 09/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 479e05b1-2642-47c7-9db4-d2a23592d29f
---

# Automating Builds and Saving Images

In the previous Windows Server quick start, a Windows container was created from a pre-created .Net Core sample. This exercise will detail automating container image creation using a Dockerfile, and storing container images in the Docker Hub public registry.

This quick start is specific to Windows Server containers on Windows Server 2016 and will use the Windows Server Core container base image. Additional quick start documentation can be found in the table of contents on the left hand side of this page.

**Prerequisites:**

- One computer system (physical or virtual) running Windows Server 2016.
- Configure this system with the Windows Container feature and Docker. For a walkthrough on these steps, see [Windows Containers on Windows Server](./quick-start-windows-server.md).
- A Docker ID, this will be used to push a container image to Docker Hub. If you do not have a Docker ID, sign up for one at [Docker Cloud](https://cloud.docker.com/).

## 1. Container Image - Dockerfile

Although a container can be manually created, modified, and then captured into a new container image, Docker includes a method for automating this process using a Dockerfile. For this exercise, a Docker ID is required. If you do not have a Docker ID, sign up for one at [Docker Cloud]( https://cloud.docker.com/).

On the container host, create a directory `c:\build`, and in this directory create a file named `Dockerfile`. Note – the file should not have a file extension.

```
powershell new-item c:\build\Dockerfile -Force
```

Open the Dockerfile in notepad.

```
notepad c:\build\Dockerfile
```

Copy the following text into the Dockerfile, and save the file. These commands instruct Docker to create a new image, using `microsoft/iis` as the base. The dockerfile then runs the commands specified in the `RUN` instruction, in this case the index.html file is updated with new content. 

For more information on Dockerfiles, see the [Dockerfiles on Windows](../manage-docker/manage-windows-dockerfile.md).

```
FROM microsoft/iis
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
```

The `docker build` command will start the image build process. The `-t` parameter instructs the build process to name the new image `iis-dockerfile`. **Replace 'user' with the user name of your Docker account**. If you do not have an account with Docker, sign up for one at [Docker Cloud](https://cloud.docker.com/).

```
docker build -t <user>/iis-dockerfile c:\Build
```

When completed, you can verify that the image has been created using the `docker images` command.

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
iis-dockerfile      latest              8d1ab4e7e48e        2 seconds ago       9.483 GB
microsoft/iis       windowsservercore   c26f4ceb81db        2 weeks ago         9.48 GB
windowsservercore   10.0.14300.1000     dbfee88ee9fd        8 weeks ago         9.344 GB
windowsservercore   latest              dbfee88ee9fd        8 weeks ago         9.344 GB
```

Now, deploy a container with the following command, again replacing user with your Docker ID.

```
docker run -d -p 80:80 <user>/iis-dockerfile ping -t localhost
```

Once the container has been created, browse to the IP address of the container host. You should see the hello world application.

![](media/dockerfile2.png)

Back on the container host, use `docker ps` to get the name of the container, and `docker rm` to remove the container. Note – replace the name of the container in this example with the actual container name.

Get container name.

```
docker ps

CONTAINER ID   IMAGE            COMMAND               CREATED              STATUS              PORTS                NAMES
c1dc6c1387b9   iis-dockerfile   "ping -t localhost"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp   cranky_brown
```
Stop container.

```
docker stop <container name>
```

Remove container.

```
docker rm -f <container name>
```

## 2. Docker Push

Docker container images can be stored in a container registry. Once an image is stored in a registry, it can be retrieved for later use across many different container hosts. Docker provides a public registry for storing container images at [Docker Hub](https://hub.docker.com/).

For this exercise, the custom hello world image will be pushed to your own account on Docker Hub.

First, login to your docker account using the `docker login command`.

```
docker login

Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.

Username: user
Password: Password

Login Succeeded
```

Once logged in, the container image can be pushed to Docker Hub. To do so, use the `docker push` command. **Replace 'user' with your Docker ID**. 

```
docker push <user>/iis-dockerfile
```

The container image can now be downloaded from Docker Hub onto any Windows container host using `docker pull`. For this tutorial, we will delete the existing image, and then pull it down from Docker Hub. 

```
docker rmi <user>/iis-dockerfile
```

Running `docker images` will show that the image has been removed.

```
docker images

REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
modified-iis              latest              51f1fe8470b3        5 minutes ago       7.69 GB
microsoft/iis             latest              e4525dda8206        3 hours ago         7.61 GB
```

Finally, docker pull can be used to pull the image back onto the container host. Replace user with the user name of your Docker account. 

```
docker pull <user>/iis-dockerfile
```

## Next Steps

If you would like to see how to package a sample ASP.NET application, visit the Windows 10 tutorials linked below.

[Windows Containers on Windows 10](./quick-start-windows-10.md)
