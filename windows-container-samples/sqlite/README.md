# Description:

This sample will create a demo container with the latest SQLite 3.37.0 software on windows server 2022 servercore image. Sqlite is a library that implements a serverless, self-contained, high-reliability SQL database engine.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t sqlite:latest .
```

**Docker Run**

This will run a container, display the SQLite version, and then exit. Modify the Dockerfile appropriately for application use.

```
docker run -it sqlite
```

**Instructions**

All container sample source code is kept under the Vitualization-Documentation git repository in a folder called windows-container-samples.
1. Open a PowerShell session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in PowerShell containing the PowerShell repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build -t sqlite:latest .
5. To run the newly built container, run the docker run command.
    docker run -it sqlite
6. This will enter you into the container and you should see sql lite database appear.

## Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://www.sqlite.org/copyright.html

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="SQLite" Vendor="SQLite" Version="3.37.0"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri https://www.sqlite.org/2021/sqlite-dll-win64-x64-3370000.zip -OutFile c:\sqlite-dll-win64-x64.zip ; \
	Expand-Archive -Path c:\sqlite-dll-win64-x64.zip -DestinationPath c:\sqlite ; \
	Remove-Item c:\sqlite-dll-win64-x64.zip -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri https://www.sqlite.org/2021/sqlite-tools-win32-x86-3370000.zip -OutFile c:\sqlite-tools-win32-x86.zip ; \
	Expand-Archive -Path c:\sqlite-tools-win32-x86.zip -DestinationPath c:\sqlite ; \
	Copy-Item -Path c:\sqlite\sqlite-tools-win32-x86-3370000\*.* c:\sqlite ; \
	Remove-Item c:\sqlite\sqlite-tools-win32-x86-3370000 -Recurse -Force ; \
	Remove-Item c:\sqlite-tools-win32-x86.zip -Force

RUN setx /M PATH "%PATH%;c:\sqlite"

CMD ["sqlite3.exe"]

```
