# Dockerfile on Windows

The Docker engine includes tools for automating the creation of container images. While container images can be created manually by using the ‘docker commit’ command, adopting an automated image creation process provides many benefits. Some of these include:

- Storing container images as code.
- Rapid and precise recreation of container images. 
- Continuous integration between container images and the development cycle.

The components that drive this automation are dockerfile and the Docker Build command.

- Dockerfile – a text file containing the instruction needed to create a new container image. These instructions include selecting an existing image to derive the new image from, commands to be run during the image creation process, and then run time commands for running instances of the new container image.
- Docker Build - the Docker engine command that consumes a Dockerfile and triggers the image creation process.

This document will introduce using a dockerfile with Windows Containers, discuss syntax, and detail commonly used Dockerfile instructions. 

Throughout this document, the concept of continer images and contianer image layers will be discussed. For more information on images and image layering see [Manage Windows Container Images](./manage_images). 

For a complete look at the Docker engine and Dockerfile, see the [Dockerfile reference at docker.com]( https://docs.docker.com/engine/reference/builder/).

## Dockerfile Introduction

### Basic Syntax

In its most basic form, a dockerfile can be very simple. The following example creates a new image, which includes IIS and a new ‘hello world’ site. The dockerfile includes comments (indicated with a ‘#’) that explains each line. Subsequent sections of this article will detail syntax rules and Dockerfile instructions.

```
# Sample Dockerfile

# Indicates that the windowsservercore image will be used as the base image.
FROM windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER someguy@contoso.com

# Uses dism.exe to install the IIS role.
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart

# Creates an html file and adds content to this file.
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html

# Sets a command or process that will run each time a container is run from the new image.
CMD [ "cmd" ]
```

For additional examples of Dockerfiles for Windows see the [Dockerfile for Windows Repository] (https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-server-container-samples).

### Syntax Reference 

The following table details several Dockerfile syntax items.

|Syntax Detail        | Description                                            |
|---------------------|--------------------------------------------------------|
|Comments           | Comments can be added to a Dockerfile using the '#' symbol. |
|Line Wrapping      | To wrap a single instruction onto multiple lines, place a '\' at the end of the line.|
|Case Sensitivity   | Instruction such as FROM, RUN, and ADD are not case sensitive, however convention is to differentiate instructions with upper case.|
|Variables          | Environment variables can be created using the ENV instruction. They can be referenced with ${variable_name}. For more information on environment variables see [Dockerfile Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#environment-replacement).|
|Omitting Files     | A .dockerignore file can be used to exclude files from the scope of docker build. For more information on dockerignore, see [Dockerfile Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#dockerignore-file).|

### Instructions

Dockerfile instructions provide the Docker Engine with the steps needed in order to create a container image. These instructions are performed in order and one-by-one. Here are the details for some basic Dockerfile instructions. For a complete list of dockerfile instructions, see [Dockerfile Reference on Docker.com] (https://docs.docker.com/engine/reference/builder/).

### FROM

The FROM instruction sets the container image that will be used during the new image creation process. For instance, when using the instruction `FROM windowsservercore`, the resulting image will be derived from, and have a dependency on the Windows Server Core Base OS image. If the specified image is not present on the system where the Docker build process is being run, the Docker engine will attempt to download the image from a public or private container image registry.

Examples:

```
FROM windowsservercore
```

For detailed information on the FROM instruction see the [FROM Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#from). 

### RUN

The RUN instruction specifies commands to be run, and captured into the new container image. These commands can include items such as installing software, creating files and directories, and creating environment configuration.

Examples:

This example uses DISM to install IIS in the container image.
```
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart
```

This example installs the Visual Studio redistributable package.
```
RUN powershell.exe -Command	c:\vcredist_x86.exe /quiet
``` 

For detailed information on the RUN instruction see the [RUN Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#run). 

### ADD

The ADD instruction copies files and directories to the filesystem of the container. The files and directories can be relative to the dockerfile, or on a remote location with a URL specification. 

Examples:

This example adds the contents of the sources directory to a directory sqllite in the container image.
```
ADD sources /sqlite
```

This example creates a copy of master.zip from GitHub to the temp directory in the container image.
```
ADD https://github.com/neilpeterson/demoapp/archive/master.zip /temp/master.zip
```

For detailed information on the ADD instruction see the [ADD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#add). 

### WORKDIR

The WORKDIR instruction sets a working directory for other dockerfile instructions such as RUN, CMD, and ADD. 

Examples:

```
WORKDIR c:\Apache24\bin
```

For detailed information on the WORKDIR instruction see the [WORKDIR Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#workdir). 

### CMD

The `CMD` instruction sets the default command to be run when starting a new container. For instance, if the container will be hosting an NGINX web server, the `CMD` might include instructions to start the web server, such as `nginx.exe`. If multiple CMD instructions are specified in a Dockerfile, only the last will be evaluated.

```
CMD ["httpd.exe"]
```

For detailed information on the CMD instruction see the [CMD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#cmd). 

## Docker Build 

Once a dockerfile has been created, and saved to disk, `docker build` can be run to create the new image.  The `docker build` command takes several optional parameters and a path to the dockerfile. For complete documentation on Docker Build, including a list of all build options, see [Build at Docker.com](https://docs.docker.com/engine/reference/commandline/build/#build-with).

```
Docker build [OPTIONS] PATH
```
For example, the following command will create an image named ‘iis’ and look in the relative path for the dockerfile.

```
docker build -t iis .
```

When the build process has been initiated, the output will indicate status, and return any thrown errors.

```
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

```
C:\> docker images

REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
iis                 latest              e2aafdfbe392        About a minute ago   207.8 MB
windowsservercore   latest              6801d964fda5        4 months ago         0 B
```

## Further Reading & References

[Optimize Dockerfiles and Docker Build for Windows] (./optimize_windows_dockerfile.md)

[Dockerfile Reference on Docker.com](https://docs.docker.com/engine/reference/builder/)