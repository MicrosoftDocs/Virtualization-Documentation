# This dockerfile utilizes components licensed by their respective owners/authors.

FROM microsoft/windowsservercore

LABEL Description="IIS" Vendor="Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

CMD powershell while (1 -eq 1) { Start-Sleep -Seconds 600 }
