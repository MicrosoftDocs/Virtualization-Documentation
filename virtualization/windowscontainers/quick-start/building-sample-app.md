---
title: Build a Sample App
description: Learn to build a sample app while leveraging containers
keywords: docker, containers
author: cwilhit
ms.date: 07/25/2017
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
---

# Build a Sample App

The exercise will walk you through taking a sample ASP.net app and converting it to run in a container. If you need to learn how to get up and running with containers in Windows 10, visit [Windows 10 Quick Start](./quick-start-windows-10.md).

This quick start is specific to Windows 10. Additional quick start documentation can be found in the table of contents on the left hand side of this page. Since the focus of this tutorial concerns containers, we will forego writing code and focus solely on containers. If you want to build the tutorial from the ground up, then you can find it in [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core/tutorials/first-mvc-app-xplat/)

If you don't have Git source control installed on your computer, you can grab it here: [Git](https://git-scm.com/download)

## Getting Started

This sample project was set up with [VSCode](https://code.visualstudio.com/). We will also be using Powershell. Let's grab the demo code from github. You can clone the repo with git or download the project directly from [SampleASPContainerApp](https://github.com/cwilhit/SampleASPContainerApp).

```Powershell
git clone https://github.com/cwilhit/SampleASPContainerApp.git
```

Now, let's navigate to the project directory and create the Dockerfile. A [Dockerfile](https://docs.docker.com/engine/reference/builder/) is like a makefile--a list of instructions that describe how a container image must be built.

```Powershell
#Create the dockerfile for our proj
New-Item C:/Your/Proj/Location/Dockerfile -type file
```

## Writing our Dockerfile

Now let's open up that Dockerfile we created in the project root folder (with whichever text editor you fancy) and add some logic to it. Then we'll break it down line by line and explain what is happening.

```Dockerfile
FROM microsoft/aspnetcore-build:1.1 AS build-env
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

FROM microsoft/aspnetcore:1.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]
```

The first group of lines declares from which base image we will use to build our container on top of. If the local system does not have this image already, then docker will automatically try and fetch it. Aspnetcore-build comes packaged with dependencies to compile our project. We then change the working directory in our container to be '/app', so all ensuing commands in our dockerfile will execute there.

_NOTE_: Since we must build our project, this first container we create is a temporary container which we will use to do just that, and then discard it at the end.

```Dockerfile
FROM microsoft/aspnetcore-build:1.1 AS build-env
WORKDIR /app
```

Next, we copy over the .csproj files into our temporary container's '/app' directory. We do this because .csproj files contain a list of package references our project needs.

After copying this file, dotnet will read from it and then to go out and fetch all of the dependencies and tools which our project needs.

```Dockerfile
COPY *.csproj ./
RUN dotnet restore
```

Once we've pulled down all of those dependencies, we copy it into the temporary container. We then tell dotnet to publish our application with a release configuration and specify the output path.

```Dockerfile
COPY . ./
RUN dotnet publish -c Release -o out
```

We should have successfully compiled our project. Now we need to build our finalized container. Since our application is ASP.NET, we specify an image with those libs as the source. We then copy over all files from the output directory of our temporary container into our final container. We configure our container to run with our new .dll that we compiled when we launch it.

_NOTE_: Our base image for this final container is similar but different to the ```FROM``` command above--it doesn't have the libraries capable of _building_ an ASP.NET app, only running.

```Dockerfile
FROM microsoft/aspnetcore:1.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]
```

We have now successfully performed what is called a _multi-stage build_. We used the temporary container to build our image and then moved over the published dll into another container so that we minimized the footprint of the end result. We want this container to have the absolute minimum required dependencies to run; if we had kept with using our first image, then it would have come packaged with other layers (for building ASP.NET apps) which were not vital and therefore would increase our image size.

## Running the App

Now that the dockerfile is written, all that is left to do is tell docker to build our app and then run the container. We specify the port to publish to and then give our container a tag "myapp". In powershell, execute the commands below.

_NOTE_: Your PowerShell console's current working directory needs to be the directory where the dockerfile created above resides.

```Powershell
docker build -t myasp .
docker run -d -p 5000:80 --name myapp myasp
```

To see our app running, we need to go visit the address which it is running on. Let's get the IP address by running this command.

```Powershell
 docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" myapp
```

Running this command will yield the IP address of your running container. Below is an example of what the output should look like.

```Powershell
 172.19.172.12
```

Enter this IP address into the web browser of your choice and you will be greeted by the application running successfully in a container!

>![](media/SampleAppScreenshot.png)

Clicking on "MvcMovie" in the navigation bar will take you to a web page where you can input, edit, and, delete movie entries.

## Next Steps

We have successfully taken an ASP.NET web app, configured and built it using Docker, and have succesfully deployed it into a running container. But there are further steps that you can take! You could break out the web app into further components--a container running the Web API, a container running the front end, and a container running the SQL server.

Now that you've got the hang of containers, go out there and build great containerized software!

> [!div class="nextstepaction"]
> [Check out more container samples](../samples.md)
