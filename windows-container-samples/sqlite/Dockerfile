# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://www.sqlite.org/copyright.html

# keep in mind that the SQLite Versions and download URIs change very often!

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
