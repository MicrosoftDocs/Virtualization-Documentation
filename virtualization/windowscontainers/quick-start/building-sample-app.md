---
title: Containerize a .NET Core App
description: Learn to build a sample .NET core app with containers
keywords: docker, containers
author: cwilhit
ms.date: 09/10/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
---

# Containerize a .NET Core App


In this quickstart, you will learn how to containerize a simple .NET core application. You will:

> [!div class="checklist"]
> * Clone the sample app source from GitHub
> * Create a dockerfile to build a container image with the app source
> * Test the containerized .NET core app in a local Docker environment

## Before you begin

This quickstart assumes your development environment is already configured for using containers. If you don't have an environment configured for containers, visit the [Windows 10 Quick Start](./quick-start-windows-10.md) to learn how to get started.

You will need the Git source control system installed on your computer. You can grab it here: [Git](https://git-scm.com/download)

## Getting started

All container sample source code is kept under the [Virtualization-Documentation](https://github.com/MicrosoftDocs/Virtualization-Documentation) git repo in a folder called `windows-container-samples`. Clone this git repo to your curent working directory.

```Powershell
git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
```

Navigate to the sample directory found under `<directory where clone occured>\Virtualization-Documentation\windows-container-samples\asp-net-getting-started` and create a Dockerfile. A [Dockerfile](https://docs.docker.com/engine/reference/builder/) is like a makefile--a list of instructions that instruct the container engine on how the container image must be built.

```Powershell
#Create the dockerfile for our project
New-Item -name dockerfile -type file
```

## Write the dockerfile

Open the dockerfile you just created (with whichever text editor you fancy) and add the following content.

```Dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build-env
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "asp-net-getting-started.dll"]
```

Let's break it down line-by-line and explain what each instructions does.

```Dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build-env
WORKDIR /app
```

The first group of lines declares from which base image we will use to build our container on top of. If the local system does not have this image already, then docker will automatically try and fetch it. The `mcr.microsoft.com/dotnet/core/sdk:2.1` comes comes packaged with the .NET core 2.1 SDK installed, so it's up to the task of building ASP .NET core projects targeting version 2.1. The next instruction  changes the working directory in our container to be `/app`, so all commands following this one execute under this context.

```Dockerfile
COPY *.csproj ./
RUN dotnet restore
```

Next, these instructions copy over the .csproj files into the `build-env` container's `/app` directory. After copying this file, .NET will read from it and then to go out and fetch all the dependencies and tools needed by our project.

```Dockerfile
COPY . ./
RUN dotnet publish -c Release -o out
```

Once .NET has pulled all the dependencies into the `build-env` container, the next instruction copies all project source files into the container. We then tell .NET to publish our application with a release configuration and specify the output path in the .

The compilation should succeed. Now we must build the final image. 

> [!TIP]
> This quickstart builds a .NET core project from source. When building container images, it's good practice to include _only_ the production payload and its dependencies in the container image. We don't want the .NET core SDK included in our final image because we only need the .NET core runtime, so the dockerfile is written to use a temporary container that is packaged with the SDK called `build-env` to build the app.

```Dockerfile
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "asp-net-getting-started.dll"]
```

Since our application is ASP.NET, we specify an image with this runtime included. We then copy over all files from the output directory of our temporary container into our final container. We configure our container to run with our new app as its entrypoint when the container starts

We have written the dockerfile to perform a _multi-stage build_. When the dockerfile is executed, it will use the temporary container, `build-env`, with the .NET core 2.1 SDK to build the sample app and then copy the outputted binaries into another container containing only the .NET core 2.1 runtime so that we minimized the size of the final container.

## Run the app

With the dockerfile written, we can point Docker at our dockerfile and tell it to build our image. 

>[!IMPORTANT]
>The command executed below needs to be executed in the directory where the dockerfile resides.

```Powershell
docker build -t my-asp-app .
```

To run the container, execute the command below.

```Powershell
docker run -d -p 5000:80 --name myapp my-asp-app
```

Let's dissect this command:

* `-d` tells Docker tun run the container 'detached', meaning no console is hooked up to the console inside the container. The container runs in the background. 
* `-p 5000:80` tells Docker to map port 5000 on the host to port 80 in the container. Each container gets its own IP address. ASP .NET listens by default on port 80. Port mapping allows us to go to the host's IP address at the mapped port and Docker will forward all traffic to the destination port inside the container.
* `--name myapp` tells Docker to give this container a convenient name to query by (instead of having to look up the contaienr ID assigned at runtime by Docker).
* `my-asp-app` is the image we want Docker to run. This is the container image produced as the culmination of the `docker build` process.

Open a web browser web browser and navigate to `https://localhost:5000` to be greeted by your containerized application.

>![](media/SampleAppScreenshot.png)

## Next Steps

We successfully containerized an ASP.NET web app. To see more app samples and their associated dockerfiles, click the button below.

> [!div class="nextstepaction"]
> [Check out more container samples](../samples.md)
