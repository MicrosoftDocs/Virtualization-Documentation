# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://docs.python.org/3/license.html, https://github.com/django/django/blob/master/LICENSE

FROM windowsservercore

LABEL Description="Python" Vendor="Python Software Foundation" Version="3.5.1"

RUN powershell.exe -Command \
	$ErrorActionPreference = 'Stop'; \
 	Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\python-3.5.1.exe ; \
	start-Process  c:\python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait  ; \
	Sleep 60 ; \
	Remove-Item c:\python-3.5.1.exe -Force

RUN ["pip", "install", "Django==1.8.6"]

CMD ["django-admin --version"]
	