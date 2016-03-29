# Optimize Windows Dockerfiles

Several methods can be used to optimize both the Docker build process and the resulting Docker images. This document will detail how the Docker build process operates, and demonstrate several tactics that can be used for optimal Docker build performance and container image output with Windows containers. 

## Docker Build

### Image Layers

Before examining Docker build optimization, it is important to understand how Docker build works, and to understand how Docker images are created. During the Docker build process, the Docker engine executes each actionable instruction, one-by-one, each in its own temporary container. The result is a new image layer for each actionable instruction.
Take a look at the following dockerfile. In this sample the windowsservercore base OS image is being used, IIS is installed, and then a simple website created.

```none
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

From this dockerfile, one might expect the resulting image to consist of two layers, one for the container OS image, and a second for the new layer including IIS and the website, this however is not the case. The new image is constructed of many layers, each one dependent on the previous. To visualize this, the `docker history` command can be run against the new image. Doing so will show that the image consists of four layers, the base, and then three additional layers, one for each instruction in the dockerfile.

```
C:\> docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
f4caf476e909        16 seconds ago       cmd /S /C REM (nop) CMD ["cmd"]                 41.84 kB
f0e017e5b088        21 seconds ago       cmd /S /C echo "Hello World - Dockerfile" > c   6.816 MB
88438e174b7c        About a minute ago   cmd /S /C dism /online /enable-feature /all /   162.7 MB
6801d964fda5        4 months ago                                                         0 B                                                       0 B
```

Each layer can be mapped to an instruction in the dockerfile. The bottom layer (6801d964fda5 in this example) represents the base OS image. One layer up, the IIS installation can be see, one layer up from that the website is created, and so on.

Dockerfiles can be written to minimize image layers, optimize build performance, and also more cosmetic things such as to improve readability. Ultimately, there are many ways to complete the same image build task. Understanding how the format of a dockerfile effects build time and resulting image will improve the automation experience. 

## Dockerfile Optimization

There are several strategies that can be used when building dockerfiles, that result in an optimized image or build process. This section will detail some of these dockerfile tactics specific to Windows Containers. For additional information on dockerfile best practices, see [Best practices for writing dockerfiles on Docker.com]( https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Group related actions
Because each RUN instruction creates a new layer in the container image, grouping actions into one RUN instruction can reduce the number of layers in the image. The backslash character ‘\’ can be used to organize the operation onto separate lines of the dockerfile, while still using only one Run instruction.

The following two examples will demonstrate the same operation run with many individual RUN instructions, and then consolidated into one RUN instruction. The resulting images will also be compared. This example downloads, extracts, and cleans up a PHP installation. Each of these actions are run in their own RUN operation.

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

Contrasting to grouping action in one RUN operation, there may also benefit in having unrelated operations executed by multiple individual RUN instruction. Having multiple RUN operations increase caching effectiveness. Because individual layers are created for each RUN instruction, if an identical step has already been run in a different Docker Build operation, then this operation will not be re-run. The result is that Docker Build runtime will be decreased.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one RUN operations. If any of these actions are updated, the dockerfile updated, all actions will re-run.

```
FROM windowsservercore

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
    c:\vcredist_x86.exe /quiet ; \
    Sleep 20 ; \
    Remove-Item c:\apache.zip -Force; \
    Remove-Item c:\vcredist_x86.exe -Force
```

The resulting image consists of two layers, one for the base OS image, and the second contains all operations from the single RUN instruction. If any of these operations need to be modified, then all operations will be re-run.

```none
c:\>docker history doc-sample-1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
54a1d2d3a700        2 minutes ago       cmd /S /C powershell -Command  Invoke-WebRequ   136.6 MB
6801d964fda5        5 months ago                                                        0 B
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

The resulting image consists of three layers, one for the base OS image, and then one for each RUN instruction.

```none
c:\>docker history doc-sample-2
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
d43abb81204a        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   66.46 MB
7a21073861a1        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   115.8 MB
6801d964fda5        5 months ago                                                        0 B
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