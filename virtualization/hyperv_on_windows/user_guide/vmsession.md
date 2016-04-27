# Manage Windows Virtual Machines with PowerShell Direct
 
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host. PowerShell Direct allows PowerShell management inside a virtual machine regardless of the network configuration or remote management settings on either the Hyper-V host or the virtual machine. This makes it easier for Hyper-V Administrators to automate and script management and configuration tasks.

**Ways to run PowerShell Direct:**  
* As an interactive session -- [click here](vmsession.md#create-and-exit-an-interactive-powershell-session) to create and exit an interactive PowerShell session using Enter-PSSession.
* As a single-use session to execute a single command or script -- [click here](vmsession.md#run-a-script-or-command-with-invoke-command) to run a script or command using Invoke-Command.
* As a peristant session (build 14280 and later) -- [click here](vmsession.md#copy-files-with-New-PSSession-and-Copy-Item) to create a persistent session using New-PSSession.  
Continue by coping a file to and from the virtual machine using Copy-Item then disconnect with Remove-PSSession.

## Requirements
**Operating system requirements:**
* Host: Windows 10, Windows Server Technical Preview 2, or later running Hyper-V.
* Guest/Virtual Machine: Windows 10, Windows Server Technical Preview 2, or later.

If you're managing older virtual machines, use Virtual Machine Connection (VMConnect) or [configure a virtual network for the virtual machine](http://technet.microsoft.com/library/cc816585.aspx). 

**Configuration requirements:**    
* The virtual machine must be running locally on the host.
* The virtual machine must be turned on and running with at least one configured user profile.
* You must be logged into the host computer as a Hyper-V administrator.
* You must supply valid user credentials for the virtual machine.

-------------

## Create and exit an interactive PowerShell session

The easiest way to run PowerShell commands in a virtual machine is to start an
interactive session.

When the session starts, the commands that you type run on the virtual machine, just as though you typed them directy into a PowerShell session on the virtual machine itself.

**To start an interactive session:**

1. On the Hyper-V host, open PowerShell as Administrator.

3. Run the one of the following commands to create an interactive session using the virtual machine name or GUID:  
  
  ``` PowerShell
  Enter-PSSession -VMName <VMName>
  Enter-PSSession -VMGuid <VMGuid>
  ```
  
  Provide credentials for the virtual machine when prompted.

4. Run commands on your virtual machine.
  
  You should see the VMName as the prefix for your PowerShell prompt as shown:
  
  ``` 
  [VMName]: PS C:\ >
  ```
  
  Any command run will be running on your virtual machine.  To test, you can run `ipconfig` or `hostname` to make sure that these commands are running in the virtual machine.
  
5. When you're done, run the following command to close the session:  
  
   ``` PowerShell
   Exit-PSSession 
   ``` 

> Note:  If your session won't connect, see the [troubleshooting](vmsession.md#troubleshooting) for potential causes. 

To learn more about these cmdlets, see [Enter-PSSession](http://technet.microsoft.com/library/hh849707.aspx) and [Exit-PSSession](http://technet.microsoft.com/library/hh849743.aspx). 

-------------

## Run a script or command with Invoke-Command

PowerShell Direct with Invoke-Command is perfect for situations where you need to run one command or one script on a virtual machine but do not need to continue interacting with the virtual machine beyond that point.

**To run a single command:**

1. On the Hyper-V host, open PowerShell as Administrator.

3. Run the one of the following commands to create an interactive session using the virtual machine name or GUID:  
   
   ``` PowerShell
   Invoke-Command -VMName <VMName> -ScriptBlock { cmdlet } 
   Invoke-Command -VMGuid <VMGuid> -ScriptBlock { cmdlet }
   ```
   
   Provide credentials for the virtual machine when prompted.
   
   The command will execute on the virtual machine, if there is output to the console, it'll be printed to your console.  The connection will be closed automatically as soon as the command runs.
   
   
**To run a script:**

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run the one of the following commands to create an interactive session using the virtual machine name or GUID:  
   
   ``` PowerShell
   Invoke-Command -VMName <VMName> -FilePath C:\host\script_path\script.ps1 
   Invoke-Command -VMGuid <VMGuid> -FilePath C:\host\script_path\script.ps1 
   ```
   
   Provide credentials for the virtual machine when prompted.
   
   The script will execute on the virtual machine.  The connection will be closed automatically as soon as the command runs.

To learn more about this cmdlet, see [Invoke-Command](http://technet.microsoft.com/library/hh849719.aspx). 

-------------

## Copy files with New-PSSession and Copy-Item

> **Note:** PowerShell Direct only supports persistent sessions in Windows builds 14280 and later

Persistent PowerShell sessions are incredibly useful when writing scripts that coordinate actions across one or more remote machines.  Once created, persistent sessions exist in the background until you decide to delete them.  This means you can reference the same session over and over again with `Invoke-Command` or `Enter-PSSession` without passing credentials.

By the same token, sessions hold state.  Since persistent sessions persist, any variables created in a session or passed to a session will be preserved across multiple calls. There are a number of tools available for working with persistent sessions.  For this example, we will use [New-PSSession](https://technet.microsoft.com/en-us/library/hh849717.aspx) and [Copy-Item](https://technet.microsoft.com/en-us/library/hh849793.aspx) to move data from the host to a virtual machine and from a virtual machine to the host.

**To create a session then copy files:**  

1. On the Hyper-V host, open PowerShell as Administrator.

2. Run one of the following commands to create a persistent PowerShell session to the virtual machine using `New-PSSession`.
  
  ``` PowerShell
  $s = New-PSSession -VMName <VMName>
  $s = New-PSSession -VMGuid <VMGuid>
  ```
  
  Provide credentials for the virtual machine when prompted.
  
3. Copy a file into the virtual machine.
  
  To move `C:\host_path\data.txt` to the virtual machine from the host machine, run:
  
  ``` PowerShell
  Copy-Item -ToSession $s -Path C:\host_path\data.txt -Destination C:\guest_path\
  ```
  
4.  Copy a file to the host. 
   
   To move `C:\guest_path\data.txt` to the host from the virtual machine, run:
  
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
`Enter-PSSession`, `Invoke-Command`, or `New-PSSession` do not have a `-VMName` or `-VMID` parameter.

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
**Error message:**
```
Enter-PSSession : An error has occurred which Windows PowerShell cannot handle. A remote session might have ended.
```

**Potential causes:**
* The VM is not running
* The guest OS does not support PowerShell Direct (see [requirements](#Requirements))
* PowerShell isn't available in the guest yet
  * The operating system hasn't finished booting
  * The operating system can't boot correctly
  * Some boot time event needs user input
* The guest credentials couldn't be validated
  * The supplied credentials were incorrect
  * There are no user accounts in the guest (the OS hasn't booted before)
  * If connecting as Administrator:  Administrator has not been set as an active user.  Learn more [here](https://technet.microsoft.com/en-us/library/hh825104.aspx).

You can use the [Get-VM](http://technet.microsoft.com/library/hh848479.aspx) cmdlet to check that the credentials you're using have the Hyper-V administrator role and to see which VMs are running locally on the host and booted.

### Error: Parameter set cannot be resolved

**Error message:**  
``` 
Enter-PSSession : Parameter set cannot be resolved using the specified named parameters.
```

**Potential causes:**  
`-RunAsAdministrator` is not supported when connecting to virtual machines.  

PowerShell Direct has different behaviors when connecting to virtual machines versus Windows containers.  When connecting to a Windows container, the `-RunAsAdministrator` flag allows Administrator connections without explicit credentials.  Since virtual machines do not give the host implied administrator access, you need to explicitly enter credentials.

Administrator credentials can be passed to the virtual machine with the `-Credential` parameter or by entering them manually when prompted.

-------------

## Samples

Checkout samples on [GitHub](https://github.com/Microsoft/Virtualization-Documentation/search?l=powershell&q=-VMName+OR+-VMGuid&type=Code&utf8=%E2%9C%93).

See [PowerShell Direct snippets](../develop/powershell_snippets.md) for numerous examples of how to use PowerShell Direct in your environment as well as tips and tricks for writing Hyper-V scripts with PowerShell.
