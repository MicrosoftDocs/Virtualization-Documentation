ms.ContentId: 5bbac9eb-c31e-40db-97b1-f33ea59ac3a3
title: Work in Progress

# Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

-----------------------

## General functionality

### Windows Container Image must exactly match container host
A Windows Server Container requires an operating system image that matches the container host in respect to build and patch level. A mismatch will lead to instability and or unpredictable behavior for the container and/or the host.

If you install updates against the Windows container host OS you will need to update the container base OS image to have the matching updates.
<!-- Can we give examples of behavior or errors?  Makes it more searchable -->

**Work Around:**   
Download and install a container base image matching the OS version and patch level of the container host.


### Commands sporadically fail -- try again
In our testing, commands occasionally need to be run multiple times.  The same principle applies to other actions.  
For example, if you create a new file and it doesn't appear, try touching the file.  

If you have to do this, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

** Work Around:  **  
Build scripts such that they try commands multiple times.  If a command fails, try again.  

### All non-C:/ drives are automatically mapped into new containers
All non-C:/ drives available to the container host are automatically mapped into new running Windows Server Containers.

At this point in time there is no way to selectively map folders into a container, as an interim work around drives are mapped automatically.

**Work Around: **  
We're working on it.  In the future there will be folder sharing.

### Default firewall behavior
In a container host and containers environment, you only have the container host's firewall. All the firewall rules configured in the container host will propagate to all of its containers.

### Windows Server Containers are starting very slowly
If your container is taking more than 30 seconds to start, it may be performing many duplicate virus scans.

Many anti-malware solutions, such as Windows Defender, maybe unnecessarily scanning files with-in container images including all of the OS binaries and files in the container OS image.  This occurs when ever a new container is created and from the anti-malware’s perspective all of the “container’s files” look like new files that have not previously been scanned.  So when processes inside the container attempt to read these files the anti-malware components first scan them before allowing access to the files.  In reality these files were already scanned when the container image was imported or pulled to the server. In future previews new infrastructure will be in place such that anti-malware solutions, including Windows Defender, will be aware of these situations and can act accordingly to avoid multiple scans. 

--------------------------

## Networking

### Number of network compartments per container
In this release we support one network compartment per container. This means that if you have a container with multiple network adapters, you cannot access the same network port on each adapter (e.g. 192.168.0.1:80 and 192.168.0.2:80 belonging to the same container).

**Work Around: **  
If multiple endpoints need to be exposed by a container, use NAT port mapping.

### Windows containers are not getting IPs
If you're connecting to the windows server containers with DHCP VM Switches it's possible for the container host to recieve an IP wwhile the containers do not.

The containers get a 169.254.***.*** APIPA IP address.

**Work around:**
This is a side effect of sharing the kernel.  All containers affectively have the same mac address.

Enable MAC address spoofing on the container host.

This can be achieved using PowerShell
```
Get-VMNetworkAdapter -VMName "[YourVMNameHere]"  | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### Creating file shares does not work in a Container

Currently it is not possible to create a file share within a Container. If you run `net share` you will see an error like this:

```
The Server service is not started.

Is it OK to start it? (Y/N) [Y]: y
The Server service is starting.
The Server service could not be started.

A service specific error occurred: 2182.

More help is available by typing NET HELPMSG 3547.
```

**Work Around: **
If you want to copy files into a Container you can use the other way round by running `net use` within the Container. For example: 
```
net use S: \\your\sources\here /User:shareuser [yourpassword]
```

--------------------------

## Application compatibility

There are so mnay questions about which applications work and don't work in Windows Server Containers, we decided to break application compatability information into [its own article](../reference/app_compat.md).

Some of the most common issues are located here as well.

### WinRM won't start in a Windows Server Container
WinRM starts, throws an error, and stops again.  Errors are not logged in the event log.

**Work Around:**
Use WMI, [RDP](#RemoteDesktopAccessOfContainers), or Enter-PSSession -ContainerID

### Can't install ASP.NET 4.5 or ASP.NET 3.5 with IIS in a container using DISM 
Installing IIS-ASPNET45 in a container doesn't work inside a Windows Server container.  The installation progress sticks around 95.5%.

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45
```

