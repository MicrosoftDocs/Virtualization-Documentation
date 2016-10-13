# Debug-ContainerHost.ps1
This collection of scripts is designed to make it easier to troubleshoot common problems and misconfigurations on Windows container hosts.


## How to run it
First, run `Debug-ContainerHost.ps1` with no options. It will run several tests on the system automatically.

Example Pass:

```none
Describing The right container base images are installed
 [+] microsoft/windowsservercore is installed 206ms
 [+] microsoft/nanoserver is installed 63ms
Describing Docker is installed
 [+] A Docker service is installed - 'Docker' or 'com.Docker.Service'  159ms
 [+] Service is running 40ms
 [+] Docker.exe is in path 1.13s
Describing User has permissions to use Docker daemon
 [+] docker.exe should not return access denied 166ms
Describing Windows Version and Prerequisites
 [+] Is Windows 10 Anniversary Update or Windows Server 2016 161ms
 [+] Has KB3192366 installed if running Windows build 14393 820ms
 [+] Is not a build with blocking issues 44ms
Describing Windows container settings are correct
 [+] Do not have DisableVSmbOplock set 87ms
 [+] Do not have zz values set 33ms
Tests completed in 2.91s
Passed: 11 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0
```

Example Fail:

```none
Describing The right container base images are installed
error during connect: Get http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.25/images/json: open //./pipe/docker_engine: Access is denied.
 [-] microsoft/windowsservercore is installed 196ms
   Expected: value to not be empty
   15:         $serverCoreImages | Should Not BeNullOrEmpty
   at <ScriptBlock>, C:\Users\Patrick\Source\Virtualization-Documentation-Private\windows-server-container-tools\Debug-ContainerHost\ContainerImage.Tests.ps1: line 15
 [-] microsoft/nanoserver is installed 69ms
   Expected: value to not be empty
   20:         $serverCoreImages | Should Not BeNullOrEmpty
   at <ScriptBlock>, C:\Users\Patrick\Source\Virtualization-Documentation-Private\windows-server-container-tools\Debug-ContainerHost\ContainerImage.Tests.ps1: line 20
Describing Docker is installed
 [+] A Docker service is installed - 'Docker' or 'com.Docker.Service'  115ms
 [+] Service is running 54ms
 [+] Docker.exe is in path 1.07s
Describing User has permissions to use Docker daemon
 [-] docker.exe should not return access denied 126ms
   Expected: file {err.txt} to not contain access is denied but it did
   23:         "err.txt" | Should Not Contain "access is denied"
   at <ScriptBlock>, C:\Users\Patrick\Source\Virtualization-Documentation-Private\windows-server-container-tools\Debug-ContainerHost\Docker.Tests.ps1: line 23
Describing Windows Version and Prerequisites
 [+] Is Windows 10 Anniversary Update or Windows Server 2016 256ms
 [+] Has KB3192366 installed if running Windows build 14393 914ms
 [+] Is not a build with blocking issues 31ms
Describing Windows container settings are correct
 [+] Do not have DisableVSmbOplock set 79ms
 [+] Do not have zz values set 35ms
Tests completed in 2.95s
Passed: 8 Failed: 3 Skipped: 0 Pending: 0 Inconclusive: 0
```


## Contributing
Contributions are welcome! Here are a few suggested areas needing improvement:
- Include `docker info` and `docker version` output
- Add options to start & stop log collections to Debug-ContainerHost.ps1, create CSV file
- Add a commitId and date to script output so it's easier to troubleshoot the troubleshooting script
- Search for TODO in *.ps1 for incomplete tests
