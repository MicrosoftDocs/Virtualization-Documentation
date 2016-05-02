# Description:

Creates an image with containing Python 3.5.1. Also included is a ‘World Script’ to test functionality.

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t python:latest .
```

**Docker Run** 

This will start a container, run the sample ‘Hello World’ script, and then exit.  Modify the Dockerfile appropriately for application use. 

```
docker run -it python
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://docs.python.org/3/license.html

FROM windowsservercore

LABEL Description="Python" Vendor="Python Software Foundation" Version="3.5.1"

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    wget https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
    Start-Process c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
    Remove-Item c:\python-3.5.1.exe -Force

RUN echo print("Hello World!") > c:\hello.py

CMD ["py c:/hello.py"]
		
```


