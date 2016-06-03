# Description:

Creates and image containing Nginx 1.9.13.

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t nginx:latest .

```

**Docker Run**

```
docker run -d -p 80:80 nginx
```

# Dockerfile Details:
```
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

```

