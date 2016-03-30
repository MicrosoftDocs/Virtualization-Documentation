**This is preliminary content and subject to change.** 

# Optimize Windows Dockerfiles

Several methods can be used to optimize both the Docker build process, and the resulting Docker images. This document details how the Docker build process operates, and demonstrates several tactics that can be used for optimal image create with Windows Containers.

## Docker Build

### Image Layers

Before examining Docker build optimization, it is important to understand how Docker build works. During the Docker build process, a Dockerfile is consumed, and each actionable instruction is run, one-by-one, in its own temporary container. The result is a new image layer for each actionable instruction. 

Take a look at the following dockerfile. In this example, the windowsservercore base OS image is being used, IIS installed, and then a simple website created.

```none
# Sample Dockerfile

FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - dockerfile" > c:\inetpub\wwwroot\index.html
CMD [ "cmd" ]
```

From this dockerfile, one might expect the resulting image to consist of two layers, one for the container OS image, and a second that includes IIS and the website, this however is not the case. The new image is constructed of many layers, each one dependent on the previous. To visualize this, the `docker history` command can be run against the new image. Doing so will show that the image consists of four layers, the base, and then three additional layers, one for each instruction in the dockerfile.

```none
C:\> docker history iis

IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
f4caf476e909        16 seconds ago       cmd /S /C REM (nop) CMD ["cmd"]                 41.84 kB
f0e017e5b088        21 seconds ago       cmd /S /C echo "Hello World - Dockerfile" > c   6.816 MB
88438e174b7c        About a minute ago   cmd /S /C dism /online /enable-feature /all /   162.7 MB
6801d964fda5        4 months ago                                                         0 B                                                       0 B
```

Each of these layers can be mapped to an instruction from the dockerfile. The bottom layer (6801d964fda5 in this example) represents the base OS image. One layer up, the IIS installation can be seen. The next layer includes the new website, and so on.

Dockerfiles can be written to minimize image layers, optimize build performance, and also optimize cosmetic things such as readability. Ultimately, there are many ways to complete the same image build task. Understanding how the format of a dockerfile effects build time, and resulting image, will improve the automation experience. 

## Optimize Image Size

When building Docker container images, image size may be an important factor. Container images will be moved between registries and host, exported and imported, and ultimately consume space. Several tactics can be used during the Docker build process to minimize image size. This section will detail some of these tactics specific to Windows Containers. 

