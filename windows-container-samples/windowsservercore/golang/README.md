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
docker run –it golang
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://golang.org/LICENSE

FROM windowsservercore

MAINTAINER neil.peterson@microsoft.com

LABEL Description="GO Programming Language" Vendor="Google" Version="1.5.1"

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri https://storage.googleapis.com/golang/go1.6.windows-amd64.msi -OutFile c:\go1.6.windows-amd64.msi ; \
	start-Process c:\go1.6.windows-amd64.msi -ArgumentList '/qn' -Wait ; \
	Remove-Item c:\go1.6.windows-amd64.msi -Force

WORKDIR /go/bin

CMD ["go.exe version"]
```


