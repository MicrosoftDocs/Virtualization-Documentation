# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://nginx.org/LICENSE

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="Nginx" Vendor="Nginx" Version="1.20.2"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri http://nginx.org/download/nginx-1.20.2.zip -OutFile c:\nginx-1.20.2.zip ; \
	Expand-Archive -Path c:\nginx-1.20.2.zip -DestinationPath c:\ ; \
	Remove-Item c:\nginx-1.20.2.zip -Force

WORKDIR /nginx-1.20.2

CMD ["/nginx-1.20.2/nginx.exe"]
