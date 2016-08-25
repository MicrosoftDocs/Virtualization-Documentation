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