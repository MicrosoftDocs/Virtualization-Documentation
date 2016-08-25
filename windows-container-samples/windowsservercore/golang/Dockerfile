FROM microsoft/windowsservercore

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	(New-Object System.Net.WebClient).DownloadFile('%GOLANG_DOWNLOAD_URL%', 'go.zip') ; \
	Expand-Archive go.zip -DestinationPath c:\\ ; \
	Remove-Item go.zip -Force

RUN setx PATH %PATH%;c:\go\bin

