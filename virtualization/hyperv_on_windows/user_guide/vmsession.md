ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: Manage Windows with PowerShell Direct 

# Manage Windows with PowerShell Direct #
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host. PowerShell Direct allows PowerShell management inside a virtual machine regardless of the network configuration or remote management settings on either the Hyper-V host or the virtual machine. This makes it easier for Hyper-V Administrators to automate and script virtual machine management and configuration.

There are two ways to run PowerShell Direct:  
* Create and exit a PowerShell Direct session using PSSession cmdlets
* Run script or command with the Invoke-Command cmdlet

If you're managing older virtual machines, use Virtual Machine Connection (VMConnect) or [configure a virtual network for the virtual machine](http://technet.microsoft.com/library/cc816585.aspx). 

## Create and exit a PowerShell Direct session using PSSession cmdlets
1. On the Hyper-V host, open Windows PowerShell as Administrator.

2. Run the one of the following commands to create a session by using the virtual machine name or GUID:  
``` PowerShell
Enter-PSSession -VMName <VMName>
Enter-PSSession -VMGUID <VMGUID>
```

3. Enter credentials for a user account on the virtual machine when prompted.
4. Run whatever commands you need to. These commands run on the virtual machine that you created the session with.
5. When you're done, run the following command to close the session:  
``` PowerShell
Exit-PSSession 
``` 

## Run script or command with Invoke-Command cmdlet

You can use the **Invoke-Command** cmdlet to run a pre-determined set of commands on the virtual machine. Here is an example of how you can use the Invoke-Command cmdlet where PSTest is the virtual machine name and the script to run (foo.ps1) is in the script folder on the C:/ drive:

 ``` PowerShell
 Invoke-Command -VMName PSTest -FilePath C:\script\foo.ps1 
 ```

To run a single command, use the **-ScriptBlock** parameter:

 ``` PowerShell
 Invoke-Command -VMName PSTest -ScriptBlock { cmdlet } 
 ```

## What's required to use PowerShell Direct?
To create a PowerShell Direct session on a virtual machine,
* The virtual machine must be running locally on the host and booted. 
* You must be logged into the host computer as a Hyper-V administrator.
* You must supply valid user credentials for the virtual machine.
* The host operating system must run Windows 10, Windows Server Technical Preview, or a higher version.  
* The virtual machine must run Windows 10, Windows Server Technical Preview, or a higher version.  

You can use the **Get-VM** cmdlet to check that the credentials you're using have the Hyper-V administrator role and to see which VMs are running locally on the host and booted.

## What can you do with PowerShell Direct?

See our cool [PowerShell Direct snippets](../develop/powershell_snippets.md). 

## Managing virtual machine credentials
PowerShell Direct requires that you are correctly authenticated with the guest operating system in order to run PowerShell commands inside the virtual machine.  There are multiple ways you can achieve this:

1. The first (and simplest) way is to have the same user credentials be valid in the host and the guest.  
  This is quite easy if you are logging in with your Microsoft account - or if you are in a domain environment.  
  In this scenario you can just run `Invoke-Command -VMName "test" {get-process}`.

2. Let PowerShell Direct prompt you for credentials  
  If your credentials do not match you will automatically get a credential prompt allowing you to provide the appropriate credentials for the virtual machine.

3. Store credentials in a variable for reuse.
  Running a simple command like this:  
  ``` PowerShell
  $localCred = Get-Credential
   ```
  And then running something like this:
  ``` PowerShell
  Invoke-Command -VMName "test" -Credential $localCred  {get-process} 
  ```
  Will mean that you only get prompted once per script/PowerShell session for your credentials.

4. Code your credentials into your scripts.  **Don't do this for any real workload or system**
 > Warning:  _Do not do this in a production system.  Do not do this with real passwords._
  
  You can hand craft a PSCredential object with some code like this:  
  ``` PowerShell
  $localCred = New-Object -typename System.Management.Automation.PSCredential -argumentlist "Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) 
  ```
  Grossly insecure - but useful for testing.  Now you get no prompts at all in this session. 
