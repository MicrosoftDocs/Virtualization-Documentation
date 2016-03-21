# Dockerfile on Windows

The Docker engine includes tooling to automate the creation of container images. Building automation around image creation allows for effortless, repeatable, and consistent creation of container images. The components that drive this automation are dockerfiles and the Docker Build command.

- **Dockerfile** – a text file containing instructions on how to derive the image, commands to run and captured into the image, and the run time commands for running instances of the container image.
- **Docker Build** – the Docker engine command that consumes a Dockerfile and triggers the image creation process.

This document will introduce using a dockerfile with Windows Containers, discuss syntax, and detail commonly used Dockerfile instructions. For a complete look at the Docker engine and Dockerfile, see the [Dockerfile reference at docker.com]( https://docs.docker.com/engine/reference/builder/).

## Dockerfile Introduction

### Basic Syntax

In its most basic form, a dockerfile can be very simple. The following example creates a new image that includes IIS and a customized ‘hello world’ site. This example includes one comment, indicated by the ‘#’ symbol, and four instructions (FROM, RUN, and CMD). Notice that each instruction is on its own line of the Dockerfile, and that the instructions are not encapsulated in quotation marks. Subsequent sections of this article will detail syntax rules and Dockerfile instructions. 

```
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

For additional examples of Dockerfiles for Windows see the [Dockerfile for Windows Repository] (https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-server-container-samples).

### Syntax Reference 

The following table details several Dockerfile syntax items.

|Syntax Detail| Description |
|------------------|-------------|
|**Comments**| To wrap a single instruction onto multiple lines, place a / at the end of the line. |
|**Line Wrapping**|To wrap a single instruction onto multiple lines, place a / at the end of the line.|
|**Case Sensitivity**|Instruction such as FROM, RUN, and ADD are not case sensitive however convention is to differentiate instructions with upper case.|
|**Variables**|Environment variables can be created using the ENV instruction. They can be referenced with ${variable_name}. For more information on environment variables see [Docekrfile Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#environment-replacement).|
|**Omitting Files**| A .dockerignore file can be used to exclude files from the scope of docker build. For more information on dockerignore, see [Dockerfiel Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#dockerignore-file).|

### Instructions

Dockerfile instruction provide the Docker Engine with the steps needed in order to create a container image. These instructions are performed in order and one-by-one. Here are the details for some basic Dockerfile instructions. For a complete list of dockerfile instructions, see [Dockerfile Reference on Docker.com] (https://docs.docker.com/engine/reference/builder/).

### FROM

The FROM instruction sets the container image that will be used during the new image creation process. For instance, when using the instruction `FROM WindowsServerCore`, the resulting image will be derived from, and have a dependency on the WindowsServerCore Base OS image.

Examples:

```
FROM WindowsServerCore
```

```
FROM NanoServer
```

For detailed information on the FROM instruction see the [FROM Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#from). 

### RUN

The RUN instruction specifies commands to be run, and captured, into the new container image. These commands can include items such as installing software, creating files and directories, and creating environment configuration.

Examples:

```
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
```

```
RUN powershell -Command	c:\vcredist_x86.exe /quiet
``` 

For detailed information on the RUN instruction see the [RUN Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#run). 

### ADD

The ADD instruction copies files and directories to the filesystem of the container. The files and directories can be relative to the docker file, or on a remote location with a URL specification. 

Examples:

```
ADD sources /sqlite
```

```
ADD https://github.com/neilpeterson/demoapp/archive/master.zip /temp/master.zip
```

For detailed information on the ADD instruction see the [ADD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#add). 


### WORKDIR

The WORKDIR instruction sets a working directory, for other dockerfile instructions such as RUN, CMD, and ADD. 

Examples:

```
WORKDIR c:\Apache24\bin
```

```
WORKDIR c:\nginx
```

For detailed information on the WORKDIR instruction see the [WORKDIR Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#workdir). 

### CMD

The `CMD` instruction sets the default command to be run when starting a new container. For instance, if the container will be hosting an NGINX web server, the `CMD` might include instructions to start the web server, such as `nginx.exe`. There can only be one `CMD` instruction in a dockerfile.

```
CMD ["httpd.exe"]
```

```
CMD ["nginx.exe"]
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

