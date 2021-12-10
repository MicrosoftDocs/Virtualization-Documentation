# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://golang.org/LICENSE

FROM mcr.microsoft.com/windows/servercore:ltsc2022

ENV GOLANG_VERSION 1.13
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell.exe -Command \
	$ErrorActionPreference = 'Stop'; \
	(New-Object System.Net.WebClient).DownloadFile('%GOLANG_DOWNLOAD_URL%', 'go.zip') ; \
	Expand-Archive go.zip -DestinationPath c:\\ ; \
	Remove-Item go.zip -Force
	
RUN powershell.exe -Command $path = $env:path + ';c:\go\bin'; Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $path
