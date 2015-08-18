ms.ContentId: 5bbac9eb-c31e-40db-97b1-f33ea59ac3a3
title: Work in Progress

# Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

-----------------------

## General functionality

### Windows Container Image must exactly match container host
A Windows Server Container requires an opertaing system image that matches the container host in respect to build and patch level. A mismatch will lead to instability and or unpredictable behavior for the container and/or the host.
<!-- Can we give examples of behavior or errors?  Makes it more searchable -->

**Work Around:**   
Download and install a container OS <!-- Container base image? --> matching the OS version and patch level of the container host.


### Commands sporadically fail -- try again
In our testing, commands occasionally need to be run multiple times.  The same principle applies to other actions.  
For example, if you create a new file and it doesn't appear, try touching the file.  

If you have to do this, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

** Work Around:  **  
Build scripts such that they try commands multiple times.  If a command fails, try again.  

### All non-C:/ drives appear in the container
All non-C:/ drives available to the container host are also mapped into all running Windows Server Containers.  

Since there is no way to map folders into a container, this is a way to share data.

**Work Around: **  
We're working on it.  In the future there will be folder sharing.

--------------------------

## Networking

### Number of compartments per container
In this release we support one compartment per container. 

**Work Around: **  
If multiple endpoints exposed by the container are needed, use NAT port mapping.

--------------------------

## Application compatibility

### Can't install ASP.NET 4.5 with IIS in a container using DISM 
Installing IIS-ASPNET45 in a container doesn't work inside a Windows Server container.  The installation progress sticks around 95.5%.

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45
```

This fails because ASP.NET 4.5 doesn't run in a container.

** Work Around: **  
Instead, install the Web-Server role to use IIS. ASP 5.0 does work. 

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Web-Server
```

### Applications


**Work Around:**   

The following applications have been tried to run in a Windows Server Container.
These results are no guarantee that a specific application is working or not working properly. The sole purpose is to share our experience when testing applications in a Container.

| **Name** | **Version** | **Does it work?** | **Comment** |
|:-----|:-----|:-----|:-----|
| .NET | 4.6 | Yes | Included in base image | 
| .NET CLR | 5 beta 6 | Yes | Both, x64 and x86 | 
| Active Python | 3.4.1 | Yes | |
| Apache CouchDB | 1.6.1 | No | |
| Apache HTTPD | 2.4 | Yes | |
| Apache Tomcat | 8.0.24 x64 | Yes | |
| ASP.NET | 3.5 | No | |
| ASP.NET | 4.5 | No | |
| ASP.NET | 5 beta 6 | Yes | Both, x64 and x86 |
| Erlang/OTP | 18.0 | No | |
| FileZilla FTP Server | 0.9 | Yes | Has to be installed through an RDP session  into the container | 
| Go Progamming Language | 1.4.2 | Yes | |
| Internet Information Service | 10.0 | Yes | |
| Java | 1.8.0_51 | Yes | Use the server version. The client version does not install properly |
| Jetty | 9.3 | Partially | Running demo-base fails |
| MineCraft Server | 1.8.5 | Yes | 
| MongoDB | 3.0.4 | Yes | |
| MySQL | 5.6.26 | Yes | |
| NGinx | 1.9.3 | Yes | |
| Node.js | 0.12.6 | Partially | Running node with js files works. NPM fails to download packages. Running node interactively does not work properly. |
| PHP | 5.6.11 | Yes | Both with IIS via FastCGI and Apache|
| PostgreSQL | 9.4.4 | Yes | |
| Python | 3.4.3 | Yes | |
| R | 3.2.1 | No | |
| RabbitMQ | 3.5.x | Yes | Has to be installed through an RDP session  into the container |
| Redis | 2.8.2101 | Yes | |
| Ruby | 2.2.2 | Yes | Both, x64 and x86 | 
| Ruby on Rails | 4.2.3 | |
| SQLite | 3.8.11.1 | Yes | |
| SQL Server Express | 2014 LocalDB | Yes | |
| Sysinternals Tools | * | Yes | Only tried those not requiring a GUI. PsExec does not work by current design | 

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

### Remote desktop access of containers
Windows Server Containers can be managed/interacted with through a RDP session.

The following steps are needed to remotely connect to a Windows Server Container using RDP. It is assumed that the Container is connected to the network via a NAT switch. This is the default when setting up a Container host through the installation script or creating a new VM in Azure.

** In the Container you want to connect to **

The following steps require either managing the Container using Docker or, when using PowerShell, specifying the `-RunAsAdministrator` switch when connecting to the Container.

1. Obtain the Container's IP address

  ```
  ipconfig
  ```
  
  Returns something similar to this
  
  ```
  Windows IP Configuration

  Ethernet adapter vEthernet (Virtual Switch-f758a5a9519e1956cc3bef06eb03e5728d3fb61cf6d310246185587be490210a-0):

  Connection-specific DNS Suffix  . :
  Link-local IPv6 Address . . . . . : fe80::91cd:fb4c:4ea5:51df%17
  IPv4 Address. . . . . . . . . . . : 172.16.0.2
  Subnet Mask . . . . . . . . . . . : 255.240.0.0
  Default Gateway . . . . . . . . . : 172.16.0.1
  ```
  
  Please note the IPv4 Address which is typically in the format 172.16.x.x

