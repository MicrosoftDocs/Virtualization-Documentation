# Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

-----------------------

## General functionality

### Container and host build number match
A Windows Container requires an operating system image that matches the container host in respect to build and patch level. A mismatch will lead to potential instability and or unpredictable behavior for the container and/or the host.

If you install updates against the Windows container host OS you will need to update the container base OS image to have the matching updates.
<!-- Can we give examples of behavior or errors?  Makes it more searchable -->

**Work Around:**   
Download and install a container base image matching the OS version and patch level of the container host.

### All non-C:/ drives are visible in containers
All non-C:/ drives available to the container host are automatically mapped into new running Windows Containers.

At this point in time there is no way to selectively map folders into a container, as an interim work around drives are mapped automatically.

**Work Around: **  
We're working on it.  In the future there will be folder sharing.

### Default firewall behavior
In a container host and containers environment, you only have the container host's firewall. All the firewall rules configured in the container host will propagate to all of its containers.

### Windows Containers start slowly
If your container is taking more than 30 seconds to start, it may be performing many duplicate virus scans.

Many anti-malware solutions, such as Windows Defender, maybe unnecessarily scanning files with-in container images including all of the OS binaries and files in the container OS image.  This occurs when ever a new container is created and from the anti-malware’s perspective all of the “container’s files” look like new files that have not previously been scanned.  So when processes inside the container attempt to read these files the anti-malware components first scan them before allowing access to the files.  In reality these files were already scanned when the container image was imported or pulled to the server. In future previews new infrastructure will be in place such that anti-malware solutions, including Windows Defender, will be aware of these situations and can act accordingly to avoid multiple scans. 

### Start/Stop sometimes fails if memory is restricted to < 48MB
Windows Containers experience random, inconsistant, errors when memory is restricted to less than 48MB.

Running the following PowerShell and repeating the start, stop, action multiple will cause failures in either starting or stopping.

```PowerShell
new-container "Test" -containerimagename "WindowsServerCore" -MaximumBytes 32MB
start-container test
stop-container test
```

**Work Around:**  
Change the memory value to 48MB. 


### Start-container fails when the processor count is 1 or 2 on a 4 core VM

Windows Containers fail to start with error:  
`failed to start: This operation returned because the timeout period expired. (0x800705B4).`

This occurs when the processor count is set to 1 or 2 on a 4 core VM.

``` PowerShell
new-container "Test2" -containerimagename "WindowsServerCore"
Set-ContainerProcessor -ContainerName test2 -Maximum 2
Start-Container test2

Start-Container : 'test2' failed to start.
'test2' failed to start: This operation returned because the timeout period expired. (0x800705B4).
'test2' failed to start. (Container ID 133E9DBB-CA23-4473-B49C-441C60ADCE44)
'test2' failed to start: This operation returned because the timeout period expired. (0x800705B4). (Container ID
133E9DBB-CA23-4473-B49C-441C60ADCE44)
At line:1 char:1
+ Start-Container test2
+ ~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationTimeout: (:) [Start-Container], VirtualizationException
    + FullyQualifiedErrorId : OperationTimeout,Microsoft.Containers.PowerShell.Cmdlets.StartContainer
PS C:\> Set-ContainerProcessor -ContainerName test2 -Maximum 3
PS C:\> Start-Container test2
```

** Work Around:**  
Increase the processors available to the container, don't explicitly specify processors available to the container, or reduce processors available to the VM.

--------------------------

## Networking

### Limited network compartments
In this release we support one network compartment per container. This means that if you have a container with multiple network adapters, you cannot access the same network port on each adapter (e.g. 192.168.0.1:80 and 192.168.0.2:80 belonging to the same container).

**Work Around: **  
If multiple endpoints need to be exposed by a container, use NAT port mapping.

### Windows containers are not getting IPs
If you're connecting to the windows containers with DHCP VM Switches it's possible for the container host to receive an IP while the containers do not.

The containers get a 169.254.***.*** APIPA IP address.

**Work around:**
This is a side effect of sharing the kernel.  All containers affectively have the same mac address.

Enable MAC address spoofing on the container host.

This can be achieved using PowerShell
```
Get-VMNetworkAdapter -VMName "[YourVMNameHere]"  | Set-VMNetworkAdapter -MacAddressSpoofing On
```

--------------------------

## Application compatibility

There are so many questions about which applications work and don't work in Windows Containers, we decided to break application compatibility information into [its own article](../reference/app_compat.md).

Some of the most common issues are located here as well.

### Unexpected error occurred inside a localdb instance api method call
Unexpected error occurred inside a localdb instance api method call

### RTerm doesn't work
RTerm installs but won't start in a Windows Server Container.

Error:  
```
'C:\Program' is not recognized as an internal or external command,
operable program or batch file.
```


### Container: Visual C++ Runtime x64/x86 2015 is not getting installed

Observed behavior:
In a Container:
```
C:\build\vcredist_2015_x64.exe /q /norestart
C:\build>echo %errorlevel%
0
C:\build>wmic product get
No Instance(s) Available.
```

This is an interop issue with the dedup filter. Dedup checks the rename target to see if it is a deduped file. The create it issues fails with `STATUS_IO_REPARSE_TAG_NOT_HANDLED` because the Windows Server Container filter is sitting above dedup.


See the [application compatability article](../reference/app_compat.md) for more information about what applications can be containerized.

--------------------------


## Docker management

### Docker clients unsecured
In this pre-release, docker communication is public if you know where to look.

### Not all Docker commands work
Docker exec fails in Hyper-V Containers.

Commands related to DockerHub aren't supported yet.

If anything that isn't on this list fails (or if a command fails differently than expected), let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

### Pasting commands to interactive Docker session is limited to 50 characters
Pasting commands to interactive Docker session is limited to 50 characters.  
If you copy a command line into an interactive Docker session, it is currently limited to 50 characters. The pasted string is simply truncated.

This is not by design, we're working on lifting the restriction.

### Net use errors
Net use returns System error 1223 instead of prompting for username or password

**Work Around:**  
Specify the username and password when running net use.

``` PowerShell
net use S: \\your\sources\here /User:shareuser [yourpassword]
``` 


## Remote Desktop 
Windows Containers can be managed/interacted with through a RDP session.

The following steps are needed to remotely connect to a Windows Container using RDP. It is assumed that the Container is connected to the network via a NAT switch. This is the default when setting up a Container host through the installation script or creating a new VM in Azure.

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

### Not all *-PSSession have a containerid argument
This is correct.  We're planning on full cimsession support in the future.


Feel free to voice feature requests in [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers). 
