# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://nginx.org/LICENSE

FROM windowsservercore

LABEL Description="Nginx" Vendor=Nginx" Version="1.0.13"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri http://nginx.org/download/nginx-1.9.13.zip -OutFile c:\nginx-1.9.13.zip ; \
	Expand-Archive -Path c:\nginx-1.9.13.zip -DestinationPath c:\ ; \
	Remove-Item c:\nginx-1.9.13.zip -Force

WORKDIR /nginx-1.9.13

CMD ["/nginx-1.9.13/nginx.exe"]