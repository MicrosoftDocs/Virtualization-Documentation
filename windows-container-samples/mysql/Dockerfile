# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.mysql.com/about/legal/licensing/oem/

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="MySql" Vendor="Oracle" Version="8.0.27"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Method Get -Uri https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.27-winx64.zip -OutFile c:\mysql.zip ; \
    Expand-Archive -Path c:\mysql.zip -DestinationPath c:\ ; \
    Remove-Item c:\mysql.zip -Force

RUN setx /M Path "%path%;c:\mysql-8.0.27-winx64\bin"

CMD ["mysqld.exe"]
