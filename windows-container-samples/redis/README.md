# Description:

Creates an image containing MSOpenTech Redis 2.8.2. For more information see, [MSOpenTech / redis on Github.com](https://github.com/MSOpenTech/redis/releases).

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t redis:latest .
```

**Docker Run** 

This will display the Redis splash screen. Use `ctrl - c` to exit.  

```
docker run -it redis
```

Start in the background, listening on default port.

```
docker run -d -p 6379:6379 redis
```

## Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://libraries.io/licenses/BSD-3-Clause

FROM microsoft/windowsservercore

LABEL Description="Redis" Vendor="MSOpenTech" Version="2.8"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://github.com/MSOpenTech/redis/releases/download/win-2.8.2400/Redis-x64-2.8.2400.zip -OutFile c:\redis.zip ; \
    Expand-Archive -Path c:\redis.zip -DestinationPath c:\redis ; \
    Remove-Item c:\redis.zip -Force

WORKDIR /redis

CMD redis-server.exe
```
