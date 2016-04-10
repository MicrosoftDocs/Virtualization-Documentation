FROM windowsservercore

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.msi

RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri %GOLANG_DOWNLOAD_URL% -OutFile go.msi ; \
	start-Process go.msi -ArgumentList '/qn' -Wait ; \
	Remove-Item go.msi -Force

ENV GOPATH c:\\go
WORKDIR $GOPATH
