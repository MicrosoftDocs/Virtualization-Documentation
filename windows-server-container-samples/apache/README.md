# Description:

Creates an image containing Apache 2.4.18 for Windows and the required Visual Studio redistributable package.

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

Docker Build –t apache-windows .

**Docker Run** 

Docker Run –d –p 80:80 apache-windows

## Dockerfile Details:
```
FROM windowsservercore

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

RUN powershell -Command \
	Sleep 2 ; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
	c:\vcredist_x86.exe /quiet ; \
	Sleep 20 ; \
	Remove-Item c:\vcredist_x86.exe -Force

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe –w
```


