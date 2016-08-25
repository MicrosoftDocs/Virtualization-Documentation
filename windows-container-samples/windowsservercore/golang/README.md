# Description:

Creates an image containing golang 1.5.1.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t golang:latest .
```

**Docker Run**

This will start a container, display the Go version, and then exit.  Modify the Dockerfile appropriately for application use.

```
docker run -it golang
```

## Dockerfile Details:
```
FROM microsoft/windowsservercore

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	(New-Object System.Net.WebClient).DownloadFile('%GOLANG_DOWNLOAD_URL%', 'go.zip') ; \
	Expand-Archive go.zip -DestinationPath c:\\ ; \
	Remove-Item go.zip -Force

RUN setx PATH %PATH%;c:\go\bin
```