2. Set the password for the builtin administrator user for the Container

  ```
  net user administrator [yourpassword]
  ```

3. Enable the builtin administrator user for the Container

  ```
  net user administrator /active:yes
  ```

** On the Container host **

Since Windows Server has the Windows Firewall with Advanced Security enabled by default we need to open some ports for communication in order for RDP to work. Additionally a port mapping is created so the Container is reachable through a port on the Container host.

The following steps require a PowerShell launched as Administrator on the host.

1. Allow the default RDP port through the Windows Advanced Firewall

  ```
  New-NetFirewallRule -Name "RDP" -DisplayName "Remote Desktop Protocol" -Protocol TCP -LocalPort @(3389) -Action Allow
  ```

2. Allow an additional port for RDP connection to the Container

  ```
  New-NetFirewallRule -Name "ContainerRDP" -DisplayName "RDP Port for connecting to Container" -Protocol TCP -LocalPort @(3390) -Action Allow
  ```
  
  This step opens up port 3390 on the Container host. It will be used to open a RDP session to the Container. If you want to connect to multiple Containers, you can repeat this step while providing additional port numbers. 

3. Add a port mapping for the existing NAT

  In this step you need the IP address from step 1 within the Container

  ```
  Add-NetNatStaticMapping -NatName ContainerNAT -Protocol TCP -ExternalPort 3390 -ExternalIPAddress 0.0.0.0 -InternalPort 3389 -InternalIPAddress [your container IP]
  ```
  
  Here you ensure that communication to the Container host which is coming in on port 3390 is redirected to port 3389 on the Container running at the IP address you specify.

** Connect to the container via RDP **

Finally you can connect to the Container using RDP by running: 

```
mstsc /v:[ContainerHostIP]:3390 /prompt
```

Please specify `administrator` as the user name and the password that you chose as the password.

The Remote Desktop Connection will ask you whether you want connect to the system despite certificate errors. If you select "Yes", the RDP connection will be opened.  

**Note:** Exiting the container RDP session without logoff may prevent the container from shutting down. Please make sure to exit the RDP session by typing "logoff" (instead of "exit" or just closing the RDP window) before shutting the container down.


--------------------------


## Docker management

### Docker clients unsecured by default
In this pre-release, docker communication is public if you know where to look.

### Docker commands that don't work with Windows Server Containers

Commands known to fail:

| **Docker command** | **Where it runs** | **Error** | **Notes** |
|:-----|:-----|:-----|:-----|
| **docker commit** | image | Docker stops running container and doesn’t show correct error message | Committing a stopped container works. For running containers: We're working on it :) |
| **docker diff** | daemon | Error: The windows graphdriver does not support Changes() | |
| **docker kill** | container | Error: Invalid signal: KILL  Error: failed to kill containers:[] | |
| **docker load** | image | Fails silently | No error but the image isn't loading either |
| **docker pause** | container | Error: Windows container cannot be paused.  May be not supported | |
| **docker port** | container |  | No port is getting listed even we are able to RDP.
| **docker pull** | daemon | Error: System cannot find the file path. We cant run container using this image. | Image is getting added can't be used.  We're working on it :) |
| **docker restart** | container | Error: A system shutdown is in progress. |  |
| **docker unpause** | container |  | Can't test because pause doesn't work yet. |

If anything that isn't on this list fails (or if a command fails differently than expected), let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).



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

If anything that isn't on this list fails, if a command fails differently than expected, or if you find a work around, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).


### Pasting commands to interactive Docker session is limited to 50 characters
If you copy a command line into an interactive Docker session, it is currently limited to 50 characters.
<!-- How does this present?  Does it truncate or fail?  If fail, what's the error? -->

This is not by design, we're working on lifting the restriction.


### HCS Shim errors when creating new container images
If you encounter error messages like this:
```
hcsshim::ExportLayer - Win32 API call returned error r1=2147942523 err=The filename, directory name, or volume label syntax is incorrect. layerId=606a2c430fccd1091b9ad2f930bae009956856cf4e6c66062b188aac48aa2e34 flavour=1 folder=C:\ProgramData\docker\windowsfilter\606a2c430fccd1091b9ad2f930bae009956856cf4e6c66062b188aac48aa2e34-1868857733
```

You're hitting an issue addressed by the Zero Day Patch for Windows Server 2016 TP3. This error can also occur when running the Python-3.4.3.msi installer or node-v0.12.7.msi in a container.

If you hit other hcsshim errors, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).


--------------------------

## PowerShell management


--------------------------
[Back to Container Home](../containers_welcome.md)