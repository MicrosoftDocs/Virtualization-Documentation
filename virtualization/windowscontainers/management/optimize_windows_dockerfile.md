# Optimize Windows Dockerfiles

Several methods can be used to optimize both the Docker build process and the resulting Docker images. This document will detail how the Docker build process operates, and demonstrate several tactics that can be used for optimal Docker build performance and container image output with Windows containers. 

## Docker Build

### Image Layers

During the Docker build process, the Docker engine executes each dockerfile instruction one-by-one, each in its own temporary container. The result is a new image layer for each actionable command in the dockerfile. Take a look at the following dockerfile. In this sample, the WindowsServerCore container OS image is being used, IIS installed, and then a simple ‘Hello World’ static site created.   

```
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```
From this dockerfile one might expect the resulting image to consist of two layers, one for the container OS image and a secound new layer including the IIS configuration and static 'Hello World' site, this however is not the case.  It is true that the resulting image depends on the windowsservercore container os image, thus a container created from this image depends on both images being present but what is not as apparent is that the image the dockerfile built is constructed itself of multiple layers.  Each line of a dockerfile constructs a new layer (think of each layer as a mini container image) and when the build is compleated all of those layers are wrapped up together into a single image.

To inspect the layers of a container image, use the `docker history` command. Doing so against the image created with the simple example dockerfile will show that the image consists of four layers, the base, and then three additional layers, one for each actionable instruction in the dockerfile.

```
C:\> docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
f4caf476e909        16 seconds ago       cmd /S /C REM (nop) CMD ["cmd"]                 41.84 kB
f0e017e5b088        21 seconds ago       cmd /S /C echo "Hello World - Dockerfile" > c   6.816 MB
88438e174b7c        About a minute ago   cmd /S /C dism /online /enable-feature /all /   162.7 MB
6801d964fda5        4 months ago                                                         0 B                                                       0 B
```

This build behavior can be advantageous and may be desirable when troubleshooting individual image layers. However, if desired, the number of layers can be minimized using several tricks detailed later in this article.

## Dockerfile Optimization

There are several strategies that can be used when building dockerfiles, that will result in an optimized image. This section will detail some of these dockerfile tactics specific to Windows Containers. For additional information on dockerfile best practices, see [Best practices for writing dockerfiles on Docker.com]( https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Group related actions
Because each RUN instruction creates a new layer in the container image, grouping actions into one RUN instruction can reduce the number of layers in the image. The backslash character ‘\’ can be used to organize the operation onto separate lines of the dockerfile, while still using only one Run instruction.

This example downloads, extracts, and cleans up a PHP installation. Each of these actions are run in their own RUN operation.

```
FROM windowsservercore

RUN powershell Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip
RUN powershell	Expand-Archive -Path c:\php.zip -DestinationPath c:\php
RUN powershell	Remove-Item c:\php.zip -Force
```

The resulting image will consist of four layers, one for the Base image, and then one for each operation completed.

```
C:\> docker history example1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
dbe8eaac141f        30 minutes ago      cmd /S /C powershell Remove-Item c:\php.zip -   45.74 MB
ec2d672c3609        30 minutes ago      cmd /S /C powershell Expand-Archive -Path c:\   95.97 MB
99f4dcd0275a        31 minutes ago      cmd /S /C powershell Invoke-WebRequest -Metho   99.21 MB
6801d964fda5        4 months ago
```
To compare, here is the same operation, however all steps executed in the same RUN operation. Note that while each step in the RUN instruction is on a new line of the dockerfile, the / symbol is being used to line wrap. 

```
FROM windowsservercore

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
	Remove-Item c:\php.zip -Force
```

The resulting image here consists of two layers, one for the Base image and then one for the Run instruction.

```
C:\> docker history example2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
95bc97a63e47        4 minutes ago       cmd /S /C powershell -Command  Sleep 2 ;  Inv   128.6 MB
6801d964fda5        4 months ago                                                        0 B
```

### Minimize operations per instruction

Contrasting to grouping action in one RUN operation, there may also benefit in having unrelated operations executed by multiple individual RUN operations. Having multiple RUN operations increase caching effectiveness. Because individual layers are created for each RUN instruction, if an identical step has already been run in a different Docker Build operation, then this operation will not be re-run. The result is that Docker Build runtime will be decreased.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one RUN operations. If any of these actions are updated, the dockerfile updated, all actions will re-run.

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

To contrast, here are the same actions broken down into two RUN instructions. In this case each RUN instruction is cached in a contianer image layer, and only those that have changed will need to re-run on subsequent dockerfile builds.

> The docker engine consumes a Dockerfile from the top to the bottom. As soon as any change is detected, all remaining actions will be re-run. Because of this, place all frequently changing actions towards the bottom of the dockerfile.

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

### MSI base installation
 
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
