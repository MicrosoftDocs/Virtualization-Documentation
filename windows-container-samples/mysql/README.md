# Description:

This repository creates an image containing mysql 8.0.27. Using this example, the root password will be blank, and remote connections enabled. There are a few hacks in this Dockerfile to mitigate some unknown issues. The dockerfile CMD is just a persistent ping to give the container something to hang off of.

This dockerfile is for demonstration purposes and may require modification for production use.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t mysql:latest .
```

**Docker Run**

```
docker run -d -p 3306:3306 mysql
```

# Dockerfile Details:
```Dockerfile
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.mysql.com/about/legal/licensing/oem/

FROM mcr.microsoft.com/windows/servercore:2022

LABEL Description="MySql" Vendor="Oracle" Version="8.0.27"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Method Get -Uri https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.27-winx64.zip -OutFile c:\mysql.zip ; \
    Expand-Archive -Path c:\mysql.zip -DestinationPath c:\ ; \
    Remove-Item c:\mysql.zip -Force

RUN SETX /M Path %path%;C:\mysql-8.0.27-winx64\bin

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    mysqld.exe --install ; \
    Start-Service mysql ; \
    Stop-Service mysql ; \
    Start-Service mysql

RUN mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"

CMD [ "ping localhost -t" ]

```
