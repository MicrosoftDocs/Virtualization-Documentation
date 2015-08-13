ms.ContentId: 5bbac9eb-c31e-40db-97b1-f33ea59ac3a3
title: Work in Progress

# Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

-----------------------

**Template**  
## Broad category

### Specific issue
A more detailed explaination to identify the issue.

** Work Around: **  
Description

** More Information: ** (optional)  
When does this happen?  Why?

-----------------------

## General functionality

### Windows Container Image 
A Windows Server Container requires a opertaing system image that matches the container host in respect to build and patch level. A mismatch will lead to instability and or unpredictable behaivor for the container and/or the host.
We try to limit this impact by not starting containers with mismatched container OS. 

** Work Around: **  
Download and install a container OS matching the OS version and patch level of the container host.


### Run twice
In our testing, commands occasionally need to be run multiple times.  THe same principle applies to other actions.  For example, if you create a new file and it doesn't appear, try touching the file.  
We're working on it :).  If you have top do this, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

### Drive mapping
All non-C:/ drives mapped in the container (that represent a physical drive on the host) appear in all Windows Server Containers.  

Since there is no way to map folders into a container, this is a way to share data.

**Work Around: **
We're working on it.

## Networking

### Number of compartments per container
In this release we support one compartment per container. 

**Work Around: **
If multiple endpoints exposed by the container are needed, use NAT port mapping.


## Application compatability

### Can't install IIS in a container using DISM 
Installing IIS-ASPNET45 in a container doesn't work inside a Windows Server container.  The installation progress sticks around 95.5%.

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45
```

This fails because ASP.NET 4.5 doesn't run in a container.

** Work Around: **  
ASP 5.0 does work.  Instead, install the Web-Server role.

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Web-Server
```

### Remote access of containers
Windows Server Containers can be managed/interacted with through a RDP session. Exiting the container RDP session without logoff may prevent the container from shutting down.

** Work Around: **  
Exit the RDP session by typing "logoff" (instead of "exit" or just closing the RDP window) before shutting the container down.


### Windows Optional Features that do install

* AD-Certificate
* ADCS-Cert-Authority
* File-Services
 * FS-FileServer
 * FS-VSS-Agent
* DirectAccess-VPN
* Routing
* Remote-Desktop-Services
* VolumeActivation
* Web-Server
* Web-WebServer
* Web-Common-Http
* Web-Default-Doc
* Web-Dir-Browsing
* Web-Http-Errors
* Web-Static-Content
* Web-Http-Redirect
* Web-DAV-Publishing
* Web-Health
* Web-Http-Logging
* Web-Custom-Logging
* Web-Log-Libraries
* Web-ODBC-Logging
* Web-Request-Monitor
* Web-Performance
* Web-Stat-Compression
* Web-Dyn-Compression
* Web-Security
* Web-Filtering
* Web-Basic-Auth
* Web-CertProvider
* Web-Client-Auth
* Web-Digest-Auth
* Web-Cert-Auth
* Web-IP-Security
* Web-Url-Auth
* Web-Windows-Auth
* Web-App-Dev
* Web-AppInit
* Web-CGI
* Web-ISAPI-Ext
* Web-ISAPI-Filter
* Web-Includes
* Web-WebSockets
* Web-Mgmt-Compat
* Web-Metabase
* BitLocker
* EnhancedStorage
* GPMC
* Isolated-UserMode
* Server-Media-Foundation
* MSMQ-DCOM
* MultiPoint-Connector-Feature
* qWave
* RDC
* RSAT-Feature-Tools-BitLocker
* RSAT-Clustering-PowerShell
* RSAT-Clustering-AutomationServer
* RSAT-Clustering-CmdInterface
* RSAT-Shielded-VM-Tools
* RSAT-AD-Tools
* RSAT-AD-PowerShell
* RSAT-ADDS
* RSAT-AD-AdminCenter
* RSAT-ADDS-Tools
* RSAT-ADLDS
* Hyper-V-PowerShell
* UpdateServices-API
* RSAT-NetworkController
* Windows-Fabric-Tools
* RSAT-HostGuardianService
* FS-SMBBW
* Storage-Replica
* Telnet-Client
* WAS
 * WAS-Process-Model
 * WAS-Config-APIs
* Windows-Server-Backup
* Migration

## Docker management

### Docker clients unsecured by default
In this pre-release, docker communication is public if you know where to look.

To secure your windows server container to Docker communications, use this script: LARS?  STEVE?

### Docker commands that don't work with Windows Server Containers

Commands known to fail:

| **Docker command** | **Where it runs** | **Error** | **Notes** |
|:-----|:-----|:-----|:-----|
| **docker commit** | image | Docker stops running container and doesn’t shows correct error message | We're working on it :) |
| **docker diff** | daemon | Error: The windows graphdriver does not support Changes() | |
| **docker kill** | container | Error: Invalid signal: KILL  Error: failed to kill containers:[] | |
| **docker load** | image | Fails silently | No error but the image isn't loading either |
| **docker pause** | container | Error: Windows container cannot be paused.  May be not supported | |
| **docker port** | container |  | No port is getting listed even we are able to RDP.
| **docker pull** | daemon | Error: System cannot find the file path. We cant run container using this image. | Image is getting added can't be used.  We're working on it :) |
| **docker restart** | container | Error: A system shutdown is in progress. |  |
| **docker unpause** | container |  | Can't test because pause doesn't work yet. |



### Docker commands that partially work with Windows Server Containers

Commands with partial functionality:

| **Docker command** | **Runs on...** | **Parameter** | **Notes** |
|:-----|:-----|:-----|:-----|
| **docker attach** | container | --no-stdin=false | The command doesn't exit when Ctrl-P and CTRL-Q is pressed |
| | | --sig-proxy=true | works |
| **docker build** | images | -f, --file | Error: Unable to prepare context: Unable to get synlinks |
| | | --force-rm=false | works |
| | | --no-cache=false | works |
| | | -q, --quiet=false | |
| | | --rm=true | works|
| | | -t, --tag="" | works |
| **docker login** | daemon | -e, -p, -u | sporratic behavior | 
| **docker push** | daemon | | Getting occasional "repository does not exit" errors. |
| **docker rm** | container | -f | Error: A system shutdown is in progress. |


## PowerShell management


[Back to Container Home](../containers_welcome.md)

