# Description
This sample shows how to create a go image for both windows nanoserver and servercore 2022.

# Nano Server

## Nano Server - Description:

The first samples creates an image containing the latest version of golang, which is golang 1.13.

This dockerfile is for demonstration purposes and may require modification for production use.

## Nano Server - Environment:

Nano Server Base OS Image

## Nano Server - Usage:

**Docker Build**

```
docker build --isolation=hyperv -t golang:latest .
```

**Docker Run**

This will start a container, display the Go version, and then exit.  Modify the Dockerfile appropriately for application use.

```
docker run -it golang
```



# Instructions

All container sample source code is kept under the Vitualization-Documentation git repository in a folder called windows-container-samples.
1. Open a Powershell session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in CLI containing the django repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build --isolation=hyperv -t golang:latest .
5. To run the newly built container, run the docker run command.
    docker run -it golang
7. The golang version should display. Use the exit command to exit the container.
The below directions will show users how to run the samples located in the repo. 

### Nano Server - Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://golang.org/LICENSE

FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

ENV GOLANG_VERSION 1.13
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell.exe -Command ; \
   $ErrorActionPreference = 'Stop'; \
	(New-Object System.Net.WebClient).DownloadFile('%GOLANG_DOWNLOAD_URL%', 'go.zip') ; \
	Expand-Archive go.zip -DestinationPath c:\\ ; \
    Remove-Item c:\go.zip -Force

RUN powershell.exe -Command $env:path = $env:path + ';c:\go\bin'

```

## Windows Server Core - Description:

This sample creates an image containing golang 1.13 on Windows Server Core 2022. 

This dockerfile is for demonstration purposes and may require modification for production use.

## Windows Server Core - Environment:

Windows Server Core Base OS Image

## Windows Server Core - Usage:

**Docker Build**

```
docker build -t golang:latest .
```

**Docker Run**

This will start a container, display the Go version, and then exit.  Modify the Dockerfile appropriately for application use.

```
docker run -it golang
```

### Windows Server Core - Dockerfile Details:
```Dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022

ENV GOLANG_VERSION 1.13
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    (New-Object System.Net.WebClient).DownloadFile('%GOLANG_DOWNLOAD_URL%', 'go.zip') ; \
    Expand-Archive go.zip -DestinationPath c:\\ ; \
    Remove-Item go.zip -Force

RUN setx PATH %PATH%;c:\go\bin
```
