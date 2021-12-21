# Description:

This sample creates a demo container with IIS 10. The dockerfile CMD is just a persistent ping to give the container something to hang off of for demonstration purposes.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t iis:latest .
```

**Docker Run**

```
docker run -d -p 80:80 iis
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="IIS" Vendor="Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

CMD [ "ping", "localhost", "-t" ]
```


