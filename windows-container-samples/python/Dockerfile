# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://docs.python.org/3/license.html

FROM microsoft/windowsservercore

LABEL Description="Python" Vendor="Python Software Foundation" Version="3.7.3"

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    wget https://www.python.org/ftp/python/3.7.3/python-3.7.3.exe -OutFile c:\python-3.7.3.exe ; \
    Start-Process c:\python-3.7.3.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
    Remove-Item c:\python-3.7.3.exe -Force

RUN echo print("Hello World!") > c:\hello.py

CMD ["py", "c:/hello.py"]
