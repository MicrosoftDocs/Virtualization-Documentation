# Description:

Creates an image containing Python 3.7.3 and Django 2.2.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t python-django:latest .
```

**Docker Run**

This will run a container, display the Django version, and then exit. Modify the Dockerfile appropriately for application use.

```
docker run -it python-django
```

## Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://docs.python.org/3/license.html, https://github.com/django/django/blob/master/LICENSE

FROM mcr.microsoft.com/windows/servercore

LABEL Description="Python" Vendor="Python Software Foundation" Version="3.7.3"

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest https://www.python.org/ftp/python/3.7.3/python-3.7.3.exe -OutFile c:\python-3.7.3.exe ; \
    start-Process  c:\python-3.7.3.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait  ; \
    Sleep 60 ; \
    Remove-Item c:\python-3.7.3.exe -Force

RUN ["pip", "install", "Django==2.2"]

CMD ["django-admin --version"]
```
