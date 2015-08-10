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

### Run twice
In our testing, commands occasionally need to be run multiple times.  Sometimes you need to touch the file.
We're working on it :).  If you have top do this, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

### Drive mapping
All non-C:/ drives mapped in the container host appear in all Windows Server Containers.  

Since there is no way to map folders into a container, this is a way to share data.

**Work Around: **
We're working on it.


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
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
```

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