For additional information on dockerfile best practices, see [Best practices for writing dockerfiles on Docker.com]( https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

### Group related actions

Because each RUN instruction creates a new layer in the container image, grouping actions into one RUN instruction, can reduce the number of layers. The backslash character ‘\’ is used to organize the instruction onto separate lines of the dockerfile, while still using only one Run instruction.

The following two examples will demonstrate the same operation, which results in container images of identical capibility, however the two dockerfiles constructed differently. The resulting images will also be compared. 

This first example downloads, extracts, and cleans up the Visual Studio redistributable package. Each of these actions are run in their own RUN instruction.

```
FROM windowsservercore

RUN powershell.exe -command Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe
RUN powershell.exe -command c:\vcredist_x86.exe /quiet
RUN powershell.exe -command Remove-Item c:\vcredist_x86.exe -Force
```

The resulting image will consist of four layers, one for the Base image, and then one for each RUN instruction.

```
C:\> docker history doc-example-1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
bd6c831b55b8        2 minutes ago       cmd /S /C powershell.exe -command Remove-Item   46.23 MB
02b0752ebd10        2 minutes ago       cmd /S /C powershell.exe -command c:\vcredist   45.29 MB
91508fd744e5        3 minutes ago       cmd /S /C powershell.exe -command Invoke-WebR   51.92 MB
6801d964fda5        5 months ago
```
To compare, here is the same operation, however all steps run with the same RUN instruction. Note that each step in the RUN instruction is on a new line of the dockerfile, the '/' character is being used to line wrap. 

```none
FROM windowsservercore

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
	c:\vcredist_x86.exe /quiet ; \
	Sleep 20 ; \
	Remove-Item c:\vcredist_x86.exe -Force
```

The resulting image here consists of two layers, one for the Base image and then one for the Run instruction.

```
C:\> docker history doc-example-2
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
6d013914b19d        45 seconds ago      cmd /S /C powershell -Command  Invoke-WebRequ   65.44 MB
6801d964fda5        5 months ago                                                        0 B                                                      0 B
```

### Remove excess files

If a file, such as an installer, is not required after it has been used, remove the file to reduce image size. This will need to occur in the same step in which the file was copied into the image layer. Doing so will prevent the file from persisting in a lower level image layer.

In this example, the Visual Studio Redistribute package is downloaded, executed, and then the executable removed. This is all completed in one RUN operation and will result in a single image layer.
```none
RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
	c:\vcredist_x86.exe /quiet ; \
	Remove-Item c:\vcredist_x86.exe -Force
```

## Optimize Build Speed

### Multiple Lines

When optimizing for Docker build speed, it may be advantageous to separate operations into multiple individual instructions. Having multiple RUN operations increase caching effectiveness. Because individual layers are created for each RUN instruction, if an identical step has already been run in a different Docker Build operation, this cached operation (image layer) will be re-used. The result is that Docker Build runtime will be decreased.

In the following example, both Apache and the Visual Studio Redistribute packages are downloaded, installed, and then the un-needed files cleaned up. This is all done with one RUN instruction. If any of these actions are updated, all actions will re-run.

```none
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

To contrast, here are the same actions broken down into three RUN instructions. In this case, each RUN instruction is cached in a contianer image layer, and only those that have changed will need to re-run on subsequent dockerfile builds.

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

A Dockerfile is processed from top to the bottom, each Instruction compared against cached layers. When an instruction is found without a cached layer, this instruction and all subsequent instructions will be processed in new container image layers. Because of this, the order in which instructions are placed is important. Place instructions that will remain constant towards the top of the Dockerfile. Place instructions that may change towards the bottom of the Dockerfile. Doing so will reduce the likelihood of negating existing cache.

The intention of this example is to demonstrated how dockerfile instruction ordering can effect caching effectiveness. In this simple dockerfile, four numbered folders are created.  

```
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-3
RUN mkdir test-4
```
The resulting image has five layers, one for the base OS image, and one for each of the RUN instructions.

```
C:\> docker history doc-sample-1

IMAGE               CREATED              CREATED BY               SIZE                COMMENT
afba1a3def0a        38 seconds ago       cmd /S /C mkdir test-4   42.46 MB
86f1fe772d5c        49 seconds ago       cmd /S /C mkdir test-3   42.35 MB
68fda53ce682        About a minute ago   cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        About a minute ago   cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                  0 B    
```

The docker file has now been slightly modified. Notice that the third RUN instruction has changed. When Docker build is run against this dockerfile, the first three instructions, which are identical to those in the last example, will use cached image layers. However, because the changed RUN instruction has not been cached, a new layer will be created for itself and all subsequent instructions.

```
FROM windowsservercore

RUN mkdir test-1
RUN mkdir test-2
RUN mkdir test-5
RUN mkdir test-4
```

Comparing Image ID’s of the new image, to that in the last example, you will see that the first three layers (bottom to the top) are shared, however the fourth and fifth are unique.

```
C:\> docker history doc-sample-2

IMAGE               CREATED             CREATED BY               SIZE                COMMENT
c92cc95632fb        28 seconds ago      cmd /S /C mkdir test-4   5.644 MB
2f05e6f5c523        37 seconds ago      cmd /S /C mkdir test-5   5.01 MB
68fda53ce682        3 minutes ago       cmd /S /C mkdir test-2   6.745 MB
5e5aa8ba1bc2        4 minutes ago       cmd /S /C mkdir test-1   7.12 MB
6801d964fda5        5 months ago                                 0 B
```

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

## Further Reading & References

[Dockerfile on Windows] (./manage_windows_dockerfile.md)

[Best practices for writing Dockerfiles on Docker.com](https://docs.docker.com/engine/reference/builder/)