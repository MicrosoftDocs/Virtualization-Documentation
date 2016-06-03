---
author: scooley
---

# Application Compatability in Windows Containers

**This is preliminary content and subject to change.** 

This is a preview.  While eventually application that runs on Windows should also run in a container, this is a good place to see our current application compatability status.

The sole purpose of this document is to share our experience.

Is something not on this list?  Let us know what fails and succeeds in your environment via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

## Windows Server Containers

We have tried to running the following applications in a Windows Server Container.  These results do not guarantee that the application functions correctly.

| **Name** | **Version** | **Windows Server Core base image** | **Nano Server base image** | **Comment** |
|:-----|:-----|:-----|:-----|:-----|
| .NET | 3.5 | Yes | Unknown |  | 
| .NET | 4.6 | Yes | Unknown |  | 
| .NET CLR | 5 beta 6 | Yes | Yes| Both, x64 and x86 | 
| Active Python | 3.4.1 | Yes | Yes | |
| Apache Cassandra || Yes | Unkown | 
| Apache CouchDB | 1.6.1 | No | No | |
| Apache Hadoop | | Yes | No | |
| Apache HTTPD | 2.4 | Yes | Yes | VC++ runtime does not get installed if dedup filter is loaded. Unload dedup using `fltmc unload dedup` |
| Apache Tomcat | 8.0.24 x64 | Yes | Unknown | |
| ASP.NET | 4.6 | Yes | Unkown | |
| ASP.NET | 5 beta 6 | Yes | Yes | Both, x64 and x86 |
| Django | |Yes|Yes| |
| Go | 1.4.2 | Yes | Yes | |
| Internet Information Service | 10.0 | Yes | Yes | HTTPS/TLS does not work.  VC++ runtime does not get installed if dedup filter is loaded. Unload dedup using `fltmc unload dedup` |
| Java | 1.8.0_51 | Yes | Yes | Use the server version. The client version does not install properly |
| MongoDB | 3.0.4 | Yes | Unkown | |
| MySQL | 5.6.26 | Yes | Yes | |
| NGinx | 1.9.3 | Yes | Yes | |
| Node.js | 0.12.6 | Partially | Partially | NPM fails to download packages. |
| Perl | | Yes | Unkown | |
| PHP | 5.6.11 | Yes | Yes | VC++ runtime does not get installed if dedup filter is loaded. Unload dedup using `fltmc unload dedup` |
| PostgreSQL | 9.4.4 | Yes | Unknown | VC++ runtime does not get installed if dedup filter is loaded. Unload dedup using `fltmc unload dedup` |
| Python | 3.4.3 | Yes | Yes | |
| R | 3.2.1 | No | No | |
| RabbitMQ | 3.5.x | Yes | Unknown | |
| Redis | 2.8.2101 | Yes | Yes | |
| Ruby | 2.2.2 | Yes | Yes | Both, x64 and x86 | 
| Ruby on Rails | 4.2.3 | Yes | Yes | |
| SQLite | 3.8.11.1 | Yes | No | |
| SQL Server Express | 2014 | Yes | Unknown | You can quickly start by building this [community-contributed Dockerfile](https://github.com/brogersyh/Dockerfiles-for-windows/tree/master/sqlexpress) that installs SQL Express 2014. |
| Sysinternals Tools | * | Yes | Yes | Only tried those not requiring a GUI. PsExec does not work by current design | 

## Hyper-V Containers

We have tried to running the following applications in a Hyper-V Container.  These results do not guarantee that the application works correctly.

| **Name** | **Version** | **Nano Server base image** | **Comment** |
|:-----|:-----|:-----|:-----|
| Apache Hadoop | | No | |
| Apache HTTPD | 2.4 | Yes | VC++ runtime does not get installed if dedup filter is loaded. Unload dedup using `fltmc unload dedup` |
| ASP.NET | 5 beta 6 | Yes | Both, x64 and x86 |
| Django |  | Yes | If the image is created with a DockerFile and python binaries are copied as part it, Python does not work. Start container and then copy the python binaries. |
| Go | 1.4.2 | Yes | |
| Internet Information Service | 10.0 | Yes | HTTPS/TLS does not work.  IIS does not install using dism directly.  Do unattended installation of IIS using dism commands. |
| Java | 1.8.0_51 | Yes | Use the server version. The client version does not install properly |
| MySQL | 5.6.26 | Yes | |
| NGinx | 1.9.3 | Yes | |
| Node.js | 0.12.6 | Partially | NPM fails to download packages. |
| Python | 3.4.3 | Yes |  If the image is created with a DockerFile and python binaries are copied as part it, Python does not work. Start container and then copy the python binaries. |
| Redis | 2.8.2101 | Yes | |
| Ruby | 2.2.2 | Yes | Both, x64 and x86 | 
| Ruby on Rails | 4.2.3 | Yes | |
| Sysinternals Tools | | Yes | Only tried those not requiring a GUI. PsExec does not work by current design. |

## Tell us about your experiences
Is something not on this list?  Let us know what fails and succeeds in your environment via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).
