# Sample to create a Windows Server Container image with Python 3.5.1 installed

This sample was created for Windows Server 2016 Technical Preview 4 with Containers. They assume that the 
WindowsServerCore Container base image is present.


## Building the Image using Docker


On the Container host, enter the directory with the file, then build it:
```
docker build --tag=python3
```

  
Progress will be shown as the build progresses:
<!-- TODO - replace the sample below with a successful build -->
```
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM windowsservercore
 ---> 6801d964fda5
Step 2 : LABEL Description "Python" Vendor "Python Software Foundation" Version "3.5.1"
 ---> Running in ae520b20d674
 ---> e8f3682e11a1
Removing intermediate container ae520b20d674
Step 3 : RUN mkdir c:\build
 ---> Running in b72647b4858c
 ---> 97df127996d3
Removing intermediate container b72647b4858c
Step 4 : RUN powershell.exe -Command { Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFi
le c:\Build\python-3.5.1.exe }
 ---> Running in 68d7fa66ea65
 Invoke-WebRequest https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe
-OutFile c:\Build\python-3.5.1.exe
 ---> 76990669b3dd
Removing intermediate container 68d7fa66ea65
Step 5 : RUN C:\build\python-3.5.1.exe  /quiet InstallAllUsers=1 PrependPath=1
 ---> Running in d2952b70bcb1
'C:\build\python-3.5.1.exe' is not recognized as an internal or external command,
operable program or batch file.
The command 'cmd /S /C C:\build\python-3.5.1.exe  /quiet InstallAllUsers=1 PrependPath=1' returned a non-zero code: 1
```

After the build is complete, it will be in the local repository.
<!-- TODO - replace the sample below after doing a  successful build -->
```
PS C:\PowerShellDSC_iis-10.0> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   10.0.10586.0        6801d964fda5        9 weeks ago         0 B
windowsservercore   latest              6801d964fda5        9 weeks ago         0 B
```
