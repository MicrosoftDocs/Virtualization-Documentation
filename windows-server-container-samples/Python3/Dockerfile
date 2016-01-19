FROM windowsservercore
LABEL Description="Python" Vendor="Python Software Foundation" Version="3.5.1"
RUN mkdir c:\build
RUN powershell.exe -Command { Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile c:\Build\python-3.5.1.exe }
RUN C:\build\python-3.5.1.exe  /quiet InstallAllUsers=1 PrependPath=1
RUN del C:\build\python-3.5.1.exe