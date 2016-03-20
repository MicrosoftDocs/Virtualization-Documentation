# Dockerfile on Windows

The Docker engine includes tooling to automate the creation of container images. Building automation around image creation allows for effortless, repeatable, and consistent creation of container images. The component that drives this automation is a dockerfile, which is a text file containing a list of instructions to be run and captured into a new container image.

Two components drive the automation of image creation:

- **Dockerfile** – a text file containing instructions on how to derive the image, commands to run and captured into the image, and run time commands.
- **Docker Build** – the Docker engine command that triggers the image creation process.

This document will introduce using a dockerfile with Windows Containers, detail some best practices, and provide some ready to use examples. For a complete look at the Docker engine and Dockerfile, see the [Dockerfile reference at docker.com]( https://docs.docker.com/engine/reference/builder/).

## Dockerfile Introduction

### Basic Syntax

In its most basic form, a dockerfile can be very simple. The following example creates a new image that includes IIS and a customized ‘hello world’ site. This example uses only three dockerfile instructions, FROM, RUN and CMD. Also note that a # can be used to add comments to the Dockerfile.
```
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

Here are the details for some basic Dockerfile instructions. For a complete list of dockerfile instructions, see [Dockerfile Reference on Docker.com] (https://docs.docker.com/engine/reference/builder/).

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

### Group related actions
Because each RUN operations creates a new layer in the container image, grouping actions into one RUN operation can reduce the number of layers in the image. The backslash character ‘\’ can be used to organize the operation onto separate lines of the Dockerfile, while still using one Run operation.

This example downloads, extracts, and cleans up a PHP installation. Each of these actions are run in their own RUN operation.

```
FROM windowsservercore

RUN powershell Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip
RUN powershell	Expand-Archive -Path c:\php.zip -DestinationPath c:\php
RUN powershell	Remove-Item c:\php.zip -Force
```

The resulting image will consist of three layers, one for each operation completed.

```
C:\> docker history example1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
b4a936eed201        2 minutes ago       cmd /S /C powershell Remove-Item c:\php.zip -   24.57 MB
b9eaf6ddbda9        2 minutes ago       cmd /S /C powershell Expand-Archive -Path c:\   73.88 MB
114054baa14a        2 minutes ago       cmd /S /C powershell Invoke-WebRequest -Metho   98.68 MB
```
To compare, here is the same operation, however all steps executed in the same RUN operation.

```
FROM windowsservercore

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
	Remove-Item c:\php.zip -Force
```

The resulting image here consists of only one layer.

```
C:\> docker history example2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
286051e85b58        46 seconds ago      cmd /S /C powershell -Command  Sleep 2 ;  Inv   128.3 MB
```

### Minimize operations per instruction

Contrasting with grouping action in one RUN operation, there is also benefit in having unrelated operations being executed by individual RUN operations. Having multiple RUN operations increase caching effectiveness. If the same step has been done in a similar build, then this step could be cached. Although adding a script is convenient, breaking it into multiple RUN commands will cache more and build faster.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one RUN operations. If any of these actions are updated, the Dockerfile re-built, all actions will re-run.

```
FROM windowsservercore

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
    c:\vcredist_x86.exe /quiet ; \
    Remove-Item c:\apache.zip -Force; \
    Remove-Item c:\vcredist_x86.exe -Force
```

To contrast, here are the same actions broken down into two RUN instructions. In this case each RUN instruction is cached in a layer, and only those that have changed will need to re-run on subsequent Dockerfile builds.

> The docker engine consumes a Dockerfile from the top to the bottom. As soon as any change is detected, all remaining actions will be re-run. Because of this, place all frequently changing actions towards the bottom of the Dockerfile.

```
FROM windowsservercore

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
	c:\vcredist_x86.exe /quiet ; \
	Sleep 20 ; \
	Remove-Item c:\vcredist_x86.exe -Force
```

### Remove excess files
If a file, such as an installer, isn't required after the RUN step, delete it to minimize image size. Perform the delete operation in the same RUN instruction as it was used. This will prevent a second image layer. 

In this example, the Visual Studio Redistribute package is downloaded, executed, and then the executable removed. This is all completed in one RUN operation and will result in a single image layer in the final image.
```
RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
	c:\vcredist_x86.exe /quiet ; \
	Remove-Item c:\vcredist_x86.exe -Force
```

### Consider using copy-based installs instead of MSI-based installs  
The [Windows Installer](https://msdn.microsoft.com/en-us/library/aa367449(v=vs.85).aspx) package format is designed to install, upgrade, repair, and remove applications from a Windows machine. This is convenient for desktop machines and servers that may be maintained for a long time, but may not be necessary for a container that can easily be redeployed or rebuilt. Using ADD to copy the needed files into a container, or unzipping an archive may produce fewer changes in the container, and make the resulting image smaller.

Example:

```
ADD Example
```

[@StefanScherer](http://www.github.com/StefanScherer) shared his experiences optimizing an image for building applications using Go in [Issue:dockerfiles-windows#1](https://github.com/StefanScherer/dockerfiles-windows/issues/1).  


<!--## WORKDIR -->
<!-- Topics: compare to RUN cd ... -->


<!-- ## CMD -->
<!-- Topics: envvar scope & set /x workaround -->

## Further Reading & References
* [Optimizing Docker Images](https://www.ctl.io/developers/blog/post/optimizing-docker-images/)


