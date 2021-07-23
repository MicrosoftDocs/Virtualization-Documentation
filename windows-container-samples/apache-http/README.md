# Description:

Creates an image containing Apache 2.4.18 for Windows and the required Visual Studio redistributable package.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t apache-http:latest .
```

**Docker Run**

```
docker run -d -p 80:80 apache-http
```


## Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.apache.org/licenses/

FROM mcr.microsoft.com/windows/servercore:2009

LABEL Description="Apache" Vendor="Apache Software Foundation" Version="2.4.18"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
    Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    Remove-Item c:\apache.zip -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
    start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; \
    Remove-Item c:\vcredist_x86.exe -Force

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w
```
