# This dockerfile utilizes components licensed by their respective owners/authors.

FROM windowsservercore

MAINTAINER neil.peterson@microsoft.com

LABEL Description="IIS" Vendor=Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

CMD [ "ping localhost -t" ]