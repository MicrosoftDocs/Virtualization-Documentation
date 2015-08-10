ms.ContentId: 5bbac9eb-c31e-40db-97b1-f33ea59ac3a3
title: Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

# Work in Progress

## Application compatability

## Docker management

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

## General functionality

## Broad category

### Specific issue
A more detailed explaination to identify the issue.

** Work Around: **  
Description

** More Information: ** (optional)  
When does this happen?  Why?

[Back to Container Home](../containers_welcome.md)

