# This dockerfile utilizes components licensed by their respective owners/authors.

FROM windowsservercore

LABEL Description="IIS" Vendor=Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

CMD [ "ping localhost -t" ]