# Dockerfile on Windows

The Docker engine includes tooling to automate the creation of container images. Building automation around image creation allows for effortless, repeatable, and consistent creation of container images. The component that drives this automation is a dockerfile, which is a text file containing a list of instructions to be run and captured into a new container image.

Two components drive the automation of image creation:

- **Dockerfile** – a text file containing instructions on how to derive the image, commands to run and captured into the image, and run time commands.
- **Docker Build** – the Docker engine command that triggers the image creation process.

This document will introduce using a dockerfile with Windows Containers, detail some best practices, and provide some ready to use examples. For a complete look at the Docker engine and Dockerfile, see the [Dockerfile reference at docker.com]( https://docs.docker.com/engine/reference/builder/).

## Dockerfile Introduction

### Basic Syntax

In its most basic form, a dockerfile can be very simple. The following example creates a new image that includes IIS and a customized ‘hello world’ site. This example uses only three dockerfile instructions, FROM, RUN and CMD. This section will cover some basic Dockerfile instructions. For a complete list of dockerfile instructions, see [Dockerfile Reference on Docker.com] (https://docs.docker.com/engine/reference/builder/).
```
FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

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

The `CMD` instruction sets the default command to be run when starting a new container from the container image. For instance, if the container will be hosting an NGINX web server, the `CMD` might include instructions to start the web server, such as `nginx.exe`. There can only be one `CMD` instruction in a dockerfile.

```
CMD ["httpd.exe"]
```

```
CMD ["nginx.exe"]
```

For detailed information on the CMD instruction see the [CMD Reference on Docker.com]( https://docs.docker.com/engine/reference/builder/#cmd). 

## Docker Build operations

Once a dockerfile has created, and saved to disk, `docker build` can be run to create the new image. 

### Docker Build 

The `docker build` command takes several optional parameters and a path to the dockerfile.

```
Docker build [OPTIONS] PATH
```
For example, the following command will create an image named ‘iis’ and look in the relative path for the dockerfile.

```
docker build -t iis .
```

For complete documentation on Docker Build, including a list of all build options, see [Build at Docker.com](https://docs.docker.com/engine/reference/commandline/build/#build-with).


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

The result is a new container image with the name 'iis'.

```
C:\> docker images

REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
iis                 latest              e2aafdfbe392        About a minute ago   207.8 MB
windowsservercore   latest              6801d964fda5        4 months ago         0 B
```

### Image Layers

During the Docker Build process, the Docker engine executes each dockerfile instruction one-by-one, each in its own temporary container. The result is a new image layer for each actionable command in the dockerfile. Looking back at the simple example given above, one might expect the resulting image to consist of two layers, WindowsServerCore, and then the new layer including the IIS configuration. This however is not the case. 

To inspect a container image, use the `docker history` command. Doing so against the image created with the simple example dockerfile will show that the image consists of three layers, the base, and then two additional layers, one for each actionable instruction in the dockerfile. 

```
C:\> docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
e2aafdfbe392        About a minute ago   cmd /S /C echo "Hello World - Dockerfile" > c   46.05 MB
4cd675d35444        2 minutes ago        cmd /S /C dism /online /enable-feature /all /   161.8 MB
6801d964fda5        4 months ago                                                         0 B
```

## Dockerfile Optimization

There are several strategies that can be used when building Dockerfiles, that will result in an optimized image. This section will detail some of these dockerfile tactics, specific to Windows Containers. For additional information on Dockerfile best practices, see [Best practices for writing Dockerfiles on Docker.com]( https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Minimize operations per instruction
This makes caching more effective. If the same step has been done in a similar build, then this step could be cached. Although adding a script is convenient, breaking it into multiple RUN commands will cache more and build faster.

```
RUN script.cmd
```
<!-- build twice, show docker history excerpt -->

```
RUN foo
RUN bar
```
<!-- build twice, show docker history excerpt -->

### Remove excess files
If a file, such as an installer, isn't required after the RUN step, you can delete it to save space in the layer.

Example:
<!-- compare wget & unzip to wget & unzip & delete -->


### Consider using copy-based installs instead of MSI-based installs  
The [Windows Installer][msi] is designed to install, upgrade, repair, and remove applications from a Windows machine. This is convenient for desktop machines and servers that may be maintained for a long time, but may not be necessary for a container that can easily be redeployed or rebuilt. Using ADD to copy the needed files into a container, or unzipping an archive may produce fewer changes in the container, and make the resulting image smaller.

Example:
<!-- compare a Git installation vs UNZIP -->



[@StefanScherer](http://www.github.com/StefanScherer) shared his experiences optimizing an image for building applications using Go in [Issue:dockerfiles-windows#1](https://github.com/StefanScherer/dockerfiles-windows/issues/1)  


<!--## WORKDIR -->
<!-- Topics: compare to RUN cd ... -->


<!-- ## CMD -->
<!-- Topics: envvar scope & set /x workaround -->



## Further Reading & References
* [Optimizing Docker Images](https://www.ctl.io/developers/blog/post/optimizing-docker-images/)

<!-- These URLs can't be used with the typical [text](link) syntax, so the reference style was used instead -->
<!--[msi]: https://msdn.microsoft.com/en-us/library/aa367449(v=vs.85).aspx "About Windows Installer"-->
