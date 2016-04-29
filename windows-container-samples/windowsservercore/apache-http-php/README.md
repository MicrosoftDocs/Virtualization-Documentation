# Description:

Creates an image containing Apache 2.4.18 for Windows, PHP and the required Visual Studio redistributable package. Additionally, a sample Apache configuration file (included in the repo) is copied into the Apache folder, and a sample PHP site created (to validate functionality). This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```none
docker build -t apache-http-php:latest .
```

**Docker Run** 

```none
docker run -d -p 80:80 apache-http-php
```


## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.apache.org/licenses/, https://secure.php.net/license/

FROM windowsservercore

LABEL Description="Apache-PHP" Vendor1="Apache Software Foundation" Version1="2.4.18" Vendor2="The PGP Group" Version2="5.5.33"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri https://www.apachelounge.com/download/VC11/binaries/httpd-2.4.18-win32-VC11.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
   	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -OutFile c:\vcredist_x86.exe ; \
   	start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; \
   	Remove-Item c:\vcredist_x86.exe -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri http://windows.php.net/downloads/releases/php-5.5.33-Win32-VC11-x86.zip -OutFile c:\php.zip ; \
	Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
	Remove-Item c:\php.zip -Force

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Remove-Item c:\Apache24\conf\httpd.conf ; \
	new-item -Type Directory c:\www -Force ; \
	Add-Content -Value "'<?php phpinfo() ?>'" -Path c:\www\index.php

ADD httpd.conf /apache24/conf

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w
```

