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

## Cosmetic Optimization

### Instruction Case

Dockerfile instructions are not case sensitive, however convention is to use upper case. This improves readability by differentiating between Instruction call, and instruction operation. The below two examples demonstrate this concept. 

Lower case:
```none
# Sample Dockerfile

from windowsservercore
run dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
run echo "Hello World - dockerfile" > c:\inetpub\wwwroot\index.html
cmd [ "cmd" ]
```
Upper case: 
```none
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

### Line Wrapping

Long and complex operations can be separated onto multiple line using the backslash ‘\’ character. The following dockerfile installs the Visual Studio Redistributable package, removes the installer files, and then creates a configuration file. These three operations are all specified on one line.

```
FROM windowsservercore

RUN powershell -Command c:\vcredist_x86.exe /quiet ; Remove-Item c:\vcredist_x86.exe -Force ; New-Item c:\config.ini
```
The command can be re-written so that each operation from the one RUN instruction is specified on its own line. 
```
FROM windowsservercore

RUN powershell -Command \
	c:\vcredist_x86.exe /quiet ; \
	Remove-Item c:\vcredist_x86.exe -Force ; \
	New-Item c:\config.ini
```

## PowerShell in Dockerfile

### PowerShell Commands

Powershell commands can be run in a dockerfile using the RUN operation. 

```none
FROM windowsservercore

RUN powershell -command Expand-Archive -Path c:\apache.zip -DestinationPath c:\
```

### REST Calls

PowerShell and the `Invoke-WebRequest` command can be useful when gathering information or files from a web service. For instance, if building an image that includes the Apache webserver, the following example could be used. Notice here that a single RUN instruction is used to perform three operations.

```none
FROM windowsservercore

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force
```

### PowerShell Scripts

In some cases it may be helpful to copy a script to the containers being used during the image creation process and run it from within the container. Note that this process will limit any image layer caching and decrease readability of the Dockerfile.

This example copies a script from the build machine, into the container using the ADD instruction. This script is the run using the RUN instruction.

```
FROM windowsservercore
ADD script.ps1 /windows/temp/script.ps1
RUN powershell.exe -executionpolicy bypass c:\windows\temp\script.ps1
```

## Optimize Image Size

### Consolidate Instructions

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

## Optimize Build Speed

### Multiple Lines

When optimizing for Docker build speed, it may be advantageous to separate operations into multiple individual instructions. Having multiple RUN operations increase caching effectiveness. Because individual layers are created for each RUN instruction, if an identical step has already been run in a different Docker Build operation, this caches operation (image layer) will be re-used and the operation will not be re-run. The result is that Docker Build runtime will be decreased.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one RUN operations. If any of these actions are updated, all actions will re-run.

```
FROM windowsservercore

RUN powershell -Command \
	
    # Download software ; \
    
    Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
    Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
    Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	
    # Install Software ; \
    
    Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
    Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    c:\vcredist_x86.exe /quiet ; Sleep 20 ; \
    
    # Remove unneeded files ; \
     
    Remove-Item c:\apache.zip -Force; \
    Remove-Item c:\vcredist_x86.exe -Force
```

The resulting image consists of two layers, one for the base OS image, and the second that contains all operations from the single RUN instruction.

```none
c:\> docker history doc-sample-1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
9bdf3a21fd41        8 minutes ago       cmd /S /C powershell -Command     Invoke-WebR   205.8 MB
6801d964fda5        5 months ago                                                        0 B
```

To contrast, here are the same actions broken down into three RUN instructions. In this case each RUN instruction is cached in a contianer image layer, and only those that have changed will need to re-run on subsequent dockerfile builds.

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

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
	Remove-Item c:\php.zip -Force
```

The resulting image consists of four layers, one for the base OS image, and then one for each RUN instruction. Because each RUN instruction has been run in its own layer, any subsequent runs of this Dockerfile or identical set of instructions in a different Dockerfile, will use the cached image layer, thus reducing build time. Instruction ordering is important when working with image cache, for more details, see Instruction Ordering.

```none
C:\> docker history doc-sample-2
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
ddf43b1f3751        6 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   127.2 MB
d43abb81204a        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   66.46 MB
7a21073861a1        7 days ago          cmd /S /C powershell -Command  Sleep 2 ;  Inv   115.8 MB
6801d964fda5        5 months ago
```

### Ordering Instructions

A Dockerfile is processed from top to the bottom, each Instruction compared against cached layers. When an instruction is found without a cached layer, this instruction and all subsequent instructions will be processed in a new container image layer. Because of this, the order in which instructions are placed is important. Place instructions that will remain constant towards the top of the Dockerfile. Place instructions that may change towards the bottom of the Dockerfile. Doing so will reduce the likelihood of negating existing cache.

```
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-3
RUN mkdir test-4
```

```
C:\> docker history doc-sample-1

IMAGE               CREATED              CREATED BY               SIZE                COMMENT
afba1a3def0a        38 seconds ago       cmd /S /C mkdir test-4   42.46 MB
86f1fe772d5c        49 seconds ago       cmd /S /C mkdir test-3   42.35 MB
68fda53ce682        About a minute ago   cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        About a minute ago   cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                  0 B    
```

```
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-5
RUN mkdir test-4
```

```
C:\> docker history doc-sample-2

IMAGE               CREATED             CREATED BY               SIZE                COMMENT
c92cc95632fb        28 seconds ago      cmd /S /C mkdir test-4   5.644 MB
2f05e6f5c523        37 seconds ago      cmd /S /C mkdir test-5   5.01 MB
68fda53ce682        3 minutes ago       cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        4 minutes ago       cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                 0 B
```
