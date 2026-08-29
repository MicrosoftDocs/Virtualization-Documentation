# Description:

This sample creates an image with containing Python 3.10.0. Also included is a ‘World Script’ to test functionality.

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
# Instructions

All container sample source code is kept under the Vitualization-Documentation git repository in a folder called windows-container-samples.
1. Open a PowerShell session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in CLI containing the django repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build -t python:latest .
5. To run the newly built container, run the docker run command.
   docker run -it python
6. This will enter you into the container and show you "Hello world!"
7. The container exits successfully.
## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://docs.python.org/3/license.html

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="Python" Vendor="Python Software Foundation" Version="3.10.0"

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    wget https://www.python.org/ftp/python/3.10.0/python-3.10.0.exe -OutFile c:\python-3.10.0.exe ; \
    Start-Process c:\python-3.10.0.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
    Remove-Item c:\python-3.10.0.exe -Force

CMD ["py", "-m" ,"__hello__"]
```
