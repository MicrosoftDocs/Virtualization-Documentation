# Sample to create a Windows Server Container Image with IIS 10.0 using Windows PowerShell DSC

This sample was created for Windows Server 2016 Technical Preview 4 with Containers. They assume that the 
WindowsServerCore container base image is present.


## Building the Image using Docker

In order to create an IIS container image when you are running Docker-managed Windows Server containers, please 
copy both files (dockerfile, RunDSC.ps1) to a directory on the host.

On the container host, enter the directory with the file, then build it:
```
docker build -t iis-dsc .
```

The following steps will be run when building the dockerfile:

1. Copying RunDSC.ps1 script to the TEMP directory in the container
2. Running RunDSC.ps1 inside of the container
3. The pushed policy will add the Web-Server role.
  
  
Progress will be shown as the build progresses:
```
PS C:\PowerShellDSC_iis-10.0> docker build -t iis-dsc .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM windowsservercore
 ---> 6801d964fda5
Step 2 : ADD RunDsc.ps1 /windows/temp/RunDsc.ps1
 ---> fd6ac802c94a
Removing intermediate container 893e70678a34
Step 3 : RUN powershell.exe -executionpolicy bypass c:\windows\temp\RunDsc.ps1
 ---> Running in 195d29e1481e
WARNING: The configuration 'ContosoWebsite' is loading one or more built-in
resources without explicitly importing associated modules. Add
Import-DscResource ModuleName 'PSDesiredStateConfiguration' to your
configuration to avoid this message.


    Directory: C:\Windows\system32\ContosoWebsite


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         1/4/2016  12:17 PM           1928 localhost.mof
VERBOSE: Perform operation 'Invoke CimMethod' with following parameters,
''methodName' = SendConfigurationApply,'className' =
MSFT_DSCLocalConfigurationManager,'namespaceName' =
root/Microsoft/Windows/DesiredStateConfiguration'.
VERBOSE: An LCM method call arrived from computer 893E70678A34 with user sid
S-1-5-18.
VERBOSE: [893E70678A34]: LCM:  [ Start  Set      ]
VERBOSE: [893E70678A34]: LCM:  [ Start  Resource ]  [[WindowsFeature]IIS]
VERBOSE: [893E70678A34]: LCM:  [ Start  Test     ]  [[WindowsFeature]IIS]
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS] The
operation 'Get-WindowsFeature' started: Web-Server
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS] The
operation 'Get-WindowsFeature' succeeded: Web-Server
VERBOSE: [893E70678A34]: LCM:  [ End    Test     ]  [[WindowsFeature]IIS]  in
9.3040 seconds.
VERBOSE: [893E70678A34]: LCM:  [ Start  Set      ]  [[WindowsFeature]IIS]
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Installation started...
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Continue with installation?
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Prerequisite processing started...
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Prerequisite processing succeeded.
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Installation succeeded.
VERBOSE: [893E70678A34]:                            [[WindowsFeature]IIS]
Successfully installed the feature Web-Server.
VERBOSE: [893E70678A34]: LCM:  [ End    Set      ]  [[WindowsFeature]IIS]  in
107.6800 seconds.
VERBOSE: [893E70678A34]: LCM:  [ End    Resource ]  [[WindowsFeature]IIS]
VERBOSE: [893E70678A34]: LCM:  [ End    Set      ]
VERBOSE: [893E70678A34]: LCM:  [ End    Set      ]    in  117.8680 seconds.
VERBOSE: Operation 'Invoke CimMethod' complete.
VERBOSE: Time taken for configuration job to complete is 123.788 seconds


 ---> 28d42c431f8f
Removing intermediate container 195d29e1481e
Successfully built 28d42c431f8f
```

After the build is complete, it will be in the local repository.
```
PS C:\PowerShellDSC_iis-10.0> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
iis-dsc             latest              28d42c431f8f        43 seconds ago      169.6 MB
iis                 latest              8b4b7d750c76        2 weeks ago         166.5 MB
windowsservercore   10.0.10586.0        6801d964fda5        9 weeks ago         0 B
windowsservercore   latest              6801d964fda5        9 weeks ago         0 B
```

## Starting the container using Docker

Now, start a container using the image:
```
docker run --name iis-dsc-demo -it -p 80:80 iis-dsc cmd
```

Connecting to the container host, port 80 will show the index page from the web server
running in the container.
