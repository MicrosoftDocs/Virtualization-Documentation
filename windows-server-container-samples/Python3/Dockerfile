FROM windowsservercore
LABEL Description="Python" Vendor="Python Software Foundation" Version="3.5.0"
ADD sources /build
RUN C:\build\python-3.5.0.exe  /quiet InstallAllUsers=1 PrependPath=1 & del C:\build\python-3.5.0.exe