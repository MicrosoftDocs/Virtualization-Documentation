# Description:

Create a demo container with IIS 10. The dockerfile CMD is just a persistent ping to give the container something to hang off of for demonstration purposes.

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker Build –t iis .
```

**Docker Run** 

This will enter the container and display the SQLite version to validate functionality. Type `.exit` to exit.

```
docker run -d -p 80:80 iis
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.

FROM windowsservercore

MAINTAINER neil.peterson@microsoft.com

LABEL Description="IIS" Vendor=Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

CMD [ "ping localhost -t" ]
```


