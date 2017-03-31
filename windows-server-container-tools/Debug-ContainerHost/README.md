# Debug-ContainerHost.ps1
This collection of scripts is designed to make it easier to troubleshoot common problems and misconfigurations on Windows container hosts.


## How to run it
First, run `Debug-ContainerHost.ps1` with no options. It will run several tests on the system automatically. Any failures will be in red, and there is a pass/fail summary at the end.

All of the tests use [Pester](https://github.com/pester/Pester/wiki). 

The first line of each test starts with _Describe_ and explains what a group of tests will do. Each part of the test describes what a good result _Should_ look like.

Example Pass:

```none
Checking for common problems
Describing Windows Version and Prerequisites
 [+] Is Windows 10 Anniversary Update or Windows Server 2016 79ms
 [+] Has KB3192366, KB3194496, or later installed if running Windows build 14393 21ms
 [+] Is not a build with blocking issues 30ms
 [+] Has 'Containers' feature installed 1.75s
Describing Docker is installed
 [+] A Docker service is installed - 'Docker' or 'com.Docker.Service'  32ms
 [+] Service is running 22ms
 [+] Docker.exe is in path 2.05s
 [+] Docker is registered in the EventLog service 20ms
Describing User has permissions to use Docker daemon
 [+] docker.exe should not return access denied 32ms
Describing Windows container settings are correct
 [+] Do not have DisableVSmbOplock set to 1 32ms
 [+] Do not have zz values set 22ms
 [+] Do not have FDVDenyWriteAccess set to 1 30ms
Describing The right container base images are installed
 [+] At least one of 'microsoft/windowsservercore' or 'microsoft/nanoserver' should be installed 136ms
Describing Container network is created
 [+] At least one local container network is available 3.23s
 [+] At least one NAT, Transparent, or L2Bridge Network exists 58ms
 [+] NAT Network's vSwitch is internal 74ms
 [+] Specified Network Gateway IP for NAT network is assigned to Host vNIC 150ms
 [+] NAT Network's internal prefix does not overlap with external IP' 66ms
```

Example Failure:

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

In this case, the tests "Describing User has permissions to use Docker daemon" and "Describing The right container base images are installed" failed. The rest of this page describes the tests and how to fix the problems.



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

**[+] Has 'Containers' feature installed**

The `Containers` feature should be installed before the Docker Engine will work. Use one of these PowerShell commands to enable it:

- Windows 10 - `Enable-WindowsOptionalFeature -Online -FeatureName containers -All`
- Windows Server 2016 - `Add-WindowsFeature containers`


### Describing Docker is installed
**[+] A Docker service is installed - 'Docker' or 'com.Docker.Service'**

If this fails, then the Docker Engine is not installed. Check [here](http://aka.ms/windowscontainers) for a quick start guide to help get everything installed.

**[+] Service is running**

- If you installed the Docker engine manually, try `net start Docker`
- If you are using Docker for Windows, try searching for it on the Start menu and run it.

**[+] Docker.exe is in path**

- Try logging out and back in
- If it still fails, try reinstalling based on the Quick Start guide [here](http://aka.ms/windowscontainers) 

**[+] Docker is registered in the EventLog service**

- Create and run this registry file: 
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\docker]
"CustomSource"=dword:00000001
"EventMessageFile"="C:\\Program Files\\docker\\dockerd.exe"
"TypesSupported"=dword:00000007

```

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


**[+] Do not have FDVDenyWriteAccess set to 1**

This is a registry key set by a Group Policy setting "Deny write access to fixed drives not protected by bitlocker." For more details on it, see [technet](https://technet.microsoft.com/en-us/library/ee706521(v=ws.10).aspx#BKMK_driveaccess1). If your machines are Active Directory domain joined, then this policy needs to be modified otherwise the registry key will be overwritten the next time Group Policy is synced.

It can cause problems with Windows containers because VHD files are used for container temporary storage. This may cause failures in `docker load` or `docker pull`. This was described in issues [#355](https://github.com/Microsoft/Virtualization-Documentation/issues/355) and [#530](https://github.com/Microsoft/Virtualization-Documentation/issues/530) . 

Anti-virus products that have not been updated and validated based on the [Anti-virus optimization for Windows Containers](https://msdn.microsoft.com/en-us/windows/hardware/drivers/ifs/anti-virus-optimization-for-windows-containers) can also cause similar failures without this registry value set. If this test passes but you still have problems with `docker pull` and `docker load`, try updating or disabling anti-virus as the next troubleshooting step.

### Describing The right container base images are installed
**[+] At least one of 'microsoft/windowsservercore' or 'microsoft/nanoserver' should be installed**

- Try `docker pull microsoft/nanoserver` or `docker pull microsoft/windowsservercore` to pull a Windows container image



### Describing Container network is created ###
** At least one local container network is available **

> TODO - description & help needed

** At least one NAT, Transparent, or L2Bridge Network exists **

> TODO - description & help needed

** NAT Network's vSwitch is internal **

> TODO - description & help needed

** A Windows NAT is configured if a Docker NAT network exists **

If something deletes the Window NAT configuration then you may need to recreate it. First, find what the NAT's internal prefix should be with `docker network inspect nat`

```
PS> docker network inspect nat
[
    {
        "Name": "nat",
        "Id": "9d35e3b6619d919f554b2c419aee515133238070121ca999d3514196541a7cfd",
        "Created": "2017-03-31T14:21:02.2013811-07:00",
        "Scope": "local",
        "Driver": "nat",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "windows",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.25.112.0/20",
                    "Gateway": "172.25.112.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {
            "com.docker.network.windowsshim.hnsid": "bcbf2335-aa54-4561-a665-2b05caa7f5b4",
            "com.docker.network.windowsshim.networkname": "nat"
        },
        "Labels": {}
    }
]
```

In this case it was 172.25.112.0/20. Next, create the Windows NAT using that subnet.

```powershell
New-NetNat -Name nat -InternalIPInterfaceAddressPrefix 172.25.112.0/20 
```

** Specified Network Gateway IP for NAT network is assigned to Host vNIC **

> TODO - description & help needed

** NAT Network's internal prefix does not overlap with external IP' **

When using network address translation (nat) with containers, the internal IP address range must be separate from the external range.
If they overlap, then you need to delete the network with `docker network remove` and create a new one with `docker network create`.

## Contributing to Debug-ContainerHost.ps1
Contributions are welcome! Here are a few suggested areas needing improvement:
- Add options to start & stop log collections to Debug-ContainerHost.ps1, create CSV file
- Add a commitId and date to script output so it's easier to troubleshoot the troubleshooting script
- Search for TODO in *.ps1 for incomplete tests