This fails because ASP.NET 4.5 doesn't run in a container.

**Work Around:**  
Instead, install the Web-Server role to use IIS. ASP 5.0 does work. 

``` PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Web-Server
```

See the [application compatability article](../reference/app_compat.md) for more information about what applications can be containerized.

--------------------------


## Docker management

### Docker clients unsecured by default
In this pre-release, docker communication is public if you know where to look.

### Docker commands that don't work with Windows Server Containers

Commands known to fail:

| **Docker command** | **Where it runs** | **Error** | **Notes** |
|:-----|:-----|:-----|:-----|
| **docker commit** | image | Docker stops running container and doesn’t show correct error message | Committing a stopped container works. Running containers cannot be committed to an image. |
| **docker diff** | daemon | Error: The windows graphdriver does not support Changes() | Docker diff will not be supported by the Windows Docker daemon. |
| **docker kill** | container | Error: Invalid signal: KILL  Error: failed to kill containers:[] | |
| **docker load** | image | Fails silently | No error but the image isn't loading either |
| **docker pause** | container | Error: Windows container cannot be paused.| By design. |
| **docker port** | container |  | No port is getting listed even we are able to RDP.
| **docker restart** | container | Error: A system shutdown is in progress. |  |
| **docker stat** | daemon | Fails silently | No error, functionality not yet implemented  |
| **docker unpause** | container |  | By design. |

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
If you copy a command line into an interactive Docker session, it is currently limited to 50 characters. The pasted string is simply truncated.

This is not by design, we're working on lifting the restriction.

### net use returns System error 1223 instead of prompting for username or password
Workaround: specify both, the username and password, when running net use. For example:
```
net use S: \\your\sources\here /User:shareuser [yourpassword]
``` 

### HCS Shim errors when creating new container images
If you encounter error messages like this:
```
hcsshim::ExportLayer - Win32 API call returned error r1=2147942523 err=The filename, directory name, or volume label syntax is incorrect. layerId=606a2c430fccd1091b9ad2f930bae009956856cf4e6c66062b188aac48aa2e34 flavour=1 folder=C:\ProgramData\docker\windowsfilter\606a2c430fccd1091b9ad2f930bae009956856cf4e6c66062b188aac48aa2e34-1868857733
```

You're hitting an issue addressed by the Zero Day Patch for Windows Server 2016 TP3. This error can also occur when running the Python-3.4.3.msi installer or node-v0.12.7.msi in a container.

If you hit other hcsshim errors, let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).


## Accessing windows server container with Remote Desktop 
Windows Server Containers can be managed/interacted with through a RDP session.

The following steps are needed to remotely connect to a Windows Server Container using RDP. It is assumed that the Container is connected to the network via a NAT switch. This is the default when setting up a Container host through the installation script or creating a new VM in Azure.

** In the Container you want to connect to **

The following steps require either managing the Container using Docker or, when using PowerShell, specifying the `-RunAsAdministrator` switch when connecting to the Container. Please take the following steps in the Container you want to connect to.

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

The following steps require a PowerShell launched as Administrator on the Container host.

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

Finally you can connect to the Container using RDP. In order to do that please run the following command on a system which has the Remote Desktop Client installed (e.g. your system running the Container host VM): 

```
mstsc /v:[ContainerHostIP]:3390 /prompt
```

Please specify `administrator` as the user name and the password that you chose as the password.

The Remote Desktop Connection will ask you whether you want connect to the system despite certificate errors. If you select "Yes", the RDP connection will be opened.  

**Note:** Exiting the container RDP session without logoff may prevent the container from shutting down. Please make sure to exit the RDP session by typing "logoff" (instead of "exit" or just closing the RDP window) before shutting the container down.

--------------------------

## PowerShell management

### Enter-PSSession has containerid argument, New-PSSession doesn't

This is correct.  We're planning on full cimsession support in the future.


Feel free to voice feature requests in [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers). 

--------------------------
[Back to Container Home](../containers_welcome.md)