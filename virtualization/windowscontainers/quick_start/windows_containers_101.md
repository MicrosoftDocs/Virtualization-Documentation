---
title: Windows Containers on Windows Server
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05//2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 
---

# Windows Containers on Windows Server

This exercise will walk through the basic deployment of the Windows container feature and Docker on Windows Server 2016. This exercise assumes that you have familiarized yourself with basic container concepts and terminology. If you need to review concepts and terminology, see the [Quick Start Introduction](./quick_start.md).

This exercise must be run on **Windows Server 2016 Technical Preview 5**. The Windows Server 2016 Technical Preview 5 installation media can be found [here]( https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview).
If you would like to work through this exercise on Windows 10, see the [Windows 10 Container Quick Start](./windows_10_containers_101.md).


## 1. Install Container Feature

The container feature needs to be enabled before working with Windows containers. To do so run the following command in an elevated PowerShell session. 

```none
Install-WindowsFeature containers
```

When the feature installation has completed, reboot the computer.

## 2. Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. For this exercise, both will be installed. Run the following commands to do so. 

```none
# Create Docker directory
New-Item -Type Directory $env:programfiles\docker

# Download Docker Engine
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/dockerd-1.12.0-dev.exe -OutFile $env:programfiles\docker\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/docker.exe -OutFile $env:programfiles\docker\docker.exe
```

Next, add the docker directory to the path variable. This will allow Docker commands to be run from any path. 

```none
$env:Path += ";$env:programfiles\docker"
```

Finally, to install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

## 3. Install Base Container Images

Before a container can be deployed, a container base OS image needs to be downloaded. The following commands will download the Windows Server Core base OS image. This process can take some time, so teak a break and pick back up once the download has completed. 
    
```none
# Install Container Image Provider    
Install-PackageProvider ContainerImage -Force    

# Install Windows Server Core Image  
Install-ContainerImage -Name WindowsServerCore    
```

## 4. Verify Deployment

At this stage the Windows container feature and Docker are ready to deploy containers. To verify, open up a Windows command prompt and type `docker images’, this will display the installed images.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
windowsservercore   10.0.14300.1000     dbfee88ee9fd        7 weeks ago         9.344 GB
```

## 5. Deploy Your First Container

For this exercise, you will download a pre-created IIS image from the Docker Hub registry, and deploy a simple container running IIS.  

To search Docker Hub for Windows container images, run `docker search Microsoft`.  

```none
docker search microsoft

NAME                                         DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
microsoft/sample-django:windowsservercore    Django installed in a Windows Server Core ...   1                    [OK]
microsoft/dotnet35:windowsservercore         .NET 3.5 Runtime installed in a Windows Se...   1         [OK]       [OK]
microsoft/sample-golang:windowsservercore    Go Programming Language installed in a Win...   1                    [OK]
microsoft/sample-httpd:windowsservercore     Apache httpd installed in a Windows Server...   1                    [OK]
microsoft/iis:windowsservercore              Internet Information Services (IIS) instal...   1         [OK]       [OK]
microsoft/sample-mongodb:windowsservercore   MongoDB installed in a Windows Server Core...   1                    [OK]
microsoft/sample-mysql:windowsservercore     MySQL installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-nginx:windowsservercore     Nginx installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-python:windowsservercore    Python installed in a Windows Server Core ...   1                    [OK]
microsoft/sample-rails:windowsservercore     Ruby on Rails installed in a Windows Serve...   1                    [OK]
microsoft/sample-redis:windowsservercore     Redis installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-ruby:windowsservercore      Ruby installed in a Windows Server Core ba...   1                    [OK]
microsoft/sample-sqlite:windowsservercore    SQLite installed in a Windows Server Core ...   1                    [OK]
```

Download the IIS image using `docker pull`.  

```none
docker pull microsoft/iis:windowsservercore
```

The image download can be verified with the `docker images` command. Notice here that you will see both the base image (windowsservercore) and the IIS image.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
microsoft/iis       windowsservercore   c26f4ceb81db        2 weeks ago         9.48 GB
windowsservercore   10.0.14300.1000     dbfee88ee9fd        7 weeks ago         9.344 GB
```

User `docker run` to deploy your IIS container. This command has several parameters, those in the example below are:

- `-d` this starts the container as a background process.  
- `-p` this bind port 80 of the container to port 80 of this container host. In this configuration http request made to the container host on port 80 will be forwarded to the container. Read more about container networking at [Manage Container Networking](../management/container_networking.md).  
- `microsot/iis:windowsservercore` - this specifies the image that will be deployed. Read more about container images including image tagging at [Manage Container Images](../management/manage_images.md).  
- `ping localhost -t` - this give the container a long running process. A container will only stay running when it’s delegated process is running.  

```none
docker run -d -p 80:80 microsoft/iis:windowsservercore ping -t localhost
```

All running containers can be seen with the `docker ps` command. Take note of the container name, this will be used in a later step.

```none
docker ps

CONTAINER ID        IMAGE                             COMMAND               CREATED              STATUS              PORTS                NAMES
9cad3ea5b7bc        microsoft/iis:windowsservercore   "ping -t localhost"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp   grave_jang
```

From a different computer system, open up a web browser and enter the IP address of the container host. If everything has been configured correctly, you should see the IIS splash screen. This is being served from the IIS instance hosted in the Windows container.

![](media/iis1.png)

Back on the container host, use the `docker rm` command to remove the container.

```none
docker rm -f grave_jang
```
