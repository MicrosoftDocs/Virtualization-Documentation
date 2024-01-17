---
title: Manage Windows Virtual Machines with PowerShell Direct
description: Manage Windows Virtual Machines with PowerShell Direct
keywords: windows 10, hyper-v, powershell, integration services, integration components, automation, powershell direct
author: scooley
ms.author: scooley
ms.date: 05/02/2016
ms.topic: article
ms.assetid: fb228e06-e284-45c0-b6e6-e7b0217c3a49
---

# Virtual Machine automation and management using PowerShell

You can use PowerShell Direct to run arbitrary PowerShell in a Windows 10 or Windows Server 2016 virtual machine from your Hyper-V host regardless of network configuration or remote management settings.

Here are some ways you can run PowerShell Direct:

* [As an interactive session using the Enter-PSSession cmdlet](#create-and-exit-an-interactive-powershell-session)
* [As a single-use section to execute a single command or script using the Invoke-Command cmdlet](#run-a-script-or-command-with-invoke-command)
* [As a persistant session (build 14280 and later) using the New-PSSession, Copy-Item, and Remove-PSSession cmdlets](#copy-files-with-new-pssession-and-copy-item)

## Requirements
**Operating system requirements:**
* Host: Windows 10, Windows Server 2016, or later running Hyper-V.
* Guest/Virtual Machine: Windows 10, Windows Server 2016, or later.

If you're managing older virtual machines, use Virtual Machine Connection (VMConnect) or [configure a virtual network for the virtual machine](/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc816585(v=ws.10)). 

**Configuration requirements:**    
* The virtual machine must be running locally on the host.
* The virtual machine must be turned on and running with at least one configured user profile.
* You must be logged into the host computer as a Hyper-V administrator.
* You must supply valid user credentials for the virtual machine.

-------------

## Create and exit an interactive PowerShell session

The easiest way to run PowerShell commands in a virtual machine is to start an
interactive session.

When the session starts, the commands that you type run on the virtual machine, just as though you typed them directly into a PowerShell session on the virtual machine itself.

**To start an interactive session:**

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run one of the following commands to create an interactive session using the virtual machine name or GUID:  
  
  ``` PowerShell
  Enter-PSSession -VMName <VMName>
  Enter-PSSession -VMId <VMId>
  ```
  
  Provide credentials for the virtual machine when prompted.

3. Run commands on your virtual machine.
  
  You should see the VMName as the prefix for your PowerShell prompt as shown:
  
  ``` 
  [VMName]: PS C:\>
  ```
  
  Any command run will be running on your virtual machine. To test, you can run `ipconfig` or `hostname` to make sure that these commands are running in the virtual machine.
  
4. When you're done, run the following command to close the session:  
  
   ``` PowerShell
   Exit-PSSession 
   ``` 

> Note:  If your session won't connect, see the [troubleshooting](#troubleshooting) for potential causes. 

To learn more about these cmdlets, see [Enter-PSSession](/powershell/module/Microsoft.PowerShell.Core/Enter-PSSession?view=powershell-5.1&preserve-view=true) and [Exit-PSSession](/powershell/module/Microsoft.PowerShell.Core/Exit-PSSession?view=powershell-5.1&preserve-view=true). 

-------------

## Run a script or command with Invoke-Command

PowerShell Direct with Invoke-Command is perfect for situations where you need to run one command or one script on a virtual machine but do not need to continue interacting with the virtual machine beyond that point.

**To run a single command:**

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run one of the following commands to create a session using the virtual machine name or GUID:  
   
   ``` PowerShell
   Invoke-Command -VMName <VMName> -ScriptBlock { command } 
   Invoke-Command -VMId <VMId> -ScriptBlock { command }
   ```
   
   Provide credentials for the virtual machine when prompted.
   
   The command will execute on the virtual machine, if there is output to the console, it'll be printed to your console.  The connection will be closed automatically as soon as the command runs.
   
   
**To run a script:**

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run one of the following commands to create a session using the virtual machine name or GUID:  
   
   ``` PowerShell
   Invoke-Command -VMName <VMName> -FilePath C:\host\script_path\script.ps1 
   Invoke-Command -VMId <VMId> -FilePath C:\host\script_path\script.ps1 
   ```
   
   Provide credentials for the virtual machine when prompted.
   
   The script will execute on the virtual machine.  The connection will be closed automatically as soon as the command runs.

To learn more about this cmdlet, see [Invoke-Command](/powershell/module/Microsoft.PowerShell.Core/Invoke-Command?view=powershell-5.1&preserve-view=true). 

-------------

## Copy files with New-PSSession and Copy-Item

> **Note:** PowerShell Direct only supports persistent sessions in Windows builds 14280 and later

Persistent PowerShell sessions are incredibly useful when writing scripts that coordinate actions across one or more remote machines.  Once created, persistent sessions exist in the background until you decide to delete them.  This means you can reference the same session over and over again with `Invoke-Command` or `Enter-PSSession` without passing credentials.

By the same token, sessions hold state.  Since persistent sessions persist, any variables created in a session or passed to a session will be preserved across multiple calls. There are a number of tools available for working with persistent sessions.  For this example, we will use [New-PSSession](/powershell/module/Microsoft.PowerShell.Core/New-PSSession?view=powershell-5.1&preserve-view=true) and [Copy-Item](/powershell/module/Microsoft.PowerShell.Management/Copy-Item?view=powershell-5.1&preserve-view=true) to move data from the host to a virtual machine and from a virtual machine to the host.

**To create a session then copy files:**  

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run one of the following commands to create a persistent PowerShell session to the virtual machine using `New-PSSession`.
  
  ``` PowerShell
  $s = New-PSSession -VMName <VMName> -Credential (Get-Credential)
  $s = New-PSSession -VMId <VMId> -Credential (Get-Credential)
  ```
  
  Provide credentials for the virtual machine when prompted.
  
  > **Warning:**  
   There is a bug in builds before 14500.  If credentials aren't explicitly specified with `-Credential` flag, the service in the guest will crash and will need to be restarted.  If you hit this issue, workaround instructions are available [here](#error-a-remote-session-might-have-ended).
  
3. Copy a file into the virtual machine.
  
  To copy `C:\host_path\data.txt` to the virtual machine from the host machine, run:
  
  ``` PowerShell
  Copy-Item -ToSession $s -Path C:\host_path\data.txt -Destination C:\guest_path\
  ```
  
4.  Copy a file from the virtual machine (on to the host). 
   
   To copy `C:\guest_path\data.txt` to the host from the virtual machine, run:
  
  ``` PowerShell
  Copy-Item -FromSession $s -Path C:\guest_path\data.txt -Destination C:\host_path\
  ```

5. Stop the persistent session using `Remove-PSSession`.
  
  ``` PowerShell 
  Remove-PSSession $s
  ```
  
-------------

## Troubleshooting

There are a small set of common error messages surfaced through PowerShell Direct.  Here are the most common, some causes, and tools for diagnosing issues.

### -VMName or -VMID parameters don't exist
**Problem:**  
`Enter-PSSession`, `Invoke-Command`, or `New-PSSession` do not have a `-VMName` or `-VMId` parameter.

**Potential causes:**  
The most likely issue is that PowerShell Direct isn't supported by your host operating system.

You can check your Windows build by running the following command:

``` PowerShell
[System.Environment]::OSVersion.Version
```

If you are running a supported build, it is also possible your version of PowerShell does not run PowerShell Direct.  For PowerShell Direct and JEA, the major version must be 5 or later.

You can check your PowerShell version build by running the following command:

``` PowerShell
$PSVersionTable.PSVersion
```


### Error: A remote session might have ended
> **Note:**  
For Enter-PSSession between host builds 10240 and 12400, all errors below reported as "A remote session might have ended".

**Error message:**
```
Enter-PSSession : An error has occurred which Windows PowerShell cannot handle. A remote session might have ended.
```

**Potential causes:**
* The virtual machine exists but is not running.
* The guest OS does not support PowerShell Direct (see [requirements](#requirements))
* PowerShell isn't available in the guest yet
  * The operating system hasn't finished booting
  * The operating system can't boot correctly
  * Some boot time event needs user input

You can use the [Get-VM](/powershell/module/hyper-v/get-vm?view=win10-ps&preserve-view=true) cmdlet to check to see which VMs are running on the host.

**Error message:**  
```
New-PSSession : An error has occurred which Windows PowerShell cannot handle. A remote session might have ended.
```

**Potential causes:**
* One of the reasons listed above -- they all are equally applicable to `New-PSSession`  
* A bug in current builds where credentials must be explicitly passed with `-Credential`.  When this happens, the entire service hangs in the guest operating system and needs to be restarted.  You can check if the session is still available with Enter-PSSession.

To work around the credential issue, log into the virtual machine using VMConnect, open PowerShell, and restart the vmicvmsession service using the following PowerShell:

``` PowerShell
Restart-Service -Name vmicvmsession
```

### Error: Parameter set cannot be resolved
**Error message:**  
``` 
Enter-PSSession : Parameter set cannot be resolved using the specified named parameters.
```

**Potential causes:**  
* `-RunAsAdministrator` is not supported when connecting to virtual machines.
     
  When connecting to a Windows container, the `-RunAsAdministrator` flag allows Administrator connections without explicit credentials.  Since virtual machines do not give the host implied administrator access, you need to explicitly enter credentials.

Administrator credentials can be passed to the virtual machine with the `-Credential` parameter or by entering them manually when prompted.


### Error: The credential is invalid.

**Error message:**  
```
Enter-PSSession : The credential is invalid.
```

**Potential causes:** 
* The guest credentials couldn't be validated
  * The supplied credentials were incorrect.
  * There are no user accounts in the guest (the OS hasn't booted before)
  * If connecting as Administrator:  Administrator has not been set as an active user.  Learn more [here](/previous-versions/windows/it-pro/windows-8.1-and-8/hh825104(v=win.10)).
  
### Error: The input VMName parameter does not resolve to any virtual machine.

**Error message:**  
```
Enter-PSSession : The input VMName parameter does not resolve to any virtual machine.
```

**Potential causes:**  
* You are not a Hyper-V Administrator.  
* The virtual machine doesn't exist.

You can use the [Get-VM](/powershell/module/hyper-v/get-vm?view=win10-ps&preserve-view=true) cmdlet to check that the credentials you're using have the Hyper-V administrator role and to see which VMs are running locally on the host and booted.


-------------

## Samples and User Guides

PowerShell Direct supports JEA (Just Enough Administration).  Check out this user guide to try it.

Check out samples on [GitHub](https://github.com/Microsoft/Virtualization-Documentation/search?l=powershell&q=-VMName+OR+-VMGuid&type=Code&utf8=%E2%9C%93).
