# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.apache.org/licenses/

FROM microsoft/windowsservercore

LABEL Description="Apache" Vendor="Apache Software Foundation" Version="2.4.23"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri https://home.apache.org/~steffenal/VC14/binaries/httpd-2.4.38-win64-VC14.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe" -OutFile c:\vc_redist.x64.exe ; \
	start-Process c:\vc_redist.x64.exe -ArgumentList '/quiet' -Wait ; \
	Remove-Item c:\vc_redist.x64.exe -Force

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w
