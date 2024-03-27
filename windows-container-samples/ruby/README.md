# Description:

This sample creates an image containing Ruby 3.0.3. It has been updated to use the latest windows server image as well as the latest ruby version.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t ruby:latest .
```

**Docker Run**

This will display the Ruby version and exit. Modify the Dockerfile appropriately for application use.

```
docker run -it ruby cmd
```
# Instructions
All container sample source code is kept under the Virtualization-Documentation git repository in a folder called windows-container-samples.
1. Open a PowerShell session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in CLI containing the Ruby repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build -t ruby:latest .
5. To run the newly built container, run the docker run command.
    docker run -it ruby cmd
6. This will enter you into the container. Use the following command to retrieve the version of Ruby that you are using.
    C:/Ruby22-x64/bin/ruby.exe --version
7. The Ruby version should display. Use the exit command to exit the container.

## Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://www.ruby-lang.org/en/about/license.txt

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="Ruby Programming Language for Windows" Vendor="Ruby" Version="3.0.3-x64"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.3-1/rubyinstaller-3.0.3-1-x64.exe -OutFile c:\rubyinstaller-3.0.3-1-x64.exe ; \
	Start-Process c:\rubyinstaller-3.0.3-1-x64.exe -ArgumentList '/verysilent' -Wait ; \
	Remove-Item c:\rubyinstaller-3.0.3-1-x64.exe -Force

WORKDIR /Ruby30-x64/bin

CMD ["C:\Ruby30-x64\bin\ruby.exe --version"]
