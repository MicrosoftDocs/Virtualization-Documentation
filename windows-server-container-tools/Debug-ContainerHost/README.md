# Debug-ContainerHost.ps1
This collection of scripts is designed to make it easier to troubleshoot common problems and misconfigurations on Windows container hosts.


## How to run it
First, run `Debug-ContainerHost.ps1` with no options. It will run several tests on the system automatically. Any failures will be in red, and there is a pass/fail summary at the end.

All of the tests use [Pester](https://github.com/pester/Pester/wiki). 

The first line of each test starts with _Describe_ and explains what a group of tests will do. Each part of the test describes what a good result _Should_ look like.

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

## List of tests
Here's a list of the test cases, organized by _Describe_ and _Should_, along with suggestions on how to fix the failure.

### Describing Windows Version and Prerequisites
**[+] Is Windows 10 Anniversary Update or Windows Server 2016**

- For Windows 10, see [Windows Update: FAQ](http://go.microsoft.com/fwlink/p/?LinkID=698739)


**[+] Has KB3192366, KB3194496, or later installed if running Windows build 14393**

To check your OS version, run `winver.exe`, and compare the version shown to [Windows 10 update history](https://support.microsoft.com/en-us/help/12387/windows-10-update-history). 
Make sure you have 14393.206 or later. If not, run Windows Update and install the latest KB shown in that list.

**[+] Is not a build with blocking issues**

Some Windows Insider builds could have issues running containers. This test fails if it finds a build with known problems. Watch for an updated Windows Insider build to resolve this later or check the [Container Forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers) for more help.

### Describing Docker is installed
**[+] A Docker service is installed - 'Docker' or 'com.Docker.Service'**

If this fails, then the Docker Engine is not installed. Check [here](http://aka.ms/windowscontainers) for a quick start guide to help get everything installed.

**[+] Service is running**

- If you installed the Docker engine manually, try `net start Docker`
- If you are using Docker for Windows, try searching for it on the Start menu and run it.

**[+] Docker.exe is in path**

- Try logging out and back in
- If it still fails, try reinstalling based on the Quick Start guide [here](http://aka.ms/windowscontainers) 

### Describing User has permissions to use Docker daemon
**[+] docker.exe should not return access denied**

- Try running from an elevated PowerShell window

### Describing Windows container settings are correct
**[-] Do not have DisableVSmbOplock set**

This was needed for testing Windows Containers using Windows Server 2016 TP5. It's no longer needed and can cause problems.
```powershell
Remove-ItemProperty -Path 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers' -Name VSmbDisableOplocks
```

**[+] Do not have zz values set**

These registry values should not be needed, and can be removed. Some past test builds needed these for workarounds in the past but they should not be necessary in Windows 10 Anniversary Update or Windows Server 2016.

### Describing The right container base images are installed
**[+] At least one of 'microsoft/windowsservercore' or 'microsoft/nanoserver' should be installed**

- Try `docker pull microsoft/nanoserver` or `docker pull microsoft/windowsservercore` to pull a Windows container image

## Contributing to Debug-ContainerHost.ps1
Contributions are welcome! Here are a few suggested areas needing improvement:
- Include `docker info` and `docker version` output
- Add options to start & stop log collections to Debug-ContainerHost.ps1, create CSV file
- Add a commitId and date to script output so it's easier to troubleshoot the troubleshooting script
- Search for TODO in *.ps1 for incomplete tests
