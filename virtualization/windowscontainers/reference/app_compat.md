# Application Compatability in Windows Containers

This is a preview.  While eventually application that runs on Windows should also run in a container, this is a good place to see our current application compatability status.

Is something not on this list?  Let us know what fails and succeeds in your environment via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

## Applications in Windows Server Container

We have tried to running the following applications in a Windows Server Container.  These results do not guarantee that the application is working.  The sole purpose is to share our experience.

| **Name** | **Version** | **Windows Server Core base image** | **Nano Server base image** | **Comment** |
|:-----|:-----|:-----|:-----|:-----|
| .NET | 3.5 | Yes | Unknown |  | 
| .NET | 4.6 | Yes | Unknown |  | 
| .NET CLR | 5 beta 6 | Yes | Yes| Both, x64 and x86 | 
| Active Python | 3.4.1 | Yes | Yes | |
| Apache Cassandra || Yes | Unkown | 
| Apache CouchDB | 1.6.1 | No | No | |
| Apache Hadoop | | Yes | No | |
| Apache HTTPD | 2.4 | Yes | Yes | |
| Apache Tomcat | 8.0.24 x64 | Yes | Unknown | |
| ASP.NET | 4.5 | Yes | Unkown | |
| ASP.NET | 5 beta 6 | Yes | Yes | Both, x64 and x86 |
| Django | |Yes|Yes| |
| Go Progamming Language | 1.4.2 | Yes | Yes | |
| Internet Information Service | 10.0 | Yes | Yes | |
| Java | 1.8.0_51 | Yes | Yes | Use the server version. The client version does not install properly |
| MongoDB | 3.0.4 | Yes | Unkown | |
| MySQL | 5.6.26 | Yes | Yes | |
| NGinx | 1.9.3 | Yes | Yes | |
| Node.js | 0.12.6 | Partially | Partially | NPM fails to download packages. |
| Perl | | Yes | Unkown | |
| PHP | 5.6.11 | Yes | Yes |  |
| PostgreSQL | 9.4.4 | Yes | Unknown | |
| Python | 3.4.3 | Yes | Yes | |
| R | 3.2.1 | No | No | |
| RabbitMQ | 3.5.x | Yes | Unknown | |
| Redis | 2.8.2101 | Yes | Yes | |
| Ruby | 2.2.2 | Yes | Yes | Both, x64 and x86 | 
| Ruby on Rails | 4.2.3 | Yes | Yes | |
| SQLite | 3.8.11.1 | Yes | No | |
| SQL Server Express | 2014 LocalDB | No | No |  |
| Sysinternals Tools | * | Yes | Yes | Only tried those not requiring a GUI. PsExec does not work by current design | 

## 

## What Optional Windows Features can I install?

The following Windows Optional Features have been confirmed as being able to install.  Many do not function once they are installed at this point in time.

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

Is something not on this list?  Let us know what fails and succeeds in your environment via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).
