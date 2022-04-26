---
title: WSL Interoperability with Docker
description: Learn about the supported features for calling the docker daemon under Windows using the Windows Subsystem for Linux.
author: mattbriggs
ms.author: mabrigg
date:       2017-12-08 18:20:23
ms.date: 12/08/2017
categories: containers
---
# WSL Interoperability with Docker

We frequently get asked about running docker from within the Windows Subsystem for Linux (WSL). We don’t support running the docker daemon directly in WSL. But what you _can_ do is call in to the daemon running under Windows from WSL. What does this let you do? You can create dockerfiles, build them, and run them in the daemon—Windows or Linux, depending on which runtime you have selected—all from the comfort of WSL. <!--[![](https://msdnshared.blob.core.windows.net/media/2017/12/npipeconf.gif)](https://msdnshared.blob.core.windows.net/media/2017/12/npipeconf.gif)-->

### **Overview**

The architectural design of docker is split into three components: a client, a REST API, and a server (the daemon). At a high level:

  * **C** **lient** **:** interacts with the REST API. The primary purpose of this piece is to allow a user to interface the daemon.
  * **REST API** : Acts as the interface between the client and server, allowing a flow of communication.
  * **Daemon:** Responsible for actually managing the containers—starting, stopping, etc. The daemon listens for API requests from docker clients.

The daemon has very close ties to the kernel. Today in Windows, when you’re running Windows Server containers, a daemon process runs in Windows. When you switch to Linux Container mode, the daemon actually runs inside a VM called the Moby Linux VM. With the [upcoming release](https://blog.docker.com/2017/11/docker-for-windows-17-11/) of Docker, you’ll be able to run Windows Server containers and Linux container side-by-side, and the daemon will always run as a Windows process. The client, however, doesn’t have to sit in the same place as the daemon. For example, you could have a local docker client on your dev machine communicating with Docker up in Azure. This allows us to have a client in WSL talking to the daemon running on the host.

### **What** **'s the** **Proposal?**

This method is made available because of a tool built by John Starks ([@gigastarks](https://twitter.com/gigastarks)), a dev lead on Hyper-V, called **npiperelay**. Getting communication up and running between WSL and the daemon isn't new; there have been several great blog posts ([ this blog](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly) by Nick Janetakis comes to mind) which recommend going a TCP-route by opening a port without TLS. <!--(like below): [![](https://msdnshared.blob.core.windows.net/media/2017/11/tls.png)](https://msdnshared.blob.core.windows.net/media/2017/11/tls.png)--> While I would consider the port 2375 method to be more robust than the tutorial we're about to walk through, you _do_ expose your system to potential attack vectors for malicious code. We don't like exposing attack vectors 🙂 What about opening another port to have docker listen on and protect _that_ with TLS? Well, Docker for Windows [ doesn’t support](https://github.com/docker/for-win/issues/453) the requirements needed to make this happen. So this brings up back to npiperelay.  _Note:_ the tool we are about to use works best with insider builds--it can be a little buggy on ver. 1709. Your mileage may vary.

### Installing Go

We're going to build the relay from within WSL. If you do not have WSL installed, then you'll need to download it from the [Microsoft Store](https://www.microsoft.com/store/productId/9NBLGGH4MSV6). Once you have WSL running, we need to download Go. To do this: `#Make sure we have the latest package lists sudo apt-get update #Download Go. You should change the version if there's a newer one. Check at: https://golang.org/dl/ sudo wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz` Now we need to unzip Go and add the binary to our PATH: `#unzip Go sudo tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz #Put it in the path export PATH=$PATH:/usr/local/go/bin`

### Building the Relay

With Go now installed, we can build the relay. In the command below, make sure to replace with your Windows username: `go get -d github.com/jstarks/npiperelay GOOS=windows go build -o /mnt/c/Users/<your_user_name>/go/bin/npiperelay.exe github.com/jstarks/npiperelay` We've now built the relay for Windows but we want it callable from within WSL. To do this, we make a symlink. Make sure to replace with your Windows username: `sudo ln -s /mnt/c/Users/<your_user_name>/go/bin/npiperelay.exe /usr/local/bin/npiperelay.exe` We'll be using socat to help enable the relay. Install [socat](https://linux.die.net/man/1/socat), a tool that allows for bidirectional flow of data between two points (more on this later). Grab this package: `sudo apt install socat` We need to install the docker client on WSL. To do this: `sudo apt install docker.io`

### Last Steps

With socat installed and the executable built, we just need to string a few things together. We're going to make a shell script to activate the functionality for us. We're going to place this in the home directory of the user. To do this: `#make the file touch ~/docker-relay #add execution privileges chmod +x ~/docker-relay` Open the file we've created with your favorite text editor (like vim). Paste this into the file: `#!/bin/sh exec socat UNIX-LISTEN:/var/run/docker.sock,fork,group=docker,umask=007 EXEC:"npiperelay.exe -ep -s //./pipe/docker_engine",nofork` Save the file and close it. The docker-relay script configures the Docker pipe to allow access by the docker group. To run as an ordinary user (without having to attach 'sudo' to every docker command), add your WSL user to the docker group. In Ubuntu: `sudo adduser ${USER} docker`

### Test it Out!

Open a new WSL shell to ensure your group membership is reset. Launch the relay in the background: `sudo ~/docker-relay &` Now, run a docker command to test the waters. You should be greeted by the same output as if you ran the command from Windows (and note you don't need 'sudo' prefixed to the command, either!). <!--[![](https://msdnshared.blob.core.windows.net/media/2017/12/npipetest.gif)](https://msdnshared.blob.core.windows.net/media/2017/12/npipetest.gif)-->

#### Volume Mounting

If you're wondering how volume mounting works with npiperelay, you'll need to use the **Windows path** when you specify your volume. See the comparison below: `#this is CORRECT docker run **-v C:/Users/crwilhit.REDMOND/tmp/** mcr.microsoft.com/windows/nanoserver cmd.exe` `#this is INCORRECT docker run **-v /mnt/c/Users/crwilhit.REDMOND/tmp/** mcr.microsoft.com/windows/nanoserver cmd.exe`

### How Does it Work?

There's a fundamental problem with getting the docker client running under WSL to communicate with Docker for Windows: the WSL client understands IPC via unix sockets, whereas Docker for Windows understands IPC via named pipes. This is where socat and npiperelay.exe come in to play--as the mediators between these two forms of disjoint IPC. Socat understands how to communicate via unix sockets and npiperelay understands how to communicate via named pipes. Socat and npiperelay both understand how to communicate via stdio, hence they can talk to each other. <!--[![](https://msdnshared.blob.core.windows.net/media/2017/12/docker4win.png)](https://msdnshared.blob.core.windows.net/media/2017/12/docker4win.png)-->

### Conclusion

Congratulations, you can now talk to Docker for Windows via WSL. With the recent [addition of background processes](https://blogs.msdn.microsoft.com/commandline/2017/12/04/background-task-support-in-wsl/) in WSL, you can close out of WSL, open it later, and the relay we've built will continue to run. However, if you kill the socat process or do a hard reboot of your system, you'll need to make sure you launch the relay in the background again when you first launch WSL.  You can use the npiperelay tool for other things as well. Check out the [GitHub repo](https://github.com/jstarks/npiperelay) to learn more. Try it out and let us know how this works out for you. __
